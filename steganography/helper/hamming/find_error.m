%error finder
%Compares Hamming matrix with error vector R to find out what bit is
%erroneous

function b=find_error(message_received,nbp)

Y=message_received;

P=generate_hamming_matrix(Y,nbp);

R=error_check(Y,nbp);

for b=1:length(P)
    
    c=isequal(R(:,1),P(:,b));
    
    if c==1
    
        R;
        P(:,b);
        bit=b;
        
        disp('Error on bit')
        disp(b)
        
        break
    end
    
end