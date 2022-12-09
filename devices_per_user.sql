-- how often do users ever use more than 1 device?


select
	sub.num_devices,
	count(*)
from(
select 
	user_id,
    count(distinct device) as num_devices
from events
group by user_id
order by 2 desc
) sub
group by sub.num_devices
;

-- 5,692 users only use one device
-- 1900 users use 2
-- 1927 use 3 devices
-- 241 use 4 devices