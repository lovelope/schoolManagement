function q(num){
	for(var id = 1;id<=4;id++)
	{
		var cons="con"+id;
		if(id==num)
			document.getElementById(cons).style.display="block";
		else
			document.getElementById(cons).style.display="none";
	}
	if(num==1) 
		document.getElementById("title").className="title title_bg1";
	if(num==2)
		document.getElementById("title").className="title title_bg2";
	if(num==3)
		document.getElementById("title").className="title title_bg3";
}