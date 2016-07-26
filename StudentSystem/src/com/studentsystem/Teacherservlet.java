package com.studentsystem;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
/**
 * 作为处理教师请求的servlet，负责处理各种教师请求信息
 * @version 1.0
 * @author Administrator
 */
public class Teacherservlet extends HttpServlet {

	public void destroy() {
		super.destroy();
	}
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			//建立数据库连接
			Context initCtx=new InitialContext();
			Context encCtx=(Context)initCtx.lookup("java:comp/env");
			DataSource ds=(DataSource)encCtx.lookup("jdbc/mssql2014");
			Connection con=ds.getConnection();
			Statement st=null;
			ResultSet rs=null;
			String coursename=null;
			String username=null;
			HttpSession session=request.getSession();
			username=(String)session.getAttribute("userid");
			String hidden=request.getParameter("item");
			//用于区分第一次和之后的课程名，若是第二次，则从session中获取
			if((String)session.getAttribute("coursename")==null)
			{
			  coursename=new String(request.getParameter("coursename").getBytes("ISO8859_1"));
			  session.setAttribute("coursename",coursename);
			}
			else
				coursename=(String)session.getAttribute("coursename");
			List<Student> MyStudent=new ArrayList<Student>();
			//提取的表单中隐藏表单是1，表示查询选了某门课的所有学生的学号，姓名和成绩
			if(hidden.equals("1"))
			{
			    PreparedStatement ps=null;//预查询
			    //SQL语句的含义：表示通过联系学生表，SC，TC，课程表，查出选择了选择登录老师的教授的某一门课的学生的学号和姓名及成绩
			    ps=con.prepareStatement("SELECT StudentInfo.StudentNo,StudentInfo.Name,StudentInfo.ClassNo,SC.Result FROM CourseInfo,TC,StudentInfo,SC WHERE TC.CourseNo=CourseInfo.CourseNo AND SC.CourseNo=TC.CourseNo AND SC.StudentNo=StudentInfo.StudentNo AND TC.CourseNo=CourseInfo.CourseNo AND CourseInfo.CourseName=? AND TC.TeacherNo=?");
			    ps.setString(1,coursename);
			    ps.setString(2,username);
			    rs=ps.executeQuery();
			    while(rs.next())
			    {
				  System.out.println("选 "+coursename+" 的学生姓名是"+rs.getString(2)+"班级号是"+rs.getString(3));
				  Student temp=new Student();
			      temp.setStudentNo(rs.getString(1));
			      temp.setName(rs.getString(2));
			      temp.setClass(rs.getString(3));
			      temp.setCourseGrade(rs.getFloat(4));
			      MyStudent.add(temp);
			    }
			    session.setAttribute("MyStudentinfo",MyStudent);
			    //转回原来的页面
			    request.getRequestDispatcher("/upload_classgrade.jsp").forward(request, response);
			}
			//上传成绩的处理
			else if(hidden.equals("2"))
			{
				MyStudent=(List<Student>)session.getAttribute("MyStudentinfo");
				int size=MyStudent.size();
				TestDB test=new TestDB();
				for(int i=0;i<MyStudent.size();i++)
				{	
					String coursegrade=(String)request.getParameter(MyStudent.get(i).getStudentNo());
					if(coursegrade.length()!=0)
					{
						test.Teacherwork(MyStudent.get(i).getStudentNo(), coursename, new Float(coursegrade));
						System.out.println("学号为"+MyStudent.get(i).getStudentNo()+"选 "+coursename+" 的成绩："+coursegrade);
					    MyStudent.get(i).setCourseGrade(new Float(coursegrade));
					}
					else
					{
						//在成绩一栏中不填，默认值为0
						test.Teacherwork(MyStudent.get(i).getStudentNo(), coursename,0);
						System.out.println("学号为"+MyStudent.get(i).getStudentNo()+"选 "+coursename+" 的成绩：0");
						MyStudent.get(i).setCourseGrade(0);
					}
				}
				session.setAttribute("MyStudentinfo",MyStudent);
				request.getRequestDispatcher("/upload_classgrade.jsp").forward(request, response);
				
			}
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
