/*oracle 函数的大致写法*/
CREATE OR REPLACE FUNCTION f_function_name (                        
    --输入参数
    p_param_1     VARCHAR2,
    p_param_2     NUMBER)
    --返回值类型
    RETURN varchar2
IS
   --声明零时变量
   ls_param_1   VARCHAR2 (100);
   ls_param_2   Number;
   ls_result    VARCHAR2 (100);
   
--方法体
BEGIN
   --初始化一些参数
   ls_param_1 := 'holle world : ';

   --查询语句赋值
   SELECT 20 INTO ls_param_2 FROM DUAL;

   --写一个for 循环:i 从1 到 ls_param_2循环递增
   FOR i IN 1 .. ls_param_2
   LOOP
      --写一个判断语句
      IF (p_param_2 = i)                              --如果循环的值和参数相同
      THEN
         --输出语句
         ls_result := ls_param_1 || p_param_1;
         DBMS_OUTPUT.put (ls_result);
      END IF;
   END LOOP;

   --返回值
   RETURN (ls_result);
END f_function_name;
/


--  select F_FUNCTION_NAME('YANBIN', 10) from dual;  调用函数