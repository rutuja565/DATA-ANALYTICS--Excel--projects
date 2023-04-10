use operations;
select * from project;
select * from users;
select * from T_event;
DROP TABLE email_events;

-- importing data from csv to table fromat
-- users
LOAD DATA LOCAL INFILE 'D:/Downloads/users.csv'  -- path of the file
INTO TABLE users -- name of the table values to insert into
FIELDS TERMINATED BY ',' -- break lines into tabs
ENCLOSED BY '"'
LINES TERMINATED BY '\n' -- to enter new line
IGNORE 1 ROWS -- ignore headers from file
(`user_id`,`created_at`,`company_id`,`language`,@activated_at,`state`); 
SET activated_at = nullif(@activated_at, " ");
-- event
CREATE TABLE T_event(user_id INT, occured_at DATETIME, event_type VARCHAR(20),event_name VARCHAR(20), location VARCHAR(20), device VARCHAR(30), user_type INT);
LOAD DATA LOCAL INFILE 'D:/Downloads/events.csv' 
INTO TABLE T_event
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id,occured_at,event_type,event_name,location,device,user_type);

-- email_events
CREATE TABLE email_events(user_id INT, occured_at DATETIME, action VARCHAR(20), user_type INT);
select * from email_events;
LOAD DATA LOCAL INFILE 'D:/Downloads/email_events.csv' 
INTO TABLE email_events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, occured_at, action, user_type);
