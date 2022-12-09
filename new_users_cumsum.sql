-- find number of active users per month

select * from users;


select 
	nu.year as year,
    nu.month as month,
    sum(new_users) over (order by nu.year, nu.month) as cumulative_sum
from (
		select
			extract(year from created_at) as year,
			extract(month from created_at) as month,
			count(*) as new_users
		from users
		group by 1, 2
) nu 
;