function mod_data_out=MOD_DATA_PROCESS(inform_in, M)
%mod_obj=modem.qammod('M' , M, 'PhaseOffset', 0, 'Symbolorder' , ...
%        'binary', 'InputType' , 'integer' ) ;
%mod_data_out=modulate(mod_obj, inform_in) ;

    mod_data_out= qammod(inform_in, M, 'UnitAveragePower', true, 'InputType', 'integer');
end
