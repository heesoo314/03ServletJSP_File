<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<%
	String cPath = request.getParameter("cPath");
	String fName = request.getParameter("f_name");
	
	// 지우고자 하는 파일의 절대경로
	String delPath = application.getRealPath("/members/"  + cPath + "/" + fName);

	File f = new File(delPath);
	if( f.exists() )
		f.delete();	

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>delete</title>

<script type="text/javascript">
	function gogo(){
		document.forms[0].submit();
	}
</script>

</head>

<body onload="gogo()">

	<form action="myDisk.jsp" method="post">
		<input type="hidden" name="cPath" value="<%=cPath %>"/>
	</form>
	
</body>
</html>