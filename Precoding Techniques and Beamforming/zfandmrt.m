clc; clear all; close all;

% Parameters
Nt = 4; % Number of transmit antennas
Nr = 4; % Number of receive antennas (usually Nr <= Nt for ZF)
SNR_dB = 100; % SNR in dB

% Load grayscale image and convert to bit stream
img = imread('cameraman.tif'); % 256x256 grayscale image
img_gray = im2double(img);
img_bin = de2bi(round(img_gray(:)*255),8,'left-msb')'; % 8 bits per pixel
img_bits = img_bin(:); % vector of bits

% Pad bits to multiple of Nt (symbols)
num_bits = length(img_bits);
num_symbols = ceil(num_bits/Nt);
pad_len = num_symbols*Nt - num_bits;
img_bits = [img_bits; zeros(pad_len,1)];

% BPSK Modulation: 0->-1, 1->+1
tx_symbols = 2*img_bits - 1; 
tx_symbols = reshape(tx_symbols, Nt, num_symbols); % Nt x num_symbols

% Channel matrix H (Nr x Nt)
H = (randn(Nr,Nt) + 1i*randn(Nr,Nt))/sqrt(2); % Rayleigh fading

% Noise
SNR = 10^(SNR_dB/10);
noise_var = 1/SNR;

% --- Zero Forcing Precoding ---
% F_zf = H' * inv(H*H')
F_zf = H' * inv(H*H');

% Normalize power
F_zf = sqrt(Nt) * F_zf / norm(F_zf,'fro');

% Transmit signal with ZF precoding
tx_zf = F_zf * tx_symbols;

% Add noise at receiver
noise = sqrt(noise_var/2)*(randn(Nr,num_symbols) + 1i*randn(Nr,num_symbols));
rx_zf = H*tx_zf + noise;

% Receiver: simple matched filter for ZF case
rx_zf_eq = pinv(H)*rx_zf;

% Detect symbols
rx_bits_zf = real(rx_zf_eq) > 0;

% --- MRT Precoding ---
% MRT precoder F_mrt = normalized H' (max ratio transmission)
F_mrt = H';

F_mrt = sqrt(Nt)*F_mrt / norm(F_mrt,'fro'); % normalize overall power

% Since F_mrt needs to be Nt x Nr, take this simplified version:
F_mrt = H'/norm(H','fro')*sqrt(Nt);

% Transmit signal with MRT precoding
tx_mrt = F_mrt * tx_symbols;

% Add noise at receiver
rx_mrt = H*tx_mrt + noise;

% Receiver: simple matched filter for MRT case
rx_mrt_eq = pinv(H)*rx_mrt;

% Detect symbols
rx_bits_mrt = real(rx_mrt_eq) > 0;

% --- Calculate BER ---
original_bits_reshaped = reshape(img_bits(1:end-pad_len), Nt, num_symbols);
ber_zf = sum(rx_bits_zf(:) ~= original_bits_reshaped(:))/num_bits;

ber_mrt = sum(rx_bits_mrt(:) ~= original_bits_reshaped(:))/num_bits;

fprintf('BER ZF = %.4f\n', ber_zf);
fprintf('BER MRT = %.4f\n', ber_mrt);

% --- Reconstruct image from bits ---
rx_bits_zf = rx_bits_zf(:);
rx_bits_mrt = rx_bits_mrt(:);

rx_bits_zf = rx_bits_zf(1:num_bits); % remove padding
rx_bits_mrt = rx_bits_mrt(1:num_bits);

% Convert bits to pixel values
img_bin_zf = reshape(rx_bits_zf,8,[])';
img_bin_mrt = reshape(rx_bits_mrt,8,[])';

img_rx_zf = uint8(bi2de(img_bin_zf,'left-msb'));
img_rx_mrt = uint8(bi2de(img_bin_mrt,'left-msb'));

img_rx_zf = reshape(img_rx_zf,size(img));
img_rx_mrt = reshape(img_rx_mrt,size(img));

% --- Plot images ---
figure;
subplot(1,3,1);
imshow(img);
title('Original Image');

subplot(1,3,2);
imshow(img_rx_zf);
title('Received Image (ZF)');

subplot(1,3,3);
imshow(img_rx_mrt);
title('Received Image (MRT)');
