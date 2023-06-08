USE operations;

-- 							-------------------------- Operation Analytics ----------------------------------
SELECT * FROM project;

-- jobs reviewed per hour per day
SELECT ds AS Date, 
	ROUND(COUNT(DISTINCT job_id)/ SUM(time_spent)*3600) as jobs_reviewed 
FROM project 
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds;

-- daily throughput
SELECT ds AS Date, 
	ROUND(COUNT(event)/ SUM(time_spent),2) AS Daily_throughput
FROM project 
GROUP BY ds 
ORDER BY ds;
-- 7 day throughput
SELECT ROUND(COUNT(event)/ SUM(time_spent),2) AS Weekly_throughput FROM project ;

-- share of each language
SELECT language, 
	ROUND(100.00 * COUNT(*)/total_jobs,2) AS each_share
FROM project
CROSS JOIN
	(SELECT COUNT(*) AS total_jobs FROM project) AS total 
GROUP BY language;

-- duplicate values
SELECT actor_id, 
	COUNT(actor_id) AS Duplicates 
FROM project 
GROUP BY actor_id HAVING COUNT(*) > 1;

--          ----------------------------------------Investigating Metrics-------------------------------

SELECT * FROM users;
SELECT * FROM T_event;
SELECT * FROM email_events;

-- 	weekly user engagement
SELECT 
	EXTRACT(WEEK FROM occured_at) AS week_number,
	COUNT(DISTINCT(user_id)) AS num_of_users
FROM T_event
GROUP BY week_number;

-- user growth for product
 SELECT year, month, user_count,
	ROUND(((user_count/LAG(user_count,1) OVER (ORDER BY Month) - 1)*100),2) AS 'user_%_growth'
 FROM
 (SELECT 
	EXTRACT(year FROM created_at) AS year,
	EXTRACT(month FROM created_at) AS Month, 
	COUNT(activated_at) AS user_count FROM users 
	GROUP BY Year,Month) a Order By year;

-- Weekly retention of users
SELECT first_login AS Week_no,
SUM(CASE WHEN week_num = 1 THEN 1 ELSE 0 END) AS Week_1,
SUM(CASE WHEN week_num = 2 THEN 1 ELSE 0 END) AS Week_2,
SUM(CASE WHEN week_num = 3 THEN 1 ELSE 0 END) AS Week_3,
SUM(CASE WHEN week_num = 4 THEN 1 ELSE 0 END) AS Week_4,
SUM(CASE WHEN week_num = 5 THEN 1 ELSE 0 END) AS Week_5,
SUM(CASE WHEN week_num = 6 THEN 1 ELSE 0 END) AS Week_6,
SUM(CASE WHEN week_num = 7 THEN 1 ELSE 0 END) AS Week_7,
SUM(CASE WHEN week_num = 8 THEN 1 ELSE 0 END) AS Week_8,
SUM(CASE WHEN week_num = 9 THEN 1 ELSE 0 END) AS Week_9,
SUM(CASE WHEN week_num = 10 THEN 1 ELSE 0 END) AS Week_10,
SUM(CASE WHEN week_num = 11 THEN 1 ELSE 0 END) AS Week_11,
SUM(CASE WHEN week_num = 12 THEN 1 ELSE 0 END) AS Week_12,
SUM(CASE WHEN week_num = 13 THEN 1 ELSE 0 END) AS Week_13,
SUM(CASE WHEN week_num = 14 THEN 1 ELSE 0 END) AS Week_14,
SUM(CASE WHEN week_num = 15 THEN 1 ELSE 0 END) AS Week_15,
SUM(CASE WHEN week_num = 16 THEN 1 ELSE 0 END) AS Week_16,
SUM(CASE WHEN week_num = 17 THEN 1 ELSE 0 END) AS Week_17,
SUM(CASE WHEN week_num = 18 THEN 1 ELSE 0 END) AS Week_18
FROM
(
SELECT m.user_id,
		n.first_login ,
        m.login_week,
		m.login_week - n. first_login AS week_num
FROM
(SELECT user_id,
		extract(week FROM occured_at) AS login_week 
        FROM T_event 
        GROUP BY user_id, login_week) m,
(SELECT user_id,
		MIN(extract(week FROM occured_at)) AS first_login 
        FROM T_event 
        GROUP BY user_id) n
	WHERE m.user_id = n.user_id) AS with_week_num 
