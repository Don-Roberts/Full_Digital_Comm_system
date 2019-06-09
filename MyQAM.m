function y = MyQAM(x, M)
%%Don-Roberts Emenonye

%Input - vector of bits, M
%Output - Vector of complex numbers
%Use Gray coding and unit energy


l=log2(M);
len = length(x);

if mod(len,l) ~= 0
    error('The length of the input stream is not compatible with the number of symbols');
end

s = reshape(x,l/2,2*len/l)';

inphase = s(1:2:size(s,1),:);
quad = s(2:2:size(s,1),:);


if (M == 16)
    y = (2.*(inphase(:,1)) -1) .*(2.*((inphase(:,2) -1).^2) +1) + 1i.*(2.*(quad(:,1)) -1) .*(2.*((quad(:,2) -1).^2) +1);
    label_num = reshape(x,l,len/l)';
    label_ = int2str(label_num);
    figure
    plot(real(y), imag(y),'*');
    text(real(y),imag(y),label_,  'HorizontalAlignment','center', 'FontSize',9);
    title('16 QAM plot by Don-Roberts');
    xlabel('In phase component');
    ylabel('Quadrature component');
    xlim([-4 4]);
    ylim([-4 4]);
    E = 0.25 *(2+10+10+18);
    y  = y./sqrt(E);
elseif (M == 64)
    y1 = (2.* inphase(:,1) -1) .*  ((2.*( 3 - inphase(:,3)) + 1) .* ((inphase(:,2) - 1) .^2) + ((2.* inphase(:,3) +1) .* inphase(:,2)));
    y2 = (2.* quad(:,1)-1) .*  ((2.*( 3 - quad(:,3)) + 1) .* ((quad(:,2) - 1) .^2) + ((2.* quad(:,3) +1) .* quad(:,2)));
    y  = y1 + 1i * y2;
    label_num = reshape(x,l,len/l)';
    label_ = int2str(label_num);
    figure
    plot(real(y), imag(y),'*');
    text(real(y),imag(y),label_,  'HorizontalAlignment','center', 'FontSize',9);
    title('64 QAM plot by Don-Roberts');
    xlabel('In phase component');
    ylabel('Quadrature component');
    xlim([-8 8]);
    ylim([-8 8]);    
    E = (1/16)* (2+10+26+50 + 10+18+34+58 + 26+34+50+74 + 98+74+58+50);
    y = y./sqrt(E);
else
    error('This function handles only 16 QAM and 64 QAM');
end


