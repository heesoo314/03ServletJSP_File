<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("utf-8");
	String cPath = request.getParameter("cPath");
%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>newFolder</title>

<style type="text/css">
form {
	width:250px;		
}

</style>
<script type="text/javascript">

	function makeFolder(ff){
	
		if(ff.f_name.value.trim().length < 1){
			alert("폴더명을 입력해주세요!");
			ff.f_name.focus();
			return;
		}

		ff.submit();
	}
	
</script>
</head>

<body>

	<form action = "newFolder_OK.jsp" method="post">
		<fieldset>
			<legend>폴더만들기</legend>
			
			<input type="hidden" name="cPath" value="<%=cPath %>"/>			
			폴더명 : <input type="text" name="f_name" /><br/>
			<input type="button" value="만들기" onclick="makeFolder(this.form)" /><br/>
		</fieldset>
	</form>

</body>
</html>