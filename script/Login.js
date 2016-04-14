$(function(){
	//元素绑定全局ajaxStart事件
	$("#divMsg").ajaxStart(function(){
		$(this).show.html("正在发送登录请求···");//显示元素
	})
	//元素绑定全局ajaxStop事件
	$("#divMsg").ajaxStop(function(){
		$(this).html("登录请求已完成。").hide();
	})
	$("#login").click(function(){//按钮点击事件
		var $name = $("#txtName");//用户名
		var $pass = $("#txtPass");//密码
		if($name.val() != "" && $pass.val() != ""){
			userLogin($name.val(), $pass.val());
		}
		else{
			if($name.val() == ""){
				alert("用户名不能为空！");
				$name.focus();
				return false;
			}
			else{
				alert("密码不能为空！");
				$pass.focus();
				return false;
			}
		}
	})
});

function userLogin(name, pass){
	$.ajax({
		type: "GET", 
		url: "index.php",
		data: "action=Login&d=" + new Date() + "&name=" +name +"&pass=" + pass,
		success: function(data){
			if(data == "1"){
				window.location = "ChatMain.html";
			}
			else{
				alert("用户名或密码错误！");
				return false;
			}
		}
	});
}