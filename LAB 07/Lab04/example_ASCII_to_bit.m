%% Convert text into a vector of bits
a = dec2bin('Test Message\n',8);    % get binary representation; gives character array
numChars = size(a,1);               % get number of characters

a = a - '0';                        % converts char array into matrix of numbers
a = reshape(a.',8*numChars,1);      % reshape matrix into a vector; 8 bits per character

stem(a)                             % plot vector of bits

%% Recover text from vector of bits
b = reshape(a, 8, numChars).';      % reshape vector into matrix; 8 bits per row
b = num2str(b);                     % convert to char array
b = bin2dec(b);                     % convert to decimal
fprintf(char(b));                   % print characters
