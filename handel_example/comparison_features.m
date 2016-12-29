% comparison of feature in the paper
% need voicebox to implement melbankm.m function: 
% http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
N = 65536;
load handel;
y = y(1:N);

%% MFSC feature
nmel=40;
wlen=256;
win=hamming(wlen)';
wshft=28;
[mfsc_x4]=mfsc_mat(y',win,wshft,nmel,sr);
figure
imagesc(log(mfsc_x4'))
colormap(jet)
xlabel('Time step', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
ylabel('Mel scale', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca, 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman')
set(gca,'Ydir','normal')