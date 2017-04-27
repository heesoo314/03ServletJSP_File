<%@page import="java.io.File"%>
<%@page import="java.sql.Date"%>
<%@page import="mybatis.vo.MemVO"%>
<%@page import="mybatis.dao.MemDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%! // 선언부 : 변수, 함수 선언
	
	public String makePhone(String[] ar, String delim){
	
		// 문자형을 변환시키기 위한 전용 버퍼!
		StringBuffer sb = new StringBuffer();
		
		for(int i=0; i<ar.length; i++){
			
			sb.append(ar[i]);
			
			if(i < ar.length - 1)
				sb.append(delim);
			
		}
	
		return sb.toString();
}

%>    
 
<% 
 	request.setCharacterEncoding("utf-8");
 
 	String id = request.getParameter("id");
 	String pwd = request.getParameter("pwd");
 	String name = request.getParameter("name");
 	String[] p_ar = request.getParameterValues("phone");
 	String phone = makePhone(p_ar, "-");
 	String email = request.getParameter("email");
 	String addr = request.getParameter("addr");
 	
 		
 	// DB에 저장
 	 	boolean reg_ok = MemDAO.regMember(id, pwd, name, email, phone);
 	 	if(reg_ok){
 	 		
 	 		MemVO vo = new MemVO();
 	 		vo.setId(id);
 	 		vo.setPwd(pwd);
 	 		vo.setName(name);
 	 		vo.setPhone(phone);
 	 		vo.setEmail(email);
 	 		
 	 		// 현재날짜 구하기
 	 		java.sql.Date now = new java.sql.Date(System.currentTimeMillis());
 	 		vo.setReg_date(now.toString());
 	 		
 	 		// 세션처리, 로그인 정보로 바로 저장
 	 		session.setAttribute("login_vo", vo);
 	 
 	 		// members 폴더에 해당 id로 된 폴더 생성
 	 		String path = application.getRealPath("/members/" + id);
 	 		File f = new File(path);
 	 		
 	 		if( !f.exists() ){
 	 			f.mkdirs();
 	 			response.sendRedirect("index.jsp");	// 페이지이동
 	 		}
 	 			
 	 	} else {
 	
 %>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>reg</title>

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
		회원가입 오류!	<br/>
		<input type="button" value="돌아가기" onclick=" javascript:location.href='index.jsp' " />
	</div>
</body>
</html>

<%
		}
%>