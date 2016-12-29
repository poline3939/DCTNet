%% Generate ADCTNet feature
trainset = 'all-tracks.list';
datapath = './songs';
dataext = '.wav';
train_files = textread(trainset, '%s');
datapath1 = '../dctnet';
dataext1 = '.mat';
% train_labs = labelsfor(trainset);

for i = 1:length(train_files)
    train_files_2{i} = fullfile([train_files{i}, dataext]);
end

tt=1;
train_files1=cell(1,200);
for i = 1:length(train_files)
    train_files1{tt} = fullfile(datapath1, [train_files{i}, dataext1]);  
    tt=tt+1;
end

tt=1;
model = 1;
files = train_files_2(model);
aa=fullfile(files{1});
[d1,sr1] = wavread(aa);

minfreq=100;         % 
minfreq2=100;         
freqrat_1=2^(1/48);        
freqrat_2=2^(1/10);       
maxfreq=22050;
windsizmax=4096; %windsizmax = floor( .1 * SR);  % take a 100 ms max
hopsiz1=1;
hopsiz2=100;

[cqtrans1_2,~,~,~]=logftS2_dct2(d1,sr1,minfreq,freqrat_1,maxfreq,windsizmax,hopsiz1);
mu3=zeros(2165,43);
mu4=mu3;
mu=cqtrans1_2';
for jj=1:size(cqtrans1_2,2)        
    [cqtrans1_3,~,~,~]=logftS2_dct2(mu(jj,:),sr/4,minfreq,freqrat_2,maxfreq,windsizmax,hopsiz2);
    mu3=mu3+abs(cqtrans1_3);
    clc; disp([num2str(jj/size(cqtrans1_2,2)*100),'%']);
end
mus1=log10(mu3'+realmin);    










