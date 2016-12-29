% comparison of feature in the papers
% need voicebox to implement melbankm.m function: 
% http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html

load music_classic_country_downsample.mat % music_2_d
sig=music_2_d{1}; 
sr=11025;					 % sample rate

%% MFSC feature
nmel=40;
wlen=256;
win=hamming(wlen)';
wshft=28;
[mfsc_x4]=mfsc_mat(sig',win,wshft,nmel,sr);

% plot of feature
figure
imagesc(0.1:length(sig)/sr,1:40,log10(mfsc_x4'))
colormap(jet)
xlabel('Time (s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Mel scale', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca,'Ydir','normal')