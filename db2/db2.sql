--查询sequence下一个的值
select nextval for s_seqname from sysibm.sysdummy1;

--查询sequence当前的值
select prevval for s_seqname from sysibm.sysdummy1;

--查询数据库当前时间
select current timestamp from sysibm.sysdummy1;

--查询表的字段长度
select TABNAME,sum(length) from syscat.COLUMNS where TABSCHEMA = 'HSMDB' group by TABNAME having sum(length) >4005

--修改列
alter table table_name alter column column_name SET DATA TYPE varchar(64);

--增加一列
alter table table_name add column column_name varchar(64);

--查询前多少条数据
select * from table_name fetch first 100 rows only;