% AMATH 582 Homework 2
%% Part 1 Handel's Messiah

clear all; close all; clc; %Start Fresh

load handel % Load Sound Clip
 
%Set up Parameters
v = y'/2;  

figure() %Unfiltered Handel's Messiah

subplot(2,1,1) % Plotting Handel's Messiah
plot((1:length(v))/Fs,v) 
  xlabel('Time [sec]');
  ylabel('Amplitude');
  title('Signal of Interest, v(n)');
  

 % Set up Parameters for FFT
 v = v(1:end-1); %Parse v
 L = (length(v)-1) / Fs; %Time Domain
 n = length(v); % Amount of time (to calculate frequency conversion)
 vt = fft(v); % Fourier Transform of Handel's Messiah
 k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; % Frequency conversion
 ks=fftshift(k); 
 
subplot(2,1,2) % Plotting FFT of Handel's Messiah 
 plot(ks, abs(fftshift(vt)) / max(abs(vt)));
 xlabel('Frequency (k)')
 ylabel('FFT(v)')
 title('FFT of v Without Filter')
 

 %% Play Sound Clip (Handel's Messiah)
    %p8 = audioplayer(v,Fs);
    %playblocking(p8); 
   
%% Filters
% Configure Parameters    
 width = 10;          % Width of filter
 intervals = 100;        % Number of time intervals
 t1 = (0:length(v))/Fs;
 t = t1(1:end-1);
 tslide = linspace(0,t(end-1),intervals);             % Time discretization
 spec = zeros(length(tslide),length(v));             % Preallocate space for spectrogram
 spec_g = zeros(length(tslide),length(v));
 spec_m = zeros(length(tslide),length(v));
 spec_s = zeros(length(tslide),length(v));
 
% Translate Filter accross intervals
figure()
 for j=1:length(tslide)
     
     g = exp(-width*(t-tslide(j)).^2); %Gaussian Filter
     m = (1-((t-tslide(j))/width).^2).*exp(-(((t-tslide(j))/width).^2)/2); %Mexican Hat Filter
     s = ((t-tslide(j))>-width/2 & (t-tslide(j))< width/2); %Shannon Filter
     filter = g ; %Pick the filter {g, m, s}
     vf = filter.*v; %Apply Filter
     vft = fft(vf); %Fourier Transform of Filtered
     spec(j,:) = abs(fftshift(vft));             % Store fft in spectrogram
    
     %Store for all Filters
     vgf_spec = g.*v; %Apply Gausian Filter
     vgft_spec = fft(vgf_spec); %Take Fourier Transform with filter
     spec_g(j,:) = abs(fftshift(vgft_spec));   % Store fft in spectrogram
     
     vmf_spec = m.*v; %Apply Mexican Hat Filter
     vmft_spec = fft(vmf_spec); %Take Fourier Transform with filter
     spec_m(j,:) = abs(fftshift(vmft_spec));    % Store fft in spectrogram
     
     vsf_spec = s.*v; %Apply Mexican Hat Filter
     vsft_spec = fft(vsf_spec); %Take Fourier Transform with filter
     spec_s(j,:) = abs(fftshift(vsft_spec));   % Store fft in spectrogram
     
     % Annimation of the filter moving accross the signal
     subplot(3,1,1), plot(t,v,'k',t,filter,'r'), title('Gabor filter and signal'), legend('v','Gabor filter')
     subplot(3,1,2), plot(t,vf,'k'), title('Gabor filter * signal')
     subplot(3,1,3), plot(ks, abs(fftshift(vft))/max(abs(vft))), title('Gabor transformation of signal')
     drawnow
     
 end
% Plot spectrogram
 figure()
 pcolor(tslide,ks,spec.'), shading interp
 colormap('hot')

  %% Spectograms for Three Filter Types (Gaussian, Mexican Hat, and Shannon)
  %Setup
  figure()
     subplot(1,3,1),
     pcolor(tslide,ks,spec_g.'), shading interp
     colormap('hot')
     
     subplot(1,3,2),
     pcolor(tslide,ks,spec_m.'), shading interp
     colormap('hot')
     
     subplot (1,3,3), 
     pcolor(tslide,ks,spec_s.'), shading interp
     colormap('hot')
 
 %% All in one image Different Filters
 
v = y'/2;
n = length(v); 
t = (1:length(v))/Fs; 
L = max(t);
k = (2*pi)*[0:n/2 -n/2:-1];
ks = fftshift(k);
midpoint = L / 2;
center = midpoint;

figure()

width = 10; % Fixed Width (comment out: for, moving width, and end)

intervals = 100;        % Number of width interval
wslide = linspace(.1,10,intervals);             % width discretization

%for j=1:length(wslide)
%width = wslide(j); %moving width
   
   %Gausian
     filter_g = exp(-width*((t-center).^2)); %Gaussian Filter
     vgf = filter_g.*v; %Apply Gausian Filter
     vgft = fft(vgf); %Take Fourier Transform with filter
    
     subplot(3,3,1), plot(t,v,'k',t,filter_g,'r'), title('Gaussian Filter and Signal'), xlim([0, L])
     subplot(3,3,4), plot(t,vgf,'k'), title('Filter * signal'), xlim([0, L])
     subplot(3,3,7), plot(ks, abs(fftshift(vgft))/max(abs(vgft))), title('Transformation of signal')
  
   % Mexican Hat
   
    filter_m = (1-((t-center)/width).^2).*exp(-(((t-center)/width).^2)/2); %Mexican Hat Filter 
    vmf = filter_m.*v; %Apply Mexican Hat Filter
    vmft = fft(vmf); %Take Fourier Transform with filter
     
     subplot(3,3,2), plot(t,v,'k',t,filter_m,'r'), title('Mexican Hat Filter and Signal'), xlim([0, t(end)])
     subplot(3,3,5), plot(t,vmf,'k'), title('Width:'), xlim([0, L])
     subplot(3,3,8), plot(ks, abs(fftshift(vmft))/max(abs(vmft))), title('Transformation of signal')
     
     
 % Shannon Filter
     
     filter_s = ((t-center)>-width/2 & (t-center)< width/2); %Shannon Filter
     vsf = filter_s.*v; %Apply Shannon Filter
     vsft = fft(vsf); %Take Fourier Transform with filter
     
     subplot(3,3,3), plot(t,v,'k',t,filter_s,'r'), title('Shannon filter and signal'), xlim([0, t(end)])
     subplot(3,3,6), plot(t,vsf,'k'), title(width), xlim([0, L])
     subplot(3,3,9), plot(ks, abs(fftshift(vsft))/max(abs(vsft))), title('Transformation of signal')
     drawnow
%end     


 %% All in one image Gaussian Filters Different Widths
 
v = y'/2;
n = length(v); 
t = (1:length(v))/Fs; 
L = max(t);
k = (2*pi)*[0:n/2 -n/2:-1];
ks = fftshift(k);
midpoint = L / 2;
center = midpoint;

figure()

intervals = 100;        % Number of width interval
wslide = linspace(.1,10,intervals);             % width discretization

   
   %Gausian 1
     filter_g = exp(-1*((t-center).^2)); %Gaussian Filter
     vgf = filter_g.*v; %Apply Gausian Filter
     vgft = fft(vgf); %Take Fourier Transform with filter
    
     subplot(3,3,1), plot(t,v,'k',t,filter_g,'r'), title('Width:1'), xlim([0, L])
     subplot(3,3,4), plot(t,vgf,'k'), title('Filter * signal'), xlim([0, L])
     subplot(3,3,7), plot(ks, abs(fftshift(vgft))/max(abs(vgft))), title('Transformation of signal')
  
   %Gausian 2
     filter_g = exp(-10*((t-center).^2)); %Gaussian Filter
     vgf = filter_g.*v; %Apply Gausian Filter
     vgft = fft(vgf); %Take Fourier Transform with filter
    
     subplot(3,3,2), plot(t,v,'k',t,filter_g,'r'), title('Width:10'), xlim([0, L])
     subplot(3,3,5), plot(t,vgf,'k'), title('Filter * signal'), xlim([0, L])
     subplot(3,3,8), plot(ks, abs(fftshift(vgft))/max(abs(vgft))), title('Transformation of signal')
     
     
 %Gausian 3
     filter_g = exp(-100*((t-center).^2)); %Gaussian Filter
     vgf = filter_g.*v; %Apply Gausian Filter
     vgft = fft(vgf); %Take Fourier Transform with filter
    
     subplot(3,3,3), plot(t,v,'k',t,filter_g,'r'), title('Width:100'), xlim([0, L])
     subplot(3,3,6), plot(t,vgf,'k'), title('Filter * signal'), xlim([0, L])
     subplot(3,3,9), plot(ks, abs(fftshift(vgft))/max(abs(vgft))), title('Transformation of signal')
     drawnow
%end 






%% Part 2 Mary Had a Little Lamb

% Fourier Transform see the notes but not when
% Filter based on those notes to create clean spectogram
% look at how the overtones 
clear all , close all, clc;

%Piano
figure()
tr_piano = 16;  % record time in seconds
 y = audioread('music1.wav');
 Fs=length(y)/tr_piano;
 
 subplot (2,1,1)
 plot((1:length(y))/Fs,y);
 xlabel('Time [sec]'); ylabel('Amplitude');
 title('Mary had a little lamb (piano)');  drawnow

 % Set up Parameters for FFT
 y = y.'; %Parse y
 L = tr_piano; %Time Domain
 n = length(y);
 yt = fft(y); % Fourier Transform of Mary Had a Little Lamb (Piano)
 k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; % Frequency Reframe
 ks=fftshift(k);
 
 subplot(2,1,2) % Plotting FFT Mary Had a Little Lamb (Piano)
 plot(ks, abs(fftshift(yt)) / max(abs(yt)));
 xlabel('Frequency [Hz]')
 ylabel('FFT(y)')
 title('FFT of y Without Filter')
 
 %Play Mary Had a Little Lamb (Piano)
 %p8 = audioplayer(y,Fs); playblocking(p8); 

% Set up for spectograms

t1 = linspace(0,L,n+1);
t = t1(1:end-1);
width = 100;
intervals = 100;
tslide = linspace(0, t(end-1), intervals);
spec = zeros(length(tslide),n);

%% Filters
figure()   
   for j = 1:length(tslide)
     g = exp(-width*(t-tslide(j)).^2); %Gaussian Filter
     m = (1-((t-tslide(j))/width).^2).*exp(-(((t-tslide(j))/width).^2)/2); %Mexican Hat Filter
     s = ((t-tslide(j))>-width/2 & (t-tslide(j))< width/2); %Shannon Filter
     filter = g ; %Pick the filter {g, m, s}
     yf = filter.*y; %Apply Filter
     yft = fft(yf); %Fourier Transform of Filtered
     spec(j,:) = abs(fftshift(yft));    % Store fft in spectrogram

    % Plot
    subplot(3,1,1), plot(t,y,'k',t,filter,'r'), title('Gabor filter and signal'), legend('y','Gabor filter')
    xlabel('Time [sec]'), ylabel('Amplitude')
    subplot(3,1,2), plot(t,yf,'k'), title('Gabor filter * signal')
    xlabel('Time [sec]'), ylabel('Amplitude')
    subplot(3,1,3), plot(ks, abs(fftshift(yft))/max(abs(yft))), title('Gabor transformation of signal')
    xlabel('Frequency [Hz]'), ylabel('Magnitude')
    drawnow
    
   end
  
%% Plot full spectrogram
figure()
subplot(3,1,1)
pcolor(tslide,ks, log(spec.'+1)), shading interp
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Piano Spectrogram')


% Plot Zoom of spectrogram
subplot(3,1,2)
pcolor(tslide,ks, log(spec.'+1)), shading interp
axis([0 16 0 4200])
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Piano Spectrogram (zoomed)') 

% Plot More Zoom of spectrogram
subplot(3,1,3)
pcolor(tslide,ks, log(spec.'+1)), shading interp
axis([0 16 750 1050])
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Piano Spectrogram (zoomed further)') 
          


%% Recorder
  figure()
  tr_rec=14;  % record time in seconds
  y = audioread('music2.wav');
  Fs = length(y)/tr_rec;
  subplot(2,1,1);
  plot((1:length(y))/Fs,y);
  xlabel('Time [sec]'); ylabel('Amplitude');
  title('Mary had a little lamb (recorder)');  

 % Set up Parameters for FFT
 y = y.'; %Parse y
 L = tr_rec; %Time Domain
 n = length(y);
 yt = fft(y); % Fourier Transform of Mary Had a Little Lamb (Recorder)
 k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; % Frequency Reframe
 ks=fftshift(k);
 
 subplot(2,1,2) % Plotting FFT Mary Had a Little Lamb (Recorder)
 plot(ks, abs(fftshift(yt)) / max(abs(yt)));
 xlabel('Frequency [Hz]')
 ylabel('FFT(y)')
 title('FFT of y Without Filter')
 %%
 %Play Mary Had a Little Lamb (Recorder)
 %p8 = audioplayer(y,Fs); playblocking(p8); 
 
% Set up for spectograms

t1 = linspace(0,L,n+1);
t = t1(1:end-1);
width = 1000;
intervals = 100;
tslide = linspace(0, t(end-1), intervals);
spec = zeros(length(tslide),n);

%%Filters
figure()   
   for j = 1:length(tslide)
     g = exp(-width*(t-tslide(j)).^2); %Gaussian Filter
     m = (1-((t-tslide(j))/width).^2).*exp(-(((t-tslide(j))/width).^2)/2); %Mexican Hat Filter
     s = ((t-tslide(j))>-width/2 & (t-tslide(j))< width/2); %Shannon Filter
     filter = g ; %Pick the filter {g, m, s}
     yf = filter.*y; %Apply Filter
     yft = fft(yf); %Fourier Transform of Filtered
     spec(j,:) = abs(fftshift(yft));    % Store fft in spectrogram

    % Plot Data 
    subplot(3,1,1), plot(t,y,'k',t,filter,'r'), title('Gabor filter and signal'), legend('y','Gabor filter')
    xlabel('Time [sec]'), ylabel('Amplitude')
    subplot(3,1,2), plot(t,yf,'k'), title('Gabor filter * signal')
    xlabel('Time [sec]'), ylabel('Amplitude')
    subplot(3,1,3), plot(ks, abs(fftshift(yft))/max(abs(yft))), title('Gabor transformation of signal')
    xlabel('Frequency [Hz]'), ylabel('Magnitude')
    drawnow
    
   end

%% Plot full spectrogram
figure()
subplot (3,1,1)
pcolor(tslide,ks, log(spec.'+1)), shading interp
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Log of Recorder Spectrogram')

% Plot Zoom of spectrogram
subplot (3,1,2)
pcolor(tslide,ks,log(spec.'+1)), shading interp
axis([0 14 0 20000])
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Log of Recorder Spectrogram (zoomed)') 

% Plot Zoom of spectrogram
subplot (3,1,3)
pcolor(tslide,ks,log(spec.'+1)), shading interp
axis([0 14 2200 3500])
colormap('hot'), xlabel('Time [sec]'), ylabel('Frequency [Hz]'), title('Log of Recorder Spectrogram (zoomed further)') 


