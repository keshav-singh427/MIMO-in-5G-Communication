function data_out=demodulate_process (data_in, M)

%demod_obj=modem.qamdemod('M',M,'phaseoffset',pi/4,'SymbolOrder','Gray', ...
 %               'OutputType', 'integer');
%data_out=demodulate (demod_obj,data_in) ;

data_out = qamdemod(data_in, M, 'UnitAveragePower', true, 'OutputType', 'integer');
end