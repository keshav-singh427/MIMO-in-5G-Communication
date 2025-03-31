clc;
clear all;
warning off;

%% BPSK 
disp('EXECUTING BPSK IN SINGLE INPUT MUTLIPLE OUTPUT');
pause(2);
figure,
for no_of_rx=2:2 % no of receiver
    mess_len=20000;
    data=randsrc(mess_len, 1, 0:1) ; % generate message
    modulation_index=2;
    mod_data= MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
    index=1;
    chan_mdl=randn(1, no_of_rx) + 1i*randn(1, no_of_rx) ; % channel model
    for snrval=0:2:20
        noise_data=awgn(mod_data, snrval);
        for k3=1:mess_len
            rx_data(k3, 1:no_of_rx) = chan_mdl*noise_data(k3);
        end
        for k4=1:mess_len
            rx_data_process(k4, 1:no_of_rx)=conj(chan_mdl) .* rx_data(k4,:) ;
        end
        rx_data_final=rx_data_process(:, 1) ;
        rx_data_out=DEMOD_DATA_PROCESS(rx_data_final, modulation_index) ;
        [erramt, errrate]=biterr(data, rx_data_out);
        final_err1(index) =errrate;
        final_snr1(index) =snrval;
        index=index+1;
    end

    semilogy(final_snr1, final_err1, 'color', [rand 1 rand], 'linewidth', 2) ;
    final_err1=[];
    final_snr1=[];
    hold on

end
xlabel('SNR (dB) ');
ylabel('BER' ) ;
grid on;
legend (' SINGLE INPUT MULTIPLE OUTPUT') ;
title ('BPSK' ) ;
pause (2) ;

%% QPSK 

disp('EXECUTING QPSK IN SINGLE INPUT MUTLIPLE OUTPUT');
pause(2);
figure,
for no_of_rx=2:2 % no of receiver
    mess_len=20000;
    data=randsrc(mess_len, 1, 0:1) ; % generate message
    modulation_index=4;
    mod_data= MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
    index=1;
    chan_mdl=randn(1, no_of_rx) + 1i*randn(1, no_of_rx) ; % channel model
    for snrval=0:2:20
        noise_data=awgn(mod_data, snrval);
        for k3=1:mess_len
            rx_data(k3, 1:no_of_rx) = chan_mdl*noise_data(k3);
        end
        for k4=1:mess_len
            rx_data_process(k4, 1:no_of_rx)=conj(chan_mdl) .* rx_data(k4,:) ;
        end
        rx_data_final=rx_data_process(:, 1) ;
        rx_data_out=DEMOD_DATA_PROCESS(rx_data_final, modulation_index) ;
        [erramt, errrate]=biterr(data, rx_data_out);
        final_err2(index) =errrate;
        final_snr2(index) =snrval;
        index=index+1;
    end

    semilogy(final_snr2, final_err2, 'color', [rand rand 0], 'linewidth', 2) ;
    final_err2=[];
    final_snr2=[];
    hold on;

end
xlabel('SNR (dB) ');
ylabel('BER' ) ;
grid on;
legend (' SINGLE INPUT MULTIPLE OUTPUT') ;
title ('QPSK' ) ;
pause (2) ;

%% 16 QAM 

disp('EXECUTING 16-QAM IN SINGLE INPUT MUTLIPLE OUTPUT');
pause(2);
figure,
for no_of_rx=2:2 % no of receiver
    mess_len=20000;
    data=randsrc(mess_len, 1, 0:1) ; % generate message
    modulation_index=16;
    mod_data= MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
    index=1;
    chan_mdl=randn(1, no_of_rx) + 1i*randn(1, no_of_rx) ; % channel model
    for snrval=0:2:20
        noise_data=awgn(mod_data, snrval);
        for k3=1:mess_len
            rx_data2(k3, 1:no_of_rx) = chan_mdl*noise_data(k3);
        end
        for k4=1:mess_len
            rx_data_process2(k4, 1:no_of_rx)=rx_data2(k4,:)./chan_mdl ;
        end
        rx_data_final=rx_data_process2(:, 1) ;
        rx_data_out=DEMOD_DATA_PROCESS(rx_data_final, modulation_index) ;
        [erramt, errrate]=biterr(data, rx_data_out);
        final_err3(index) =errrate;
        final_snr3(index) =snrval;
        index=index+1;
    end

    semilogy(final_snr3, final_err3, 'color', [rand 1 rand], 'linewidth', 2) ;
    final_err3=[];
    final_snr3=[];
    hold on;

end
xlabel('SNR (dB) ');
ylabel('BER' ) ;
grid on;
legend (' SINGLE INPUT MULTIPLE OUTPUT') ;
title ('16-QAM' ) ;
pause (2) ;

%% 64 QAM

disp('EXECUTING 64-QAM IN SINGLE INPUT MUTLIPLE OUTPUT');
pause(2);
figure,
for no_of_rx=2:2 % no of receiver
    mess_len=20000;
    data=randsrc(mess_len, 1, 0:1) ; % generate message
    modulation_index=64;
    mod_data= MOD_DATA_PROCESS(data, modulation_index) ; % modulation process
    index=1;
    chan_mdl=randn(1, no_of_rx) + 1i*randn(1, no_of_rx) ; % channel model
    for snrval=0:2:20
        noise_data=awgn(mod_data, snrval);
        for k3=1:mess_len
            rx_data3(k3, 1:no_of_rx) = chan_mdl*noise_data(k3);
        end
        for k4=1:mess_len
            rx_data_process3(k4, 1:no_of_rx)=rx_data3(k4,:)./chan_mdl ;
        end
        rx_data_final=rx_data_process3(:, 1) ;
        rx_data_out=DEMOD_DATA_PROCESS(rx_data_final, modulation_index) ;
        [erramt, errrate]=biterr(data, rx_data_out);
        final_err4(index) =errrate;
        final_snr4(index) =snrval;
        index=index+1;
    end

    semilogy(final_snr4, final_err4, 'color', [0 rand rand], 'linewidth', 2) ;
    final_err4=[];
    final_snr4=[];
    hold on;

end
xlabel('SNR (dB) ');
ylabel('BER' ) ;
grid on;
legend (' SINGLE INPUT MULTIPLE OUTPUT') ;
title ('64 QAM' ) ;



