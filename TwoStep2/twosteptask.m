% main file from which all scripts are ran

clc
clear all
temp_wd = pwd;

ts_initialize;
ts_prac_instructions;
ts_practice;
ts_test_instructions;
ts_test;
ts_close;

cd(temp_wd);