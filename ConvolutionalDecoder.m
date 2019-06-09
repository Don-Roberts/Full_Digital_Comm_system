function [s_hat, dist] = ConvolutionalDecoder(bits,  path_dis, path_exist, nos_output,N,bits_holder)
%function [s_hat, dist] = ConvolutionalDecoder(bits,  path_dis, path_exist, nos_output,N,bits_holder)
%bits generated
%encoding_type 
%polynomial

    if (mod(length(bits),nos_output) ~= 0)
        padding_bits = zeros(1,(nos_output - mod(length(bits),nos_output)));
        bits = [bits padding_bits];
    end
M =length(bits)/nos_output;  %time sequence
M;
dist = zeros(N,M);
dist(:,:)  = Inf;
dist(1,1) = 0;
p=1;
for i =2:M+1
    bits_ = bits(p:p+nos_output-1);
    for (n_to =1:N)
        hold_ = 1e6;
        hold_now =1e6;
        for  (n_fro = path_exist{n_to}) 
                if (hold_ > sum(xor(path_dis{n_fro, n_to}, bits_)) + dist(n_fro,i-1))
                    hold_ = sum(xor(path_dis{n_fro, n_to}, bits_)) + dist(n_fro,i-1);
%                     fprintf('From %d\n', (n_fro));
%                     fprintf('Ti %d\n', (n_to));
%                     fprintf('the sum is %d\n', (hold_));
                    if hold_now > hold_
                        dist(n_to,i) =  hold_;
                        
                    else
                        dist(n_to,i) = hold_now;
                        hold_now = hold_;
                    end
                    
                end
            end
            
        
        %dist(n_to,i) = dist(n_to,i) + hold_;
    end
    p = p+nos_output;
end
    L = size(dist,2);
    [~,j] = min(dist(:,L));
    M= L-1;
    while M > 0
        [~,i] = min(dist(:,M));
        s_hat(M) = bits_holder(i,j);
        M = M-1;
        j = i;
    end
end