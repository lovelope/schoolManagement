<%@ page language="java" import="java.util.*,java.sql.*,javax.sql.*,javax.naming.*,javax.servlet.http.HttpSession" pageEncoding="GBK"%>
<%! String StudentNo;
    String Name;
    String CardNo;
    String Prince;
    String sex;
    String birthday;
    String phone;
    String subject;
    String classnumber;
    String Email;
    String Academy;
    String Photo_temp;
    String Photo;
%>
<% 
   StudentNo=(String)session.getAttribute("StudentNo");
   Name=(String)session.getAttribute("Name");
   CardNo=(String)session.getAttribute("CardNo");
   Prince=(String)session.getAttribute("Prince");
   sex=(String)session.getAttribute("Sex");
   birthday=(String)session.getAttribute("Birthday");
   phone=(String)session.getAttribute("Phone");
   subject=(String)session.getAttribute("Subject");
   classnumber=(String)session.getAttribute("Classnumber");
   Email=(String)session.getAttribute("Email");
   Academy=(String)session.getAttribute("Academy");
   Photo_temp=(String)session.getAttribute("StudentPhoto");
   Photo="../"+Photo_temp;
%>

<html>
  <body>
       <h2>&nbsp;&nbsp;&nbsp;学生个人信息</h2> <br>
    <table border=1>
      <tr>
       	<td>学号：</td>
       	<td><%=StudentNo%></td>
       	<td>姓名：</td>
       	<td><%=Name%></td>
      </tr>
      <tr>
       	<td>身份证号：</td>
       	<td><%=CardNo%></td>
       	<td>省份：</td>
       	<td><%=Prince%></td>
      </tr>
      <tr>
       	<td>性别：</td>
       	<td><%=sex%></td>
       	<td>出生年月</td>
       	<td><%=birthday%></td>
      </tr>
      <tr>
       	<td>联系电话：</td>
       	<td><%=phone%></td>
       	<td>专业：</td>
       	<td><%=subject%></td>
      </tr>
      <tr>
       	<td>班级：</td>
       	<td><%=classnumber%></td>
       	<td>电子邮箱：</td>
       	<td><%=Email%></td>
      </tr>
       <tr>
       	<td>学院：</td>
       	<td><%=Academy%></td>
      </tr>
      <tr>
        <td>照片</td>
        <td><img src=<%=Photo%>></td>
      </tr>
    </table>
  </body>
</html>
