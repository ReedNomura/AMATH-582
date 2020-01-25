% AMATH 582 Homework 1
% Use fftn and ifftn instead of fft and ifft for 3d space

clear all; close all; clc;

% Load the data
load Testdata

%Setup
L=15; % spatial domain
n = 64; %Fourier modes

x2=linspace(-L,L,n+1); 
x=x2(1:n);
y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1];
ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z); % Dimensions in Spatial Domain
[Kx,Ky,Kz]=meshgrid(ks,ks,ks); % Dimensions in Frequency Domain

% Visualize noisy data
for j=1:20
  Un(:,:,:)=reshape(Undata(j,:),n,n,n); % reshaping data into cube 
end
figure(1)
  close all, 
  isosurface(X,Y,Z,abs(Un),0.4)
  axis([-20 20 -20 20 -20 20]), grid on, drawnow
  title('Noisy Data in the Spatial Domain')
  xlabel('x-axis')
  ylabel('y-axis')
  zlabel('z-axis')
  pause(5)
% Figure out central frequency look in 1D  
 
Unt_avg = 0;
    for j=1:20
   Un(:,:,:)=reshape(Undata(j,:),n,n,n); % Reshaping data into cube
   Unt = fftn(Un); % Transform data to Fourier domain
   Unt_avg = Unt_avg + Unt; % Add together each measurement in the Fourier Domain
    end
       % Get averaged signal in Fourier domain
   Unt_avg = Unt_avg./20;
   [M,linearInd] = max(abs(Unt_avg(:)));
  
   figure (2)
    close all;
    isosurface(Kx,Ky,Kz,fftshift(abs(Unt_avg)./max(abs(Unt_avg(:)))), 0.6)
    axis([-6 6 -6 6 -6 6]), grid on, drawnow
  title('Averaged Signal in the Fourier Domain')
  xlabel('Kx-axis')
  ylabel('Ky-axis')
  zlabel('Kz-axis')
  pause (5)
% Identify "peak" frequencies

%Components for the central frequency
[I,J,K] = ind2sub([n n n], linearInd);
Central_x = Kx(I,J,K);
Central_y = Ky(I,J,K);
Central_z = Kz(I,J,K);
Central_Frequency = sprintf('The central frequency in frequency domain is at %s %d %f.',Central_x,Central_y,Central_z);
disp(Central_Frequency)

% Create a filter and filter data
    % Create filter
    filter = exp(-1 * ((Kx - Central_x).^2 + (Ky - Central_y).^2 + (Kz - Central_z).^2));
    
    % Apply filter to data in Fourier domain
    
    position = zeros(3,20);
for j=1:20
    Un = reshape(Undata(j,:),n,n,n);
    Unft = fftn(Un) .* filter;
    Unf = ifftn(Unft);

    % Store coordinates of marble at each (time) step
    [~, ind] = max(abs(Unf(:)));
    [position_x, position_y, position_z] = ind2sub([n n n], ind);
    position(1,j) = X(position_x, position_y, position_z);
    position(2,j) = Y(position_x, position_y, position_z);
    position(3,j) = Z(position_x, position_y, position_z);
end

% Plot the marble's path
figure(3)
plot3(position(1,:), position(2,:), position(3,:),'b-o', 'linewidth', 2), 
text(position(1,1), position(2,1),position(3,1),'\leftarrow Initial Point' );
text(position(1,20), position(2,20),position(3,20),'\leftarrow 20th Point' );
grid on;
title('Path of marble'), xlabel('x'), ylabel('y'), zlabel('z')

%% print the last position

Final_position = sprintf('The position of the marble at the 20th data point is x: %.3f, y: %.3f, z: %.3f',...
    position(1,20), position(2,20),position(3,20));

disp(Final_position)