GROUP BY first_login ORDER BY first_login;

-- weekly engagement
select EXTRACT(week FROM occured_at) AS week_num,
count(distinct case when device in('acer aspire desktop') then user_id else null end) as 'acer aspire desktop',
count(distinct case when device in('acer aspire notebook') then user_id else null end) as 'acer aspire notebook',
count(distinct case when device in('amazon fire phone') then user_id else null end) as 'amazon fire phone',
count(distinct case when device in('asus chromebook') then user_id else null end) as 'asus chromebook',
count(distinct case when device in('dell inspiron desktop') then user_id else null end) as 'dell inspiron desktop',
count(distinct case when device in('dell inspiron notebook') then user_id else null end) as 'dell inspiron notebook',
count(distinct case when device in('hp pavilion desktop') then user_id else null end) as 'hp pavilion desktop',
count(distinct case when device in('htc one') then user_id else null end) as 'htc one',
count(distinct case when device in('ipad air') then user_id else null end) as 'ipad air',
count(distinct case when device in('ipad mini') then user_id else null end) as 'ipad mini',
count(distinct case when device in('iphone 4s') then user_id else null end) as 'iphone 4s',
count(distinct case when device in('iphone 5') then user_id else null end) as 'iphone 5',
count(distinct case when device in('iphone 5s') then user_id else null end) as 'iphone 5s',
count(distinct case when device in('kindle fire') then user_id else null end) as 'kindle fire',
count(distinct case when device in('lenovo thinkpad') then user_id else null end) as 'lenovo thinkpad',
count(distinct case when device in('mac mini') then user_id else null end) as 'mac mini',
count(distinct case when device in('macbook air') then user_id else null end) as 'macbook air',
count(distinct case when device in('macbook pro') then user_id else null end) as 'macbook pro',
count(distinct case when device in('nexus 10') then user_id else null end) as 'nexus 10',
count(distinct case when device in('nexus 5') then user_id else null end) as 'nexus 5',
count(distinct case when device in('nexus 7') then user_id else null end) as 'nexus 7',
count(distinct case when device in('nokia lumia 635') then user_id else null end) as 'nokia lumia 635',
count(distinct case when device in('samsumg galaxy tablet') then user_id else null end) as 'samsumg galaxy tablet',
count(distinct case when device in('samsung galaxy note') then user_id else null end) as 'samsung galaxy note',
count(distinct case when device in('samsung galaxy s4') then user_id else null end) as 'samsung galaxy s4',
count(distinct case when device in('windows surface') then user_id else null end) as 'windows surface'
FROM T_event
where event_type = 'engagement'
group by 1
order by 1;

-- emeail engagement
SELECT 
	week_num,
	ROUND((email_sent/Total*100),2) AS sent_email_rate,
	ROUND((email_opened/Total*100),2) AS opened_email_rate,
	ROUND((email_clicked/Total*100),2) AS clicked_email_rate
FROM (
	SELECT EXTRACT(week FROM occured_at) AS week_num,
		   COUNT(CASE WHEN action in ('sent_weekly_digest','sent_reengagement_email' ) THEN user_id ELSE NULL END) AS 'email_sent',
		   COUNT(CASE WHEN action = 'email_open' THEN user_id ELSE NULL END) AS email_opened,
		   COUNT(CASE WHEN action = 'email_clickthrough' THEN user_id ELSE NULL END) AS email_clicked,
		   COUNT(user_id) AS Total
	FROM email_events 
    Group BY 1 
    ORDER BY 1) AS cal 
GROUP BY 1;

