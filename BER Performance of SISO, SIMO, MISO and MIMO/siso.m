clc;  close all;
warning off;


%% BPSK 
disp('EXECUTING BPSK IN SINGLE INPUT SINGLE OUTPUT');
pause(2);

mess_len=10000;
snr_lmt=0:1:20; % snr rage
modulation_ind=2;
data=randsrc(1,mess_len, 0:1) ; % generate message
data_mod=modulate_process(data, modulation_ind) ; % modulation process
snr_range=snr_lmt;
index=1;
for k1=1 : length(snr_range)
    % genarte noise apply channel
    noise=1/sqrt(2)*[randn(1,mess_len) + 1j*randn(1,mess_len) ];
    channel_mat=uncorr_rayleg_channel(mess_len) ;
    rx_data=channel_mat .* data_mod + 10^(-snr_range(k1)/20)*noise;
    rx_data2=rx_data ./ channel_mat;
    data_out=demodulate_process(rx_data2, modulation_ind) ;
    [erramt, errrate]=biterr(data, data_out); % find bit error rate
    final_err1(index) = errrate;
    final_snr1(index)=snr_range(k1) ;
    index=index+1;
end
final_err1=sort(final_err1, 'descend');
pause(2) ;

%% QPSK 

disp('EXECUTING QPSK IN SINGLE INPUT SINGLE OUTPUT');
pause(2);
modulation_ind=4;
data=randsrc(1,mess_len, 0:modulation_ind-1) ; % generate message
data_mod=modulate_process(data, modulation_ind) ; % modulation process
index=1;
for k1=1 : length(snr_range)
    % genarte noise apply channel
    noise=1/sqrt(2)*[randn(1,mess_len) + 1j*randn(1,mess_len) ];
    channel_mat=uncorr_rayleg_channel(mess_len) ;
    rx_data=channel_mat .* data_mod + 10^(-snr_range(k1)/20)*noise;
    rx_data2=rx_data ./ channel_mat;
    data_out=demodulate_process(rx_data2, modulation_ind) ;
    [erramt, errrate]=biterr(data, data_out); % find bit error rate
    final_err2(index) = errrate;
    final_snr2(index)=snr_range(k1) ;
    index=index+1;
end
final_err2=sort(final_err2, 'descend');
pause(2) ;

%% 16 QAM

disp('EXECUTING 16 QAM IN SINGLE INPUT SINGLE OUTPUT');
pause(2);
modulation_ind=16;
data=randsrc(1,mess_len, 0:modulation_ind-1) ; % generate message
data_mod=modulate_process(data, modulation_ind) ; % modulation process
index=1;
for k1=1 : length(snr_range)
    % genarte noise apply channel
    noise=1/sqrt(2)*[randn(1,mess_len) + 1j*randn(1,mess_len) ];
    channel_mat=uncorr_rayleg_channel(mess_len) ;
    rx_data=channel_mat .* data_mod + 10^(-snr_range(k1)/20)*noise;
    rx_data2=rx_data ./ channel_mat;
    data_out=demodulate_process(rx_data2, modulation_ind) ;
    [erramt, errrate]=biterr(data, data_out); % find bit error rate
    final_err3(index) = errrate;
    final_snr3(index)=snr_range(k1) ;
    index=index+1;
end
final_err3=sort(final_err3, 'descend');
pause(2) ;

%% 64 QAM

disp('EXECUTING 64 QAM IN SINGLE INPUT SINGLE OUTPUT');
pause(2);
modulation_ind=64;
data=randsrc(1,mess_len, 0:modulation_ind-1) ; % generate message
data_mod=modulate_process(data, modulation_ind) ; % modulation process
index=1;
for k1=1 : length(snr_range)
    % genarte noise apply channel
    noise=1/sqrt(2)*[randn(1,mess_len) + 1j*randn(1,mess_len) ];
    channel_mat=uncorr_rayleg_channel(mess_len) ;
    rx_data=channel_mat .* data_mod + 10^(-snr_range(k1)/20)*noise;
    rx_data2=rx_data ./ channel_mat;
    data_out=demodulate_process(rx_data2, modulation_ind) ;
    [erramt, errrate]=biterr(data, data_out); % find bit error rate
    final_err4(index) = errrate;
    final_snr4(index)=snr_range(k1) ;
    index=index+1;
end

final_err4=sort(final_err4, 'descend');
pause(2) ;

%% Plot Results
figure;
semilogy(final_snr1, final_err1, 'r-o', 'LineWidth', 2);
hold on;
semilogy(final_snr2, final_err2, 'b-*', 'LineWidth', 2);
semilogy(final_snr3, final_err3, 'g-s', 'LineWidth', 2);
semilogy(final_snr4, final_err4, 'm-d', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
legend('BPSK', 'QPSK', '16-QAM', '64-QAM');
title('BER vs SNR for Different Modulation Schemes');
