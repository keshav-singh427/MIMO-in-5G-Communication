function enc_data_out=OSTBCBENC_PROCESS (data_in, tx_no_of)

if (tx_no_of<5)
enc_obj=comm.OSTBCEncoder('NumTransmitAntennas' , tx_no_of) ;
enc_data_out=step(enc_obj,data_in) ;

elseif (tx_no_of == 5)
    enc_obj=comm.OSTBCEncoder('NumTransmitAntennas' , tx_no_of-1) ;
    enc_data_out=step(enc_obj,data_in);
    enc_data_out=[enc_data_out enc_data_out(:,end) ] ;
elseif (tx_no_of == 6)
    enc_obj=comm.OSTBCEncoder('NumTransmitAntennas', tx_no_of-2) ;
    enc_data_out=step(enc_obj,data_in) ;
    enc_data_out=[enc_data_out enc_data_out(:,3:end) ];
elseif (tx_no_of == 7)
    enc_obj=comm.OSTBCEncoder('NumTransmitAntennas' , tx_no_of-3) ;
    enc_data_out=step(enc_obj,data_in) ;
    enc_data_out=[enc_data_out enc_data_out(:,2:end) ] ;
elseif (tx_no_of == 8)
    enc_obj=comm. OSTBCEncoder('NumTransmitAntennas' , tx_no_of-4) ;
    enc_data_out=step(enc_obj,data_in) ;
    enc_data_out=[enc_data_out enc_data_out(: , 1:end) ] ;
end