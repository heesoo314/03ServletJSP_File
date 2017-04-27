<%@page import="java.io.File"%>
<%@page import="java.sql.Date"%>
<%@page import="mybatis.vo.MemVO"%>
<%@page import="mybatis.dao.MemDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 
 <%
 
 	String id = request.getParameter("id");
 	String pwd = request.getParameter("pwd");
 	
 	MemVO vo = MemDAO.login(id, pwd);
 	
 	if(vo != null){
 		
 		session.setAttribute("login_vo", vo);
 		response.sendRedirect("index.jsp");
 		
 	} else {
 
 %>
 		

 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login</title>

<style>
	div#fail {
		width:300px; height:100px;
		border:1px solid #afafaf;
		border-radius:5px;
		text-align:center;
		line-height:100px;
	}
</style>

</head>
<body>
	<div id="fail">
		ID 또는 비밀번호가 잘못되었습니다.	<br/>
		<input type="button" value="돌아가기" onclick=" javascript:location.href='index.jsp' " />
	</div>
</body>
</html>

<%
		}
%>