% This script tests Transmitter and Receiver functionality over an AWGN
% channel.
% NOTE:  One transmit and receive antenna are assumed.

SNRdB = 0:10;     % SNRs tested
Nb = 1000;     % number of bits per frame
Frames = 10;   % number of frames
Rs = 10^7;      % sample rate

FlipFlag = 0;
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
        NumSamples = size(OutputSamples,2);
        
        Nt = size(OutputSamples,1);
        % measure the bit rate in bits / second
        Rb(i) = Nb/size(OutputSamples,2)*Rs;
        % pass samples through an AWGN channel
        sigma = 1/sqrt(SNR(i)); % noise variance
        for n = 1:Nt
            OutputSamples(n,:) = OutputSamples(n,:) / sqrt(mean(abs(OutputSamples(n,:)).^2)); % normalize power
        end
        if size(OutputSamples,2)==1
            OutputSamples = OutputSamples';
            FlipFlag = 1;
        end
        ReceivedSamples = repmat(sum(OutputSamples,1),Nr,1) + sigma*randn(Nr,size(OutputSamples,2)) + j*sigma*randn(Nr,size(OutputSamples,2));
        % Pass bits through the reciever
        if FlipFlag
            ReceivedSamples = ReceivedSamples';
        end
        EstimatedBits = MyReceiver(ReceivedSamples);
        if size(EstimatedBits,2) == 1
            EstimatedBits = EstimatedBits';
        end
        Nx = min(Nb, length(EstimatedBits));
        err = sum(abs(EstimatedBits(1:Nx)-InfoBits(1:Nx)));
        BitErrors(i) = BitErrors(i) + err;
        FrameErrors(i) = FrameErrors(i) + (err>0);
        
    end
end

AchievedDataRate = Nx/(1/Rs*NumSamples)

figure
semilogy(10*log10(SNR), BitErrors/Frames/Nb,'k-x')
hold on
semilogy(10*log10(SNR), FrameErrors/Frames,'k-x')
semilogy(10*log10(SNR),q(sqrt(SNR)),'r')
legend('BER','FER','Uncoded BPSK Reference')
xlabel('SNR (dB)')


figure
Spectrum = fftshift(fft(OutputSamples(1,:)));
f = -Rs/2:Rs/length(Spectrum):Rs/2-Rs/length(Spectrum);
plot(f, abs(Spectrum).^2)
xlabel('Frequency (Hz)')
ylabel('Power Spectrum')