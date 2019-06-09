function OFDMRemoved = EstimateOFDM(InputSample,Nt)
    Nr = size(InputSample,1);
    SymbolLength = length(InputSample(1,:));
    PilotPattern = [[1,0,1,0,1,0,1,0,1,0,1,0];[1,1,1,1,1,1,1,1,1,1,1,1]];
    %PilotPattern = [[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0];[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];    
    PilotSymbols = 2 .* PilotPattern -1;
    N_Carriers = 128;
    N_Spacing = 4;
    N_Pilots = length(PilotPattern(1,:));
    N_Data = N_Carriers - 2*N_Pilots- 2*N_Spacing;
    N_cp =32;
    

    PilotSpacing = (N_Carriers -(2*N_Spacing)) / (2*N_Pilots);
    
    pilot_ind = 1+N_Spacing:PilotSpacing:N_Carriers - N_Spacing -1;
    hold_ind = 1:1:N_Carriers;
    Data_Ind  = setdiff(hold_ind, pilot_ind);
    Data_Ind = Data_Ind(1+N_Spacing:length(Data_Ind) -N_Spacing );    
    
    N_Total = N_Carriers +N_cp;
    N_OfdmSymbols = SymbolLength/N_Total;
    
    Offset = CPSymbolTiming(InputSample, N_Total,N_Carriers,N_cp);
    InputSamples = InputSample(:,Offset+1:end);
    
     
    SymbolLength = length(InputSamples(1,:));
    OFDMRemoved =[];
    for i = 1:N_Total:SymbolLength
        
        OfdmSymbolCP = InputSamples(:,i:i+N_Total-1);
        OfdmSymbol_ = OfdmSymbolCP(:, N_cp+1:end);
        OfdmSymbol = fft(OfdmSymbol_, [] ,2);
        %OfdmSymbol = OfdmSymbol .*hth;
        RecoveredPilots = OfdmSymbol(:,pilot_ind);
        RecoverdData = OfdmSymbol(:,Data_Ind);
        

        %%
        if Nr == 1
            %h = 1;
            PilotSymbols1 = (repmat(PilotSymbols(1,:) ,1,2));
          
            s_tt = 1;
            p = [];
            q =[];
            rang = 1;   

            for tt = 1:rang:length(RecoveredPilots(1,:))                
                h(1,1,s_tt) = sum(RecoveredPilots(1,tt).*  conj(PilotSymbols1(1,tt))) / (sum(abs(PilotSymbols1(1,tt).^2)));               
               s_tt = s_tt +1;
            end            
        elseif Nr ==2
            for ii =1:Nr

            s_tt = 1;
            p = [];
            q =[];
            rang = 2;
            for tt = 1:rang:length(RecoveredPilots(ii,:))-1
                
               h(ii,1,s_tt) = (sum(RecoveredPilots(ii,tt:2:tt+rang-1)) - sum(RecoveredPilots(ii,tt+1:2:tt+rang-1)));
               h(ii,2,s_tt) = (sum(RecoveredPilots(ii,tt:2:tt+rang-1)) + sum(RecoveredPilots(ii,tt+1:2:tt+rang-1)));
               p = [p tt:2:tt+rang-1];
               q = [q tt+1:2:tt+rang-1];
               
               s_tt = s_tt +1;
            end
               
            end
        h;  
        end
        H_est =ifft(h, [], 2);
        %h_interpolate(1,1,1,1) =0;
        %% Interpolate the channel

        EqualizedSymbols=[];
        if Nr == 1
            t2 = pilot_ind;
            t3 = [Data_Ind ];

            s_tt = 1;      
            EqualizedSymbols = [];
            store = [];
            NumberChannel = length(squeeze(h(1,1,:)));
            Tap_Size = length(RecoverdData(1,:)) / NumberChannel;
            h_interpolate(1,1,:) = interp1(t2,repelem(squeeze(h(1,1,:)),rang),t3,'spline');
            EqualizedSymbols = MaximumRatioCombining(RecoverdData, squeeze(h_interpolate(1,1,:)).',Nt);

        elseif Nr ==2 
            s_tt = 1;      
            EqualizedSymbols = [];
            store = [];
            t2 = pilot_ind;
            t3 = [Data_Ind ];
            NumberChannel = length(squeeze(h(1,1,:)));
            Tap_Size = length(RecoverdData(1,:)) / NumberChannel;

            h_interpolate(1,1,:) = repelem(squeeze(h(1,1,:)),Tap_Size);
            h_interpolate(1,2,:) = repelem(squeeze(h(1,2,:)),Tap_Size);
            h_interpolate(2,1,:) = repelem(squeeze(h(2,1,:)),Tap_Size);
            h_interpolate(2,2,:) = repelem(squeeze(h(2,2,:)),Tap_Size);
            EqualizedSymbols = MaximumRatioCombining(RecoverdData, (h_interpolate(:,:,:)),Nt);
      
        end
        OFDMRemoved =[OFDMRemoved EqualizedSymbols];
    end
   OFDMRemoved;
end