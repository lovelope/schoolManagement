<%@ page language="java" import="java.util.*,java.sql.*,javax.sql.*,javax.naming.*,com.studentsystem.*;" pageEncoding="GBK"%>

<%
      List<Course> Grade=new ArrayList<Course>();
      List<Course> SearchGrade=new ArrayList<Course>();
      Connection con=null;
      DataSource ds=null;
      PreparedStatement ps=null;
      PreparedStatement ps_grade=null;
      //读取数据库中数据
      try {
			Context initCtx=new InitialContext();
			Context encCtx=(Context)initCtx.lookup("java:comp/env");
			ds=(DataSource)encCtx.lookup("jdbc/mssql2014");
			con=ds.getConnection();
			con.setAutoCommit(false);
	        session=request.getSession();
	        String username;
	        username=(String)session.getAttribute("userid");  
			ps_grade=con.prepareStatement("SELECT CourseInfo.CourseNo,CourseInfo.CourseName,CourseInfo.Grade,SC.Result FROM SC,CourseInfo WHERE CourseInfo.CourseNo=SC.CourseNo AND SC.StudentNo=? AND SC.Result!=0");
			ps_grade.setString(1,username);
			ResultSet rs_grade=ps_grade.executeQuery();
            while (rs_grade.next()) 
	        {     
			    Course temp=new Course();
			    temp.setCourseNo(rs_grade.getString(1));
			    temp.setCourseName(rs_grade.getString(2));
			    temp.setGrade(rs_grade.getFloat(3));
			    temp.setResult(rs_grade.getFloat(4));
			    Grade.add(temp);       
			}	
			rs_grade.close();
			ps_grade.close();
			con.close();
			
			System.out.println("用户："+username+"有成绩的课程的大小:"+Grade.size());
            session.setAttribute("Grade",Grade);
            session.setAttribute("SearchGrade",SearchGrade);		
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
%>
<html>
<head>
   	
   <link rel="stylesheet" type="text/css" href="style.css">
   	<style type="text/css">
   	#mainwrapper 
   	{
   	     width:100%;
   		 height:95%;
   	} 
   
    #content 
    {
    	 overflow:hidden;
    	 float:right;
    	 background:#EE7621;
    	 width:80%;
    	 height:95%;
    }
    #content iframe{
    	 width:100%;
    	 height:100%;
    	 border: 0px;
    }
    #sidebar
    { 
    	overflow:hidden;
    	float:left;
    	background:#2268c8;
    	width:20%;
    	height:95%;
    }
	</style>
</head>
 <body>
	   <div id="mainwrapper">
	   	  <div id="sidebar">
	   	  	<ul>
	   	  	<!--注意iframe里的id和name要相同，且嵌套的html的iframe的id必须不同 -->
	   	  		<li><a href="Grade.jsp" target="show_grade" ><span>查询成绩 </span> </a>
	   	  		<li><a href="All_Grade.jsp" target="show_grade">显示所有已修课程成绩</a></li>
	   	  	</ul>
	   	  </div>
	     <div id="content">
	        <iframe id="show_grade" name="show_grade" ></iframe>
	   	 </div>
	   </div>
	   <div id="footer">
    	<div id="copy">
		   <div id="copyright">
			 <p>CopyRight&copy;2016</p>
			 <p>西安电子科技大学</p>
			</div>
		</div>
	</div>
 </body>
</html>