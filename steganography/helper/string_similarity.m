function [matchPercentage, charsMatch, charsDiff, charsTotal] = string_similarity(s1, s2, len)
% string_similarity() Compares how similar two strings are
%   The strings can be of different lengths, but that will increase the
%   reported difference between them.
% INPUTS
%    s1  - First string to compare
%    s2  - Second strong to compare
%    len - How many characters to compare
%          Set to 0 to compare all
% OUTPUTS
%    matchPercentage - A percentage for how many characters match
%                      Value is a float between 0 and 1
%    charsMatch      - The absolute number of matching characters
%    charsDiff       - The absolute number of differing characters
%    charsTotal      - How many characters were compared

if len == 0
    charsTotal = max(length(s1), length(s2));
else
    charsTotal = len;
end

% Pad strings to make them the same length
spacing = ['%-', num2str(charsTotal),'s'];
s1p = sprintf(spacing, s1);
s2p = sprintf(spacing, s2);

d = xor(s1p, s2p);
charsMatch = sum(d);
charsDiff = length(d) - charsMatch;

matchPercentage = charsMatch / charsTotal;

% Remap such that a match of 50% equates to 0%, because 50% means that
% every other bit matches, which is essentially a 0% match.
matchPercentage = 1 - ((1 - matchPercentage) * 2);
if matchPercentage < 0
    matchPercentage = 0;
end

end