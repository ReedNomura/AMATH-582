%% Final Project (Low Resolution Medical Imaging)

%% Initial .mat file conversion
clear all; close all; clc; %Start Fresh
v = VideoReader('RGB_Data.avi');
vid_frames = read(v);  %read all frames
clear v   %release it
save('RGB_Data.mat', 'vid_frames');

%% Load Data
clear all; close all; clc; %Start Fresh
load('RGB_Data.mat');
vid_frames_double = double(vid_frames); % Make Double Percision
[A1_1,B1_1,C1_1,D1_1] = size(vid_frames); %Initial Size Check
% Isolate Color Channels
Channel_1 = vid_frames_double(:,:,1,:);
Channel_2 = vid_frames_double(:,:,2,:);
Channel_3 = vid_frames_double(:,:,3,:);
%% All Frames Containing Streaks
S = [51, 52, 161, 162, 212, 213, 213, 247, 248, 249, 250, 264, 265, 302, 303, 303, 304, 322, 323, 333, 334, 364, 365, 365, 366, 368, 369, 388, 389, 474, 475, 510, 511, 549, 550, 570, 570, 571, 571, 572, 586, 587, 612, 613, 650, 651, 652, 667, 668, 670, 671, 697, 698, 737, 738, 739, 740];
NS = [1:762]; % All Frames
for kk = 1:57
NS = NS(NS~=S(kk)); %Frams with no Streaks
end
%% Display Channel Differences
Frame = 738; % 1 to 762
a = (['RGB Frame ', num2str(Frame)]);
b = (['Grayscale Frame ', num2str(Frame)]);
c = (['Red Frame ', num2str(Frame)]);
d = (['Green Frame ', num2str(Frame)]);
e = (['Blue Frame ', num2str(Frame)]);
Color = 'gray'; %  parula, jet, hsv, hot, cool, spring, summer, autumn, winter, gray, bone, copper, pink, lines, colorcube, prism, flag, white
figure()
subplot(2,2,1)
image(vid_frames(:,:,:,Frame))
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(2,2,2)
image(rgb2gray(vid_frames(:,:,:,Frame))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(b)

subplot(2, 3, 4)
pcolor(flipud((vid_frames(:,:,1,Frame)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(c)
hold on

subplot(2, 3, 5)
pcolor(flipud((vid_frames(:,:,2,Frame)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(d)

subplot(2, 3, 6)
pcolor(flipud((vid_frames(:,:,3,Frame)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(e)
%% Isolating Single Color Channel
One_Channel_frames_double = Channel_2; %Pick Color Channel

%% Subtract background
One_Channel_Ave = One_Channel_frames_double(:,:,1);
for jj = 2:762
Frame = jj;
One_Channel_Each = One_Channel_frames_double(:,:,Frame);
One_Channel_Ave = One_Channel_Ave + One_Channel_Each;
end
One_Channel_Ave = One_Channel_Ave/762;

for kk = 1:762
    Frame = kk;
    Sub_One_Channel(:,:,Frame) = One_Channel_frames_double(:,:,Frame) - One_Channel_Ave;
end
%% Compare Subtracted Background
Frame = 738; % 1 to 762
a = (['Frame ', num2str(Frame)]);
b = (['Background Subtracted from Frame ', num2str(Frame)]);
Color = 'gray'; %  parula, jet, hsv, hot, cool, spring, summer, autumn, winter, gray, bone, copper, pink, lines, colorcube, prism, flag, white

figure()
subplot(2,1,1)
pcolor(flipud((vid_frames(:,:,2,Frame)))), 
shading interp, 
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(2,1,2)
pcolor(flipud((Sub_One_Channel(:,:,Frame)))), 
shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(b)


%% Gaussian filter
Width = 0.00001; % Filter Width

kx =1:640;
ky=1:480; 
[Kx,Ky] = meshgrid(kx,ky);

G = exp(-Width*(Kx-241).^2-Width*(Ky-321).^2); %Gausian Filter

Filter = G; % Pick Filter

vid_frames_filtered = One_Channel_frames_double;
for j = 1:762
Frame = j ; %Frames 1 to 762
Frame_Text = (['Frame:', num2str(j)]);
A = Sub_One_Channel(:,:,Frame); %Isolate Specific Frame and Channel
AFt = fft2(A); % Two Dimensional Fourier Transform
Ats=fftshift(AFt); % Shift
Atsf = Ats.*Filter; % Apply Filter
Atf = ifftshift(Atsf); % Shift back
Af = ifft2(Atf); % Inverse Fourier Transform
vid_frames_filtered(:,:,Frame) = abs(Af); % Take the Absolute Value in order to display without issues
vid_frames_Fourier(:,:,Frame) = abs(Ats);
vid_frames_Fourier_filtered(:,:,Frame)= abs(Ats.*Filter);
end
%% Plot Data in the Fourier Domain
Frame_1 = 738; %frame with Streak
Frame_2 = 670; %frame 2 with Streak
Frame_3 = 530; %frame without streak
Frame_4 = 115; %frame 2 without streak
a = (['Frame ', num2str(Frame_1), ' With Streak']);
b = (['Frame ', num2str(Frame_2), ' With Streak']);
c = (['Frame ', num2str(Frame_3), ' Without Streak']);
d = (['Frame ', num2str(Frame_4), ' Without Streak']);
Color = 'Hot';
figure()
subplot(2,2,1)
pcolor(flipud((vid_frames_Fourier(:,:,Frame_1)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(2,2,2)
pcolor(flipud((vid_frames_Fourier(:,:,Frame_2)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(b)


subplot(2,2,3)
pcolor(flipud((vid_frames_Fourier(:,:,Frame_3)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(c)

subplot(2,2,4)
pcolor(flipud((vid_frames_Fourier(:,:,Frame_4)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(d)

%% Plot Data in Spatial Domain
Frame_1 = 738; %frame with Streak
Frame_2 = 670;%frame 2 with Streak
Frame_3 = 530; %frame without streak
Frame_4 = 115; %frame 2 without streak
a = (['Frame ', num2str(Frame_1), ' With Streak']);
b = (['Frame ', num2str(Frame_2), ' With Streak']);
c = (['Frame ', num2str(Frame_3), ' Without Streak']);
d = (['Frame ', num2str(Frame_4), ' Without Streak']);
Color = 'gray';
figure()
subplot(2,2,1)
pcolor(flipud((Sub_One_Channel(:,:,Frame_1)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(2,2,2)
pcolor(flipud((Sub_One_Channel(:,:,Frame_2)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(b)


subplot(2,2,3)
pcolor(flipud((Sub_One_Channel(:,:,Frame_3)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(c)

subplot(2,2,4)
pcolor(flipud((Sub_One_Channel(:,:,Frame_4)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(d)

%% Display Filtered vs Unfiltered in Spatial Domain
Frame_1 = 738; %frame with Streak
Frame_2 = 670;%frame 2 with Streak
Frame_3 = 530; %frame without streak
Frame_4 = 115; %frame 2 without streak
a = (['Frame ', num2str(Frame_1), ' Unfiltered With Streak']);
b = (['Frame ', num2str(Frame_1), ' Filtered With Streak']);
c = (['Frame ', num2str(Frame_3), ' Unfiltered Without Streak']);
d = (['Frame ', num2str(Frame_3), ' Filtered Without Streak']);
Color = 'gray';
figure()
subplot(2, 2, 1)
pcolor(flipud((Sub_One_Channel(:,:,Frame_1)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(2, 2, 2)
pcolor(flipud((vid_frames_filtered(:,:,Frame_1)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(b)

subplot(2, 2, 3)
pcolor(flipud((Sub_One_Channel(:,:,Frame_3)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(c)

subplot(2, 2, 4)
pcolor(flipud((vid_frames_filtered(:,:,Frame_3)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(d)

%% Alt Display Filtered vs Unfiltered in Spatial Domain
Frame_1 = 365; %frame with Streak
Frame_2 = 670;%frame 2 with Streak
Frame_3 = 530; %frame without streak
Frame_4 = 115; %frame 2 without streak
a = (['Frame ', num2str(Frame_1), ' Unprocessed']);
b = (['Frame ', num2str(Frame_1), ' Background Removed']);
c = (['Frame ', num2str(Frame_1), ' Filtered']);
d = (['Frame ', num2str(Frame_1), ' Filtered Without Streak']);
Color = 'gray';
figure()
subplot(1,3,1)
pcolor(flipud((One_Channel_frames_double(:,:,Frame_1)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(a)

subplot(1, 3, 2)
pcolor(flipud((Sub_One_Channel(:,:,Frame_1)))), shading interp,
set(gca, 'Xtick', [], 'Ytick',[])
title(b)

subplot(1, 3, 3)
pcolor(flipud((vid_frames_filtered(:,:,Frame_1)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(c)

%% Display Filtered vs Unfiltered in Fourier Domain
Frame_1 = 738; %frame with Streak
Frame_2 = 670;%frame 2 with Streak
Frame_3 = 530; %frame without streak
Frame_4 = 115; %frame 2 without streak
a = (['Frame ', num2str(Frame_1), ' Unfiltered With Streak']);
b = (['Frame ', num2str(Frame_1), ' Filtered With Streak']);
c = (['Frame ', num2str(Frame_3), ' Unfiltered Without Streak']);
d = (['Frame ', num2str(Frame_3), ' Filtered Without Streak']);
Color = 'hot';
figure()
% subplot(2, 2, 1)
% pcolor(flipud((vid_frames_Fourier(:,:,Frame_1)))), shading interp,
% set(gca, 'Xtick', [], 'Ytick',[])
% title(a)

subplot(2, 1, 1)
pcolor(flipud(vid_frames_Fourier_filtered(:,:,Frame_3))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(b)

% subplot(2, 2, 3)
% pcolor(flipud((vid_frames_Fourier(:,:,Frame_3)))), shading interp,
% set(gca, 'Xtick', [], 'Ytick',[])
% title(c)

subplot(2,1,2)
pcolor(flipud((vid_frames_Fourier_filtered(:,:,Frame_3)))), shading interp, colormap(Color)
set(gca, 'Xtick', [], 'Ytick',[])
title(d)
%% Create Fourier Data Matrix for all Frames
A = imresize(vid_frames_Fourier_filtered,[120,160]);
 for kk = 1:762
     Frame = kk;
     filtered_fourier_matrix(Frame,:) = reshape(A(:,:,Frame),1, 120*160);
 end
 %% Perform svd on Fourier Domain
[u,s,v] = svd(filtered_fourier_matrix);
sig = diag(s);
%% Plot Diagonals and Top Modes
figure()
semilogy(sig(1:20), 'ko', 'Linewidth', [2])
set (gca, 'Fontsize' , [14])
title('Diagonals')

figure()
subplot(2,2,1), face1 = reshape(v(:,1),120, 160); pcolor(flipud(face1)), shading interp, colormap(gray), set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 1')
subplot(2,2,2), face2 = reshape(v(:,2),120, 160); pcolor(flipud(face2)), shading interp, colormap(gray), set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 2')
subplot(2,2,3), face3 = reshape(v(:,3),120, 160); pcolor(flipud(face3)), shading interp, colormap(gray), set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 3')
subplot(2,2,4), face4 = reshape(v(:,4),120, 160); pcolor(flipud(face4)), shading interp, colormap(hot), set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 4') 
%% Average Fourier Streak Images
Fourier_Streak_All_filtered = imresize(vid_frames_Fourier_filtered(:,:,51),[120,160]);
 for kk = S
     Frame = kk;
     Fourier_Streak_Each_filtered = imresize(vid_frames_Fourier_filtered(:,:,Frame),[120,160]);
     Fourier_Streak_All_filtered = Fourier_Streak_All_filtered + Fourier_Streak_Each_filtered;
 end
Fourier_Streak_Ave_filtered = (Fourier_Streak_All_filtered - imresize(vid_frames_Fourier_filtered(:,:,51),[120,160]))/57;
vec_Fourier_Streak_Ave_filtered = reshape(Fourier_Streak_Ave_filtered,1,120*160);
%%
face1 = reshape(v(:,2),120, 160); 
face2 = reshape(v(:,2),120, 160);
face3 = reshape(v(:,3),120, 160);

figure()

subplot(3,1,1)
pcolor(flipud((Fourier_Streak_Ave_filtered))), shading interp, colormap(hot)
set(gca, 'Xtick', [], 'Ytick',[])
title('Averaged all Streak Frames in the Fourier Domain')


subplot(3,1,2)
projB_1 = vec_Fourier_Streak_Ave_filtered*v;
bar(projB_1(2:20)), set(gca, 'Xlim', [0,20], 'Ylim', [-2000, 2000], 'Xtick', [], 'Ytick',[])
text( 12, -1700, 'Streak Fourier Domain Key', 'Fontsize', [15])


subplot(3,3,7)
pcolor(flipud(face1)), shading interp, colormap(hot),
set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 1')

subplot(3,3,8) 
pcolor(flipud(face2)), shading interp, colormap(hot),
set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode 2')

subplot(3,3,9) 
pcolor(flipud(face3)), shading interp, colormap(hot),
set(gca, 'Xtick',[], 'Ytick',[]) 
title('Dominate Mode3')