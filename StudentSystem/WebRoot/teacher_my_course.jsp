<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%!
   String teacherno;
%>
<%
  teacherno=(String)session.getAttribute("userid"); 
%>
<html>
  <head>
   <style type="text/css">
   #head
   {
      width:100%;
      height:50px;
      background:#CDB38B;
   }
   #main
   {
      width:100%;
      height:600px;
      background:#EAEAEA;
   }
   #nextpage
   {
     width:100%;
     height:30px;
     background:#EAEAEA;
   }
   .tablelist tr:hover,.tablelist tr.backrow
   {
      background-color:#c4c4ff;
   }
   </style>
   <script lang="javascript">
        var XMLHttpReq;
        var kind;
        var inputField;
        var cno;
        var cname;
        var cst;
        var cgrade;
        var cterm;
        var cwt;
        var pageSum=1;
        var lastpagenode;
        var currentpage=1;
   
        var page=new Array(30);
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

        function search()
        { 
           var url;
           createXMLHttpRequest();
           url="autoComplete?action=search_course&name="+<%=teacherno%>;
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
                clearNames();
                cno=XMLHttpReq.responseXML.getElementsByTagName("courseno");
                cname=XMLHttpReq.responseXML.getElementsByTagName("coursename");
                cst=XMLHttpReq.responseXML.getElementsByTagName("cst");
                cgrade=XMLHttpReq.responseXML.getElementsByTagName("grade");
                cterm=XMLHttpReq.responseXML.getElementsByTagName("term");
                cwt=XMLHttpReq.responseXML.getElementsByTagName("cwt");
               
                var size=cno.length;
                if(size<=5)
                   pageSum=1;
                for(var k=1;k<=size;k++)
                  if(k>5)
                  {
                     size=size-5
                     k=1;
                     pageSum++;
                  }
                  
                lastpagenode=size%5;
                for(var j=1;j<=pageSum;j++)
                   page[j]=5;
                if(lastpagenode!=0)
                   page[pageSum]=lastpagenode;
                document.getElementById("currentpage").value=currentpage;
                document.getElementById("sumpage").value=pageSum;
                for(var i=0;i<page[1];i++)
                {
                   showitems(i);
                }
             }
          }
        }
        function clearNames()
        {
           var sortlist=document.getElementById("sortlist");
           var ind=sortlist.childNodes.length;
           for(var i=ind;i>0;i--)
           {
                 sortlist.removeChild(sortlist.childNodes[i-1]);
           }  
        }
        function forwardpage()
        {
           if(currentpage>1)
           {
                currentpage--;
                document.getElementById("currentpage").value=currentpage;
                clearNames();
                for(var i=(currentpage-1)*5;i<(currentpage-1)*5+page[currentpage];i++)
                {
                   showitems(i);
                }              
           }
        }
        function nextpage()
        {
           if(currentpage<pageSum)
           {
                currentpage++;
                document.getElementById("currentpage").value=currentpage;
                clearNames();
                for(var i=(currentpage-1)*5;i<(currentpage-1)*5+page[currentpage];i++)
                {
                   showitems(i);
                }
       }
       }
       function showitems(i)
       {
             var cno_nextNode=cno[i].firstChild.data;
             var cname_nextNode=cname[i].firstChild.data;
             var cst_nextNode=cst[i].firstChild.data;
             var cgrade_nextNode=cgrade[i].firstChild.data;
             var cterm_nextNode=cterm[i].firstChild.data;
             var cwt_nextNode=cwt[i].firstChild.data;
             var row,cell_cno,cell_cname,cell_cst,cell_cgrade,cell_cterm,cell_academy,cell_change,cell_cwt;
             row=document.createElement("tr");
                 
             cell_cno=document.createElement("td");
             cell_cno.appendChild(document.createTextNode(cno_nextNode));
             row.appendChild(cell_cno);
                   
             cell_cname=document.createElement("td");
             cell_cname.appendChild(document.createTextNode(cname_nextNode));
             row.appendChild(cell_cname);
             
             cell_cst=document.createElement("td");
             cell_cst.appendChild(document.createTextNode(cst_nextNode));
             row.appendChild(cell_cst);
             
             cell_cgrade=document.createElement("td");
             cell_cgrade.appendChild(document.createTextNode(cgrade_nextNode));
             row.appendChild(cell_cgrade);
             
             cell_cterm=document.createElement("td");
             cell_cterm.appendChild(document.createTextNode(cterm_nextNode));
             row.appendChild(cell_cterm);
                         
             cell_cwt=document.createElement("td");
             cell_cwt.appendChild(document.createTextNode(cwt_nextNode));
             row.appendChild(cell_cwt);
                      
             document.getElementById("sortlist").appendChild(row);
        }
        var rows=document.getElementByTagName('tr');
        for(var i=0;i<rows.length;i++)
        {
            rows[i].onmouseover=function()
            {
               this.className='backrow';
            }
            rows[i].onmouseout=function()
            {
               this.className=this.className.replace('backrow','');
            }
 
        }
   </script>

  </head>
  
  <body>
   <div id="head" align="center">
         <input type="button" value="查询我的课程" onclick="search();">   
   </div>
   <div id="main" align="center">
    <table border="1px" width="1300px" class='tablelist'>
     <tr>
          <td align="center" width="20px">课程编号</td>
          <td align="center" width="20px">课程名</td>
          <td align="center" width="20px">学时</td>
          <td align="center" width="20px">学分</td>
          <td align="center" width="20px">开课学期</td>
          <td align="center" width="20px">上课时间</td>
     </tr>
     <tbody id="sortlist">
     </tbody>
    </table>
   </div>
   <div id="nextpage" align="center">
      第<input type="text" id="currentpage" style="width:20px" readonly="true">页&nbsp;&nbsp;&nbsp;
      <input type="button" value="上一页" onclick="forwardpage();">&nbsp;
      <input type="button" value="下一页" onclick="nextpage();">&nbsp;&nbsp;&nbsp;
      共<input type="text" id="sumpage" style="width:20px" readonly="true">页
    </div>
  </body>
</html>
