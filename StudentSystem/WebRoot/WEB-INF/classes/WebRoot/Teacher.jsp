<%@ page language="java" import="java.util.*" pageEncoding="gb2312"%>
<%!
   String username; 
%>
<%
   username=(String)session.getAttribute("userid");
%>
<html>
<head>
   <title>教师信息界面 </title>	
   	<style type="text/css">
   	
   	    a{
   	     text-decoration:none;
   	     }
        a:hover{ 
        text-decoration:underline;
        }
   	    ul{
			display:inline;
			white-space: nowrap;
		}
		ul li{
			padding: 10px 20px;
			display: inline-block;
			background:pink;
			white-space:nowrap;
		}
		#head 
         {
           margin: 0px auto;
    	   background-image:url(daohang.jpg);
    	   width:100%;
    	   height:100px;
         }
         #zhuangtai
         {
            left:90%;
            float：left;
            position:absolute;
            background:transparent;
            height:100px;
         }
         #time
         {
            right:90%;
            float：rignt;
            position:absolute;
            background:transparent;
            height:100px;
         }
		#main
		{
		 background-image:url(iframe.jpg);
		 background-repeat:no-repeat;
		 margin: 0px auto;
         text-align:center ;
	     overflow:hidden;
         width: 1600px;
	     height: 800px;
        }
        #namefont
        {
          font-weight:bold;
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
		</script>
</head>


<body align="center" onload="displayTime()">

	<div id="head" >
	    <div id="time" name="mytime"> 
	       当前时间：<br>
	      <p><input type="text" name="showyearmonth" style="border:0px;background:rgba(0, 0, 0, 0); "></p>
	      <input type="text" name="showTime" style="border:0px;background:rgba(0, 0, 0, 0); ">
	    </div>
	    <div id="zhuangtai">
	      <font id="namefont" >用户名：<%=username%></font>
	  
	      <form action="Studentservlet" method="post"> 
	        <input type="hidden" name="item" value="exit">
	        <input type="submit" name="submit" value="注销">
	      </form>
	      
        </div>
        <h2>&nbsp;&nbsp;Welcome to Student System!</h2>
		<ul>
		 <li><a href="upload_classgrade.jsp" target="show" ><span>上传成绩 </span> </a></li> 
	     <li><a href="teacher_my_course.jsp" target="show" ><span>课程管理 </span> </a></li> 
	    </ul> 	
	    
    </div>
    <div id="main" align="center">
	  <iframe id="show" name="show" src="" style="width:100%;height:100%"></iframe>
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
