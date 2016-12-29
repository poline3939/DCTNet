%% Generate MFSC, LFSC and ERB-SC features for bird song
trainset = 'all-tracks.list';
datapath = './songs';
dataext = '.wav';
train_files = textread(trainset, '%s');
% train_labs = labelsfor(trainset);
datapath1 = '../dctnet';
datapath2 = '../mfsc';
datapath3 = '../lfsc';
datapath4 = '../erb';
dataext1 = '.mat';

for i = 1:length(train_files)
    train_files_2{i} = fullfile([train_files{i}, dataext]);
end

tt=1;
train_files1=cell(1,200); train_files2=cell(1,200);
train_files3=train_files1; train_files4=train_files1;
for i = 1:length(train_files)
    train_files1{tt} = fullfile(datapath1, [train_files{i}, dataext1]);  
    train_files2{tt} = fullfile(datapath2, [train_files{i}, dataext1]);
    train_files3{tt} = fullfile(datapath3, [train_files{i}, dataext1]);  
    train_files4{tt} = fullfile(datapath4, [train_files{i}, dataext1]);
    tt=tt+1;
end

% List of all unique labels
tt=1;
model = 1;
files = train_files_2(model);
aa=fullfile(files{1});
[d1,sr1] = wavread(aa);
    
nmel=78;
wlen=512;
%%% mel scale
fbank_c = melbankm(nmel,wlen,sr1,0,0.5); % mel-filterbank
fbank_c(:,end) = [];
fbank_c1 = melbankm(nmel,wlen,sr1,0,0.5,'fm'); % linear filterbank
fbank_c1(:,end) = [];
fbank_c2 = melbankm(nmel,wlen,sr1,0,0.5,'e'); % erb filterbank
fbank_c2(:,end) = [];

% generate data file of features
for model = 3:length(train_files)
  % Select filenames that have this label as ground truth
    files = train_files_2(model);
    
    files_1=train_files2(model); % mfsc
    files_2=train_files3(model); % lfsc
    files_3=train_files4(model); % erb
    
    aa=fullfile(files{1});
    [d1,sr1] = wavread(aa);
    
    [x_1,~,~,~]=spectrogram(d1,512,256,512,sr1,'yaxis');
    mfsc=log(fbank_c*abs(x_1(1:256,:))+realmin); % log-Mel-spectrogram
    lfsc=log(fbank_c1*abs(x_1(1:256,:))+realmin); % log-linear fc
    erbsc=log(fbank_c2*abs(x_1(1:256,:))+realmin); % log-erb fc   
     
    save(files_1{1},'mfsc');
    save(files_2{1},'lfsc');
    save(files_3{1},'erbsc');
    clc; disp([num2str(model/length(train_files)*100),'%']);
end