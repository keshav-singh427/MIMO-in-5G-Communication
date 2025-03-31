function data_out=modulate_process(data_in, M)
%mod_obj=modem.qammod('M' , M, 'phaseoffset' , pi/4, ' SymbolOrder' , 'Gray', ...
%            'InputType' , 'integer' ) ;

%data_out=modulate (mod_obj, data_in) ;

data_out = qammod(data_in, M, 'UnitAveragePower', true, 'InputType', 'integer');