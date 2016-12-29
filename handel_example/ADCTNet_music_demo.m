% read data
N = 65536;
load handel;
sig = y(1:N);
sr=8192; % sampling frequency of music
% soundsc(y)

% plot of spectrogram of music
[x_s,fa,ta,~]=spectrogram(sig,256,128,256,sr,'yaxis');
figure
imagesc(ta,fa,abs(x_s).^2)
set(gca,'Ydir','normal')
colormap(jet)
xlabel('Time (s)','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Frequency (Hz)','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
% title('Reconstructed signal based on T')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')

%% parameters (2 layer A-DCTNet (adaptive dctnet))
minfreq=40;         % G3 = freq of G below middle C in Hz
freqrat_1=2^(1/12);        % quarter tone spacing = 1.0293022366;  
freqrat_2=2^(1/6);        % quarter tone spacing = 1.0293022366;  
maxfreq=4000; % from spectrogram knows maximum frequency 2000Hz.
windsizmax=500; %windsizmax = floor( .1 * SR);  % take a 100 ms max
hopsiz1=1;
hopsiz2=30;

mu_cqt=[];
mu_cqt2=[];

% A-DCTNet 1st layer
[cqtrans1_2,~,~,~]=logftS2_dct2(sig,sr,minfreq,freqrat_1,maxfreq,windsizmax,hopsiz1);
mu=cqtrans1_2';
[cqtrans1_3,~,~,~]=logftS2_dct2(mu(1,:),sr,minfreq,freqrat_2,maxfreq,windsizmax,hopsiz2);
mu3=zeros(size(cqtrans1_3));
mu4=mu3;

% A-DCTNet 2nd layer
for jj=1:size(cqtrans1_2,2)
    [cqtrans1_3,~,~,~]=logftS2_dct2(mu(jj,:),sr,minfreq,freqrat_2,maxfreq,windsizmax,hopsiz2);
    mu3=mu3+abs(cqtrans1_3);
    clc; disp([num2str(jj/size(cqtrans1_2,2)*100),'%']);
end
mus1=log10(mu3'+realmin);

% plot of A-DCTNet 2nd layer output
figure
imagesc(mus1)
set(gca,'Ydir','normal')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
xlabel('Time (s)','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Scale','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
