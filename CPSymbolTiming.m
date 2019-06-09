function Offset = CPSymbolTiming(InputSample, N_Total,N_Carriers,N_cp)
% function Offset = CPSymbolTiming(InputSample, N_Total,N_Carriers,N_cp)
 % This uses the cyclic prefix to estimate symbol timing offsets
    %Assume that both antennas suffer the same offset
 
    PossibleOffset = [];
    N_Offset = 0;
    N_Simulation = 50;
    SymbolLength = length(InputSample(1,:));

    if mod(SymbolLength,N_Total) ~= 0
        %fprintf('%4.2f offsets are present\n', mod(SymbolLength,N_Total));
        N_Offset = mod(SymbolLength,N_Total);
    end
    
    PossibleOffset = [0:N_Offset];
    %for i_Nr = 1:Nr
    i_Nr = 1;
    for n_sim = 1:N_Simulation
        for i = 1:length(PossibleOffset)
            PossibleOffsetValue = PossibleOffset(i);
            n = 1;
            %for n= 1:N_cp
                dist(i) = sum((abs(InputSample(i_Nr,n+PossibleOffsetValue:N_cp)) ...
                - abs(conj(InputSample(i_Nr,n+PossibleOffsetValue+N_Carriers:N_Total)))).^2);
                %InputSamples(i_Nr,:) =
           %end        
        end
        [~,min_dist] = min(dist);
        OffsetValue(n_sim) =   min_dist;
        %[~,OffsetValue(i,n_sim)] = min(dist);
    end
    Offset = PossibleOffset(mode(OffsetValue));
    