Select sender_id,txn_id,amount,
Round(AVG(amount)over (partition by sender_id order by txn_time
rows between 5 Preceding and current row),2)as moving_avg,
case 
   when amount >2* AVG (amount) over (partition by sender_id order by txn_time
   rows between 5 preceding and current row )
   then 'spike'
   else 'normal'
   End as status 
   from transactions 
   order by sender_id,txn_time;