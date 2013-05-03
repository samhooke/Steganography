function [matchPercentage, charsMatch, charsDiff, charsTotalMax] = string_similarity(s1, s2, len)
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
    charsTotalMax = max(length(s1), length(s2));
    charsTotalMin = min(length(s1), length(s2));
else
    charsTotalMax = len;
    charsTotalMin = len;
end

% Ensure both strings are the same length
s1p = s1(1:charsTotalMin);
s2p = s2(1:charsTotalMin);

s1p = str2num(s1p')'; %#ok<ST2NM>
s2p = str2num(s2p')'; %#ok<ST2NM>

d = xor(s1p, s2p);
charsDiff = sum(d);

% If comparing the whole string, add to the difference however many
% characters the string differs in length. This ensures that strings of
% different lengths incur a matching penalty.
if len == 0
    charsDiff = charsDiff + (charsTotalMax - charsTotalMin);
end

charsMatch = length(d) - charsDiff;

matchPercentage = charsMatch / charsTotalMax;

% Remap such that a match of 50% equates to 0%, because 50% means that
% every other bit matches, which is essentially a 0% match.
%matchPercentage = 1 - ((1 - matchPercentage) * 2);
matchPercentage = 2 * matchPercentage - 1;
if matchPercentage < 0
    matchPercentage = 0;
end

end