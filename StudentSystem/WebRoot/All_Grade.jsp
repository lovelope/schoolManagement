<%@ page language="java" import="java.util.*,java.sql.*,javax.sql.*,javax.naming.*,com.studentsystem.*;" pageEncoding="GBK"%>
<%!  List<Course> Courseinfo=new ArrayList<Course>();
     Course temp;
%>
<% 
    Courseinfo=(List<Course>)session.getAttribute("Grade"); 
    System.out.println("在All_grade的Grade的大小:"+Courseinfo.size());
%>

<html>
  <body>
      <h2>所有课程成绩</h2> 
      <form action="Studentservlet" method="post">
      <input type="hidden" name="item" value="2">
      <table border="1">
      <tr>
        <td>课程号</td>
        <td>课程名</td>
        <td>学分</td>
        <td>成绩</td>
      </tr>
      <tr>
       <%
      
         for(int i=0;i<Courseinfo.size();i++)
         {
             temp=Courseinfo.get(i); 
        %>
       <td><%=temp.getCourseNo()%></td>
       <td><%=temp.getCouresName()%></td>
       <td><%=temp.getGrade()%></td>
       <td><%=temp.getResult()%></td>
       </tr>
       <%
       }%>
      </table>
      </form>
  </body>
</html>