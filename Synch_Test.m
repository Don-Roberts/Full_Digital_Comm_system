% This script tests Transmitter and Receiver functionality over an AWGN
% channel.
% NOTE:  One transmit and receive antenna are assumed.

SynchParams = [1 0 1];  % [timing freq phase]


SNRdB = 0:10;     % SNRs tested
Nb = 1000;     % number of bits per frame
Frames = 100;   % number of frames
Rs = 10^7;      % sample rate


BitErrors = zeros(1,length(SNRdB));
FrameErrors = zeros(1,length(SNRdB));

for i=1:length(SNRdB)
    i
    SNR(i) = 10^(SNRdB(i)/10);
    
    for k = 1:Frames
        
        % I create data
        InfoBits = round(rand(1,Nb));
        % feed the bits into your transmitter
        [OutputSamples,Nr] = MyTransmitter(InfoBits);
        Nt = size(OutputSamples,1);
        % measure the bit rate in bits / second
        Rb(i) = Nb/size(OutputSamples,2)*Rs;
        % pass samples through an AWGN channel
        sigma = 1/sqrt(SNR(i)); % noise variance
        for n = 1:Nt
            OutputSamples(n,:) = OutputSamples(n,:) / sqrt(mean(abs(OutputSamples(n,:)).^2)); % normalize power
        end
        
        ReceivedSamples = repmat(sum(OutputSamples,1),Nr,1) + sigma*randn(Nr,size(OutputSamples,2)) + j*sigma*randn(Nr,size(OutputSamples,2));
        
        % apply offset for synchronization
        % timing offset
        t_o = ceil(10*rand*SynchParams(1));
        ReceivedSamples = [zeros(Nr, t_o), ReceivedSamples(:,t_o+1:end)];
        % freq offset and phase offset
        t = 0:1/Rs:(size(ReceivedSamples,2)-1)/Rs;
        f_o = 20000*rand*SynchParams(2);
        p_o = 2*pi*rand*SynchParams(3);
        freq_offset = repmat(exp(j*2*pi*f_o*t+j*p_o),Nr,1);
        
        
        % Pass bits through the reciever
        ReceivedSamples = ReceivedSamples.*freq_offset;
        EstimatedBits = MyReceiver(ReceivedSamples);
        Nx = min(Nb, length(EstimatedBits));
        err = sum(abs(EstimatedBits(1:Nx)-InfoBits(1:Nx)));
        BitErrors(i) = BitErrors(i) + err;
        FrameErrors(i) = FrameErrors(i) + (err>0);
        
    end
end

figure
semilogy(10*log10(SNR), BitErrors/Frames/Nb,'k-x')
hold on
semilogy(10*log10(SNR), FrameErrors/Frames,'k-x')
semilogy(10*log10(SNR),q(sqrt(SNR)),'r')
legend('BER','FER','Uncoded BPSK Reference')
