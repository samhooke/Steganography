%fixes erroneous bit

function a=correct_message(message_received,nbp)
    
d=message_received;

error_pos=find_error(message_received, nbp);

%modulo inverts a bit
a=d;

a(1,error_pos)=mod(d(1,error_pos)+1,2);