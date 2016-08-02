package com.studentsystem;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
/**
 * 用来处理学生事务的Servlet，将各种传来的表单数据进行处理，并进行数据结果的返回
 * @version 1.0
 * 
 */
public class Studentwork extends HttpServlet {
   
	public void destroy() {
		super.destroy(); 
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//确定编码格式
		request.setCharacterEncoding("GBK");
		//获取session对象，即会话，用来传递数据和持久化
		HttpSession session=request.getSession();
		String phone=request.getParameter("phone");//提取表单中name为phone的对象
		String email=request.getParameter("email");//提取表单中name为email的对象
		String pwd=request.getParameter("newpwd");//提取表单中name为修改密码的对象
		String hidden=request.getParameter("item");//提取表单中name为item的对象
		String Coursename=request.getParameter("search_course");//提取表单中name为esearch_course的对象
		//通过Session持久化，提取用户名，可以选的课，已选的课
		String username=(String)session.getAttribute("userid");
		List<Course> Courseinfo=(List<Course>)session.getAttribute("CanCourseinfo"); 
		List<Course> MyCourseinfo=(List<Course>)session.getAttribute("MyCourseinfo"); 
		
		System.out.println("隐藏表单是"+hidden);
		//修改学生信息表单
		if(hidden.equals("0"))
		 {
		    session.setAttribute("Phone",phone);//目的：在session里更新修改的数据
		    session.setAttribute("Email",email);//目的：在session里更新修改的数据
		    session.setAttribute("message","修改成功！");
		    //生成一个新的数据库操作对象，对学生的相关信息进行修改
		    TestDB test=new TestDB();
		    test.Studenwork(username, phone, email, pwd);
		    //返回处理前的页面
			request.getRequestDispatcher("/Student_change.jsp").forward(request, response);
		 }
		//选课处理
		else if(hidden.equals("1"))
		{
			
			for(int i=0;i<Courseinfo.size();)
			{
				//以课程号作为表单中checkbox的id值
				if((String)request.getParameter(Courseinfo.get(i).getCourseNo())!=null)
				{
					   //总结：每次需重新发布工程，才能保证正确
					   //符合条件后进行数据库处理
					   TestDB test=new TestDB();
					   float newsum;
					   newsum=test.Coursework(0, Courseinfo.get(i).getCourseNo(), username);	  
					   Courseinfo.get(i).setStudentSum((int)newsum);
					   MyCourseinfo.add(Courseinfo.get(i));
					   
					   Courseinfo.remove(i);
					   i=0;//由于Courseinfo每进行一次操作，就会变化的小，所以应该从i=0开始重新计数
				}	
				else i++;
			}
			session.setAttribute("MyCourseinfo",MyCourseinfo);
			session.setAttribute("message","选课成功！");
			session.setAttribute("CanCourseinfo",Courseinfo);
			request.getRequestDispatcher("/Course_select.jsp").forward(request, response);		
		}
		
		//取消选课
		else if(hidden.equals("2"))
		{
			int size=MyCourseinfo.size();//若将MyCourseinfo.size()放在for里，则由于其会每次循环都会动态计算arraylist大小，而导致错误
			for(int i=0;i<MyCourseinfo.size();)
			{	
				if((String)request.getParameter(MyCourseinfo.get(i).getCourseNo())!=null)
				{
					   //总结：每次需重新发布工程，才能保证正确
					   //符合条件后进行数据库处理
					   TestDB test=new TestDB();
					   float newsum;
					   newsum=test.Coursework(1, MyCourseinfo.get(i).getCourseNo(), username);
					   MyCourseinfo.get(i).setStudentSum((int)newsum);
					   Courseinfo.add(MyCourseinfo.get(i));
					   MyCourseinfo.remove(i);
					   i=0;
					   System.out.println("ok");	   
			   }	
				else i++;
			}
			session.setAttribute("MyCourseinfo",MyCourseinfo);
			session.setAttribute("CanCourseinfo",Courseinfo);
			session.setAttribute("message","取消选课成功！");
			request.getRequestDispatcher("/Course.jsp").forward(request, response);	
		}
		//成绩查询
		else if(hidden.equals("3"))
		{
			List<Course> Grade=(List<Course>)session.getAttribute("Grade");//Grade 表示分数，第一次是在GradeInfo.jsp中通过查数据库获得
			List<Course> SearchGrade=new ArrayList<Course>();
			for(int i=0;i<Grade.size();i++)
			{
				if(Grade.get(i).getCouresName().equals(Coursename))
					SearchGrade.add(Grade.get(i)); 		
			}				   		   
			session.setAttribute("message","查询成功！"); 
			session.setAttribute("SearchGrade",SearchGrade);
			request.getRequestDispatcher("/Grade.jsp").forward(request, response);	
			
		}
		//注销操作
		else if(hidden.equals("exit"))
		{
			session.removeAttribute("StudentNo");
			session.removeAttribute("Name");
			session.removeAttribute("CardNo");
			session.removeAttribute("Prince");
			session.removeAttribute("Sex");
			session.removeAttribute("Phone");
			session.removeAttribute("Subject");
			session.removeAttribute("Classnumber");
			session.removeAttribute("Email");
			session.removeAttribute("Academy");
			session.removeAttribute("userid");
			session.removeAttribute("password");
			session.invalidate();
			response.sendRedirect(request.getContextPath()+"/Login.jsp");
 		}	
	}

	public void init() throws ServletException {
		
	}
}
