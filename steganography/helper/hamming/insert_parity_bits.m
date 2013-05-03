%Calculates parity bits and inserts them in the right spots
function E=insert_parity_bits(message,nbp)

nbp=nbp;

A=message;

E=insert_parity_spots(A,nbp);

P=generate_hamming_matrix(E,nbp);



%%%%%%%%%%%%%%%%%
%Finds spots in the message string where bits are = 1
for V=1:nbp
    Q(V,:)=P(V,:).*E;
end

Q;

%For each parity line, finds if the sum of bits that are 1 is even (0), or odd (1)
for U=1:nbp
    R(U,:)=mod(length(find(Q(U,:))),2);
end
%%%%%%%%%%%%%%%%%

R;

%Adds the necessary parity bits in the message
for S=0:nbp-1
    E(1,2^S)=R(S+1,1);
end

E;