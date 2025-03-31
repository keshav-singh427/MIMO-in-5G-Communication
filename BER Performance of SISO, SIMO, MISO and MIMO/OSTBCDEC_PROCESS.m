function dec_data_out=OSTBCDEC_PROCESS (data_in, tx_no_of, rx_no_of, pg)

if (tx_no_of<5)
    dec_obj=comm.OSTBCCombiner('NumTransmitAntennas' , tx_no_of, 'NumReceiveAntennas' , rx_no_of) ;
    dec_data_out=step(dec_obj, data_in, squeeze(pg) ) ;
elseif (tx_no_of == 5)
    dec_obj=comm.OSTBCCombiner('NumTransmitAntennas' , tx_no_of-1, 'NumReceiveAntennas' , rx_no_of) ;
    dec_data_out=step(dec_obj,data_in, squeeze(pg(:,:,1:tx_no_of-1,:)) ) ;
elseif (tx_no_of == 6)
    dec_obj=comm.OSTBCCombiner('NumTransmitAntennas' , tx_no_of-2, 'NumReceiveAntennas' , rx_no_of) ;
    dec_data_out=step(dec_obj,data_in, squeeze(pg(:,:,1:tx_no_of-2,:) ) ) ;
elseif (tx_no_of == 7)
    dec_obj=comm.OSTBCCombiner('NumTransmitAntennas' , tx_no_of-3, 'NumReceiveAntennas' , rx_no_of) ;
    dec_data_out=step(dec_obj,data_in,squeeze(pg(:,:,1:tx_no_of-3,:)));
elseif(tx_no_of == 8)
    dec_obj=comm.OSTBCCombiner('NumTransmitAntennas', tx_no_of-4, 'NumReceiveAntennas' , rx_no_of) ;
    dec_data_out=step(dec_obj,data_in, squeeze(pg(:,:,1:tx_no_of-4,:) ) ) ;
end