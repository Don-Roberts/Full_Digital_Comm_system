function OfdmSignals = OFDM(PrecodedSymbols,PilotSymbols)  

    SymbolLength = length(PrecodedSymbols(1,:));
    Nr = length(PrecodedSymbols(:,1));
    
%     N_Spacing = 4;
%     N_Carriers = 128;
%     N_Pilots = length(PilotSymbols);
%     N_Data = N_Carriers - 2*N_Pilots - 2*N_Spacing;
%     N_cp =32;
%     N_check = N_Carriers+N_cp;

    N_Spacing = 4;
    N_Carriers = 128;
    N_Pilots = length(PilotSymbols);
    N_Data = N_Carriers - 2*N_Pilots - 2*N_Spacing;
    N_cp =32;
    N_check = N_Carriers+N_cp;
    PilotSpacing = (N_Carriers -(2*N_Spacing)) / (2*N_Pilots);
    
    pilot_ind = 1+N_Spacing:PilotSpacing:N_Carriers - N_Spacing -1;
    hold_ind = 1:1:N_Carriers;
    Data_Ind  = setdiff(hold_ind, pilot_ind);
    Data_Ind = Data_Ind(1+N_Spacing:length(Data_Ind) -N_Spacing );
%     
    if (mod(SymbolLength,N_Data) ~= 0)
        padding_bits = zeros(1,(N_Data - mod(SymbolLength,N_Data)));
        PrecodedSymbols = [PrecodedSymbols padding_bits];
    end
%     
%          X_Time = ifft(PilotSyn);
%          X_Time = [X_Time(N_Carriers-N_cp+1:N_Carriers) X_Time];
%          OfdmSymbols= [X_Time X_Time];
        OfdmSymbols =[ ];
        for i = 1:N_Data:length(PrecodedSymbols) % This includes padding bits
            X_Freq = zeros(Nr, N_Carriers);
            X_Freq(pilot_ind) = repmat(PilotSymbols,1,2);
            X_Freq(Data_Ind) = PrecodedSymbols(i:i+N_Data-1);
            %X_Freq=[zeros(1,N_Spacing) PilotSymbols PrecodedSymbols(i:i+N_Data-1) PilotSymbols zeros(1,N_Spacing)];
            x_Time=ifft(X_Freq); % Convert to 'time domain', normalize to unit power
            ofdm_signal=[x_Time(N_Carriers-N_cp+1:N_Carriers) x_Time]; % Add cyclic prefix to generate an ofdm symbol
            OfdmSymbols = [OfdmSymbols ofdm_signal];
        end
        
        OfdmSignals = OfdmSymbols;
end

