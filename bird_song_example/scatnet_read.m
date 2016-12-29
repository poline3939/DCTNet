%%  generate scattering transform feature for bird song
trainset = 'all-tracks.list';
datapath = './songs';
dataext = '.wav';
train_files = textread(trainset, '%s');
datapath5 = '../scat2';
dataext1 = '.mat';

for i = 1:length(train_files)
    train_files_2{i} = fullfile([train_files{i}, dataext]);
end

tt=1;
train_files5=cell(1,200); 
for i = 1:length(train_files)
    train_files5{tt} = fullfile(datapath5, [train_files{i}, dataext1]);
    tt=tt+1;
end

% scattering transform
T=512;  % window or frame length
filt_opt.Q=[8,1]; % filter coeff
filt_opt.J=T_to_J(T,filt_opt);
scat_opt.M=2; % two layer scattering trans

for model = 1:length(train_files)
  % Select filenames that have this label as ground truth
    files = train_files_2(model);    
    files_4=train_files5(model); % scat
    
    aa=fullfile(files{1});
    [d1,sr1] = wavread(aa);
    T0=length(d1);
    Wop=wavelet_factory_1d(T0,filt_opt,scat_opt); % obtain scat filter coeff

    S1=scat(d1,Wop);
    logrenorm_S = log_scat(renorm_scat(S1));
    gg=format_scat(logrenorm_S);
    
    save(files_4{1},'gg');
    clc; disp([num2str(model/length(train_files)*100),'%']);
end

