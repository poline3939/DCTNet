function d1_1 = stdct(x, f, h, sr)
% x = input signal
% f = length of fft
% h = length of hop step
% d1_1 = output of Short time DCT of x, square it to get the spectrogram like image

if nargin < 5;  sr = 8000; end

% expect x as a row
if size(x,1) > 1
  x = x';
end
s = length(x);
win=rectwin(f)';

% w = length(win);
% win2=win./sqrt(win*win');

c = 1;

% pre-allocate output array
d1 = zeros(f,1+fix((s-f)/h));
d1_1=d1;

for b = 0:h:(s-f)
  u = win.*x((b+1):(b+f));
  t_1=dct(u);
  d1_1(:,c)=t_1(1:f)';
  c = c+1;
end