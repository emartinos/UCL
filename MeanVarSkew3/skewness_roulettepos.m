%function to plot constant decelerating object position given time

function [pos_out, tix] = skewness_roulettepos(out_ang, T_end, frame_dur)

vinit = 360*2./1000; %initial velocity in degrees per ms
scale = 2*T_end./vinit; %required scaling factor
tix = 0:frame_dur:T_end; %time index (frames)
pos_out = -(((tix - T_end).^2)./scale) + out_ang; %position indices
