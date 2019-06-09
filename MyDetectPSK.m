function bits=MyDetectPSK(samples,M)
%%Don-Roberts
%%2/25/2019

%samples = y;
%M=16;
l = log2(M);
len =length(samples);
%Determine the M likely complex symbols
stored_letters = 0:M-1;
stored_complex = exp(1i * 2 * pi * stored_letters / M);


%%Generate the possible bit values;

stored_bits = zeros(M, l);
hold_letters = stored_letters';

for i=1:l
    stored_bits(:,i) = floor(hold_letters / 2^(l-i));
    hold_letters = hold_letters - stored_bits(:,i)*2^(l-i);
end

for (i =1:len)
   [e(i),index(i)]  = min(abs(samples(i) - stored_complex)); 
end


hold_bits(:,1) = stored_bits(:,1);
for i = 2:l
    hold_bits(:,i) = xor(hold_bits(:,i-1),stored_bits(:,i));
end
stored_bits = hold_bits;

recovered_bits_ = stored_bits(index,:);

recovered_bits = reshape(recovered_bits_',  l*length(recovered_bits_),1);

bits = recovered_bits;



