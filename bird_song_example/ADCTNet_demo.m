% ADCTNet demo
[d1,sr1] = wavread('F-RW_typeA_a1');

% ADCTNet parameter
minfreq=100;         % 
minfreq2=100;         
freqrat_1=2^(1/48);        
freqrat_2=2^(1/10);       
maxfreq=22050;
windsizmax=4096; %windsizmax = floor( .1 * SR);  % take a 100 ms max
hopsiz1=1;
hopsiz2=100;

% generate ADCTNet feature
[cqtrans1_2,~,~,~]=logftS2_dct2(d1,sr1,minfreq,freqrat_1,maxfreq,windsizmax,hopsiz1);
mu=cqtrans1_2';
[cqtrans1_3,~,~,~]=logftS2_dct2(mu(1,:),sr1,minfreq,freqrat_2,maxfreq,windsizmax,hopsiz2);
mu3=zeros(size(cqtrans1_3));
for jj=1:size(cqtrans1_2,2)        
    [cqtrans1_3,~,~,~]=logftS2_dct2(mu(jj,:),sr1,minfreq,freqrat_2,maxfreq,windsizmax,hopsiz2);
    mu3=mu3+abs(cqtrans1_3);
    clc; disp([num2str(jj/size(cqtrans1_2,2)*100),'%']);
end
mus1=log10(mu3'+realmin);  

% plot of DCTNet 2-nd layer output
figure
imagesc(0.1:length(d1)/sr1, 1:size(mu3,2), mus1)
set(gca,'Ydir','normal')
colormap(jet)
xlabel('Time (s)','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Scale','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
