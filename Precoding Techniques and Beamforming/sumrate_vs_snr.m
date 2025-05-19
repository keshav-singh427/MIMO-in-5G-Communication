%% MIMO System Parameters
clear all;
close all;
clc;

% System parameters
M = 64;                   % Number of BS antennas
K = 8;                    % Number of users
SNR_dB = -10:5:30;        % SNR range in dB
SNR_linear = 10.^(SNR_dB/10); % Linear SNR values
num_realizations = 1000;  % Number of channel realizations

% Initialize result arrays
sum_rate_ZF = zeros(length(SNR_dB), 1);
sum_rate_MRT = zeros(length(SNR_dB), 1);

%% Main Simulation Loop
for snr_idx = 1:length(SNR_dB)
    power_per_user = SNR_linear(snr_idx);  % Transmit power per user
    
    % Temporary variables for averaging
    rate_ZF_temp = 0;
    rate_MRT_temp = 0;
    
    for n = 1:num_realizations
        % Generate Rayleigh fading channel matrix (M x K)
        H = (randn(M, K) + 1i*randn(M, K))/sqrt(2);
        
        %% Zero-Forcing Precoding
        % Calculate pseudo-inverse of channel matrix for ZF precoding
        W_ZF = H/(H'*H);  % W_ZF = H * inv(H'*H)
        
        % Normalize ZF precoding vectors
        for k = 1:K
            W_ZF(:,k) = W_ZF(:,k)/norm(W_ZF(:,k));
        end
        
        %% Maximum Ratio Transmission Precoding
        % MRT precoding (matched filter)
        W_MRT = H;
        
        % Normalize MRT precoding vectors
        for k = 1:K
            W_MRT(:,k) = W_MRT(:,k)/norm(W_MRT(:,k));
        end
        
        %% Calculate SINR and Sum Rate for ZF
        for k = 1:K
            % Calculate desired signal power
            desired_signal = power_per_user * abs(H(:,k)'*W_ZF(:,k))^2;
            
            % Calculate interference from other users
            interference = 0;
            for j = 1:K
                if j ~= k
                    interference = interference + power_per_user * abs(H(:,k)'*W_ZF(:,j))^2;
                end
            end
            
            % Calculate SINR (Signal to Interference plus Noise Ratio)
            sinr_ZF = desired_signal/(interference + 1); % Noise power = 1
            
            % Calculate rate for user k
            rate_ZF_temp = rate_ZF_temp + log2(1 + sinr_ZF);
        end
        
        %% Calculate SINR and Sum Rate for MRT
        for k = 1:K
            % Calculate desired signal power
            desired_signal = power_per_user * abs(H(:,k)'*W_MRT(:,k))^2;
            
            % Calculate interference from other users
            interference = 0;
            for j = 1:K
                if j ~= k
                    interference = interference + power_per_user * abs(H(:,k)'*W_MRT(:,j))^2;
                end
            end
            
            % Calculate SINR (Signal to Interference plus Noise Ratio)
            sinr_MRT = desired_signal/(interference + 1); % Noise power = 1
            
            % Calculate rate for user k
            rate_MRT_temp = rate_MRT_temp + log2(1 + sinr_MRT);
        end
    end
    
    % Average over all realizations
    sum_rate_ZF(snr_idx) = rate_ZF_temp/(num_realizations*K);
    sum_rate_MRT(snr_idx) = rate_MRT_temp/(num_realizations*K);
end

%% Plot Results
figure;
plot(SNR_dB, sum_rate_ZF, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(SNR_dB, sum_rate_MRT, 'bs-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Average Sum Rate (bits/s/Hz)', 'FontSize', 12);
title('Sum Rate Comparison: ZF vs MRT (M=64, K=8)', 'FontSize', 14);
legend('Zero-Forcing', 'Maximum Ratio Transmission', 'Location', 'northwest');

%% Display Precoding Methods
disp('-------------------------------------------------------');
disp('Block Diagram Explanation:');
disp('-------------------------------------------------------');
disp('1. Channel Estimation: H (M×K complex channel matrix)');
disp('2. Precoding Matrix Calculation:');
disp('   - Zero-Forcing (ZF): W_ZF = H * inv(H''*H)');
disp('   - Maximum Ratio Transmission (MRT): W_MRT = H');
disp('3. Precoding Vector Normalization');
disp('4. Signal Transmission with Precoding');
disp('5. Signal Reception and SINR Calculation');
disp('6. Sum Rate Calculation: Sum of log2(1+SINR) across users');
disp('-------------------------------------------------------');

%% Print numerical results
fprintf('\nNumerical Results:\n');
fprintf('-------------------------------------------------------\n');
fprintf('SNR (dB)\tZF Sum Rate\tMRT Sum Rate\n');
for i = 1:length(SNR_dB)
    fprintf('%d\t\t%.4f\t\t%.4f\n', SNR_dB(i), sum_rate_ZF(i), sum_rate_MRT(i));
end
fprintf('-------------------------------------------------------\n');