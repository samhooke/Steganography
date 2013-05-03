%This function generates a Hamming matrix, receiving in input the message
%string and the number of parity bits it needs

function P=generate_hamming_matrix(coded_message,nbp)

P=zeros(nbp,length(coded_message));
stop_z=length(P);

for X=1:nbp
    
    for Y=0:length(P)-1
        
        if Y<stop_z/2^X
           P(X,((2^X)*Y+2^(X-1)):((2^X)*Y+(2^X)-1))=1;
        end
        
    end    
    
end

P=P(:,1:stop_z);