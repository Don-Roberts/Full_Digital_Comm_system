function [OfdmSignals, Nr] =  MyTransmitter(b, Feedback)
    
    bits = b;
    EncoderType ='Convolutional';  % Convolutional,NONE;
    ModulationType = 'BPSK'; %BPSK, 8-PSK, 16-PSK;
   % Pulseshape = 'SRRC';
    TypeOfTx = 'Alamouti'; %'SingleAntenna' ;%"Alamouti";  %OpenLoopSpatialMultiplexing
    Nt =2;
    Nr =2;
 
    if size(bits,2) ~= 1
        bits = bits';
    end
        
    if strcmp(EncoderType, 'Convolutional')
        polynomial = [[1,1,0];[1,0,1];[1,1,1]]; %%This specifies the convolutional polynomials
        %polynomial = [[1,0,1]; [1,1,1]];
        %polynomial = [[1,0,1];[1,1,1];[1,1,1]];
        %polynomial = [[1,0,1,1,1,0,0,0,1];[1,1,1,1,0,1,0,1,1]];
        EncodedBits = Convolutional(bits,  polynomial );
    elseif strcmp(EncoderType,'NONE')
        EncodedBits = bits;
    end
    
    if strcmp(ModulationType,'BPSK')
        M= 2;
        x = EncodedBits;
        ModulatedSymbols = MyPSK(x, M).';
    elseif strcmp(ModulationType,'8-PSK')
         M= 8;
        x = EncodedBits;
        ModulatedSymbols = MyPSK(x, M).';
    elseif strcmp(ModulationType,'16-PSK')
         M= 16;
        x = EncodedBits;
        ModulatedSymbols = MyPSK(x, M).';        
    end
    
    %% Precoding for 2 by 2 diversity scheme
    if strcmp(TypeOfTx,'Alamouti')
        if mod(length(ModulatedSymbols),Nt) ~=0
            ModulatedSymbols = [ModulatedSymbols zeros(mod(length(ModulatedSymbols),Nt),1)];
        end
            PrecodedSymbols = zeros(Nt, length(ModulatedSymbols));
            PrecodedSymbols(1,1:2:end) = ModulatedSymbols(1:2:end);
            PrecodedSymbols(1,2:2:end) = -conj(ModulatedSymbols(2:2:end));
            PrecodedSymbols(2,1:2:end) = ModulatedSymbols(2:2:end);
            PrecodedSymbols(2,2:2:end) = conj(ModulatedSymbols(1:2:end));

%             PrecodedSymbols1 = [ModulatedSymbols(1:2:end) -conj(ModulatedSymbols(2:2:end));...
%              ModulatedSymbols(2:2:end) conj(ModulatedSymbols(1:2:end))];
    elseif strcmp(TypeOfTx,'SingleAntenna')
        PrecodedSymbols = ModulatedSymbols;
    end    
    
    %% OFDM 
    PilotPattern = [[1,0,1,0,1,0,1,0,1,0,1,0];[1,1,1,1,1,1,1,1,1,1,1,1]];
    %PilotPattern = [[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0];[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
    
    PilotSymbols = 2 .* PilotPattern -1;
    
    for i =1:size(PrecodedSymbols(:,1),1)
        OfdmSignals(i,:) = OFDM(PrecodedSymbols(i,:), PilotSymbols(i,:));
    end
    OfdmSignals;


end