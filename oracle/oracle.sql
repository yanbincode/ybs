
--11g安装卸载：http://www.docin.com/p-101031596.html ;
--oracle SQL 基本语法

--==============表空间的操作===============--

--创建表空间
create tablespace ts_name
logging
datafile 'path\ts_name.dat' 
size 10m
autoextend on
next 10m maxsize 1025m;
extend management local;

--修改表空间
alter tablespace xx;

--查询表空间
select * from dba_data_files where TABLESPACE_NAME = '';

--删除表空间
drop tablespace ts_name including contents and datafiles;

--============================对用户的操作========================--

--创建用户
create user user_name identified by pass_word
default tablespace ts_name
temporary tablespace user_temp;

--删除用户
drop user user_name cascade;

--给用户授权
grant connect,resource to user_name

--================================对表的操作===============================

--创建表
create table t_name (
	column_1 type not null,
	column_2 number,
	column_3 varchar2(10)
) 
tablespace ts_name; --指定表空间

--指定列设置主键
alter table t_name
add constraint pk_t_name primary key(column_name);

--对主键列定义自增序列（创建序列）
create sequence seq_name
increment by 1
start with 1;

--对sequence的查询，查找sequence的下一个序列
select seq_name.nextval from dual;
--查找当前的序列
select seq_name.currval from dual;

--建立"自增"触发器
create or replace trigger seq_trigger_name 
    before insert on table_name  
    for each row  
begin  
    select seq_trigger_name.Nextval into :New.column_name from dual;  
end;

--修改表名
alter table old_t_name rename to new_t_name; 

--删除表
drop table t_name;

--============================对表字段结构的操作========================--

--给现有表添加字段（单列，单句）
alter table t_name 
add column_name type;

--给现有表添加字段（单句批量）
alter table t_name
add (
	column_name_1 type,
	column_name_2 type,
	column_name_3 type
);

--修改现有列（单列，单句）
alter table t_name
modify column_name type;

--修改现有列（单句批量）
alter table t_name
modify (
	column_name_1 type,
	column_name_2 type,
	column_name_3 type
);

--删除列 （不存在批量删除）
alter table t_name
drop column column_name;

--重命名列
alter table t_name
rename column old_column_name to new_column_name;

--给表结构中的列添加注释
comment on column t_name.c_name is 'comment_content';

--只复制表结构的sql
create table tb_a as select * from tb_b where 1<>1;

--即复制表结构又复制表中数据的sql
create table tb_a as select * from tb_b;

--复制表的制定字段的sql
create table tb_a as select column_1,column_2,column_3 from tb_b where 1<>1;



--======================================SQL 查询语句 DML =============================--

--分页查询语句(效率最高的方式)
--rownum对小于某值的查询条件是人为true的，rownum对于大于某值的查询条件直接认为是false的
select *
  from (select tn.*, rownum as rn
          from (select * from table_name) tn
         where rownum <= end_num)  --rownum属性where条件 > 是差不出数据的
 where rn >= begin_num;
 
--选择第一条
select * from table_name where rownum = 1;

--排序完第一条
select *
  from (select * from table_name order by column_1 desc)
 where rownum = 1;
 
--外联接
select * from table_1 t1 full outer join table_2 t2 on t1 = t2;
 
--oracle常用函数
nvl(A, B) --如果 A为空则结果为B ，如果A不为空结果则为A ，如果A，B都为空则返回NULL。
nvl2(A, b, c) --如果A为空则结果为b，如果A不为空结果则为c 
decode(A, B, b, C, c, D,d) --如果A=B 结果为b，如果A=C 结果为c，如果A=D 则结果为d 

--树形结构使用
--根节点查询所有枝叶
select *
  from table_name t
connect by prior t.id = t.parent_id
 start with t.id = 0; --此处可以用in 例如:start with t.id in (0,1,2)查寻出多个父的枝叶

--根据子节点查询所有父节点
select * fromtable_name t
connect by prior t.parent_id = t.id --和父查子的位置交换
 startwith t.id = 100; --同样此处可以用in查询多个父节点

--根据根节点查询所有的叶子
-- connect_by_isleaf函数：判断此节点是否为叶子，如果为叶子则伪列值为1，如果不是为0
select t.*, connect_by_isleaf as isleaf
  from table_name t
