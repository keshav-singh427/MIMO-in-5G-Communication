%% Function to Generate Rayleigh Fading Channel
function h = uncorr_rayleg_channel(len)
    h = 1/sqrt(2) * (randn(1, len) + 1j * randn(1, len)); % Rayleigh channel coefficients
end