function data_out=NOISE_CHANNEL_MODEL(snrval, data_in)
    noise_chan=comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SignalPower', 0.9) ;
    noise_chan.SNR =snrval;
    data_out=step(noise_chan, data_in) ;
end