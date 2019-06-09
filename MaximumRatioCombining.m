function EqualizedSymbols = MaximumRatioCombining(r, H,Nt)
    %H = [-0.817853540726659 - 1.94017787348672i,-1.52086169677438 + 0.339067730770996i;0.0542482823781714 - 0.528988390136151i,0.151608082432021 + 0.562952187003049i];
     %H = [-0.817853540726659 - 1.94017787348672i];
    rcvd_stat1 = zeros(1,length(r(1,:)));
    rcvd_pow =0;
    Nr = size(r,1);
    %Nt = size(H,2);
    if Nt == 1
        rcvd_stat1 =(conj(H) .* r) ./ (abs(H).^2);
    elseif Nt == 2
        for nr =1:Nr
            h1 = squeeze(H(nr,1,:)).';
            h2 = squeeze(H(nr,2,:)).';
  
        
%             rcvd_stat1(1:2:end) = rcvd_stat1(1:2:end)  + (conj(h1).*r(nr, 1:length(r)/2)...
%             +h2.*conj(r(nr, 1+length(r)/2:end))); %for s1
%         
%             rcvd_stat1(2:2:end) = rcvd_stat1(2:2:end)  + (conj(h2).*r(nr, 1:length(r)/2)...
%             -h1.*conj(r(nr, 1+length(r)/2:end))); %for s2

            rcvd_stat1(1:2:end) = rcvd_stat1(1:2:end)  + (conj(h1(1:2:end)).*r(nr, 1:2:end)...
            +h2(2:2:end).*conj(r(nr, 2:2:end ))); %for s1
        
            rcvd_stat1(2:2:end) = rcvd_stat1(2:2:end)  + (conj(h2(1:2:end)).*r(nr, 1:2:end)...
            -h1(2:2:end).*conj(r(nr, 2:2:end))); %for s2
        
            rcvd_pow = rcvd_pow + (abs(h1).^2+abs(h2).^2);

        end
        rcvd_stat1 = rcvd_stat1./rcvd_pow;
    end
    EqualizedSymbols = rcvd_stat1;
end