 <%@ page language="java" import="java.util.*;" pageEncoding="gb2312"%>
<%!
   String username;   
%>
<% 
   username=(String)session.getAttribute("userid");
%>
<html>
   <!-- 实现AJAX查询自动补全列表 -->
   <!-- 页面编码为gb2312，serverlt端位为UTF-8 -->
  <head>
   <link rel="stylesheet" type="text/css" href="style.css">
   <style type="text/css">
    #main{
      width: 100%;
      height:95%;
    }
    #complete_table{
      background-color:#FFFAFA;
      border:0px;
    }
    </style>
   
  </head>
  <body>
  <div id="main">
      <h1>查询成绩</h1> 
     <table>
     <tr>
           <td>输入课程名:</td>
           <td>
            <input type="text" id="names" onkeyup="findNames();">
            <input type="button" id="search" onclick="searchResult();" value="确 定">
            <div id="popup">
              <table id="complete_table" >
               <tbody id="complete_body" ></tbody>
              </table>  
            </div>
           </td>
     </tr>
     <tr>
         <td height="20">课程情况
         </td>
         <td height="80">
           <table border="1">
            <tr>
              <td>课程号</td>
              <td>课程名</td>
              <td>学分</td>
              <td>成绩</td>
            </tr>         
            <tr>
              <td><input type="text" id="content1" readonly="true"></td>
              <td><input type="text" id="content2" readonly="true"></td>
              <td><input type="text" id="content3" readonly="true"></td>
              <td><input type="text" id="content4" readonly="true"></td>
            </tr>
            </table>
         </td>   
     </tr>
     </table>
     </div>
     <div id="footer">
      <div id="copy">
       <div id="copyright">
       <p>CopyRight&copy;2016</p>
       <p>西安电子科技大学</p>
      </div>
    </div>
  </div>
     <script language="javascript">
        var XMLHttpReq;
        var completeDiv;
        var inputField;
        var completeTable;
        var completeBody;
        function createXMLHttpRequest()
        {
            if(window.XMLHttpRequest)
            {
             XMLHttpReq=new XMLHttpRequest();
            }
            else if(window.SctiveXObject)
            {
                 try
                 {
                    XMLHttpReq=new ActiveXObject("Msxm12.XMLHTTP");     
                 }
                 catch(e)
                 {
                     try{
                       XMLHttpReq=new ActiveXObject("Microsoft.XMLHTTP");
                     }catch(e){}
                 }
            }
        }
        
        function findNames()
        {
            inputField=document.getElementById("names");
            completeTable=document.getElementById("complete_table");
            completeDiv=document.getElementById("popup");
            completeBody=document.getElementById("complete_body");
            if(inputField.value.length>0)
            {
               createXMLHttpRequest();
               var url="autoComplete?action=match&name="+inputField.value;
               XMLHttpReq.open("GET",url,true);
               XMLHttpReq.onreadystatechange=processMatchResponse;
               XMLHttpReq.send(null);
            }
            else
            {
              clearNames();
            }
            
        }
        function processMatchResponse()
        {
            if(XMLHttpReq.readyState==4)
            {
               if(XMLHttpReq.status==200)
               {
                  setNames(XMLHttpReq.responseXML.getElementsByTagName("res"));
               }
               else
               { 
                  windows.alert("请求页面不存在!");
               }
            }
        }
        function setNames(names)
        {
            clearNames();
            var size=names.length;
            setOffsets();
            var row,cell,txtNode;
            for(var i=0;i<size;i++)
            {
               var nextNode=names[i].firstChild.data;
               row=document.createElement("tr");
               cell=document.createElement("td");
               cell.onmouseout=function(){this.className='mouseOn';};
               cell.onmouseover=function(){this.className='mouseOver';};
               cell.setAttribute("bgcolor","#FFFAFA");
               cell.setAttribute("border","0");
               cell.onclick=function(){completeField(this);};
               txtNode=document.createTextNode(nextNode);
               cell.appendChild(txtNode);
               row.appendChild(cell);
               completeBody.appendChild(row);
               
            }
        }
        function setOffsets()
        {
             completeTable.style.width=inputField.offsetWidth+"px";
             var left=calculateOffset(inputField,"offsetLeft");
             var top=calculateOffset(inputField,"offsetTop")+inputField.offsetHeight;
             completeDiv.style.border="blcak 1px solid";
             completeDiv.style.left=left+"px";
             completeDiv.style.top=top+"px";
        }
        function calculateOffset(field,attr)
        {
           var offset=0;
           while(field)
           {
              offset+=field[attr];
              field=field.offsetParent;
           }
           return offset;
        }
        function completeField(cell)
        {
           inputField.value=cell.firstChild.nodeValue;
           clearNames();         
        }
        function clearNames()
        {
           var ind=completeBody.childNodes.length;
           for(var i=ind;i>0;i--)
           {
                 completeBody.removeChild(completeBody.childNodes[i-1]);
           }  
           completeDiv.style.border="none";
        }
        function searchResult()
        {
           createXMLHttpRequest();
           var url="autoComplete?action=search&name="+inputField.value+"&username="+<%=username%>;
           XMLHttpReq.open("GET",url,true);
           XMLHttpReq.onreadystatechange=processSearchResponse;
           XMLHttpReq.send(null);
        }
        function processSearchResponse()
        {
          if(XMLHttpReq.readyState==4)
          {
             if(XMLHttpReq.status==200)
             {
                var courseno=XMLHttpReq.responseXML.getElementsByTagName("courseno");
                var coursename=XMLHttpReq.responseXML.getElementsByTagName("coursename");
                var coursegrade=XMLHttpReq.responseXML.getElementsByTagName("coursegrade");
                var result=XMLHttpReq.responseXML.getElementsByTagName("result");
                if(courseno.length>0&&courseno.length>0&&coursename.length>0&&coursegrade.length>0&&result.length>0)
                {
                   document.getElementById("content1").value=courseno[0].firstChild.data;
                   document.getElementById("content2").value=coursename[0].firstChild.data;
                   document.getElementById("content3").value=coursegrade[0].firstChild.data;
                   document.getElementById("content4").value=result[0].firstChild.data;
                }
             }
          }
        }
   </script>
  </body>
</html>
