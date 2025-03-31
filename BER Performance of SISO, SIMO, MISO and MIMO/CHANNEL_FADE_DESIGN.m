function[noise_data, chan_gain] =CHANNEL_FADE_DESIGN(tx_r1, rx_r1, data_in, snrval)

[data_net, chan_gain]=CHANNEL_DESIGN_PROCESS(tx_r1, rx_r1, data_in) ;
noise_data=NOISE_CHANNEL_MODEL(snrval, data_net) ;