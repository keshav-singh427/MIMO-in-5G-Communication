%% BER vs SNR for ZF and MRT in Downlink Massive MIMO
% This script simulates the Bit Error Rate (BER) performance of 
% Zero-Forcing (ZF) and Maximum Ratio Transmission (MRT) precoding
% in a downlink Massive MIMO system.

clear all;
close all;
clc;

%% Simulation Parameters
Nt = 100;    % Number of transmit antennas at the base station
K = 10;      % Number of single-antenna users
SNR_dB = -10:2:20;  % SNR range in dB
SNR_linear = 10.^(SNR_dB/10);  % Linear SNR values
num_bits = 10000;  % Number of bits per SNR point
modulation = 'QPSK';  % Modulation scheme
num_monte = 50;  % Number of Monte Carlo simulations

% Preallocate arrays for BER results
ber_ZF = zeros(1, length(SNR_dB));
ber_MRT = zeros(1, length(SNR_dB));

%% Main Simulation Loop
for snr_idx = 1:length(SNR_dB)
    fprintf('Simulating SNR = %d dB\n', SNR_dB(snr_idx));
    sigma2 = 1/SNR_linear(snr_idx);  % Noise variance
    
    % Monte Carlo iterations
    error_ZF = 0;
    error_MRT = 0;
    total_bits = 0;
    
    for mc = 1:num_monte
        % Generate random bits for all users
        bits = randi([0 1], K, num_bits);
        total_bits = total_bits + K*num_bits;
        
        % QPSK modulation
        switch modulation
            case 'QPSK'
                % Map bits to QPSK symbols (2 bits per symbol)
                symbols = zeros(K, num_bits/2);
                for k = 1:K
                    bits_reshaped = reshape(bits(k,:), 2, []).';
                    for i = 1:size(bits_reshaped,1)
                        if bits_reshaped(i,:) == [0 0]
                            symbols(k,i) = (1 + 1i)/sqrt(2);
                        elseif bits_reshaped(i,:) == [0 1]
                            symbols(k,i) = (1 - 1i)/sqrt(2);
                        elseif bits_reshaped(i,:) == [1 0]
                            symbols(k,i) = (-1 + 1i)/sqrt(2);
                        else % [1 1]
                            symbols(k,i) = (-1 - 1i)/sqrt(2);
                        end
                    end
                end
        end
        
        % Generate channel matrix (Rayleigh fading)
        H = (randn(K, Nt) + 1i*randn(K, Nt))/sqrt(2);  % K×Nt channel matrix
        
        % Process each symbol
        for sym_idx = 1:size(symbols, 2)
            s = symbols(:, sym_idx);  % K×1 symbol vector
            
            % ZF Precoding
            W_ZF = H' * inv(H * H');  % Nt×K ZF precoder
            
            % Normalize ZF precoding matrix
            W_ZF = W_ZF ./ sqrt(trace(W_ZF * W_ZF'));
            
            % MRT Precoding
            W_MRT = H';  % Nt×K MRT precoder
            
            % Normalize MRT precoding matrix
            W_MRT = W_MRT ./ sqrt(trace(W_MRT * W_MRT'));
            
            % Transmit signals
            x_ZF = W_ZF * s;  % Nt×1 transmit signal for ZF
            x_MRT = W_MRT * s;  % Nt×1 transmit signal for MRT
            
            % Generate noise
            n = sqrt(sigma2/2) * (randn(K, 1) + 1i*randn(K, 1));
            
            % Received signals
            y_ZF = H * x_ZF + n;  % K×1 received signal for ZF
            y_MRT = H * x_MRT + n;  % K×1 received signal for MRT
            
            % Detection (Hard decision)
            detected_ZF = zeros(K, 2);
            detected_MRT = zeros(K, 2);
            
            for k = 1:K
                % QPSK demodulation
                if real(y_ZF(k)) >= 0 && imag(y_ZF(k)) >= 0
                    detected_ZF(k,:) = [0 0];
                elseif real(y_ZF(k)) >= 0 && imag(y_ZF(k)) < 0
                    detected_ZF(k,:) = [0 1];
                elseif real(y_ZF(k)) < 0 && imag(y_ZF(k)) >= 0
                    detected_ZF(k,:) = [1 0];
                else
                    detected_ZF(k,:) = [1 1];
                end
                
                if real(y_MRT(k)) >= 0 && imag(y_MRT(k)) >= 0
                    detected_MRT(k,:) = [0 0];
                elseif real(y_MRT(k)) >= 0 && imag(y_MRT(k)) < 0
                    detected_MRT(k,:) = [0 1];
                elseif real(y_MRT(k)) < 0 && imag(y_MRT(k)) >= 0
                    detected_MRT(k,:) = [1 0];
                else
                    detected_MRT(k,:) = [1 1];
                end
            end
            
            % Original bits for this symbol
            original_bits = zeros(K, 2);
            for k = 1:K
                original_bits(k,:) = bits(k, 2*sym_idx-1:2*sym_idx);
            end
            
            % Count bit errors
            error_ZF = error_ZF + sum(sum(detected_ZF ~= original_bits));
            error_MRT = error_MRT + sum(sum(detected_MRT ~= original_bits));
        end
    end
    
    % Calculate BER
    ber_ZF(snr_idx) = error_ZF / total_bits;
    ber_MRT(snr_idx) = error_MRT / total_bits;
end

%% Plot Results
figure;
semilogy(SNR_dB, ber_ZF, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
semilogy(SNR_dB, ber_MRT, 'rs-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Bit Error Rate (BER)', 'FontSize', 12);
title('BER vs SNR for Downlink Massive MIMO', 'FontSize', 14);
legend('Zero-Forcing (ZF)', 'Maximum Ratio Transmission (MRT)', 'Location', 'southwest');
xlim([min(SNR_dB), max(SNR_dB)]);
ylim([1e-4, 1]);

% Display system parameters in the figure
dim = [0.15 0.6 0.3 0.3];
str = sprintf('System Parameters:\nTx Antennas (Nt) = %d\nUsers (K) = %d\nModulation = %s', Nt, K, modulation);
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'white');

fprintf('Simulation completed.\n');