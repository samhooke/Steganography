function allowed_coefficients = generate_allowed_coefficients()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ac_pos = 1;
for loopx = 1:8
    for loopy = 1:8
        loopxy = loopx + loopy;
        if (loopxy > 5 && loopxy < 11 && loopx > 1 && loopy > 1 && loopx < 7 && loopy < 7)
            allowed_coefficients(ac_pos,1) = loopx;
            allowed_coefficients(ac_pos,2) = loopy;
            ac_pos = ac_pos + 1;
        end
    end
end

end

