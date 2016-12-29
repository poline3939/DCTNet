% DCTNet using short time DCT transform
%% read data
N = 65536;
load handel;
sig = y(1:N);
sr=8192; % sampling frequency of music
% soundsc(y)

%% DCTNet parameters
%%% parameters for layer 1, 
f=256; % length of window dct
h=1; % length of hop size

%%% parameters for layer 2
f1=40; % length of window dct
h1=28; % length of hop size

aa=stdct(sig,f,h,sr); % first layer short time DCT
bb1=stdct(aa(1,:),f1,h1,sr); % perform short time DCT on first layer output

Mu_a=zeros(size(bb1));    
for jj=1:size(aa,1)
    bb=stdct(aa(jj,:),f1,h1,sr); % second layer short time DCT
    Mu_a=Mu_a+abs(bb).^2; % absolute value square sum
    clc; disp([num2str(jj/size(aa,1)*100),'%']);
end
Mu_a1=log(Mu_a+realmin); % second layer DCTNet output

% plot 2-layer DCTNet output
figure
imagesc(Mu_a1)
set(gca,'Ydir','normal')
colormap(jet)
xlabel('Time step','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Linear Scale','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')