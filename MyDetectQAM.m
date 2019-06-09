function bits = MyDetectQAM(samples, M)

%   samples = randi([0,1],7200,1);
%   M=16;
    l =log2(M);


    if (M == 16)
        stored_bits_16qam = [0,0,0,0;0,0,0,1;0,0,1,0;0,0,1,1;0,1,0,0;0,1,0,1;0,1,1,0;
            0,1,1,1;1,0,0,0;1,0,0,1;1,0,1,0;1,0,1,1;1,1,0,0;1,1,0,1;1,1,1,0;1,1,1,1];
        len=length(stored_bits_16qam);
        stored_bits_in = stored_bits_16qam(:,1:2);
        stored_bits_quad = stored_bits_16qam(:,3:4);

        stored_symbols_in = (2.*(stored_bits_in(:,1)) -1) .*(2.*((stored_bits_in(:,2) -1).^2) +1);
        stored_symbols_quad = (2.*(stored_bits_quad(:,1)) -1) .*(2.*((stored_bits_quad(:,2) -1).^2) +1);
        stored_complex = stored_symbols_in +1i .* stored_symbols_quad;
        E = 0.25 *(2+10+10+18);
        stored_complex  = stored_complex./sqrt(E);
        for i=1:length(samples)
            [e(i),index(i)] = min(abs(samples(i)-stored_complex));
        end

        recovered_bits_ = stored_bits_16qam(index, :)';
        recovered_bits = reshape(recovered_bits_, l*length(recovered_bits_), 1);
    elseif (M == 64)
        stored_bits_64qam = [0,0,0,0,0,0;0,0,0,0,0,1;0,0,0,0,1,0;0,0,0,0,1,1;0,0,0,1,0,0;
            0,0,0,1,0,1;0,0,0,1,1,0;0,0,0,1,1,1;0,0,1,0,0,0;0,0,1,0,0,1;0,0,1,0,1,0;0,0,1,0,1,1;
            0,0,1,1,0,0;0,0,1,1,0,1;0,0,1,1,1,0;0,0,1,1,1,1;0,1,0,0,0,0;0,1,0,0,0,1;0,1,0,0,1,0;
            0,1,0,0,1,1;0,1,0,1,0,0;0,1,0,1,0,1;0,1,0,1,1,0;0,1,0,1,1,1;0,1,1,0,0,0;0,1,1,0,0,1;
            0,1,1,0,1,0;0,1,1,0,1,1;0,1,1,1,0,0;0,1,1,1,0,1;0,1,1,1,1,0;0,1,1,1,1,1;1,0,0,0,0,0;
            1,0,0,0,0,1;1,0,0,0,1,0;1,0,0,0,1,1;1,0,0,1,0,0;1,0,0,1,0,1;1,0,0,1,1,0;1,0,0,1,1,1;
            1,0,1,0,0,0;1,0,1,0,0,1;1,0,1,0,1,0;1,0,1,0,1,1;1,0,1,1,0,0;1,0,1,1,0,1;1,0,1,1,1,0;
            1,0,1,1,1,1;1,1,0,0,0,0;1,1,0,0,0,1;1,1,0,0,1,0;1,1,0,0,1,1;1,1,0,1,0,0;1,1,0,1,0,1;
            1,1,0,1,1,0;1,1,0,1,1,1;1,1,1,0,0,0;1,1,1,0,0,1;1,1,1,0,1,0;1,1,1,0,1,1;1,1,1,1,0,0;
            1,1,1,1,0,1;1,1,1,1,1,0;1,1,1,1,1,1];
        len=length(stored_bits_64qam);
        stored_bits_in = stored_bits_64qam(:,1:3);
        stored_bits_quad = stored_bits_64qam(:,4:6);

        stored_symbols_in = (2.* stored_bits_in(:,1) -1) .*  ((2.*( 3 - stored_bits_in(:,3)) + 1) .* ((stored_bits_in(:,2) - 1) .^2) + ((2.* stored_bits_in(:,3) +1) .* stored_bits_in(:,2)));
        stored_symbols_quad = (2.* stored_bits_quad(:,1)-1) .*  ((2.*( 3 - stored_bits_quad(:,3)) + 1) .* ((stored_bits_quad(:,2) - 1) .^2) + ((2.* stored_bits_quad(:,3) +1) .* stored_bits_quad(:,2)));
        stored_complex = stored_symbols_in +1i .* stored_symbols_quad;
        E = (1/16)* (2+10+26+50 + 10+18+34+58 + 26+34+50+74 + 98+74+58+50);
        stored_complex = stored_complex./sqrt(E);
        for i=1:length(samples)
            [e(i),index(i)] = min(abs(samples(i)-stored_complex));
        end

        recovered_bits_ = stored_bits_64qam(index, :)';
        recovered_bits = reshape(recovered_bits_, l*length(recovered_bits_), 1);
    end
    
    bits = recovered_bits;
end