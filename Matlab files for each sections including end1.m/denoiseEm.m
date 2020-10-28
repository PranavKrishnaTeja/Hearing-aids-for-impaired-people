function y = denoiseEm(x);

[thr,sorh,keepapp]=ddencmp( 'den' , 'wv' ,x);  

y=wdencmp( 'gbl' ,x, 'db3' ,2,thr,sorh,keepapp);  
subplot(2,1,1)
plot(x);
subplot(2,1,2)
plot(y);