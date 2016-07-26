package com.studentsystem;
import java.sql.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import javax.naming.*;
import java.util.ArrayList;
/**
 * 负责数据库处理，包括对教师，课程，学生的信息的相关操作
 * @version 1.0
 * @author LBJ
 */
public class TestDB {

	Connection connection=getConnection();
	PreparedStatement ps=null;
	CallableStatement cs=null;
	String cas="{call course_student_sum(?, ?)}"; 
	//获取数据库连接
	private Connection getConnection()
	{
		Connection con;
		try {
			Context initCtx=new InitialContext();
			Context encCtx=(Context)initCtx.lookup("java:comp/env");
			DataSource ds=(DataSource)encCtx.lookup("jdbc/mssql2014");		
			con = ds.getConnection();
			return con;
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	public TestDB()
	{
		
	}
	//负责学生权限内的修改学生个人信息，即学生只允许修改姓名，电话，电子邮件，登录密码
    public boolean Studenwork(String name,String phone,String Email,String pwd)
    {	
    	 try {
			   ps=connection.prepareStatement("update StudentInfo SET Phone=?,Email=? WHERE StudentNo=?");
			   ps.setString(1, phone);
			   ps.setString(2,Email);
			   ps.setString(3, name);
			   ps.executeUpdate();
			   if(pwd!=null)
		       {
				 PreparedStatement	ps_userinfo=connection.prepareStatement("update UserInfo SET Password=? WHERE Name=?");
				 ps_userinfo.setString(1, pwd);
				 ps_userinfo.setString(2,name);	
				 ps_userinfo.executeUpdate();
		       }
			   connection.commit();
			  return true;
		   } catch (SQLException e) {
			// TODO Auto-generated catch block
			  e.printStackTrace();
			  try {
				connection.rollback();
			      } catch (SQLException e1) {
				// TODO Auto-generated catch block
				  e1.printStackTrace();
				 return false;
			}
			     return false;   
		  }
	
    }
    //选课，取消选课操作
    public float Coursework(int do_what,String CourseNo,String StudentNo)
    {
    	//选课操作
    	if(do_what==0)
    	{
    		try {
				ps=connection.prepareStatement("INSERT INTO SC VALUES(?,?,?)");
				ps.setString(1, StudentNo);
				ps.setString(2,CourseNo);
				ps.setFloat(3,0);
				ps.executeUpdate();
				connection.commit();
				cs= connection.prepareCall(cas);
                cs.setString(1, CourseNo);
                cs.registerOutParameter(2, Types.INTEGER);
                cs.executeUpdate();
                int studentsum = cs.getInt(2);
                return (float)studentsum;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				try {
					connection.rollback();
					
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					
					
				}
				
				e.printStackTrace();
				return -1;
				
			}
			
    	}
    	//取消选课
    	else if(do_what==1)
    	{
    		try {
				ps=connection.prepareStatement("DELETE FROM SC WHERE StudentNo=? AND CourseNo=?");
				ps.setString(1, StudentNo);
				ps.setString(2,CourseNo);
				ps.executeUpdate();
				connection.commit();
				cs= connection.prepareCall(cas);
                cs.setString(1, CourseNo);
                cs.registerOutParameter(2, Types.INTEGER);
                cs.executeUpdate();
                int studentsum = cs.getInt(2);
                return (float)studentsum;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				try {
					connection.rollback();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				e.printStackTrace();
				return -1;
			}
    	}
    	else return -1;
    }
    //教师录入或修改成绩
    public boolean Teacherwork(String StudentNo,String CourseName,float coursegrade)
    {
    	
    	try {
			ps=connection.prepareStatement("update SC SET Result=? WHERE StudentNo=? AND CourseNo=(SELECT CourseNo FROM CourseInfo WHERE CourseName=?)");
			ps.setFloat(1, coursegrade);
			ps.setString(2,StudentNo);
			ps.setString(3, CourseName);
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
    }

}
