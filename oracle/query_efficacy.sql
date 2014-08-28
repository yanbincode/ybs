--SQL 查询优化

OLTP : 联机事务处理
OLAP ：联机分析处理

/*
 * 1、oracle的执行计划
 * 
 */
toad ： ctrl + E 90%正确

1、where 条件删选，根据索引找数据量最小的条件先筛选

2、由里到到外，由上到下。不靠谱

	看树节点。父子关系。 从子走，上到下

2、like 不走索引   like 'xxx%' 走索引 like '%xxx' 不走索引

3、uniue all 

4、filter 和 access 。 

	filter ：全读，再逐条过滤
	access ：通过索引定位


-- 2、速度： 有效的资源下的响应速度

--3、性能的问题，优化 有很多的阶段 

--4、工具
oracle sql trace 
profiler 性能分析工具


绑定变量