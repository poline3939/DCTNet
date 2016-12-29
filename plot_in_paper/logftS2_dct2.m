function  [cqtrans, tt, freqs, ker_dct2] = logftS2_dct2(infile,SR,minfreq,freqrat,maxfreq,windsizmax,hopsiz)
% This code is modified from http://web.media.mit.edu/~brown/cqtrans.htm
% Brown, J.C., (1991). ``Calculation of a Constant Q Spectral Transform" J. Acoust. Soc. Am. 89, 425-434.

Winnam = 'hamming';
%  ccx = 0;
 constwind = 0;
% OPTIONAL INPUTS with examples
% maxfreq  = SR/2 ;					 % maximum frequency
% windsizmax = 1102;          % maximum window size in samples = 100 ms at SR 11025
% hopsiz = 150;					 % samples between frames = 15 ms at SR 11025

if ~exist('windsizmax') 
   windsizmax = floor( .1 * SR);
	fprintf('logftS: No input maximum window size. Taking $.1f ms max = %.0f samples.\n',1000* SR/windsizmax, windsizmax);
end

% Get number of bins for these min and max freqs
nfreqs = 1 + fix( log(maxfreq/minfreq)/log(freqrat) ); 
[ker_dct2, freqs] = genlgftkern_dct2(minfreq, freqrat, SR, nfreqs, windsizmax, Winnam, constwind);           % GENLGFTKERN
[cqtrans, tt]  = logft_dct2(infile, hopsiz, ker_dct2,  windsizmax, nfreqs, SR);                                         %LOGFT
