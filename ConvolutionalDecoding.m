function [s_hat,registers] = ConvolutionalDecoding(encoded_bits)

%polynomial = [[1,0,1,1,1,0,0,0,1];[1,1,1,1,0,1,0,1,1]];
polynomial = [[1,1,0];[1,0,1];[1,1,1]];
%polynomial = [[1,0,1];[1,1,1];[1,1,1]]
%polynomial = [[1,0,1]; [1,1,1]];



registers  = 2; 
M = 2^registers;
%path_exist = zeros(M,M);
path_exist = cell(M,1);
bits_holder = zeros(M,M);
states_dis = zeros(M,registers);
states = zeros(M,registers);
for i =1:M
    states(i,:) = de2bi(i-1,registers,'left-msb');
end


for i =1:M
    states(i,:) = de2bi(i-1,registers,'left-msb');
end

    if (exist('CODINGPARAMETERS.mat'))  
        load('CODINGPARAMETERS.mat');   
    else

        for (i =1:M)
            x =  states(i,:);
            for(j = 1:M)

                 y1 =  xor(x(1), 1);
                 y2 = xor(x(2), 1);
                 y3 = xor(xor(x(1), x(2)),1);

                check_states = states(i,:);
                check_states = [1 check_states(1:registers-1)];
                if (states(j,:) == check_states)
                   states_dist{i,j} = [y1 y2, y3];
                   %path_exist(i,j) =1;
                   bits_holder(i,j) =1;
                   hold_path_exist = [path_exist{j} i];
                   path_exist{j} = hold_path_exist;

                end
                 y1 =  xor(x(1), 0);
                 y2 = xor(x(2), 0);
                 y3 = xor(xor(x(1), x(2)),0);

                check_states = states(i,:);
                check_states = [0 check_states(1:registers-1)];
                if (states(j,:) == check_states)
                   states_dist{i,j} = [ y1 y2, y3]; 
                   %path_exist(i,j) =1;
                    bits_holder(i,j) = 0;
                    hold_path_exist = [path_exist{j} i];
                   path_exist{j} = hold_path_exist;
                end
            end
        end


        path_dis =states_dist;
        nos_output =3;
        N= M;
        
        memo = containers.Map;

        for n_to =1:N
            dist_indices(:,n_to) = path_exist{n_to};
        end
        save('CODINGPARAMETERS', 'path_dis', 'path_exist', 'nos_output','N','bits_holder','memo','dist_indices');
    end
[s_hat, dist] = ConvolutionalDecoder(encoded_bits',  path_dis, path_exist, nos_output,N,bits_holder);
%[s_hat, dist] = VectorizationDecoder(encoded_bits',  path_dis, path_exist, nos_output,N,bits_holder);
%[s_hat, dist] = VectorizationDecoder(encoded_bits',  path_dis, path_exist, nos_output,N,bits_holder,memo,dist_indices);