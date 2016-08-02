<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<html>
  <head>
  <link rel="stylesheet" type="text/css" href="style.css">
   <style type="text/css">
   #head>table{
    position:absolute;
    right:50%;
    margin:40px;
   }
   #head>input{
    position:absolute;
    right:40%;
    margin:40px;
   }
   #main
   {
      position: relative;
      width:100%;
      height:85%;
      background:#EAEAEA;
   }
   .tablelist{
    width:100%;
   }
   .tablelist tr:hover,.tablelist tr.backrow
   {
      background-color:#c4c4ff;
   }
   #main td, #main input{
    width:120px;
    text-align: center;
   }
   #nextpage
   {
      position: absolute;
      left:50%;
      bottom:0;
      margin-left: -300px;
     height:30px;
     background:#EAEAEA;
   }
   </style>
   <script lang="javascript">
        var XMLHttpReq;//AJAX对象
        var message;//用于页面查询反馈信息，包括学生信息添加的结果，学生信息修改的结果，班级添加的结果
        var kind;//查询学生信息时采用不同的搜索类型
        var inputField;//查询信息输入框
        var sno;//学号
        var sname;//学生姓名
        var sphone;//联系电话
        var ssex;//性别
        var ssubject;//专业
        var sacademy;//学院
        var sclass;//班级
        var scardnumber;//身份证号
        var sprince;//籍贯
        var sbirthday;//出生年月
        var semail;//学生电子邮箱
        var spwd;//登录密码
        var pageSum=1;//用于分页显示
        var lastpagenode;
        var currentpage=1;
        var page=new Array(30);
        //创建AJAX对象
        function createXMLHttpRequest()
        {
            //根据不同浏览器来创建
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
        //查询学生信息 ，after_add_class 表示是否是添加学生只后的显示，因为需要获取班级信息
        //若为正常查询，在删除和更新信息操作之后，查询条件还保存在页面中，不需要再次输入
        //而添加学生之后，需获得其班号，以班号来查询添加之后的情况
        function search(after_add_class)
        { 
           var url;
           createXMLHttpRequest();
           if(after_add_class!=null)
           {
              url="autoComplete?action=search_student&name="+after_add_class+"&kind=2";//kind=2表示以班级号为依据进行学生查询
           }
           else
           {
             inputField=document.getElementById("search");
             kind=document.getElementById("kind");
             var url="autoComplete?action=search_student&name="+inputField.value+"&kind="+kind.value;
           }
           XMLHttpReq.open("GET",url,true);
           XMLHttpReq.onreadystatechange=processSearchResponse;
           XMLHttpReq.send(null);
        }
        //状态响应函数
        function processSearchResponse()
        {
          if(XMLHttpReq.readyState==4)
          {
             if(XMLHttpReq.status==200)
             {
                //若条件都满足，则表示响应正常
                clearNames();
                //以下为从autoComplete中获取的XML文件中解析数据
                sno=XMLHttpReq.responseXML.getElementsByTagName("studentno");//学号
                sname=XMLHttpReq.responseXML.getElementsByTagName("studentname");//姓名
                sphone=XMLHttpReq.responseXML.getElementsByTagName("studentphone");//联系电话
                ssex=XMLHttpReq.responseXML.getElementsByTagName("studentsex");//学生性别
                ssubject=XMLHttpReq.responseXML.getElementsByTagName("studentsubject");//专业
                sacademy=XMLHttpReq.responseXML.getElementsByTagName("studentacademy");//学院
                sclass=XMLHttpReq.responseXML.getElementsByTagName("studentclass");//学生班级
                scardnumber=XMLHttpReq.responseXML.getElementsByTagName("studentcardnumber");//学生身份证号
                sprince=XMLHttpReq.responseXML.getElementsByTagName("studentprince");//籍贯
                sbirthday=XMLHttpReq.responseXML.getElementsByTagName("studentbirthday");//学生出生年月
                semail=XMLHttpReq.responseXML.getElementsByTagName("studentemail");//电子邮箱
                spwd=XMLHttpReq.responseXML.getElementsByTagName("studentpwd");//登录系统密码
                var size=sno.length;//获取信息组数大小，用于分页显示
                //一页包含5条记录
                if(size<=5)
                   pageSum=1;//如果学生信息少于5条，则只有第一页
                for(var k=1;k<=size;k++)
                  if(k>5)
                  {
                     size=size-5
                     k=1;
                     pageSum++;//获得分页号
                  }    
                lastpagenode=size%5;//获得最后一页学生信息个数
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
        //用于清空在页面上出现的信息表格
        function clearNames()
        {
           var sortlist=document.getElementById("sortlist");
           var ind=sortlist.childNodes.length;
           for(var i=ind;i>0;i--)
           {
                 sortlist.removeChild(sortlist.childNodes[i-1]);
           }  
        }
        //获得上一页
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
        //获得下一页
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
       //删除学生信息
       function deleteSort(i)
       {
          if(confirm("确认删除？")) {

           createXMLHttpRequest();
           var url="autoComplete?action=delete&name="+sno[i].firstChild.data+"&id="+i;
           XMLHttpReq.open("GET",url,true);
           XMLHttpReq.onreadystatechange=deleteStateChange;
           XMLHttpReq.send(null);
           }
       }
       //状态响应函数
       function deleteStateChange()
       {
           if(XMLHttpReq.readyState==4)
          {
             if(XMLHttpReq.status==200)
             {
                pageSum=1;
                search();//删除过后，再次显示更新后的学生信息表格内容
             }
          }
       }
       //学生信息修改前构建表格，方便修改
       function before_change_showinfo(i)
       {
             clearNames();
             //通过从xxx[i].firstChild.data中获取需要的数据
             var sno_nextNode=sno[i].firstChild.data;
             var sname_nextNode=sname[i].firstChild.data;
             var sphone_nextNode=sphone[i].firstChild.data;
             var ssex_nextNode=ssex[i].firstChild.data;
             var ssubject_nextNode=ssubject[i].firstChild.data;
             var sclass_nextNode=sclass[i].firstChild.data;
             var sacademy_nextNode=sacademy[i].firstChild.data;
             var spwd_nextNode=spwd[i].firstChild.data;
             var scardnumber_nextNode=scardnumber[i].firstChild.data;
             var sprince_nextNode=sprince[i].firstChild.data;
             var sbirthday_nextNode=sbirthday[i].firstChild.data;
             var semail_nextNode=semail[i].firstChild.data;
             var row,cell_sno,cell_sname,cell_sphone,cell_sex,cell_subject,cell_academy,cell_change,cell_deleteinfo,cell_spwd,cell_class,cell_cardnumber,cell_prince,cell_birthday,cell_email;
             row=document.createElement("tr");
             
             //动态构建表格来呈现学生信息
             cell_sno=document.createElement("td");
             var snochange=document.createElement("input");
             snochange.setAttribute("type","text");
             snochange.setAttribute("value",sno_nextNode);
             snochange.setAttribute("id","textsno");
             cell_sno.appendChild(snochange);
             row.appendChild(cell_sno);
             
             cell_sname=document.createElement("td");
             var snamechange=document.createElement("input");
             snamechange.setAttribute("type","text");
             snamechange.setAttribute("value",sname_nextNode);
             snamechange.setAttribute("id","textsname");
             cell_sname.appendChild(snamechange);
             row.appendChild(cell_sname);
             
             cell_spwd=document.createElement("td");
             var spwdchange=document.createElement("input");
             spwdchange.setAttribute("type","text");
             spwdchange.setAttribute("value",spwd_nextNode);
             spwdchange.setAttribute("id","textspwd");
             cell_spwd.appendChild(spwdchange);
             row.appendChild(cell_spwd);
             
             cell_sphone=document.createElement("td");
             var sphonechange=document.createElement("input");
             sphonechange.setAttribute("type","text");
             sphonechange.setAttribute("value",sphone_nextNode);
             sphonechange.setAttribute("id","textsphone");
             cell_sphone.appendChild(sphonechange);
             row.appendChild(cell_sphone);
             
             cell_sex=document.createElement("td");
             var sexchange=document.createElement("input");
             sexchange.setAttribute("type","text");
             sexchange.setAttribute("value",ssex_nextNode);
             sexchange.setAttribute("id","textsex");
             cell_sex.appendChild(sexchange);
             row.appendChild(cell_sex);
             
             cell_subject=document.createElement("td");
             var subjectchange=document.createElement("input");
             subjectchange.setAttribute("type","text");
             subjectchange.setAttribute("value",ssubject_nextNode);
             subjectchange.setAttribute("id","textsubject");
             cell_subject.appendChild(subjectchange);
             row.appendChild(cell_subject);
             
             cell_class=document.createElement("td");
             var classchange=document.createElement("input");
             classchange.setAttribute("type","text");
             classchange.setAttribute("value",sclass_nextNode);
             classchange.setAttribute("id","textsclass");
             cell_class.appendChild(classchange);
             row.appendChild(cell_class);
             
             cell_academy=document.createElement("td");
             var academychange=document.createElement("input");
             academychange.setAttribute("type","text");
             academychange.setAttribute("value",sacademy_nextNode);
             academychange.setAttribute("id","textsacademy");
             cell_academy.appendChild(academychange);
             row.appendChild(cell_academy);
             
             cell_cardnumber=document.createElement("td");
             var cardnumberchange=document.createElement("input");
             cardnumberchange.setAttribute("type","text");
             cardnumberchange.setAttribute("value",scardnumber_nextNode);
             cardnumberchange.setAttribute("id","textcardnumber");
             cell_cardnumber.appendChild(cardnumberchange);
             row.appendChild(cell_cardnumber);
             
             cell_prince=document.createElement("td");
             var princechange=document.createElement("input");
             princechange.setAttribute("type","text");
             princechange.setAttribute("value",sprince_nextNode);
             princechange.setAttribute("id","textprince");
             cell_prince.appendChild(princechange);
             row.appendChild(cell_prince);
             
             cell_birthday=document.createElement("td");
             var birthdaychange=document.createElement("input");
             birthdaychange.setAttribute("type","text");
             birthdaychange.setAttribute("value",sbirthday_nextNode);
             birthdaychange.setAttribute("id","textbirthday");
             cell_birthday.appendChild(birthdaychange);
             row.appendChild(cell_birthday);
             
             cell_email=document.createElement("td");
             var emailchange=document.createElement("input");
             emailchange.setAttribute("type","text");
             emailchange.setAttribute("value",semail_nextNode);
             emailchange.setAttribute("id","textemail");
             cell_email.appendChild(emailchange);
             row.appendChild(cell_email);
                   
             cell_deleteinfo=document.createElement("td");
             var deleteinfo=document.createElement("input");
             deleteinfo.setAttribute("type","button");
             deleteinfo.setAttribute("value","确认");
             deleteinfo.onclick=function(){changeinfo(i);};
             cell_deleteinfo.appendChild(deleteinfo);
             row.appendChild(cell_deleteinfo);
             
             cell_deleteinfo=document.createElement("td");
             var deleteinfo=document.createElement("input");
             deleteinfo.setAttribute("type","button");
             deleteinfo.setAttribute("value","取消");
             deleteinfo.onclick=function(){search();};
             cell_deleteinfo.appendChild(deleteinfo);
             row.appendChild(cell_deleteinfo);
                   
             document.getElementById("sortlist").appendChild(row);
       }
       //修改信息
       function changeinfo(i)
       {
           createXMLHttpRequest();
            //通过从xxx[i].firstChild.data中获取需要的数据
           var no=document.getElementById("textsno").value;
           var name=document.getElementById("textsname").value;
           var phone=document.getElementById("textsphone").value;
           var sex=document.getElementById("textsex").value;
           var subject=document.getElementById("textsubject").value;
           var sclass=document.getElementById("textsclass").value;
           var academy=document.getElementById("textsacademy").value;
           var pwd=document.getElementById("textspwd").value;
           var cardnumber=document.getElementById("textcardnumber").value;
           var prince=document.getElementById("textprince").value;
           var birthday=document.getElementById("textbirthday").value;
           var email=document.getElementById("textemail").value;
           var url="autoComplete?action=change&name="+sno[i].firstChild.data+"&changephone="+phone+"&changename="+name+"&changeno="+no+"&changesex="+sex+"&changesubject="+subject+"&changeclass="+sclass+"&changeacademy="+academy+"&changepwd="+pwd+"&changecardnumber="+cardnumber+"&changeprince="+prince+"&changebirthday="+birthday+"&changeemail="+email;
           XMLHttpReq.open("GET",url,true);
           XMLHttpReq.onreadystatechange=changeStateChange;
           XMLHttpReq.send(null); 
       }
       //状态响应函数
       function changeStateChange(i)
       {
           if(XMLHttpReq.readyState==4)
          {
             if(XMLHttpReq.status==200)
             {
                pageSum=1;
                 message=XMLHttpReq.responseXML.getElementsByTagName("message");
                //用来提示错误信息，当输入的班号不存在时，则会提醒
                if(message.length!=0)
                {
                   alert(message[0].firstChild.data);
                }
                search();
             }
          }
       }
       //在学生添加之前构建表格
       function before_add_showinfo()
       {
             clearNames();
             var row,cell_sno,cell_sname,cell_sphone,cell_sex,cell_subject,cell_academy,cell_change,cell_deleteinfo,cell_spwd,cell_class,cell_cardnumber,cell_prince,cell_birthday,cell_email;
             row=document.createElement("tr");        
             cell_sno=document.createElement("td");
             var snochange=document.createElement("input");
             snochange.setAttribute("type","text");
             snochange.setAttribute("width","20px");
             snochange.setAttribute("id","textsno");
             cell_sno.appendChild(snochange);
             row.appendChild(cell_sno);
             
             cell_sname=document.createElement("td");
             var snamechange=document.createElement("input");
             snamechange.setAttribute("type","text");
             snamechange.setAttribute("width","20px");
             snamechange.setAttribute("id","textsname");
             cell_sname.appendChild(snamechange);
             row.appendChild(cell_sname);
             
             cell_spwd=document.createElement("td");
             var spwdchange=document.createElement("input");
             spwdchange.setAttribute("type","text");
             spwdchange.setAttribute("width","20px");
             spwdchange.setAttribute("id","textspwd");
             cell_spwd.appendChild(spwdchange);
             row.appendChild(cell_spwd);
             
             cell_sphone=document.createElement("td");
             var sphonechange=document.createElement("input");
             sphonechange.setAttribute("type","text");
             sphonechange.setAttribute("width","20px");
             sphonechange.setAttribute("id","textsphone");
             cell_sphone.appendChild(sphonechange);
             row.appendChild(cell_sphone);
             
             cell_sex=document.createElement("td");
             var sexchange=document.createElement("input");
             sexchange.setAttribute("type","text");
             sexchange.setAttribute("width","20px");
             sexchange.setAttribute("id","textsex");
             cell_sex.appendChild(sexchange);
             row.appendChild(cell_sex);
             
             cell_subject=document.createElement("td");
             var subjectchange=document.createElement("input");
             subjectchange.setAttribute("type","text");
             subjectchange.setAttribute("width","20px");
             subjectchange.setAttribute("id","textsubject");
             cell_subject.appendChild(subjectchange);
             row.appendChild(cell_subject);
             
             cell_class=document.createElement("td");
             var classchange=document.createElement("input");
             classchange.setAttribute("type","text");
             classchange.setAttribute("width","20px");
             classchange.setAttribute("id","textsclass");
             cell_class.appendChild(classchange);
             row.appendChild(cell_class);
             
             cell_academy=document.createElement("td");
             var academychange=document.createElement("input");
             academychange.setAttribute("type","text");
             academychange.setAttribute("width","20px");
             academychange.setAttribute("id","textsacademy");
             cell_academy.appendChild(academychange);
             row.appendChild(cell_academy);
             
             cell_cardnumber=document.createElement("td");
             var cardnumberchange=document.createElement("input");
             cardnumberchange.setAttribute("type","text");
             cardnumberchange.setAttribute("width","20px");
             cardnumberchange.setAttribute("id","textcardnumber");
             cell_cardnumber.appendChild(cardnumberchange);
             row.appendChild(cell_cardnumber);
             
             cell_prince=document.createElement("td");
             var princechange=document.createElement("input");
             princechange.setAttribute("type","text");
             princechange.setAttribute("width","20px");
             princechange.setAttribute("id","textprince");
             cell_prince.appendChild(princechange);
             row.appendChild(cell_prince);
             
             cell_birthday=document.createElement("td");
             var birthdaychange=document.createElement("input");
             birthdaychange.setAttribute("type","text");
             birthdaychange.setAttribute("width","20px");
             birthdaychange.setAttribute("id","textbirthday");
             cell_birthday.appendChild(birthdaychange);
             row.appendChild(cell_birthday);
             
             cell_email=document.createElement("td");
             var emailchange=document.createElement("input");
             emailchange.setAttribute("type","text");
             emailchange.setAttribute("width","20px");
             emailchange.setAttribute("id","textemail");
             cell_email.appendChild(emailchange);
             row.appendChild(cell_email);
                   
             cell_deleteinfo=document.createElement("td");
             var deleteinfo=document.createElement("input");
             deleteinfo.setAttribute("type","button");
             deleteinfo.setAttribute("value","确认");
             deleteinfo.onclick=function(){addinfo();};
             cell_deleteinfo.appendChild(deleteinfo);
             row.appendChild(cell_deleteinfo);
             
             cell_deleteinfo=document.createElement("td");
             var deleteinfo=document.createElement("input");
             deleteinfo.setAttribute("type","button");
             deleteinfo.setAttribute("value","取消");
             deleteinfo.onclick=function(){window.location.href ="charge_Student.jsp";};
             cell_deleteinfo.appendChild(deleteinfo);
             row.appendChild(cell_deleteinfo);
                   
             document.getElementById("sortlist").appendChild(row);
       }
       //添加学生信息
       function addinfo()
       {
           createXMLHttpRequest();
            //通过从xxx[i].firstChild.data中获取需要的数据
           var no=document.getElementById("textsno").value;
           var name=document.getElementById("textsname").value;
           var phone=document.getElementById("textsphone").value;
           var sex=document.getElementById("textsex").value;
           var subject=document.getElementById("textsubject").value;
           var sclass=document.getElementById("textsclass").value;
           var academy=document.getElementById("textsacademy").value;
           var pwd=document.getElementById("textspwd").value;
           var cardnumber=document.getElementById("textcardnumber").value;
           var prince=document.getElementById("textprince").value;
           var birthday=document.getElementById("textbirthday").value;
           var email=document.getElementById("textemail").value;
           if(no.length!=0&&name.length!=0&&phone.length!=0&&sex.length!=0&&subject.length!=0&&sclass.length!=0&&academy.length!=0&&pwd.length!=0&&cardnumber.length!=0&&prince.length!=0&&birthday.length!=0&&email.length!=0)
           {
              var url="autoComplete?action=add&changephone="+phone+"&changename="+name+"&changeno="+no+"&changesex="+sex+"&changesubject="+subject+"&changeclass="+sclass+"&changeacademy="+academy+"&changepwd="+pwd+"&changecardnumber="+cardnumber+"&changeprince="+prince+"&changebirthday="+birthday+"&changeemail="+email;
              XMLHttpReq.open("GET",url,true);
              XMLHttpReq.onreadystatechange=addStateChange;
              XMLHttpReq.send(null); 
           }
           else 
              alert("请输入完整信息");
       }
       //状态响应函数
       function addStateChange()
       {
           if(XMLHttpReq.readyState==4)
          {
             if(XMLHttpReq.status==200)
             {
                var after_add_class=document.getElementById("textsclass").value;
                message=XMLHttpReq.responseXML.getElementsByTagName("message");
                //用来提示错误信息，当输入的班号不存在时，则会提醒
                if(message[0].firstChild.data!="#")
                {
                   alert(message[0].firstChild.data);
                }
                pageSum=1;
                search(after_add_class);
             }
          }
       }
       //显示信息
       function showitems(i)
       {
             //通过从xxx[i].firstChild.data中获取需要的数据
             var sno_nextNode=sno[i].firstChild.data;
             var sname_nextNode=sname[i].firstChild.data;
             var sphone_nextNode=sphone[i].firstChild.data;
             var ssex_nextNode=ssex[i].firstChild.data;
             var ssubject_nextNode=ssubject[i].firstChild.data;
             var sclass_nextNode=sclass[i].firstChild.data;
             var sacademy_nextNode=sacademy[i].firstChild.data;
             var spwd_nextNode=spwd[i].firstChild.data;
             var scardnumber_nextNode=scardnumber[i].firstChild.data;
             var sprince_nextNode=sprince[i].firstChild.data;
             var sbirthday_nextNode=sbirthday[i].firstChild.data;
             var semail_nextNode=semail[i].firstChild.data;
             var row,cell_sno,cell_sname,cell_sphone,cell_sex,cell_subject,cell_academy,cell_change,cell_deleteinfo,cell_pwd,cell_class,cell_cardnumber,cell_prince,cell_birthday,cell_email;
             row=document.createElement("tr");
                 
             cell_sno=document.createElement("td");
             cell_sno.appendChild(document.createTextNode(sno_nextNode));
             row.appendChild(cell_sno);
                   
             cell_sname=document.createElement("td");
             cell_sname.appendChild(document.createTextNode(sname_nextNode));
             row.appendChild(cell_sname);
             
             cell_pwd=document.createElement("td");
             cell_pwd.appendChild(document.createTextNode(spwd_nextNode));
             row.appendChild(cell_pwd);
                   
             cell_sphone=document.createElement("td");
             cell_sphone.appendChild(document.createTextNode(sphone_nextNode));
             row.appendChild(cell_sphone);
                   
             cell_sex=document.createElement("td");
             cell_sex.appendChild(document.createTextNode(ssex_nextNode));
             row.appendChild(cell_sex);
                   
             cell_subject=document.createElement("td");
             cell_subject.appendChild(document.createTextNode(ssubject_nextNode));
             row.appendChild(cell_subject);
                   
             cell_class=document.createElement("td");
             cell_class.appendChild(document.createTextNode(sclass_nextNode));
             row.appendChild(cell_class);
                   
             cell_academy=document.createElement("td");
             cell_academy.appendChild(document.createTextNode(sacademy_nextNode));
             row.appendChild(cell_academy);
             
             cell_cardnumber=document.createElement("td");
             cell_cardnumber.appendChild(document.createTextNode(scardnumber_nextNode));
             row.appendChild(cell_cardnumber);
             
             cell_prince=document.createElement("td");
             cell_prince.appendChild(document.createTextNode(sprince_nextNode));
             row.appendChild(cell_prince);
             
             cell_birthday=document.createElement("td");
             cell_birthday.appendChild(document.createTextNode(sbirthday_nextNode));
             row.appendChild(cell_birthday);
             
             cell_email=document.createElement("td");
             cell_email.appendChild(document.createTextNode(semail_nextNode));
             row.appendChild(cell_email);
                   
  
             cell_deleteinfo=document.createElement("td");
             var deleteinfo=document.createElement("input");
             deleteinfo.setAttribute("type","button");
             deleteinfo.setAttribute("value","删除");
             deleteinfo.onclick=function(){deleteSort(i);};
             cell_deleteinfo.appendChild(deleteinfo);
             row.appendChild(cell_deleteinfo);
                   
             cell_change=document.createElement("td");
             var change=document.createElement("input");
             change.setAttribute("type","button");
             change.setAttribute("value","修改");
             change.onclick=function(){before_change_showinfo(i);};
             cell_change.appendChild(change);
             row.appendChild(cell_change);
                   
             document.getElementById("sortlist").appendChild(row);
        }
        //用来是被选中的行变色
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
   <div id="head">
     <table>
       <tr>
       <td>查找标准</td>
         <td>
         <select id="kind">
          <option value="0" selected>学号 </option>
          <option value="1">姓名 </option>
          <option value="2">班级号 </option>
          <option value="3">全部 </option>
          
        </select>
         </td>
         <td>
           <input type="text" id="search" />
         </td>
         <td>
           <input type="button" onclick="search();" value="查找">
         </td>
     	
       </tr>
     </table>
     <input type="button" value="***添加学生***" onclick="before_add_showinfo();">
   </div>
   <div id="main">
    <table class='tablelist'>
     <tr>
          <td>学号</td>
          <td>姓名</td>
          <td>登录密码</td>
          <td>电话</td>
          <td>性别</td>
          <td>专业</td>
          <td>班级</td>
          <td>学院</td>
          <td>身份证号</td>
          <td>籍贯</td>
          <td>出生年月</td>
          <td>电子邮箱</td>
          <td>操作</td>
          <td>操作</td>
     </tr>
     <tbody id="sortlist">
     </tbody>
    </table>
    <div id="nextpage">
      第<input type="text" id="currentpage" style="width:100%/18" readonly="true">页&nbsp;&nbsp;&nbsp;
      <input type="button" value="上一页" onclick="forwardpage();">&nbsp;
      <input type="button" value="下一页" onclick="nextpage();">&nbsp;&nbsp;&nbsp;
      共<input type="text" id="sumpage" style="width:100%/18" readonly="true">页
    </div>
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
