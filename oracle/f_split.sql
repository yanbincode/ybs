/*创建一个分割完字符的存储类型*/
CREATE OR REPLACE TYPE ty_split IS TABLE OF VARCHAR2 (4000);

CREATE OR REPLACE FUNCTION f_split (p_str VARCHAR2, p_seq VARCHAR2)
   RETURN ty_split
/*
  对指定的字符串，利用指定的符号，分割字符串。
  函数的核心思路是利用INSTR()和Substr()做字符串切分。
*/
IS
   --字符串切割用
   ls_len          NUMBER := 0;
   --存放临时字符串
   ls_str_before   VARCHAR2 (4000);
   ls_str_after    VARCHAR2 (4000);
   --存放返回值
   ls_result       ty_split := ty_split ();
--函数开始
BEGIN
   ls_str_after := p_str;

   LOOP
      ls_len := INSTR (ls_str_after, p_seq);

      IF ls_len > 0
      THEN
         ls_str_before := SUBSTR (ls_str_after, 0, ls_len - 1);
         ls_str_after := SUBSTR (ls_str_after, ls_len + 1);
         --将数组或空间扩展一位，值为null
         ls_result.EXTEND;
         ls_result (ls_result.COUNT) := ls_str_before;
      ELSE
         EXIT;
      END IF;
   END LOOP;

   RETURN ls_result;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END f_split;
/
