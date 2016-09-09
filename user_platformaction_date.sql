/* SQL runner query for user_platformaction_date data set*/
select distinct u.id, up.date_id
from user_platform_action_facts up
join user_dimensions u
on u.id = up.user_id
where u.email is not null 
