function [matchPercentage, charsMatch, charsDiff, charsTotal] = string_similarity(s1, s2, len)
% string_similarity() Compares how similar two strings are
%   The strings can be of different lengths, but that will increase the
%   reported difference between them.
% INPUTS
%    s1  - First string to compare
%    s2  - Second strong to compare
%    len - How many characters to compare
% OUTPUTS
%    matchPercentage - A percentage for how many characters match
%    charsMatch      - The absolute number of matching characters
%    charsDiff       - The absolute number of differing characters
%    charsTotal      - How many characters were compared

charsTotal = len;%max(length(s1), length(s2));
charsMatch = 0;
charsDiff = 0;

% Pad strings to make them the same length
spacing = ['%-', num2str(charsTotal),'s'];
s1p = sprintf(spacing, s1);
s2p = sprintf(spacing, s2);

for i = 1:charsTotal
    if (s1p(i) == s2p(i))
        charsMatch = charsMatch + 1;
    else
        charsDiff = charsDiff + 1;
    end
end

matchPercentage = charsMatch / charsTotal * 100;
end