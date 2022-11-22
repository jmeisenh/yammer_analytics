-- now we know the most lost engagments come from mobile users
-- let's make write a script to pick out all cell phone user_id to make further analysis easier


select 
	DISTINCT sub.mobile_users
from(
select
	case when events.device in
	('amazon fire phone', 'htc one', 'iphone 4s', 'iphone 5', 'iphone 5s', 'nexus 10', 
    'nexus 5', 'nexus 7', 'nokia lumia 635', 'samsung galaxy s4', 'samsung galaxy note') then user_id else null end
    as mobile_users
from events
) sub
where sub.mobile_users is not NULL
order by 1 
;

-- first get all mobile users actions

select *
from emails
where user_id in (
		select 
			DISTINCT sub.mobile_users
		from(
		select
			case when events.device in
			('amazon fire phone', 'htc one', 'iphone 4s', 'iphone 5', 'iphone 5s', 'nexus 10', 
			'nexus 5', 'nexus 7', 'nokia lumia 635', 'samsung galaxy s4', 'samsung galaxy note') then user_id else null end
			as mobile_users
		from events
		) sub
		where sub.mobile_users is not NULL);

/*
The name of the event that occurred. "sent_weekly_digest" means that the user was delivered a digest email
 showing relevant conversations from the previous day. "email_open" means that the user opened the email.
 "email_clickthrough" means that the user clicked a link in the email. 
*/
-- lets look at how the count of different actions changes from jul27th

select 
	action,
	count(*) as total_number_of_actions,
    count(case when emails.occurred_at < '2014-07-27' then 1 else null end) as before_dip_total,
	ROUND(count(case when emails.occurred_at < '2014-07-27' then 1 else null end) /
    datediff( '2014-07-27', (min(occurred_at)))) as actions_per_day_before_dip,
    count(case when emails.occurred_at >= '2014-07-27' then 1 else null end) as after_dip_total,
	ROUND(count(case when emails.occurred_at >= '2014-07-27' then 1 else null end) /
    datediff(max(occurred_at), '2014-07-27')) as actions_per_day_after_dip
from emails
where user_id in (
		select 
			DISTINCT sub.mobile_users
		from(
		select
			case when events.device in
			('amazon fire phone', 'htc one', 'iphone 4s', 'iphone 5', 'iphone 5s', 'nexus 10', 
			'nexus 5', 'nexus 7', 'nokia lumia 635', 'samsung galaxy s4', 'samsung galaxy note') then user_id else null end
			as mobile_users
		from events
		) sub
		where sub.mobile_users is not NULL)
group by emails.action
;

-- we see an increase in sent weekly digests and open emails actions for mobile users after the dip
-- however, the email click through per day dropped.

