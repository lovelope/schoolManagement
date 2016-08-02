<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String message=(String)session.getAttribute("message");//message来显示登录失败信息
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
   <title>学籍管理系统登录界面 </title>	
   <link rel="stylesheet" type="text/css" href="style.css" />
   <script type="text/JavaScript">
   	/*判断是否为数字*/
   	function isNumber(str)
   	{
   		var Letters="01234567889";
   		for(var i=0;i<str.length;i++)
   		{
   		  var CheckChar=str.charAt(i);
   		  if(Letters.indexOf(CheckChar)==-1)
   		     return false;
   		}
   		return true;
   	}
   	/*判断是否为空*/
   	function isEmpty(value)
   	{
   		return /^\s*$/.test(value);
   	}
   	/*检查输入用户名及密码是否为空*/
   	function check()
   	{
   	  if(isEmpty(document.myForm.UserID.value))
   	  {
   	  	alert("登录名不能为空");
   	  	document.myForm.loginName.focus();
   	  	return false;
   	  }	
   	  if(isEmpty(document.myForm.UserPWD.value))
   	  {
   	    alert("密码不能为空");
   	    document.myForm.password.focus();
   	    return false;	
   	  }
   	  else
   	  {
   	  	 return true;
   	  }
   	}
   	//防止按下backspace返回注销之前的界面
    window.onload=function(){  
    
    document.getElementsByTagName("body")[0].onkeydown =function(){  
        if(event.keyCode==8){  
            var elem = event.srcElement;  
            var name = elem.nodeName;  
              
            if(name!='INPUT' && name!='TEXTAREA'){  
                event.returnValue = false ;  
                return ;  
            }  
            var type_e = elem.type.toUpperCase();  
            if(name=='INPUT' && (type_e!='TEXT' && type_e!='TEXTAREA' && type_e!='PASSWORD' && type_e!='FILE')){  
                event.returnValue = false ;  
                return ;  
            }  
            if(name=='INPUT' && (elem.readOnly==true || elem.disabled ==true)){  
                event.returnValue = false ;  
                return ;  
            }  
        }  
    }  
}  
   	</script>
   	<style type="text/css">
   	*{
      margin:0 auto;
      font-family: "Microsoft YaHei";
    }
   	#myForm {
	   width:400px;
	   height:300px;
	   position:absolute;
	   top:30%;
	   left:50%;
	   margin:-150px 0 0 -200px;
	   background:#FFF;
	   border:3px solid #999;
	    border-radius:10px;
      }
     #main
   	{
   	   height:95%;
   	}
   	#footer
   	{
   	   height:5%;
   	}
   	</style>
  
</head>


<body background="background.jpg" align="center">
	<div align="center" id="main">
	<marquee behavior="alternate" direction="left">---------欢迎使用学籍管理系统--------</marquee>
    <form action="sqltest" method="post" id="myForm">
     <h2>用户登录<h2/>
     <table>
       <tr>&nbsp;</tr>
      <tr>
       	<td>用户名：</td>
       	<td><input type="text" size="20" name="UserID" id="UserID" class="border-radius"></td>
      </tr>
      <tr>
      	<td>密码：</td>
      	<td><input type="password" size="20" name="UserPWD" id="UserPWD" class="border-radius"></td>
      </tr>
      
      <tr>
      	<td>身份：</td>
      	<td>
         <select name="Kind">
     	    <option value="0" selected>管理员 </option>
     	    <option value="1">教师 </option>
     	    <option value="2">学生 </option>
     	   </select>
     	  </td>
     	</tr>

     <tr>
     	<td><input type="submit" value="提交" onClick="return check();" id="submit" class="border-radius"></td>
     	<td><input type="reset" value="重置" class="border-radius"></td>
     </tr>

    </table>
 </form>
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