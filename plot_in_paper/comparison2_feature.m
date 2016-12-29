% comparison of feature in the papers
% need voicebox to implement melbankm.m function: 
% http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html

%% read data
load music_classic_country_downsample.mat % music_2_d
sig=music_2_d{1}; 
sr=11025; % sampling rate
[x_1,f1,t1,~]=spectrogram(sig,256,128,256,sr,'yaxis'); % spectrogram of signal

%% Mel-scale, linear scale, ERB rate scale 
nmel=40; % choose 40 coefficients
wlen=256; % window length 256

% Mel-scale
fbank = melbankm(nmel,wlen,sr);
fbank(:,end) = [];
mfsc = log(fbank*abs(x_1(1:128,:))); % output feature

% linear scale
fbank1 = melbankm(nmel,wlen,sr,0,0.5,'f');
fbank1(:,end) = [];
lfsc = log(fbank1*abs(x_1(1:128,:))); % output feature

% ERB scale
fbank2 = melbankm(nmel,wlen,sr,0,0.5,'e');
fbank2(:,end) = [];
erb_sc=log(fbank2*abs(x_1(1:128,:))); % output feature

%% scattering transform
T=512;  % window or frame length
T0=60001; % signal length
filt_opt.Q=[8,1]; % filter coeff
filt_opt.J=T_to_J(T,filt_opt);
scat_opt.M=2; % two layer scattering trans
Wop=wavelet_factory_1d(T0,filt_opt,scat_opt); % obtain scat filter coeff
S1=scat(sig',Wop);
logrenorm_S = log_scat(renorm_scat(S1));
gg=format_scat(logrenorm_S); % output feature

