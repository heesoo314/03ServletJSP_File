<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");

	String cPath = request.getParameter("cPath");
	String fName = request.getParameter("f_name");
	
	String path = application.getRealPath("/members/" + cPath + "/" + fName);
	
	File f = new File(path);
	
	if( f.exists() ){
		long f_size = f.length();	// 파일크기
		
		//byte[] buf = new byte[(int)f_size];
		byte[] buf = new byte[2048];	// 파일의 값을 읽을 때 임시로 담을 공간의 사이즈
		
		int size = -1; // 파일로부터 읽어들인 바이트수
		
		
		// 필요한 I/O 스트림들 
		BufferedInputStream bis = null;
		InputStream fis = null;
		
		BufferedOutputStream bos = null;
		ServletOutputStream fos = null;
		// 서버를 요청한 클라이언트에게 파일을 보내기 위해 response 객체를 통하여 스트림을 얻어냄
		
		
		// 다운로드 대화창
		try{
			
			// 1) 화면 표시 설정
			response.setContentType("application/x-msdownload");
			response.setHeader("Content-Disposition", "attachment;filename=" 
				+ new String(fName.getBytes(), "utf-8")); 	// 파일명이 한글일 때를 대비하여 String 객체를 생성
			
			
			// 2) 파일의 자원을 읽을 InputStream을 만들고
			// 클라이언트에게 보낼 OutputStream을 만든다
			
			fis = new FileInputStream(f);
			bis = new BufferedInputStream(fis);
			
			// 보통 화면에 표현하기 위해 쓰이는 out.println("");
			// PrintWriter out 객체는 OutputStream을 쓸 때 문제가 된다.
			// 따라서 out을 삭제하여 서버측에 발생할 문제점을 제거한다.
			out.clear();
			out = pageContext.pushBody();
			
			fos = response.getOutputStream();
			bos = new BufferedOutputStream(fos);
			
			
			// 3) 파일 입출력처리
			// bis.read() : 한바이트씩 읽는다(r)
			// bis.read(byte[]) : 한바이트씩 읽은 값을 byte[]형 배열에 담는다
			while( (size = bis.read(buf)) != -1 ){
				// 더이상 읽을 값이 없다면 size = -1를 반환하고 반복문 탈출
						
				bos.write(buf, 0, size);	// buf 배열의 0번지부터 size 갯수만큼을 뽑아서 쓰기(w)
				bos.flush();				
			}			
			
		} catch(Exception e){
			e.printStackTrace();
			
		} finally {
			
			// 4) 스트림 닫기
			try{
				if(fis != null)
					fis.close();
				
				if(bis != null)
					bis.close();
				
				if(fos != null)
					fos.close();
				
				if(bos != null)
					bos.close();				
				
			} catch(Exception e){
				e.printStackTrace();
			}
		
		}
		
	}
		
	
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>download</title>
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