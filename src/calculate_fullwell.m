function [fullwell] = calculate_fullwell(gain, bits)
fullwell = (2^bits -1) * gain;