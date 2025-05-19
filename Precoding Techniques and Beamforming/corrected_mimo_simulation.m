clear; clc; close all;
%% System Parameters
Nt = 8;             % Transmit antennas
Nr = 4;             % Receive antennas
Ns = 4;             % Data streams
numSymbols = 2000;  % Symbols per stream
M = 4;              % QPSK order
qpsk = [1+1j, 1-1j, -1+1j, -1-1j]/sqrt(2); % Normalized constellation

%% Generate Transmit Symbols
data = randi([0 M-1], Ns, numSymbols);
txSymbols = qpsk(data+1);

%% Channel Matrix (fixed for comparison)
rng(123); % For reproducibility
H = (randn(Nr,Nt) + 1j*randn(Nr,Nt))/sqrt(2);

%% SNR Points
SNR_dB = [5, 25];  % Low and high SNR cases

%% Simulation Figure
figure('Position', [100 100 1200 600], 'Name', 'MRT vs ZF Precoding', 'Color', 'w');

for snr_idx = 1:length(SNR_dB)
    SNR = 10^(SNR_dB(snr_idx)/10);
    N0 = 1/SNR;     % Noise variance
    
    %% MRT Precoding (Maximizes received power)
    W_mrt = H';     % MRT precoding matrix
    W_mrt = sqrt(Ns)/norm(W_mrt,'fro') * W_mrt; % Power normalization
    
    % Transmit signal
    x_mrt = W_mrt * txSymbols;
    
    % Received signal with noise
    noise = sqrt(N0/2)*(randn(Nr,numSymbols) + 1j*randn(Nr,numSymbols));
    y_mrt = H*x_mrt + noise;
    
    % Corrected MRT receiver processing - using MMSE combiner
    % MMSE combining matrix
    G_mrt = (H*W_mrt)' / ((H*W_mrt)*(H*W_mrt)' + N0*eye(Nr));
    s_hat_mrt = G_mrt * y_mrt;
    
    %% ZF Precoding (Cancels interference)
    W_zf = H' * inv(H*H');  % Proper ZF precoder (pseudo-inverse)
    W_zf = sqrt(Ns)/norm(W_zf,'fro') * W_zf; % Power normalization
    
    % Transmit signal
    x_zf = W_zf * txSymbols;
    
    % Received signal with noise
    noise = sqrt(N0/2)*(randn(Nr,numSymbols) + 1j*randn(Nr,numSymbols));
    y_zf = H*x_zf + noise;
    
    % Simple ZF receiver processing (since pre-equalization is done)
    s_hat_zf = y_zf; % With ZF precoding, the received signal is already equalized
    
    %% Plot Constellations (First stream only)
    % MRT Plot
    subplot(2, 2, snr_idx);
    scatter(real(s_hat_mrt(1,:)), imag(s_hat_mrt(1,:)), 20, [0.8 0 0.8], 'filled');
    hold on;
    plot(real(qpsk), imag(qpsk), 'ko', 'MarkerSize', 10, 'LineWidth', 1.5);
    hold off;
    title(sprintf('MRT @ %d dB SNR', SNR_dB(snr_idx)), 'FontWeight', 'bold');
    xlabel('In-Phase'); ylabel('Quadrature'); grid on;
    axis([-2 2 -2 2]); axis square;
    set(gca, 'FontSize', 10, 'Box', 'on');
    
    % ZF Plot
    subplot(2, 2, 2+snr_idx);
    scatter(real(s_hat_zf(1,:)), imag(s_hat_zf(1,:)), 20, [0 0.6 0], 'filled');
    hold on;
    plot(real(qpsk), imag(qpsk), 'ko', 'MarkerSize', 10, 'LineWidth', 1.5);
    hold off;
    title(sprintf('ZF @ %d dB SNR', SNR_dB(snr_idx)), 'FontWeight', 'bold');
    xlabel('In-Phase'); ylabel('Quadrature'); grid on;
    axis([-2 2 -2 2]); axis square;
    set(gca, 'FontSize', 10, 'Box', 'on');
end

% Add a suptitle for the entire figure
sgtitle('MIMO Precoding Performance: MRT vs ZF', 'FontSize', 14, 'FontWeight', 'bold');

% Add BER calculation and display
for snr_idx = 1:length(SNR_dB)
    SNR = 10^(SNR_dB(snr_idx)/10);
    N0 = 1/SNR;
    
    % MRT BER calculation
    W_mrt = H';
    W_mrt = sqrt(Ns)/norm(W_mrt,'fro') * W_mrt;
    x_mrt = W_mrt * txSymbols;
    noise = sqrt(N0/2)*(randn(Nr,numSymbols) + 1j*randn(Nr,numSymbols));
    y_mrt = H*x_mrt + noise;
    G_mrt = (H*W_mrt)' / ((H*W_mrt)*(H*W_mrt)' + N0*eye(Nr));
    s_hat_mrt = G_mrt * y_mrt;
    
    % Decision for MRT
    dec_mrt = zeros(size(data));
    for i = 1:Ns
        for j = 1:numSymbols
            [~, idx] = min(abs(s_hat_mrt(i,j) - qpsk));
            dec_mrt(i,j) = idx-1;
        end
    end
    ber_mrt = sum(sum(dec_mrt ~= data)) / (Ns * numSymbols);
    
    % ZF BER calculation
    W_zf = H' * inv(H*H');
    W_zf = sqrt(Ns)/norm(W_zf,'fro') * W_zf;
    x_zf = W_zf * txSymbols;
    noise = sqrt(N0/2)*(randn(Nr,numSymbols) + 1j*randn(Nr,numSymbols));
    y_zf = H*x_zf + noise;
    s_hat_zf = y_zf;
    
    % Decision for ZF  
    dec_zf = zeros(size(data));
    for i = 1:Ns
        for j = 1:numSymbols
            [~, idx] = min(abs(s_hat_zf(i,j) - qpsk));
            dec_zf(i,j) = idx-1;
        end
    end
    ber_zf = sum(sum(dec_zf ~= data)) / (Ns * numSymbols);
    
    fprintf('SNR = %d dB: MRT BER = %.4f, ZF BER = %.4f\n', SNR_dB(snr_idx), ber_mrt, ber_zf);
end