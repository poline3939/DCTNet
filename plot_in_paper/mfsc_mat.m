function [mfsc] = mfsc_mat(x,w,wshft,nmel,fs)

wlen = length(w);
nwin = fix((length(x)-wlen+wshft)/wshft);

n = 0;
f = 1;

fbank = melbankm(nmel,wlen,fs);
fbank(:,end) = []; % Function returns one more frequency bin than needed

mfsc = zeros(nwin,nmel);
while n+wlen<=length(x)
  s = x(n+(1:wlen)).*w;

  fft_s = fft(s,wlen);
  fft_s = fft_s(1:fix(wlen/2))';
  
  % Mel -> log -> DCT
  mfsc(f,:) = fbank*abs(fft_s);

  n = n+wshft;
  f = f+1;
end
