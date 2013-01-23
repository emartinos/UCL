function payment = MVS3_nspn_payment(earning_arr, min_pay, max_pay)
%  function payment = MVS3_nspn_payment(earning_arr, min_pay, max_pay)
%
payment = 0.0;
blockN = size(earning_arr,1);
for k = 1:blockN
  this_payment = min_pay + (earning_arr(k,1) - earning_arr(k,2)) ...
      *(max_pay - min_pay)/(earning_arr(k,3) - earning_arr(k,2));
  payment = payment + this_payment/blockN;
end

end %% of whole function

