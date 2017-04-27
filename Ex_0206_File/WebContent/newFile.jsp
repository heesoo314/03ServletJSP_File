<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	String cPath = request.getParameter("cPath");
	String fName = request.getParameter("f_name");
	String ext = request.getParameter("ext");
	String content = request.getParameter("content");
	
	// 절대경로 : cPath와 f_name 그리고 확장자인 ext를 모두 합쳐서
	String path = application.getRealPath("/members/" + cPath+ "/"+ fName + ext);
	
	File f = new File(path);
	
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>newFile</title>
<script type="text/javascript">
	function init(){
		document.forms[0].submit();
	}
</script>
</head>
<body onload="init()">

	<form action="myDisk.jsp" method="post">
		<input type="hidden" name="cPath" value="<%=cPath %>"/>
		
		
		<% if(f.exists()) { 
			// 파일이 존재할 경우에만 chk를 보낸다. %>
		<input type="hidden" name="chk" value="0"/>
		<% } %>
	</form>
	
	<%
	if(f.exists()){
	%>
		<div id="box">
			파일이 존재합니다.
		</div>
	<%	
	}else{
		
		//파일을 만든다.
		FileOutputStream fos = null;
		
		try{
			fos = new FileOutputStream(f);// 파일 생성!!!!!!!
			
			//파일만 생성되었을 뿐 내용은 안들어갔다.
			
			//화면에서 입력을 받았다는 것은 파일의 내용이 모두 문자열이라는 뜻이다. 
			//따라서 문자열 기반의 스트림을 사용하면 된다.
			PrintWriter pw = new PrintWriter(fos);			
			pw.write(content);
			pw.flush();			
			pw.close();
			
		}catch(Exception e){
			e.printStackTrace();
			
		}finally{
			
			try{
				if(fos != null)
					fos.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}		
	}
	%>
	
	
</body>
</html>
