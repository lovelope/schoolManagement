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
 * 用来处理AJAX请求，并构建XML文件，用来传递信息
 * @version 1.0
 * @author LBJ
 *
 */
public class autoComplete extends HttpServlet {

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			//建立数据库连接
			Context initCtx=new InitialContext();
			Context encCtx=(Context)initCtx.lookup("java:comp/env");
			DataSource ds=(DataSource)encCtx.lookup("jdbc/mssql2014");
			Connection con=ds.getConnection();
			Statement st=null;
			ResultSet rs=null;
			//获取session，用来从其中读取用户名来完成数据库查询
			HttpSession session=request.getSession();
			//设置编码方式
			request.setCharacterEncoding("UTF-8");
			//以下均为从AJAX获取传送来的数据
			String name=request.getParameter("name");
			String action=request.getParameter("action");
			String username=request.getParameter("username");
			String changename=request.getParameter("changename");
			String changesex=request.getParameter("changesex");
			String changesubject=request.getParameter("changesubject");
			String changeacademy=request.getParameter("changeacademy");
			String changeno=request.getParameter("changeno");
	        String changephone=request.getParameter("changephone");
			String changeclass=request.getParameter("changeclass");
			String changecardnumber=request.getParameter("changecardnumber");
			String changeprince=request.getParameter("changeprince");
			String changebirthday=request.getParameter("changebirthday");
			String changeemail=request.getParameter("changeemail");
			String changepwd=request.getParameter("changepwd");
			String cno=request.getParameter("classno");
			String cname=request.getParameter("classname");
			String academy=request.getParameter("academy");
			String changecno_classinfo=request.getParameter("changecno");
			String changecname_classinfo=request.getParameter("changecname");
			String changeacademy_classinfo=request.getParameter("changeacademy");
			//在以管理员角色处理修改信息时，保证数据信息有效不为空，否则会产生异常
			if(changename!=null&&changesex!=null&&changesubject!=null&&changeacademy!=null&&changesex!=null&&changecardnumber!=null&&changeprince!=null&&changebirthday!=null&&changeemail!=null)
			{
				changename=new String(request.getParameter("changename").getBytes("ISO8859_1"));
			    changesex=new String(request.getParameter("changesex").getBytes("ISO8859_1"));
			    changesubject=new String(request.getParameter("changesubject").getBytes("ISO8859_1"));
			    changeacademy=new String(request.getParameter("changeacademy").getBytes("ISO8859_1"));
			    changeprince=new String(request.getParameter("changeprince").getBytes("ISO8859_1"));    
			}
			//这句name转换很重要,编码的不同导致要这样写，才可以获得正确的汉字
			if(name!=null)
			    name=new String(request.getParameter("name").getBytes("ISO8859_1"));
			if(username!=null)
			    username=new String(request.getParameter("username").getBytes("ISO8859_1"));
			System.out.println("用户名是"+username);
			System.out.println("课名:"+name+" action:"+action);
			String kind=request.getParameter("kind");
			System.out.println("Kind:"+kind);
			//设置response的格式
			response.setContentType("text/xml;charset=UTF-8");
			response.setHeader("Cache-Control", "no-cache");
            //获得输出对象，用来构建XML文件,供请求页面解析
			PrintWriter out = response.getWriter();
			out.println("<response>");//构建XML文件头，XML文件包含学生详细学籍信息
			//学生角色查询成绩时，实现内容自动补全的功能，产生下滑菜单（类似百度搜索）
			if("match".equals(action))
			{
				 //数据库查询语句表示使用LIKE来进行关键字匹配
			     String query="SELECT CourseName FROM CourseInfo WHERE CourseName LIKE'"+name+"%'";
				 st=con.createStatement();
				 rs=st.executeQuery(query);
				 while(rs.next())
				 {
					out.println("<res>"+rs.getString(1)+"</res>");
				 }
				 st.close();
				 rs.close();
				 con.close();
			}
			//处理以学生角色处理查询成绩事件
			else if("search".equals(action))
			{  	
				PreparedStatement ps=null;
				ps=con.prepareStatement("SELECT CourseInfo.CourseNo,CourseInfo.CourseName,CourseInfo.Grade,SC.Result FROM SC,CourseInfo WHERE CourseInfo.CourseNo=SC.CourseNo AND CourseInfo.CourseName=? AND SC.Result!=0 AND SC.StudentNo=?");
				ps.setString(1,name);
				ps.setString(2,username);
				rs=ps.executeQuery();
				while(rs.next())
				{
					System.out.println(rs.getString(1));
					System.out.println(rs.getString(2));
					System.out.println(rs.getString(3));
					System.out.println(rs.getString(4));
					
					out.println("<courseno>"+rs.getString(1)+"</courseno>");
					out.println("<coursename>"+rs.getString(2)+"</coursename>");
					out.println("<coursegrade>"+rs.getString(3)+"</coursegrade>");
					out.println("<result>"+rs.getString(4)+"</result>");
				}
				rs.close();
				con.close();
			}
			//以管理员角色处理查询学生信息事件
			else if("search_student".equals(action))
			{  
				//分为三种标准查询：按学号，按姓名，按班级号
				PreparedStatement ps=null;
				//按学号
			    if("0".equals(kind))
			    {	
				   ps=con.prepareStatement("SELECT StudentInfo.StudentNo,StudentInfo.Name,StudentInfo.Phone,StudentInfo.Sex,StudentInfo.Subject,StudentInfo.ClassNo,StudentInfo.Academy,StudentInfo.CardNumber,StudentInfo.Prince,StudentInfo.BirthDay,StudentInfo.Email,UserInfo.Password FROM StudentInfo,UserInfo WHERE  StudentInfo.StudentNo=UserInfo.Name AND StudentInfo.StudentNo=?");
				   ps.setString(1,name);
			    }
			    //按姓名
			    else if("1".equals(kind))
			    {
				   ps=con.prepareStatement("SELECT StudentInfo.StudentNo,StudentInfo.Name,StudentInfo.Phone,StudentInfo.Sex,StudentInfo.Subject,StudentInfo.ClassNo,StudentInfo.Academy,StudentInfo.CardNumber,StudentInfo.Prince,StudentInfo.BirthDay,StudentInfo.Email,UserInfo.Password FROM StudentInfo,UserInfo WHERE  StudentInfo.StudentNo=UserInfo.Name AND StudentInfo.Name=?");
				   ps.setString(1,name);
			    }
			    //按班级号
			    else if("2".equals(kind))
			    { 
				   ps=con.prepareStatement("SELECT StudentInfo.StudentNo,StudentInfo.Name,StudentInfo.Phone,StudentInfo.Sex,StudentInfo.Subject,StudentInfo.ClassNo,StudentInfo.Academy,StudentInfo.CardNumber,StudentInfo.Prince,StudentInfo.BirthDay,StudentInfo.Email,UserInfo.Password FROM StudentInfo,UserInfo WHERE  StudentInfo.StudentNo=UserInfo.Name AND StudentInfo.ClassNo=?");
				   ps.setString(1,name);
			    }  
			    else if("3".equals(kind))
			    {
				   ps=con.prepareStatement("SELECT StudentInfo.StudentNo,StudentInfo.Name,StudentInfo.Phone,StudentInfo.Sex,StudentInfo.Subject,StudentInfo.ClassNo,StudentInfo.Academy,StudentInfo.CardNumber,StudentInfo.Prince,StudentInfo.BirthDay,StudentInfo.Email,UserInfo.Password FROM StudentInfo,UserInfo WHERE  StudentInfo.StudentNo=UserInfo.Name");
			    }
			   //执行查询
               rs=ps.executeQuery();
			   //构建XML文件
			   while(rs.next())
			   {
					out.println("<studentno>"+rs.getString(1)+"</studentno>");//学号
					out.println("<studentname>"+rs.getString(2)+"</studentname>");//学生姓名
					out.println("<studentphone>"+rs.getString(3)+"</studentphone>");//电话
					out.println("<studentsex>"+rs.getString(4)+"</studentsex>");//性别
					out.println("<studentsubject>"+rs.getString(5)+"</studentsubject>");//专业
					out.println("<studentclass>"+rs.getString(6)+"</studentclass>");//班级
					out.println("<studentacademy>"+rs.getString(7)+"</studentacademy>");//学院
					out.println("<studentcardnumber>"+rs.getString(8)+"</studentcardnumber>");//身份证
					out.println("<studentprince>"+rs.getString(9)+"</studentprince>");//籍贯
					out.println("<studentbirthday>"+rs.getString(10)+"</studentbirthday>");//出生年月
					out.println("<studentemail>"+rs.getString(11)+"</studentemail>");//学生邮件
					out.println("<studentpwd>"+rs.getString(12)+"</studentpwd>");//学生密码
			   }
			   rs.close();
			   con.close();//B/S下采用数据库短连接，查询完成后即关闭数据库连接
			   
			}
			//管理员角色删除学生信息
			else if("delete".equals(action))
			{
				PreparedStatement ps=null;
				PreparedStatement ps_user=null;
				System.out.println("要删除的是"+name);
				//构建删除语句
				ps=con.prepareStatement("DELETE  FROM StudentInfo WHERE StudentNo=?");  
				ps.setString(1,name);
				ps.execute();
				ps_user=con.prepareStatement("DELETE  FROM UserInfo WHERE Name=?"); 
				ps_user.setString(1,name);
				ps_user.execute();
				con.close();
			}
			//管理员角色修改学生信息
			else if("change".equals(action))
			{
				PreparedStatement ps=null;
				PreparedStatement ps_user=null;
				PreparedStatement ps_check=null;//检查插入学生信息中的班级是否在ClassInfo中存在
				ResultSet rs_check=null;
				System.out.println("要更改的是 "+name+" changename to "+changename+" changeno to "+changeno+" changephone to "+changephone+" changesex to "+changesex+" changeclassto "+changeclass+" changesubject to "+changesubject+" changeacademy to "+changeacademy+" changepwd to "+changepwd);
				//先构建查询语句，检查修改的班级号是否存在
				ps_check=con.prepareStatement("SELECT * FROM ClassInfo WHERE ClassNo=?");
				ps_check.setString(1,changeclass);
				rs_check=ps_check.executeQuery();
				if(rs_check.next())
				{
				ps=con.prepareStatement("UPDATE StudentInfo SET StudentNo=?,Name=?,Phone=?,Sex=?,Subject=?,ClassNo=?,Academy=? WHERE StudentNo=?");  
				ps.setString(1,changeno);
				ps.setString(2,changename);
				ps.setString(3,changephone);
				ps.setString(4,changesex);
				ps.setString(5,changesubject);
				ps.setString(6,changeclass);
				ps.setString(7,changeacademy);
				ps.setString(8,name);
				ps.execute();
				ps_user=con.prepareStatement("UPDATE UserInfo SET Password=? WHERE Name=?"); 
				ps_user.setString(1,changepwd);
				ps_user.setString(2,name);
				ps_user.execute();	
				}
				else 
				{
					//添加的学生的班级不存在
					out.println("<message>"+"修改失败！原因：修改的班级不存在！"+"</message>");
				}
				rs_check.close();
				con.close();
			}
			//管理员角色添加学生信息
			else if("add".equals(action))
			{
				PreparedStatement ps=null;
				PreparedStatement ps_user=null;//添加入UserInfo表中
				PreparedStatement ps_check_class=null;//检查插入学生信息中的班级是否在ClassInfo中存在
				PreparedStatement ps_check_sno=null;//检查添加的学生是否存在
				ResultSet rs_check_class=null;
				ResultSet rs_check_sno=null;
				System.out.println("要添加的是 "+" changename to "+changename+" changeno to "+changeno+" changephone to "+changephone+" changesex to "+changesex+" changeclassto "+changeclass+" changesubject to "+changesubject+" changeacademy to "+changeacademy+" changepwd to "+changepwd);
				//先检查添加学生信息的班级号是否存在
				ps_check_class=con.prepareStatement("SELECT * FROM ClassInfo WHERE ClassNo=?");
				ps_check_class.setString(1,changeclass);
				rs_check_class=ps_check_class.executeQuery();
				ps_check_sno=con.prepareStatement("SELECT * FROM StudentInfo WHERE StudentNo=?");
				ps_check_sno.setString(1,changeno);
				rs_check_sno=ps_check_sno.executeQuery();
				if(rs_check_class.next())
				{
					if(!rs_check_sno.next())
					{
						out.println("<message>"+"#"+"</message>");//表示添加正常
					    ps=con.prepareStatement("INSERT INTO StudentInfo(StudentNo,Name,Phone,Sex,Subject,ClassNo,Academy,CardNumber,Prince,Birthday,Email) VALUES (?,?,?,?,?,?,?,?,?,?,?)");  
					    ps.setString(1,changeno);
					    ps.setString(2,changename);
						ps.setString(3,changephone);
						ps.setString(4,changesex);
						ps.setString(5,changesubject);
						ps.setString(6,changeclass);
						ps.setString(7,changeacademy);
						ps.setString(8,changecardnumber);
						ps.setString(9,changeprince);
						ps.setString(10,changebirthday);
						ps.setString(11,changeemail);
						ps.execute();
						ps_user=con.prepareStatement("INSERT INTO UserInfo VALUES (?,?,2)"); 
					    ps_user.setString(1,changeno);
					    ps_user.setString(2,changepwd);
					    ps_user.execute();
					}
					else 
					{
						//添加的学生的班级不存在
						out.println("<message>"+"添加失败！原因：添加学生已存在！"+"</message>");
					}		
				}
				else
				{
					//添加的学生的班级不存在
					out.println("<message>"+"添加失败！原因：添加班级不存在！"+"</message>");
				}
				rs_check_class.close();
				rs_check_sno.close();
				ps_check_class.close();
				ps_check_sno.close();
				con.close();
			}
			//教师角色实现搜索课程关键字补全
			else if("teachermatch".equals(action))
			{
				 String query="SELECT CourseName FROM CourseInfo WHERE CourseName LIKE'"+name+"%'";
				 st=con.createStatement();
				 rs=st.executeQuery(query);
				 
				 while(rs.next())
				 {
					out.println("<res>"+rs.getString(1)+"</res>");
				 }
				 st.close();
				 rs.close();
				 con.close();
			}
			//教师角色实现查询课程
			else if("search_course".equals(action))
			{
			   PreparedStatement ps=null;   
			   ps=con.prepareStatement("SELECT CourseInfo.CourseNo,CourseInfo.CourseName,CourseInfo.StudyTime,CourseInfo.Grade,CourseInfo.Term,CourseInfo.WhentoStudy FROM CourseInfo,TC WHERE TC.TeacherNo=? AND TC.CourseNo=CourseInfo.CourseNo");  	  
			   ps.setString(1,name);		   
			   rs=ps.executeQuery();
			   while(rs.next())
			   {
					out.println("<courseno>"+rs.getString(1)+"</courseno>");//课程号
					out.println("<coursename>"+rs.getString(2)+"</coursename>");//课程名
					out.println("<cst>"+rs.getString(3)+"</cst>");//课时
					out.println("<grade>"+rs.getString(4)+"</grade>");//学分
					out.println("<term>"+rs.getString(5)+"</term>");//开课学期
					out.println("<cwt>"+rs.getString(6)+"</cwt>");//上课时间
			 }
			  
			rs.close();
			con.close();    
			}
			//搜索班级
			else if("search_class".equals(action))
			{
			   
			   PreparedStatement ps=null;
			
			   ps=con.prepareStatement("SELECT * FROM ClassInfo");
				   
			   rs=ps.executeQuery();
			   //构建XML文件
			   while(rs.next())
			   {
				    System.out.println("班级号"+rs.getString(1));
					out.println("<classno>"+rs.getString(1)+"</classno>");//班级号
					out.println("<classname>"+rs.getString(2)+"</classname>");//班级名
					out.println("<academy>"+rs.getString(3)+"</academy>");//学院	
			   }
			   rs.close();
			   con.close(); 
			}
			//管理员身份添加班级
			else if("add_class".equals(action))
			{
				PreparedStatement ps=null;
				PreparedStatement ps_check=null;//检查插入学生信息中的班级是否在ClassInfo中存在
				ResultSet rs_check=null;
				ps_check=con.prepareStatement("SELECT * FROM ClassInfo WHERE ClassNo=?");
				ps_check.setString(1,changecno_classinfo);
				rs_check=ps_check.executeQuery();
				if(!rs_check.next())//表示班级号不存在，可添加
				{
					out.println("<message>"+"#"+"</message>");//发送给信息来表示添加正常
				ps=con.prepareStatement("INSERT INTO ClassInfo(ClassNo,ClassName,College) VALUES (?,?,?)");  
				ps.setString(1,changecno_classinfo);
				ps.setString(2,changecname_classinfo);
				ps.setString(3,changeacademy_classinfo);
				ps.execute();
				}
				else 
				{
					//添加的班级已存在，添加失败
					out.println("<message>"+"添加失败！原因：添加班级已存在！"+"</message>");
				}
				rs_check.close();
				con.close();
			}
			out.println("</response>");
			out.close();
			
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}
	public void init() throws ServletException {
		// Put your code here
	}

}
