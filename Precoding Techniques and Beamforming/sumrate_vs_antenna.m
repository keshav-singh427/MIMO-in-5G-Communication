%% MIMO System: Sum Rate vs Number of BS Antennas
clear all;
close all;
clc;

% System parameters
K = 8;                    % Number of users (fixed)
SNR_dB = 10;              % Fixed SNR at 10 dB
SNR_linear = 10^(SNR_dB/10); % Linear SNR value
M_range = [8, 16, 24, 32, 48, 64, 96, 128];  % Range of BS antennas to test
num_realizations = 1000;  % Number of channel realizations

% Initialize result arrays
sum_rate_ZF = zeros(length(M_range), 1);
sum_rate_MRT = zeros(length(M_range), 1);

%% Main Simulation Loop
for m_idx = 1:length(M_range)
    M = M_range(m_idx);    % Current number of BS antennas
    power_per_user = SNR_linear;  % Fixed transmit power per user at 10 dB SNR
    
    % Check if M >= K for Zero-Forcing (to ensure matrix inversion is possible)
    if M < K
        sum_rate_ZF(m_idx) = NaN; % ZF not applicable when M < K
    end
    
    % Temporary variables for averaging
    rate_ZF_temp = 0;
    rate_MRT_temp = 0;
    
    for n = 1:num_realizations
        % Generate Rayleigh fading channel matrix (M x K)
        H = (randn(M, K) + 1i*randn(M, K))/sqrt(2);
        
        %% Zero-Forcing Precoding (if applicable)
        if M >= K
            % Calculate pseudo-inverse of channel matrix for ZF precoding
            W_ZF = H/(H'*H);  % W_ZF = H * inv(H'*H)
            
            % Normalize ZF precoding vectors
            for k = 1:K
                W_ZF(:,k) = W_ZF(:,k)/norm(W_ZF(:,k));
            end
            
            % Calculate SINR and Sum Rate for ZF
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
        end
        
        %% Maximum Ratio Transmission Precoding
        % MRT precoding (matched filter)
        W_MRT = H;
        
        % Normalize MRT precoding vectors
        for k = 1:K
            W_MRT(:,k) = W_MRT(:,k)/norm(W_MRT(:,k));
        end
        
        % Calculate SINR and Sum Rate for MRT
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
    if M >= K
        sum_rate_ZF(m_idx) = rate_ZF_temp/(num_realizations*K);
    end
    sum_rate_MRT(m_idx) = rate_MRT_temp/(num_realizations*K);
    
    % Display progress
    fprintf('Completed M = %d antennas\n', M);
end

%% Plot Results
figure;
plot(M_range, sum_rate_ZF, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(M_range, sum_rate_MRT, 'bs-', 'LineWidth', 2, 'MarkerSize', 8);
grid on;
xlabel('Number of Base Station Antennas (M)', 'FontSize', 12);
ylabel('Average Sum Rate (bits/s/Hz)', 'FontSize', 12);
title('Sum Rate vs Number of BS Antennas at SNR = 10 dB (K=8)', 'FontSize', 14);
legend('Zero-Forcing', 'Maximum Ratio Transmission', 'Location', 'northwest');

% Add vertical line at M=K for reference
line([K K], ylim, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 1.5);
text(K+2, max(ylim)*0.2, 'M=K', 'FontSize', 10);

%% Display System Information
disp('-------------------------------------------------------');
disp('System Parameters:');
disp('-------------------------------------------------------');
disp(['- Number of users (K): ', num2str(K)]);
disp(['- SNR: ', num2str(SNR_dB), ' dB']);
disp(['- Number of channel realizations: ', num2str(num_realizations)]);
disp('-------------------------------------------------------');

%% Print numerical results
fprintf('\nNumerical Results:\n');
fprintf('-------------------------------------------------------\n');
fprintf('BS Antennas (M)\tZF Sum Rate\tMRT Sum Rate\n');
for i = 1:length(M_range)
    if isnan(sum_rate_ZF(i))
        fprintf('%d\t\t\tN/A\t\t%.4f\n', M_range(i), sum_rate_MRT(i));
    else
        fprintf('%d\t\t\t%.4f\t\t%.4f\n', M_range(i), sum_rate_ZF(i), sum_rate_MRT(i));
    end
end
fprintf('-------------------------------------------------------\n');

%% Theoretical Analysis for Large M
disp('Theoretical Insights:');
disp('-------------------------------------------------------');
disp('For large number of antennas (M):');
disp('1. ZF: Sum rate scales as O(K*log2(1 + SNR*(M-K)/K))');
disp('2. MRT: Sum rate scales as O(K*log2(1 + SNR*M/(K*SNR+1)))');
disp('3. As M increases, both ZF and MRT performance improves');
disp('4. ZF typically outperforms MRT at high SNR and large M');
disp('-------------------------------------------------------');