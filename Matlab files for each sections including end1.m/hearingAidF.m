function y = hearingAidF(input,g,Psat,transitionV,newfile);

[x,fs] = audioread(input);
xc = denoiseEm(x);                             % denoising filter
xf = applySkiSlope(xc,g,transitionV,fs);       % frequency shaping filter
y = powerCompress(xf, Psat,fs);                % amplitude shaping filter
x_length = length(x);
t=[0:1/fs:(x_length-1)/fs];
%sound(y,fs);


% plots for the input and output signals

figure;
subplot(2,1,1);
plot(t,x,'b');
axis tight;
xlabel('Time (sec)');
ylabel('Relative Magnitude');
title('Time Profile for Data in Signal 2');


subplot(2,1,2);
plot(t,y,'r');
axis tight;
xlabel('Time (sec)');
ylabel('Relative Magnitude');
title('Time Profile for Data in Adjusted Signal 2');

figure;
subplot(2,1,1);
specgram(x);
title('Spectrogram of Original Signal 2');

subplot(2,1,2);
specgram(y);
title('Spectrogram of Adjusted Signal 2');


%soundsc(input, fs);
sound(y,fs);
% audiowrite(y,fs,nbits,'linear','temp_file.wav');
audiowrite('temp_file.wav',y,fs);