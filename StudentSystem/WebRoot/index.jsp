<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%!
   String username;
%>
<%
   username=(String)session.getAttribute("userid");
%>
<html>
<head>
   <title>学生信息界面 </title>
   <link rel="stylesheet" type="text/css" href="style.css" />
   	<style type="text/css">
		#main
		{
		 background-image:url(iframe.jpg);
		 background-repeat:no-repeat;
         text-align:center ;
	     overflow:hidden;
         width: 100%;
	     height:85%;
        }
        #main iframe{
        	width:100%;
        	height: 100%;
        	border:0px;
        }
		</style>
		<script language="javascript">
		 function displayTime()
		 {
		    var vw = new Array("星期天","星期一","星期二","星期三","星期四","星期五","星期六");     
		    var today=new Date();  
		    var day = today.getDate(); 
		    var month = today.getMonth() + 1;  //获取月份
            var year = today.getFullYear();   //获取年份
            var week = today.getDay();       //获取星期数     
		    var hours=today.getHours();         
		    var minutes=today.getMinutes();
		    var seconds=today.getSeconds();         
		    minutes=fixTime(minutes);        
		    seconds=fixTime(seconds);
		    var current_time=hours+":"+minutes+":"+seconds;
		    var year_month=year+ "年" + month + "月"+day+"日"+vw[week];
		    document.all.showTime.value=current_time;
		    document.all.showyearmonth.value=year_month;
		    the_timeout=setTimeout('displayTime();',500);    
		    }
		   function fixTime(the_time){            
		   if(the_time<10)
		   {        
		     the_time="0"+the_time;          
		   }          
		   return the_time;     
		   }//修订时间显示  
		   function move(image,num)
		   {
		     image.src='../images/menu'+num+'.jpg';
		   }
		   function out(image,num)
		   {
		     image.src='../images/menu_out'+num+'.jpg';
		   }
		</script>
</head>


<body onload="displayTime()">

	<div id="head" >
	    <div id="time" name="mytime">
	       当前时间：<br>
	       <p><input type="text" name="showyearmonth" style="border:0px;background:rgba(0, 0, 0, 0); "></p>
	      <input type="text" name="showTime" style="border:0px;background:rgba(0, 0, 0, 0); ">
	    </div>
	    <div id="status">
	      <form action="Studentservlet" method="post">
	      	用户名：<%=username%>
	        <input type="hidden" name="item" value="exit">
	        <input type="submit" name="submit" value="注销">
	      </form>
        </div>
        <div id="menu">
	        <h2>Welcome to Student System!</h2>

	         <a href="index.jsp" >首页</a>
	         <a href="StudentInfo.jsp" target="show" ><span>个人信息</span></a>
	         <a href="CourseInfo.jsp" target="show"><span>选课查询 </span></a>
	         <a href="GradeInfo.jsp" target="show"><span>成绩查询 </span></a>

	    </div>
    </div>
    <div id="main" >

	  <iframe id="show" name="show" src=""></iframe>
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
