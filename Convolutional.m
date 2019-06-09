function EncodedBits = Convolutional(bits,  polynomial )
% function encoded_bits = Convolutional(bits, encoding_type, polynomial )
% This function takes in a vector of arbitrary length of bits and Performs
% Covolutional Encoding, %polynomial is the generator for this encoder.



num_branch = size(polynomial,1);
Nb = length(bits);

    for i = 1:num_branch
        y(i,:) =  mod(conv(bits,polynomial(i,:)),2);
    end
    EncodedBits = y;
    EncodedBits = reshape(EncodedBits, size(EncodedBits,1)*size(EncodedBits,2), 1);
end