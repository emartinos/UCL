function ordPlayed = orderPlayed(task_index,params)
% function ordPlayed = orderPlayed(task_index,params) 
% return at which order task task_index (as per function taskIndex) was played.

ordPlayed = -666;

for i = 1:params.taskNum
  if params.taskOrder(i) == task_index
    ordPlayed = i;
  end
end


end %% of whole function