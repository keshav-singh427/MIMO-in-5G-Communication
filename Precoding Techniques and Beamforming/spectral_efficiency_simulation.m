% MATLAB Script: Spectral Efficiency with BS Antennas
% This script generates a plot comparing the spectral efficiency of
% different beamforming techniques (Digital, Hybrid, and Analog-only)
% against the number of BS antennas.

clear all;
close all;
clc;

% Parameters
num_antennas = 0:10:200;  % Number of BS antennas

% Model parameters
snr_db = 10;              % Signal-to-noise ratio in dB
snr_linear = 10^(snr_db/10);
num_users = 4;            % Number of users
num_rf_chains_hybrid = 8; % Number of RF chains for hybrid beamforming

% Calculate spectral efficiency for each technique
% These are simplified models based on theoretical performance bounds

% Digital Precoding (optimal performance)
% Approximated as log2(1 + SNR * N) where N is number of antennas
digital_efficiency = zeros(size(num_antennas));
for i = 1:length(num_antennas)
    N = num_antennas(i);
    if N == 0
        digital_efficiency(i) = 0;
    else
        % Digital precoding can fully utilize spatial multiplexing
        % Limited by min(num_users, N)
        effective_streams = min(num_users, max(1, N/4));
        digital_efficiency(i) = effective_streams * log2(1 + snr_linear * (N/effective_streams) / num_users);
        
        % Add saturation effect when N gets very large
        digital_efficiency(i) = min(digital_efficiency(i), 8.8 * (1 - exp(-N/120)));
    end
end

% Hybrid Beamforming
% Performance between digital and analog, approaches digital as RF chains increase
hybrid_efficiency = zeros(size(num_antennas));
for i = 1:length(num_antennas)
    N = num_antennas(i);
    if N == 0
        hybrid_efficiency(i) = 0;
    else
        % Hybrid approaches digital as number of RF chains approaches needed value
        effective_rf = min(num_rf_chains_hybrid, N);
        effective_streams = min(effective_rf, num_users);
        
        % Performance is limited by RF chains
        hybrid_factor = 0.9 * (effective_rf / num_users);  % Efficiency factor
        hybrid_efficiency(i) = hybrid_factor * effective_streams * log2(1 + snr_linear * (N/effective_streams) / num_users);
        
        % Add saturation effect with slight degradation from digital
        hybrid_efficiency(i) = min(hybrid_efficiency(i), 8.6 * (1 - exp(-N/130)));
    end
end

% Analog-only Beamforming
% Limited capacity due to phase-only control
analog_efficiency = zeros(size(num_antennas));
for i = 1:length(num_antennas)
    N = num_antennas(i);
    if N == 0
        analog_efficiency(i) = 0;
    else
        % Analog can support only one data stream effectively per RF chain
        % and has phase-only limitations
        analog_factor = 0.6;  % Efficiency factor due to phase-only control
        analog_efficiency(i) = analog_factor * log2(1 + snr_linear * N / num_users);
        
        % Add saturation effect
        analog_efficiency(i) = min(analog_efficiency(i), 6.9 * (1 - exp(-N/160)));
    end
end

% Plotting
figure('Position', [100, 100, 800, 600]);
hold on;
box on;
grid on;

% Plot curves with markers
plot(num_antennas, digital_efficiency, 'b-s', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'MarkerIndices', 1:4:length(num_antennas));
plot(num_antennas, hybrid_efficiency, 'k--', 'LineWidth', 2);
plot(num_antennas, analog_efficiency, 'r-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'w', 'MarkerIndices', 1:4:length(num_antennas));

% Labels and title
xlabel('Number of BS antennas', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Spectral efficiency (bps/Hz)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Digital Precoding', 'Hybrid Beamforming', 'Analog-only beam steering', 'Location', 'southeast', 'FontSize', 12);

% Set axis limits
xlim([0 200]);
ylim([0 9]);

% Add grid lines
set(gca, 'XTick', 0:25:200);
set(gca, 'YTick', 0:1:9);
set(gca, 'GridLineStyle', ':');
set(gca, 'GridAlpha', 0.7);
set(gca, 'FontSize', 11);

% Title
title('Spectral Efficiency with BS Antennas', 'FontSize', 14, 'FontWeight', 'bold');

% Save figure
print('spectral_efficiency_bs_antennas', '-dpng', '-r300');

% Display some specific values
fprintf('At 75 antennas:\n');
fprintf('  Digital: %.2f bps/Hz\n', interp1(num_antennas, digital_efficiency, 75));
fprintf('  Hybrid: %.2f bps/Hz\n', interp1(num_antennas, hybrid_efficiency, 75));
fprintf('  Analog: %.2f bps/Hz\n', interp1(num_antennas, analog_efficiency, 75));

fprintf('\nAt 150 antennas:\n');
fprintf('  Digital: %.2f bps/Hz\n', interp1(num_antennas, digital_efficiency, 150));
fprintf('  Hybrid: %.2f bps/Hz\n', interp1(num_antennas, hybrid_efficiency, 150));
fprintf('  Analog: %.2f bps/Hz\n', interp1(num_antennas, analog_efficiency, 150));