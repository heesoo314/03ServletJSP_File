<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// "login_vo" 키의 정보 삭제
	session.removeAttribute("login_vo");
	
	//session.invalidate();	//세션 자체를 삭제

	response.sendRedirect("index.jsp");
%>
>