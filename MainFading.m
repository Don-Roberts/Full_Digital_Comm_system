% This script tests Transmitter and Receiver functionality over a Rayleigh
% fading channel

clear all


SNRdB = 0:5:40;     % SNRs tested
%SNR = 100;
Nb = 1000;     % number of bits per frame
Frames = 100;   % number of frames

Rs = 10^7;      % sample rate

fd = 10;  % doppler rate
PDP = [1 0.15 0.05 0.01]; % power delay profile for frequency selective channel
PDP = 1;

L = length(PDP);      % number of multipath components
PDP = PDP/norm(PDP);  % normalize channel

BitErrors = zeros(1,length(SNRdB));
FrameErrors = zeros(1,length(SNRdB));

for i=1:length(SNRdB)
    SNRdB(i)
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
        
        t = 0:1/Rs:(size(OutputSamples,2)-1)/Rs;
        
        for n1 = 1:Nt
            for n2 = 1:Nr
                chan = zeros(1,length(t));
                Theta = 2*pi*rand(1,50);
                phi = 2*pi*randn(1,50);
                for ii=1:50
                    chan = chan + exp(j*(2*fd*cos(Theta(ii))*t+phi(ii)));
                end
                FadingChannel(n1,n2,:) = 1/sqrt(50)*chan;
            end
        end
        TxChan = zeros(Nt, length(t));
        for n2 = 1:Nr
            TxChan(:,:) = sqrt(PDP(1))*FadingChannel(:,n2,:);
            ReceivedSamples(n2,:) = sum(OutputSamples.*TxChan,1) + sigma*randn(1,size(OutputSamples,2)) + j*sigma*randn(1,size(OutputSamples,2));
        end
        
        % frequency selective fading
        for ll=2:L
            for n1 = 1:Nt
                for n2 = 1:Nr
                    chan = zeros(1,length(t));
                    Theta = 2*pi*rand(1,50);
                    phi = 2*pi*randn(1,50);
                    for ii=1:50
                        chan = chan + exp(j*(2*fd*cos(Theta(ii))*t+phi(ii)));
                    end
                    FadingChannel(n1,n2,:) = 1/sqrt(50)*chan;
                end
            end
            TxChan = zeros(Nt, length(t));
            for n2 = 1:Nr
                TxChan(:,:) = sqrt(PDP(1))*FadingChannel(:,n2,:);
                NewPath = sum(OutputSamples.*TxChan,1);
                NewPath = 1+j*1;
                ReceivedSamples(n2,ll:end) = ReceivedSamples(n2,ll:end) + sqrt(PDP(ll))*NewPath(1:end-ll+1);
            end
        end
        
        % Pass bits through the reciever
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
semilogy(10*log10(SNR), FrameErrors/Frames,'k-o')
semilogy(10*log10(SNR),1/4./SNR,'r')
legend('BER','FER','Uncoded BPSK Reference')
