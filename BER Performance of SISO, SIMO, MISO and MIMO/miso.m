clc;
clear all;
warning off;

%% BPSK 
disp('EXECUTING BPSK IN MUTLIPLE INPUT SINGLE OUTPUT');
snr_lmt=0:1:20;
pack_len=3;
figure,
modulation_index=2;
no_of_rx=2;
for no_of_tx=2:2 % no of receiver
    indx=1;
    for snrval=snr_lmt
        mess_len=3000*pack_len;
        data = randi([0 1],mess_len, 1) ;
        % Tramsmitt source path to dest path
        data_mod=MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
        data_enc=OSTBCBENC_PROCESS(data_mod, no_of_tx) ; %% ostbc encoder
        [noise_data_src_to_dest, chan_gain_src_to_dest]=CHANNEL_FADE_DESIGN(no_of_tx, no_of_rx, data_enc, snrval) ; % channel fading and noise process
        rx_data=noise_data_src_to_dest;
        data_dec=OSTBCDEC_PROCESS(rx_data, no_of_tx, no_of_rx, chan_gain_src_to_dest) ; %% ostbc decoder process
        data_decode=DEMOD_DATA_PROCESS(data_dec, modulation_index) ; % demodulation process
        [err_amt, err_rate]=biterr(data, data_decode) ; % find error rate
        final_err(indx) =err_rate;
        snr_range(indx) =snrval;
        indx=indx+1;
    end

    final_err=sort(final_err, 'descend' ) ;
    semilogy(snr_range, final_err, 'color', [1 rand rand], 'linewidth', 2) ;
    final_err=[];
    snr_range= [] ;
    hold on;
end
xlabel('SNR (dB) ') ;
ylabel( 'BER' ) ;
grid on;
legend( 'MULTIPLE INPUT SINGLE OUTPUT') ;
title('BPSK') ;
pause(2) ;

%% QPSK
disp('EXECUTING QPSK IN MUTLIPLE INPUT SINGLE OUTPUT');
pause(2);
figure,
modulation_index=4;
no_of_rx=2;
for no_of_tx=2:2 % no of receiver
    indx=1;
    for snrval=snr_lmt
        mess_len=3000*pack_len;
        data = randi([0 1],mess_len, 1) ;
        % Tramsmitt source path to dest path
        data_mod=MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
        data_enc=OSTBCBENC_PROCESS(data_mod, no_of_tx) ; %% ostbc encoder
        [noise_data_src_to_dest, chan_gain_src_to_dest]=CHANNEL_FADE_DESIGN(no_of_tx, no_of_rx, data_enc, snrval) ; % channel fading and noise process
        rx_data=noise_data_src_to_dest;
        data_dec=OSTBCDEC_PROCESS(rx_data, no_of_tx, no_of_rx, chan_gain_src_to_dest) ; %% ostbc decoder process
        data_decode=DEMOD_DATA_PROCESS(data_dec, modulation_index) ; % demodulation process
        [err_amt, err_rate]=biterr(data, data_decode) ; % find error rate
        final_err(indx) =err_rate;
        snr_range(indx) =snrval;
        indx=indx+1;
    end

    final_err=sort(final_err, 'descend' ) ;
    semilogy(snr_range, final_err, 'color', [rand 0 rand], 'linewidth', 2) ;
    final_err=[];
    snr_range= [] ;
    hold on;
end
xlabel('SNR (dB) ') ;
ylabel( 'BER' ) ;
grid on;
legend( 'MULTIPLE INPUT SINGLE OUTPUT') ;
title('QPSK') ;
pause(2) ;

%% 16 QAM

disp('EXECUTING 16 QAM IN MUTLIPLE INPUT SINGLE OUTPUT');
pause(2);
figure,
modulation_index=16;
no_of_rx=2;
for no_of_tx=2:2 % no of receiver
    indx=1;
    for snrval=snr_lmt
        mess_len=3000*pack_len;
        data = randi([0 1],mess_len, 1) ;
        % Tramsmitt source path to dest path
        data_mod=MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
        data_enc=OSTBCBENC_PROCESS(data_mod, no_of_tx) ; %% ostbc encoder
        [noise_data_src_to_dest, chan_gain_src_to_dest]=CHANNEL_FADE_DESIGN(no_of_tx, no_of_rx, data_enc, snrval) ; % channel fading and noise process
        rx_data=noise_data_src_to_dest;
        data_dec=OSTBCDEC_PROCESS(rx_data, no_of_tx, no_of_rx, chan_gain_src_to_dest) ; %% ostbc decoder process
        data_decode=DEMOD_DATA_PROCESS(data_dec, modulation_index) ; % demodulation process
        [err_amt, err_rate]=biterr(data, data_decode) ; % find error rate
        final_err(indx) =err_rate;
        snr_range(indx) =snrval;
        indx=indx+1;
    end

    final_err=sort(final_err, 'descend' ) ;
    semilogy(snr_range, final_err, 'color', [rand rand 1], 'linewidth', 2) ;
    final_err=[];
    snr_range= [] ;
    hold on;
end
xlabel('SNR (dB) ') ;
ylabel( 'BER' ) ;
grid on;
legend( 'MULTIPLE INPUT SINGLE OUTPUT') ;
title('16 QAM') ;
pause(2) ;

%% 64 QAM

disp('EXECUTING 64 QAM IN MUTLIPLE INPUT SINGLE OUTPUT');
pause(2);
figure,
modulation_index=64;
no_of_rx=2;
for no_of_tx=2:2 % no of receiver
    indx=1;
    for snrval=snr_lmt
        mess_len=3000*pack_len;
        data = randi([0 1],mess_len, 1) ;
        % Tramsmitt source path to dest path
        data_mod=MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
        data_enc=OSTBCBENC_PROCESS(data_mod, no_of_tx) ; %% ostbc encoder
        [noise_data_src_to_dest, chan_gain_src_to_dest]=CHANNEL_FADE_DESIGN(no_of_tx, no_of_rx, data_enc, snrval) ; % channel fading and noise process
        rx_data=noise_data_src_to_dest;
        data_dec=OSTBCDEC_PROCESS(rx_data, no_of_tx, no_of_rx, chan_gain_src_to_dest) ; %% ostbc decoder process
        data_decode=DEMOD_DATA_PROCESS(data_dec, modulation_index) ; % demodulation process
        [err_amt, err_rate]=biterr(data, data_decode) ; % find error rate
        final_err(indx) =err_rate;
        snr_range(indx) =snrval;
        indx=indx+1;
    end

    final_err=sort(final_err, 'descend' ) ;
    semilogy(snr_range, final_err, 'color', [1 rand 0], 'linewidth', 2) ;
    final_err=[];
    snr_range= [] ;
    hold on;
end
xlabel('SNR (dB) ') ;
ylabel( 'BER' ) ;
grid on;
legend( 'MULTIPLE INPUT SINGLE OUTPUT') ;
title('64 QAM') ;
pause(2) ;

