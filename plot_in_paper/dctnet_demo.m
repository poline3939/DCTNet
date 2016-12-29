% DCTNet using direct DCT transform
%% read data
load music_classic_country_downsample.mat % music_2_d
sig=music_2_d{1}; 
sr=11025; % sampling rate

%% 2-layer DCTNet
% parameters for layer 1
f=256; % length of window dct
h=1; % length of hop size, the first layer needs dense sample

% parameters for layer 2
f1=40; % length of window dct
h1=28; % length of hop size

aa=stdct(sig,f,h,sr); % first layer DCTNet
bb1=stdct(aa(1,:),f1,h1,sr);
Mu_a=zeros(size(bb1));    
for jj=1:size(aa,1)
    bb=stdct(aa(jj,:),f1,h1,sr); % second layer DCTNet
    Mu_a=Mu_a+abs(bb).^2; % absolute value square sum
end
Mu_a1=log(Mu_a+realmin);

% plot of DCTNet 2-nd layer output
figure
imagesc(0.1:length(sig)/sr, 1:40, Mu_a1)
set(gca,'Ydir','normal')
colormap(jet)
xlabel('Time (s)','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Scale','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')

