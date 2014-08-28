--建表
create table t_name (
	id,
	c_name_1,
	c_name_2
	primary key(id)	
);

--创建索引
create index i_index_name on t_name (
   c_name  asc
);

--赋权
grant control(或者all) on table t_name to user login_user;

--创建sequence
create sequence seq_name as bigint
start with 1
increment by 1;

--创建唯一约束
alter table t_name add constraint c_name unique(column_name); 

--db2 建表和建序列都需要赋权


--导出数据备份
EXPORT TO /path/file_name.csv of del SELECT * FROM t_name;

--导入备份数据
import from /path/file_name.csv of del insert into t_name;