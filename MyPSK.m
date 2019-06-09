function ModulatedSymbols = MyPSK(x, M)
%%Don-Roberts Emenonye

%Input - vector of bits, M
%Output - Vector of complex numbers
%Use Gray coding and unit energy

%x = randi([0,1],720,1);
%M = 16;
l = log2(M);

if mod( length(x), l) ~= 0
    p = ceil(length(x) /l);
    pp =  zeros(p * l - length(x),1);
    x = [x ; pp] ;
end


len = length(x);

%b_y = reshape(x,len/l,l);
b_y = reshape(x,l,len/l)';

b_hold(:,1) = b_y(:,1);
for i = 2:l
    b_hold(:,i) = xor(b_y(:,i-1), b_y(:,i));
end
b_y = b_hold;



factors_2 = 2.^([l-1:-1:0]);

dft = zeros(length(x)/l, 1);

for i=1:l
    dft = dft + factors_2(i)*b_y(:,i);
end

%Energy around the DFT circle is unity
ModulatedSymbols = exp(1i*2*pi*dft/M);

% label_num = reshape(x,len/l,l);
% label_ = int2str(label_num);
% plot(real(ModulatedSymbols), imag(ModulatedSymbols),'*');
% text(real(ModulatedSymbols),imag(ModulatedSymbols),label_);
% title('Generated PSK plot by Don-Roberts');
% daspect([1 1 1]);
% xlabel('In phase component');
% ylabel('Quadrature component');
