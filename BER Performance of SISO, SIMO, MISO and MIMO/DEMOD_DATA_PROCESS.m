function data_out=DEMOD_DATA_PROCESS (data_in, M)

%mod_obj=modem.qamdemod ('M' ,M) ;

%data_out=demodulate(mod_obj,data_in) ;

data_out = qamdemod(data_in, M, 'UnitAveragePower', true, 'OutputType', 'integer');
end