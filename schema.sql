create table users 
  (id serial PRIMARY KEY, 
  created_at timestamp, 
  updated_at timestamp, 
  logged_in timestamp,
  github_id integer);
create table channels
  (id varchar(30) PRIMARY KEY, 
  key varchar(30), name varchar(64), 
  user_id integer,
  created_at timestamp, 
  updated_at timestamp);
create table gists
  (id serial PRIMARY KEY,
  gist_url varchar(180),
  channel_id varchar(30));
  
