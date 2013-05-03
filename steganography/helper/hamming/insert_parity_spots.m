%This function's role is to insert zeros (0) at the spots where the parity
%bits will be

function E=insert_parity_spots(message,nbp)

clearvars D E

nb_bits_parity=nbp;

D=message;

E=ones(1,length(D)+nb_bits_parity);


%puts zeros in the matrix at every 2^n position
for I=0:nb_bits_parity
    E(1,2^I)=0;
    E=E(1,1:length(D)+nb_bits_parity);
end

E;

%Inserts message string at the right places (everywhere but pos=2^n) in the
%message vector
for M=1:length(E)
    
    if E(1,M)==1
        
        count=floor(log2(M)+1);
        E(1,M)=D(1,M-count);
       
    end
end

E;