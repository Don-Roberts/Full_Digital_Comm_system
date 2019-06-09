function [OutPutBits,Feedback] =  MyReceiver(InputSamples)
    
    Nt = 1;
    Nr = size(InputSamples,1);
    ModulationType = '8-PSK'; %BPSK, 8-PSK, 16-PSK;
    DecoderType ='Convolutional'; %'Convolutional',  NONE; 
    EstimationType = 'Constant';
    
    %%
    %[PulseShapedInputSamples] = MatchedFiltering(InputSamples, Nr);`
    
%     %% Estimate Channel
%     %H_est = ChannelEstimation(PulseShapedInputSamples, EstimationType, Nt);
%     H_est = ChannelEstimation(InputSamples, EstimationType, Nt);
%     
%     %% Equalize
%     H=H_est;
%    % EqualizedSymbols = MaximumRatioCombining(InputSamples, H,Nt);
% 
%     %[FreqOffset, AngleOffset, SymbolTiming,ReceivedSampledSymbols] = OffsetEstimate(EqualizedSymbols);
%     
%     
%     [FreqOffset, AngleOffset, SymbolTiming,ReceivedSampledSymbols] = OffsetEstimate(InputSamples);
%     EqualizedSymbols = MaximumRatioCombining(ReceivedSampledSymbols, H,Nt);
%     %EqualizedSymbols = MaximumRatioCombining(ReceivedSampledSymbols, H,Nt);

    %% Estimate OFDM Channel
    OFDMRemoved = EstimateOFDM(InputSamples,Nt);
    
    %% Demodulate
    if strcmp(ModulationType,'QPSK')
        M= 2;
        %x = EqualizedSymbols;
        x = OFDMRemoved;
        DeModulatedSymbols = MyDetectPSK(x, M);
    elseif strcmp(ModulationType,'8-PSK')
         M= 8;
        x = OFDMRemoved;
        DeModulatedSymbols = MyDetectPSK(x, M);
    elseif strcmp(ModulationType,'16-PSK')
         M= 16;
        x = OFDMRemoved;
        DeModulatedSymbols = MyDetectPSK(x, M); 
    end
 
     if strcmp(DecoderType, 'Convolutional')
        [s_hat, registers] = ConvolutionalDecoding(DeModulatedSymbols);
        OutPutBits = s_hat(1:length(s_hat) - registers)';
        OutPutBits = OutPutBits';
     elseif strcmp(DecoderType, 'NONE')
         OutPutBits  =  DeModulatedSymbols';
     end

    %OutPutBits = s_hat(1:length(s_hat) - registers)';
    %OutPutBits  =  DeModulatedSymbols;
    Feedback = 0;
end
