package com.studentsystem;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
 * 用来检查登录的servlet，对请求登录者的身份进行验证，对成功的登录者按照身份的不同
 * 转向不同的页面
 * @version 1.0
 * @author LBJ
 *
 */
public class logincheck extends HttpServlet {

	public void destroy() {
		super.destroy(); 
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        try {
        	//连接数据库
			Context initCtx=new InitialContext();
			Context encCtx=(Context)initCtx.lookup("java:comp/env");
			DataSource ds=(DataSource)encCtx.lookup("jdbc/mssql2014");
			Connection con=ds.getConnection();
			//从表单中提取登录者的id，密码，类型
			String username=request.getParameter("UserID");
			String password=request.getParameter("UserPWD");
			String kind=request.getParameter("Kind");
			//建立session用来持久化
			HttpSession session=request.getSession();
			session.setAttribute("userid", username);
			session.setAttribute("UserPWD", password);
			session.setAttribute("UserName", username);	
			//查询数据库中userinfo表来查看是否有该用户
			PreparedStatement ps=con.prepareStatement("SELECT * FROM UserInfo WHERE Name=? and Password=? and Kind=?");
			ps.setString(1,username);
			ps.setString(2,password);
			ps.setString(3,kind);
			ResultSet rs=ps.executeQuery();
			
			boolean flag=rs.next();//注意此处不可再条件语句if中使用rs.next()，因为会是结果集指针下移
			
            if(flag&&kind.equals("0"))	
            {	
            	//进入管理员信息界面
            	request.setAttribute("success",username+password);
            	request.getRequestDispatcher("/Admin.jsp").forward(request, response);
            }
            else if(flag&&kind.equals("1"))	
            {	
            	//进入教师信息界面
            	request.setAttribute("success",username+password);
            	List<Student> MyStudent=new ArrayList<Student>();
            	session.setAttribute("MyStudentinfo",MyStudent);
            	request.getRequestDispatcher("/Teacher.jsp").forward(request, response);
            }
            else if(flag&&kind.equals("2"))	
            {	
            	//进入学生信息界面
            	request.setAttribute("success",username+password);
            	request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
            else 
            {
            	session.setAttribute("message","用户名不存在或您选择的身份错误");
            	request.getRequestDispatcher("/Login.jsp").forward(request, response);	
            }
            //B/S模式下数据库连接应为短连接，需及时断开数据库连接
			rs.close();
			ps.close();
			con.close();
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