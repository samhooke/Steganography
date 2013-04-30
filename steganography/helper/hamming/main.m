%This is a program illustrating Hamming with 5 options

%1) Illustrated error correction walkthrough: takes a string input from the user and
%does the error induction, detection and correction step by step on screen

%2) Add parity bits to string: Asks the user to input a binary string and
%outputs the string with the added correct parity bits

%3) Remove parity bits from string: Asks the user to input a binary string
%and outputs the string with the parity bits removed

%4) How many parity bits does a string that is X long need?: Asks the user
%to input a string length (integer), outputs the number of parity bits a
%string of that length needs for Hamming

%5) Generate Hamming matrix: Asks the user to input a string length
%(integer) and generates a Hamming matrix, like the one that can be seen
%here http://en.wikipedia.org/wiki/Hamming_code#General_algorithm

clc
clearvars all

%menu

choice=menu('Choose an option','Illustrated error-code walkthrough','Add parity bits to string','Remove parity bits from string','How many parity bits does a string that is X long need?','Generate Hamming matrix');

switch choice
    case 1
        %asks the user to input a binary string
        message=input('Insert a binary string of any length between square brackets []: ')
        
        %calculates the length of the string
        n=length(message);
        
        %mathematical formula that calculates the number of parity bits
        nbp=floor(log2(n+ceil(log2(n))))+1;
        
        disp('We add parity bits. This is what the message we send looks like')
        pause
        
        %function insert_parity_bits calculates and inserts the parity bits
        sent_message=insert_parity_bits(message,nbp)
        
        pause
        
        disp('A random bit gets inverted during the transmission of the message')
        pause
        
        received_message=sent_message;
        
        %an error is inserted in the message
        rnd_pos=round(rand*length(received_message)-0.5);
        received_message(1,rnd_pos)=mod(received_message(1,rnd_pos)-1,2)
        
        
        %error_check() launches the error check function
        vect_error=error_check(received_message,nbp);
        
        
        pause
        
        %find_error() returns the position of the error
        pos_err=find_error(received_message,nbp);
        
        disp('We correct the error')
        pause
        
        %correct_message() corrects the error
        corrected_message=correct_message(received_message,nbp)
        
        pause
        
        disp('Error corrected')
        pause
        
        %message_decode() removes the parity bits to unveil the original string
        disp('We remove the parity bits')
        message_final=message_decode(corrected_message,nbp)
        
        pause
        
        disp('We compare the original string with the final one: ')
        pause
        message
        message_final


    case 2
        %asks the user to input a binary string
        message=input('Insert a binary string of any length between square brackets []: ')
        
        %calculates the length of the string
        n=length(message);
        
        %mathematical formula that calculates the number of parity bits
        nbp=floor(log2(n+ceil(log2(n))))+1;
        
        disp('Message with parity bits')
        
        %function insert_parity_bits calculates and inserts the parity bits
        insert_parity_bits(message,nbp)

      
    case 3
        
        %asks the user to input a binary string
        message=input('Insert a binary string of any length between square brackets []: ')
        
        %calculates the length of the string
        n=length(message);
        
        %mathematical formula that calculates the number of parity bits
        nbp=floor(log2(n+ceil(log2(n))))+1;
        
        %message_decode() removes the parity bits to unveil the original string
        disp('We remove the parity bits')
        message_decode(message,nbp)
        
        
    case 4
        
        lgth=input('How many parity bits does a string X long need? Enter length or string: ');
        disp('Number of parity bits needed: ')
        floor(log2(lgth+ceil(log2(lgth))))+1
        
        
    case 5
        
        lgth=input('Generate Hamming matrix for string length = ');
        mess=ones(1,lgth);
        nbp=floor(log2(n+ceil(log2(n))))+1;
        generate_hamming_matrix(mess,nbp);
        
end