connect by prior t.id = t.parent_id
 start with t.id = 0;


--==========时间处理，秒，分，时，日，月，年==========--

--日期，字符转换函数
select to_date('20111103222222','yyyy-mm-dd hh24:mi:ss') from dual;
select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual;

--查看指定时间的年，月，日，周
select to_char(sysdate, 'yyyy') from dual;
select to_char(sysdate, 'mm') from dual;
select to_char(sysdate, 'dd') from dual;
select to_char(sysdate, 'ww') from dual;

--查看指定时间的时分秒  （hh24为24小时制，hh为12小时制）
select to_char(sysdate, 'hh24') from dual;
select to_char(sysdate, 'mi') from dual;
select to_char(sysdate, 'ss') from dual;

--查看指定日期是星期几，几几年，几月
select to_char(sysdate,'day') from dual;
select to_char(sysdate,'D') from dual; --查询出阿拉伯数字，result - 1 为 当天的星期几
select to_char(sysdate,'year') from dual;
select to_char(sysdate,'month') from dual;

-------时，分，秒，年，月，日 的基本计算------

--计算两个日期间的工作日天数（去除星期六和星期天）
select count(*)
  from (select rownum - 1 rnum
          from all_objects --all_objects 特定的数据集合
         where rownum <= sysdate - to_date('20111003', 'yyyy-mm-dd') + 1) --指定两个日期
 where to_char(to_date('20111003', 'yyyy-mm-dd') + rnum - 1, 'D') not in
       ('6', '7');

--计算两个日期间的天数
select floor(sysdate - to_date('20111003','yyyy-mm-dd')) from dual;  --floor() 函数，舍弃小数点后面的数值
       
--计算两个日期之间的月数  利用months_between(date_1,date_2) 函数
select floor(months_between(sysdate,to_date('20111003', 'yyyy-mm-dd'))) FROM DUAL;   
select (to_char(sysdate, 'mm') - to_char(to_date('20111003', 'yyyy-mm-dd'),'mm')) FROM DUAL;

--当前时间加一个月
select add_months(sysdate,1) from dual;

--计算两个日期之间相差的年数
select (to_char(sysdate, 'yyyy') - to_char(to_date('20111003', 'yyyy-mm-dd'),'yyyy')) FROM DUAL;

--计算两个日期之间相差的小时数
　 select Days,
　　　　　 A,
　　　　　 TRUNC(A*24)　　　　　　　　　　　　　　　　　　 Hours,
　　　　　 TRUNC(A*24*60 - 60*TRUNC(A*24))　　　　　　　　 Minutes,
　　　　　 TRUNC(A*24*60*60 - 60*TRUNC(A*24*60))　　　　　 Seconds,
　　　　　 TRUNC(A*24*60*60*100 - 100*TRUNC(A*24*60*60))　 mSeconds
　 from
　 ( select trunc(sysdate)　　Days, sysdate - to_date('20111103222222','yyyy-mm-dd hh24:mi:ss')　　　A
　 from dual
　 );

--取指定一年的天数  (一般的两个date型相减，得出的结果为天)
select add_months(trunc(sysdate,'year'), 12) - trunc(sysdate,'year') from dual;

--计算指定日期，是一年的第几天  to_char(date, 'ddd') 是计算一年的多少天
select to_char(sysdate,'ddd'),sysdate from dual;

--计算指定日期的当前月的最后一天
select last_day(sysdate) from dual; 

--=============数字计算=================---
--转换成数字
select to_number('1256') from dual;

--取整：向下取整
select floor(5.001) from dual;
select trunc(5.501) from dual;

--取整：向上取整
select ceil(5.303) from dual;


--trunc函数，截取指定小数点后n位，不指定则保留整数
select trunc(89.9934) from dual;
select trunc(89.9934,2) from dual;

--四舍五入:round函数，round和trunc用法类似
select round(89.9934) from dual;
select round(89.9934,2) from dual;

--mod函数，返回A数除以B数的余数，如果B数为0则返回A数
select mod(10,3) from dual;

--===========================字符串函数=======================================--
--查找字符串包含某个字符的个数
select nvl(lengthb('[A+B,A+C,A+D,A+E]'),0)-nvl(lengthb(replace('[A+B,A+C,A+D,A+E]',',',null)),0) from dual;
