function  [cqtrans, tt, freqs, ker_dct2] = logftS2_dct2(infile,SR,minfreq,freqrat,maxfreq,windsizmax,hopsiz)
% change so  windsizmax and hopsiz in ms

% DEFAULTS
%  SR  = 11025;					 % sample rate
%  minfreq = 40;         % G3 = freq of G below middle C in Hz
%  freqrat  = 2^(1/12);        % quarter tone spacing = 1.0293022366;  
%  maxfreq = 5512;
%  windsizmax = 1102;
%  hopsiz=150;
%  hopsiz=1;
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
% fprintf('logftS: Calculating %.0f freq bins from %.0f to %.0f .\n', nfreqs, minfreq, maxfreq);

% if ~exist('hopsiz'), hopsiz = floor(.015*SR);  end     % 15 ms
% freqs = minfreq * (freqrat .^[(0:1:nfreqs-1)]);
% Generate kernels for BASIS FNS if not previously calculated
[ker_dct2, freqs] = genlgftkern_dct2(minfreq, freqrat, SR, nfreqs, windsizmax, Winnam, constwind);           % GENLGFTKERN

% [rrr ccc] = size(ker_dct2);
% if (ccc > length(infile)), error('Length of infile < max window size\n'); end
%	Calculate cq transform
[cqtrans, tt]  = logft_dct2(infile, hopsiz, ker_dct2,  windsizmax, nfreqs, SR);                                         %LOGFT
