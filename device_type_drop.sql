select 
  sub2.device_type as device_type,
  sum(sub2.neba) as sum_neba,
  sum(sub2.percent_b4_august) as percent_b4,
  sum(sub2.neaa) as sum_neaa,
  sum(sub2.percent_after_august) as percent_after
from(
-- calculate the percent drop in engagement after august for each device type
    SELECT 
      sub.device as device,
      sub.number_engagement_before_august as neba,
      sub.number_engagement_before_august * 100 / sum(sub.number_engagement_before_august) over() as percent_b4_august,
      sub.number_engagement_after_august as neaa,
      sub.number_engagement_after_august * 100 / sum(sub.number_engagement_after_august) over() as percent_after_august,
      case when sub.device in 
        ('amazon fire phone', 'htc one', 'iphone 4s', 'iphone 5', 'iphone 5s', 'nexus 10', 'nexus 5', 'nexus 7', 'nokia lumia 635', 'samsung galaxy s4', 'samsung galaxy note') then 'mobile' else (
          case when sub.device in 
            ('acer aspire desktop', 'dell inspiron desktop', 'hp pavilion desktop', 'mac mini') then 'desktop' ELSE (
              case when sub.device in 
                ('acer aspire notebook', 'asus chromebook', 'dell inspiron notebook', 'lenovo thinkpad', 'macbook air', 'macbook pro', 'windows surface') then 'laptop' else 'tablet' end) 
            
            end) end    as device_type
    from(
        SELECT 
          device,
          count(case when occurred_at < '2014-08-01' then 1 else null end) as number_engagement_before_august,
          count(case when occurred_at > '2014-08-01' then 1 else null end) as number_engagement_after_august
        from events
        where event_type = 'engagement'
        group by device
    ) sub
    ) sub2
group by sub2.device_type