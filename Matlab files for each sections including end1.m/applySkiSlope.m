function y = applySkiSlope(x,g,transitionV,fs);


first = transitionV(1);
second = transitionV(2);
third = transitionV(3);
fourth = transitionV(4);
x_length = length(x);
n = nextpow2(x_length);
N = 2^n;
T = 1/fs;
X = fft(x,N);
gain = zeros(N,1);

% Sets the gain for the first stage of frequencies
firstC = (.3*(g-1))/first;
k=0;
while(k/N <= first/fs)
   gain(k+1) = firstC*k/(N*T) + 1;
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the second stage of frequencies
secondC = firstC*first +1;    
secondC2 = (second-first)/5;
while(k/N <= second/fs)
   gain(k+1) = 1 + (secondC-1)*exp(-((k/(N*T))-first)/secondC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the third stage of frequencies
thirdC = 1 + (secondC-1)*exp(-second/secondC2);  
thirdC2 = (third-second)/5;
while(k/N <= third/fs)
   gain(k+1) = g + (thirdC-g)*exp(-((k/(N*T)-second))/thirdC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the fourth stage of frequencies
while(k/N <= fourth/fs)
   gain(k+1) = g;
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the fifth stage of frequencies
fifthC = g;                
fifthC2 = (fs/2-fourth)/5;
while(k/N <= .5)
   gain(k+1) = 1 + (fifthC-1)*exp(-((k/(N*T))-fourth)/fifthC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;


k_v = (0:N-1)/N;
plot(k_v,gain);%entire filter transfer function

figure;%non-redundant filter transfer function
k_v = k_v*fs;
k_v = k_v(1:N/2+1);
plot(k_v,gain(1:N/2+1));
title('Frequency Shaper Transfer Function');
xlabel('Frequency (Hertz)');
ylabel('Gain');

Y = X+gain;
y = real(ifft(Y,N));

y = y(1:x_length);
t=[0:1/fs:(x_length-1)/fs];
figure;
plot(t,y,'r');
%hold;
figure;
plot(t,x);