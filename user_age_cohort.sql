select *
from events;

select * 
from users;

-- group users by how long they have been users and see if engagement drops by user account age cohort

select 
	wc.occurred_at,
    count(case when wc.week_cohort >= 10 then 1 else null end) as 10_weeks,
    count(case when wc.week_cohort = 9 then 1 else null end) as 9_weeks,
    count(case when wc.week_cohort = 8 then 1 else null end) as 8_weeks,
    count(case when wc.week_cohort = 7 then 1 else null end) as 7_weeks,
    count(case when wc.week_cohort = 6 then 1 else null end) as 6_weeks,
    count(case when wc.week_cohort = 5 then 1 else null end) as 5_weeks,
    count(case when wc.week_cohort = 4 then 1 else null end) as 4_weeks,
    count(case when wc.week_cohort = 3 then 1 else null end) as 3_weeks,
    count(case when wc.week_cohort = 2 then 1 else null end) as 2_weeks,
    count(case when wc.week_cohort = 1 then 1 else null end) as 1_weeks,
    count(case when wc.week_cohort = 0 then 1 else null end) as new_users
from(

		select 
			occurred_at,
			floor(DATEDIFF(ev.occurred_at, us.activated_at) / 7 ) as week_cohort
			
		from events ev
		left join users us on ev.user_id = us.user_id
		where ev.event_type = 'engagement'
) wc
group by week(wc.occurred_at)
order by 1
;  

-- we can see a drop in user engagment at the 10 week mark, older accounts engage with the app less