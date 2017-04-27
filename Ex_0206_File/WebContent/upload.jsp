<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	// 요청한 폼객체에 encType=multipart로 지정되어 있다면 
	// 반드시 MultipartRequest 객체를 생성하여 파라미터를 받는다. (request x)

	// 파일을 올리기 위해선 현재경로를 알아야하는데
	// 1) request 파라미터로 받기 -> 불가
	// String cPath = request.getParameter("cPath"); 
	
	// 2) HttpSession "cPath"에 저장한 값을 불러오기
	String cPath = (String) session.getAttribute("cPath");
	
	
	// 절대경로
	String path = application.getRealPath("/members/" + cPath);
	
	// cos.jar 라이브러리에 있는 MultipartRequest 객체 생성
	// 생성자 파라미터(HttpServletRequest, saveDirectory, maxUploadSize, encoding, 파일이름 중첩 생성시 처리)
	// 파일올리기 수행
	MultipartRequest mr = new MultipartRequest(request, path, 5*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	
	// 파라미터로 받은 "file"을 통해 저장된 파일 알아내기
	File f = mr.getFile("file");
	String org_name = mr.getOriginalFileName("file"); // 원래이름 (이름이 바뀔 수 있으므로)
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>upload</title>

<script type="text/javascript">
	function init(){
		document.forms[0].submit();
	}
</script>

</head>
<body onload = "init()">
	<form action="myDisk.jsp" method="post" >
		<input type="hidden" name="cPath" value="<%= cPath %>" />
	</form>
</body>
</html>