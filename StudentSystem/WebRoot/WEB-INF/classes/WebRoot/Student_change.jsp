<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%! String message;
    String phone;
    String Email;
%>
<%
message=(String)session.getAttribute("message");
phone=(String)session.getAttribute("Phone");
Email=(String)session.getAttribute("Email");
if(message!=null)
{
%>
<script type="text/javascript">
	alert("<%=message%>");
	</script>
<%
   session.removeAttribute("message"); 
   }
%>
<html>
	<head>
		<title>修改信息</title>
		<script type="text/JavaScript">
		function check_same()
   	    {
   	      var pwd=document.myForm.newpwd.value;
		  var repwd=document.myForm.againpwd.value;
   	      if(pwd!=repwd)
   	      {
   	  	    alert("两次密码输入不一致");
   	  	    return false;
   	      }
   	    }
		</script>
	</head>
	<body>
		<h2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 修改信息</h2>
		<form action="Studentservlet" method="post" name="myForm"> 
		<input type="hidden" name="item" value="0">
		<p>1.学号，姓名等重要信息的修改，请联系管理员
		</p>
		<p>2.密码若不修改，可以不用填写
		</p>
		<table width="50%" border="1">
			<tr>
				<td>联系方式：</td>
				<td>
					<input type="text" name="phone" autocomplete="off" value=<%=phone%>>
				</td>
			</tr>
			<tr>
				<td >Email：</td>
				<td>
					<input type="text" name="email" autocomplete="off" value=<%=Email%>>
				</td>
			</tr>
			<tr>
                <td >新密码：</td>
                <td><font size="6"><input type="password" name="newpwd" id="newpwd"></font></td>
                
			</tr>
			
			<tr>
			    <td >再次输入密码：</td>
                <td><font size="6"><input type="password" name="againpwd" id="againpwd"></font></td>
            </tr>
			<tr>
				<td align="right">
					<input type="submit" name="submit" value="提交" onClick="return check_same();"/>
				</td>
				<td>
				    <input type="reset" name="reset" value="重置">
				</td>
		    </tr>

		</table>
	</form>
	</body>
</html>
