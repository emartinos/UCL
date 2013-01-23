

clc
clear all

for i = 1:1000
x = [];
x_prac = [];
params.task.lower_boundary = 0.2; % nathaniel used 0.25
params.task.upper_boundary = 0.8; % nathaniel used 0.75

params.task.prac.number_of_trials = 50; %nathaniel had 50 (outside scanner)
params.task.test.number_of_trials = 201; %nathaniel had 201 (in scanner)

%prac
for i = 1:8
x(i,1) = (randi(params.task.upper_boundary*100 - params.task.lower_boundary*100 + 1,1) + params.task.lower_boundary*100 - 1) / 100;
end

%fill practice phase
for i = 2:params.task.prac.number_of_trials %for every trial
    for j = 1:4 %for every stimulus in prac phase
        x(j,i) = x(j,i-1) + 0.025*randn;
        if x(j,i) > params.task.upper_boundary x(j,i) = params.task.upper_boundary; elseif x(j,i) < params.task.lower_boundary x(j,i) = params.task.lower_boundary; end
    end
end

%fill test phase
for i = 2:params.task.test.number_of_trials %for every trial
    for j = 5:8 %for every stimulus in prac phase
        x(j,i) = x(j,i-1) + 0.025*randn;
        if x(j,i) > params.task.upper_boundary x(j,i) = params.task.upper_boundary; elseif x(j,i) < params.task.lower_boundary x(j,i) = params.task.lower_boundary; end
    end
end

plot(1:201,x(1:8,:))
axis([0 201 0 1])
drawnow
pause
end