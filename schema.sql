create table users 
  (id serial PRIMARY KEY, 
  created_at timestamp, 
  updated_at timestamp, 
  logged_in timestamp,
  github_id integer);
create table channels
  (id varchar(20) PRIMARY KEY, 
  key varchar(20), name varchar(64), 
  created_at timestamp, 
  updated_at timestamp);
