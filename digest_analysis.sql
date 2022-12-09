select 
	event_name,
    event_type
from events
group by 1,2;

select * from emails;

-- find out how users interact with 'sent_weekly_digest' and if email_open 's coincide

-- group users and timestamps by week

select 
	user_id,
    occurred_at as week,
    count(case when action = 'sent_weekly_digest' then 1 else null end) as num_weekly_digests_sent,
    count(case when action = 'email_open' then 1 else null end) as num_emails_opened
from emails
where action = 'sent_weekly_digest' or action = 'email_open'
group by user_id, week(occurred_at);

-- above querry gives us if the weekly email was sent and if it was opened for each user and each week()

-- now we can take the above query group by week and see if the weekly digest is sent every week
select 
	count(*)
from(


		select 
			user_id,
			occurred_at as week,
			count(case when action = 'sent_weekly_digest' then 1 else null end) as num_weekly_digests_sent,
			count(case when action = 'email_open' then 1 else null end) as num_emails_opened
		from emails
		where action = 'sent_weekly_digest' or action = 'email_open'
		group by user_id, week(occurred_at) 
) em
where em.num_weekly_digests_sent = 0;

-- we see a number of 2255 records where no weekly digest was sent , but emails were listed as open, is that 
-- the case for every one?

select 
	count(*)
from(


		select 
			user_id,
			occurred_at as week,
			count(case when action = 'sent_weekly_digest' then 1 else null end) as num_weekly_digests_sent,
			count(case when action = 'email_open' then 1 else null end) as num_emails_opened
		from emails
		where action = 'sent_weekly_digest' or action = 'email_open'
		group by user_id, week(occurred_at) 
) em
where em.num_weekly_digests_sent = 0 and
	em.num_emails_opened = 1;

-- yep the system is not logging the emails sent but users are opening them

select 
	*
from(


		select 
			user_id,
			occurred_at as week,
			count(case when action = 'sent_weekly_digest' then 1 else null end) as num_weekly_digests_sent,
			count(case when action = 'email_open' then 1 else null end) as num_emails_opened
		from emails
		where action = 'sent_weekly_digest' or action = 'email_open'
		group by user_id, week(occurred_at) 
) em
where em.num_weekly_digests_sent = 0 and
	em.num_emails_opened = 1;
    
-- now we can calcuate the percentage of emails opened and sent each week

select 
	em.week as week,
    sum(em.num_weekly_digests_sent) * 100 / count(em.num_weekly_digests_sent) as percentage_sent,
    sum(em.num_emails_opened) * 100 / count(em.num_emails_opened) as percentage_opened
from(


		select 
			user_id,
			occurred_at as week,
			count(case when action = 'sent_weekly_digest' then 1 else null end) as num_weekly_digests_sent,
			count(case when action = 'email_open' then 1 else null end) as num_emails_opened
		from emails
		where action = 'sent_weekly_digest' or action = 'email_open'
		group by user_id, week(occurred_at) 
) em
group by week(em.week)
order by 1;

-- not seeing a real trend for percentage of all weekly digests or percentage opened over time
