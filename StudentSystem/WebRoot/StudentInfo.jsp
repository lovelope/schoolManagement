<%@ page language="java" import="java.util.*,java.sql.*,javax.sql.*,javax.naming.*,javax.servlet.http.HttpSession" pageEncoding="UTF-8"%>
<%
      Connection con=null;
      DataSource ds=null;
      PreparedStatement ps=null;
      PreparedStatement ps_photo=null;
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
			ps_photo=con.prepareStatement("SELECT * FROM StudentPhoto");
			ps=con.prepareStatement("SELECT * FROM StudentInfo WHERE StudentNo=? ");
			ps.setString(1,username);
			ResultSet rs=ps.executeQuery();
			ResultSet rs_photo=ps_photo.executeQuery();
			while (rs.next()) {
              session.setAttribute("StudentNo",rs.getString(1));
              session.setAttribute("Name",rs.getString(2));
              session.setAttribute("CardNo",rs.getString(3));
              session.setAttribute("Prince",rs.getString(4));
              session.setAttribute("Sex",rs.getString(5));
              session.setAttribute("Birthday",rs.getString(6));
              session.setAttribute("Phone",rs.getString(7));
              session.setAttribute("Subject",rs.getString(8));
              session.setAttribute("Classnumber",rs.getString(9));
              session.setAttribute("Email",rs.getString(10));
              session.setAttribute("Academy",rs.getString(11));      
            }	
            while(rs_photo.next())
            {
               session.setAttribute("StudentPhoto",rs_photo.getString(1));
            }
            rs_photo.close();
            rs.close();//实现短连接，及时关闭与数据库的连接
            ps.close();
            con.close();
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
   <title>个人信息界面 </title>	
   	<style type="text/css">
   	#mainwrapper 
   	{
   	     width:100%;
   		 height:100%;
   	} 
   
    #content 
    {
    	 overflow:hidden;
    	 float:right;
    	 background:#FFF68F;
    	 width:80%;
    	 height:800px;
    }
    #sidebar
    { 
    	overflow:hidden;
    	float:left;
    	background:#C1C1C1;
    	width:20%;
    	height:800px;
    }
	</style>
</head>
 <body>
	   <div id="mainwrapper">
	   	  <div id="sidebar">
	   	  	<ul>
	   	  	<!--注意iframe里的id和name要相同，且嵌套的html的iframe的id必须不同 -->
	   	  		<li><a href="Student.jsp" target="sho" ><span>个人信息 </span> </a>
	   	  		<li><a href="Student_change.jsp" target="sho">个人信息修改</a></li>
	   	  	</ul>
	   	  </div>
	     <div id="content">
	        <iframe id="sho" name="sho" src="" style="width:100%;height:100%"></iframe>
	   	 </div>
	   </div>
 </body>
</html>