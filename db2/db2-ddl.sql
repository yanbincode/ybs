--����
create table t_name (
	id,
	c_name_1,
	c_name_2
	primary key(id)	
);

--��������
create index i_index_name on t_name (
   c_name  asc
);

--��Ȩ
grant control(����all) on table t_name to user login_user;

--����sequence
create sequence seq_name as bigint
start with 1
increment by 1;

--����ΨһԼ��
alter table t_name add constraint c_name unique(column_name); 

--db2 ����ͽ����ж���Ҫ��Ȩ


--�������ݱ���
EXPORT TO /path/file_name.csv of del SELECT * FROM t_name;

--���뱸������
import from /path/file_name.csv of del insert into t_name;