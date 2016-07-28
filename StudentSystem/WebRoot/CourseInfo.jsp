<%@ page language="java" import="java.util.*,java.sql.*,javax.sql.*,javax.naming.*,javax.servlet.http.HttpSession,com.studentsystem.*" pageEncoding="GBK"%>
<%
      Connection con=null;
      DataSource ds=null;
      PreparedStatement ps=null;
      PreparedStatement ps_cancourse=null;
      List<Course> MyCourseinfo=new ArrayList<Course>();
      List<Course> CanCourseinfo=new ArrayList<Course>();

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
	        CallableStatement cs=null;
	        String cas="{call course_student_sum(?, ?)}"; 
	        //连接三个表TeacherInfo，TC，CourseInfo,实现课程信息的查询  
			ps=con.prepareStatement("SELECT CourseInfo.CourseNo,CourseInfo.CourseName,CourseInfo.StudyTime,CourseInfo.Grade,CourseInfo.Term,CourseInfo.WhentoStudy,TeacherInfo.TeacherName FROM CourseInfo,TC,TeacherInfo WHERE TC.CourseNo=CourseInfo.CourseNo AND TC.TeacherNo=TeacherInfo.TeacherNo AND CourseInfo.CourseNo IN (SELECT CourseNo FROM SC WHERE StudentNo=?)");
			ps.setString(1,username);
			ps_cancourse=con.prepareStatement("SELECT CourseInfo.CourseNo,CourseInfo.CourseName,CourseInfo.StudyTime,CourseInfo.Grade,CourseInfo.Term,CourseInfo.WhentoStudy,TeacherInfo.TeacherName FROM CourseInfo,TC,TeacherInfo WHERE TC.CourseNo=CourseInfo.CourseNo AND TC.TeacherNo=TeacherInfo.TeacherNo AND CourseInfo.CourseNo NOT IN (SELECT CourseNo FROM SC WHERE StudentNo=?)");
	        ps_cancourse.setString(1,username);
			ResultSet rs=ps.executeQuery();
			ResultSet rs_cancourse=ps_cancourse.executeQuery();
			while (rs.next()) 
			{
			    Course temp=new Course();
			    temp.setCourseNo(rs.getString(1));
			    temp.setCourseName(rs.getString(2));
			    temp.setStudyTime(rs.getFloat(3));
			    temp.setGrade(rs.getFloat(4));
			    temp.setTerm(rs.getFloat(5));
			    temp.setWhentoStudy(rs.getString(6));
			    temp.setTeachername(rs.getString(7));
			    //调用存储过程来统计某门课总共的人数
			    cs= con.prepareCall(cas);
                cs.setString(1, rs.getString(1));
                cs.registerOutParameter(2, Types.INTEGER);
                cs.executeUpdate();
                      
                int studentsum = cs.getInt(2);
                temp.setStudentSum(studentsum);
                System.out.println("选"+rs.getString(2)+"学生总数为"+studentsum);
			    MyCourseinfo.add(temp);  
			}
    
            while (rs_cancourse.next()) 
	        {     
			       Course temp=new Course();
			     
			       temp.setCourseNo(rs_cancourse.getString(1));
			       temp.setCourseName(rs_cancourse.getString(2));
			       temp.setStudyTime(rs_cancourse.getFloat(3));
			       temp.setGrade(rs_cancourse.getFloat(4));
			       temp.setTerm(rs_cancourse.getFloat(5));
			       temp.setWhentoStudy(rs_cancourse.getString(6));
			       temp.setTeachername(rs_cancourse.getString(7));
			       cs= con.prepareCall(cas);
                   cs.setString(1, rs_cancourse.getString(1));
                   cs.registerOutParameter(2, Types.INTEGER);
                   cs.executeUpdate();
                   int studentsum = cs.getInt(2);
                   temp.setStudentSum(studentsum);
                   CanCourseinfo.add(temp); 
                   System.out.println("选"+rs_cancourse.getString(2)+"学生总数为"+studentsum);  
			 }		
			rs.close();
			rs_cancourse.close();
			ps.close();
			ps_cancourse.close(); 
            con.close();
            
            session.setAttribute("MyCourseinfo",MyCourseinfo);
            session.setAttribute("CanCourseinfo",CanCourseinfo);
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
   <title>选课信息界面 </title>	
   <link rel="stylesheet" type="text/css" href="style.css" />
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
    	 background:#FFF68F;
    	 width:80%;
    }
    #content iframe{
		width:100%;
		height:95%;
		border:0px;
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
	   	  		<li><a href="Course.jsp" target="show_class" ><span>选课结果 </span> </a>
	   	  		<li><a href="Course_select.jsp" target="show_class">进行选课</a></li>
	   	  	</ul>
	   	  </div>
	     <div id="content">
	        <iframe id="show_class" name="show_class"></iframe>
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