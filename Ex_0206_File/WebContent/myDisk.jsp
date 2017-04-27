<%@page import="java.io.File"%>
<%@page import="mybatis.vo.MemVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%! int totalSize = 1024 * 1024 * 10; //10MB(개인할당 최대용량)
	int useSize; //각 개인이 사용하고 있는 용량

	public int countUseSize(File f) {

		int size = 0;

		// 인자로 넘어온 폴더 경로의 내용
		File[] list = f.listFiles();

		for (File s_file : list) {

			// s_file이 파일이 아닌 폴더(디렉토리)라면 용량을 구하지 못하므로
			// 현재 메소드를 '재귀호출'하여 용량을 구한다.
			if (s_file.isDirectory())
				size += countUseSize(s_file);

			else
				size += s_file.length();

		}
		return size;

	}%>

<%
	request.setCharacterEncoding("utf-8");

	// 현재 위치값을 저장 또는 받는 변수 선언, 디렉토리를 이동할 때 사용
	String cPath = null;

	// 로그인 여부 확인
	Object obj = session.getAttribute("login_vo");

	if (obj == null)
		response.sendRedirect("index.jsp");

	else {

		MemVO vo = (MemVO) obj;

		// 절대경로
		String path = null;

		// 요청한 곳으로부터 "cPath"라는 파라미터 값을 받는다
		cPath = request.getParameter("cPath");

		if (cPath == null) {
			// 로그인 후 현재 페이지(myDisk.jsp)를 처음 왔을 경우
			cPath = vo.getId();
			path = application.getRealPath("/members/" + cPath);

			useSize = countUseSize(new File(path));

		} else {
			path = application.getRealPath("/members/" + cPath);
		}

		// path 경로를 가지고 파일 객체 생성
		File select_file = new File(path);

		// 파일 저장을 하기 위한 위치값을 미리 HttpSession에 저장
		session.setAttribute("cPath", cPath);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>myDisk</title>

<style type="text/css">
table, div {
	width: 600px;
	border: 1px solid black;
	border-collapse: collapse;
}

th, td {
	border: 1px solid black;
}

.dt {
	background-color: #dedede;
	width: 25%;
	text-align: center;
}

.dt2 {
	background-color: #dedede;
	width: 15%;
	text-align: center;
}

.dt3 {
	background-color: #dedede;
	width: 60%;
	text-align: center;
}

.dt4 {
	background-color: #dedede;
	width: 25%;
	text-align: center;
}

li.item {
	float: left;
	width: 160px;
	margin-bottom: 20px;
}

hr {
	clear: both
}

ul.menu {
	list-style: none;
}

li a {
	display: block;
	font-size: 22px;
	line-height: 35px;
	margin-right: 10px;
	color: #00b3dc;
	font-weight: bold;
	padding: 0 8px;
	border: 2px solid #00b3dc;
	text-decoration: none;
	text-align: center;
}

div#file_win {
	position: absolute;
	top: 100px;
	left: 500px;
	width: 450px;
	height: 400px;
	background-color: #ffffff;
	border-radius: 10px;
	border: 1px solid black;
	padding: 10px;
	padding-top: 30px;
	text-align: center;
	display: none;
}

div#file_win2 {
	position: absolute;
	top: 100px;
	left: 400px;
	width: 350px;
	height: 300px;
	background-color: #ffffff;
	border-radius: 10px;
	border: 1px solid black;
	padding: 10px;
	padding-top: 30px;
	text-align: center;
	display: none;
}
.dd {
	text-align: center
}
</style>

<script type="text/javascript">

	// 인자로 들어오는 폴더명으로 다시 현재 페이지(myDisk.jsp)를
	// 로드하도록 하는 함수
	function re(fname){
		// 현재 문서(document)에 이름이 myForm이라는 폼객체 내에
		// 이름이 cPath라는 객체의 값(value)으로 현재 위치값(cPath)과
		// 인자의 값을 더하여 지정한다.
		document.myForm.cPath.value = "<%=cPath%>/" + fname;
		document.myForm.action = "myDisk.jsp";
		document.myForm.submit();
	}

	// 상위로 이동
	function up(path) {
		// path는 이동하고자 하는 폴더의 전제경로 ('maru/test')
		document.myForm.cPath.value = path;
		document.myForm.action = "myDisk.jsp";
		document.myForm.submit();
	}

	// 폴더만들기
	function newFolder() {
		document.myForm.action = "newFolder.jsp";
		document.myForm.submit();
	}
	
	// 파일을 올리기하기 위해 div를 보여주는 메서드
	function upload() {
		
		// 아이디가 "file_win"인 객체를 검색한다.
		var f_div = document.getElementById("file_win");
		f_div.style.display = "block";
	}

	//파일 올리기 div 숨기기 기능
	function noView() {
		var f_div = document.getElementById("file_win");
		f_div.style.display = "none";
	}
	
	
	// 파일만들기
	function newFile() {
		
		var f_div = document.getElementById("file_win2");
		f_div.style.display = "block";
	}
	
	//파일 올리기 div 숨기기 기능
	function noView2() {
		var f_div = document.getElementById("file_win2");
		f_div.style.display = "none";
	}

	//파일 다운로드 기능
	function down(fname) {
		// 파일을 다운로드할 수 있도록
		// 파일이 있는 경로(cPath)와 
		// 파일의 이름(fname)을 보내야 한다.
		document.myForm.f_name.value = fname;
		document.myForm.action = "download.jsp";
		document.myForm.submit();
	}

	//파일을 삭제 하는 기능
	function del(fname) {

		// 우선 진짜 삭제 할 것인지를 물어보자!
		var cmd = confirm("삭제하시겠습니까?");// true아니면 false

		if (cmd) {
			document.myForm.f_name.value = fname;
			document.myForm.action = "delete.jsp";
			document.myForm.submit();
		}
	}
	
	
	function check(){
		alert("이미 존재하는 파일입니다.");
	}
	
	
</script>
</head>
<body 
<% if(request.getParameter("chk") != null){ %> 
	onload="check()" 
<% } %> >

	<h1>MyDisk Service</h1>
	<table summary="사용량표시테이블" cellspacing="0" cellpadding="4">
		<tbody>
			<tr>
				<td class="dt">전체용량</td>
				<td><%=totalSize / 1024%>KB</td>
			</tr>
			<tr>
				<td class="dt">사용용량</td>
				<td><%=useSize / 1024%>KB</td>
			</tr>
			<tr>
				<td class="dt">남은용량</td>
				<td><%=(totalSize - useSize) / 1024%>KB</td>
			</tr>
		</tbody>
	</table>

	<hr />
	<ul class="menu">
		<li class="item"><a href="#" onclick="newFolder()">폴더만들기</a></li>
		<li class="item"><a href="javascript:upload()">파일올리기</a></li>
		<li class="item"><a href="javascript:newFile()">파일만들기</a></li>
	</ul>
	<hr />


	<!-- 현재위치의 디렉토리 내부의 내용을 출력하는 표 -->
	현재위치:
	<%=cPath%>
	<table summary="현재위치내용테이블" cellpadding="4" cellspacing="0">
		<caption>현재 위치의 내용</caption>
		<thead>
			<tr>
				<th class="dt2">구분</th>
				<th class="dt3">폴더 및 파일명</th>
				<th class="dt4">삭제여부</th>
			</tr>
		</thead>
		<tbody>

			<%
				// 해당사용자가 볼 수 있는 최상위 폴더까지 갔다면 
				// 즉, 현재위치 = id라면 [상위로...]가 보이지 않게 한다.
				if (!cPath.equals(vo.getId())) {

					// 현재위치 경로에서 뒤에서 첫번째에 있는 "/"까지의 경로를 버리고 cPath 지정
					// myDisk.jsp를 다시 수행
					String upPath = cPath.substring(0, cPath.lastIndexOf("/"));
			%>
			<tr>
				<td class="dd"><img src="images/go_up.jpg" /></td>
				<td colspan="2"><a href="javascript:up('<%=upPath%>')">상위로...</a></td>
			</tr>

			<%
				}

					// 현재위치(cPath)에 있는 하위 요소를 받아온다.
					File[] sub_list = select_file.listFiles();
					for (File f : sub_list) {
			%>
			<tr>
				<td class="dd">
					<%
						if (f.isDirectory()) {
					%> <img src='images/folder.jpg' width='25' height='20' /> <%
 						} else {
					%> <img src="images/file.jpg" width="25" height="20" /> <%
 						}
 					%>
				</td>

				<td>
					<%
						// 폴더일 경우 내부로 접근 -> re
						// 파일일 경우 다운로드 -> down
						if (f.isDirectory()) {
					%> <a href="javascript:re('<%=f.getName()%>')"> <%=f.getName()%></a> <%
 						} else {
 					%> <a href="javascript:down('<%=f.getName()%>')"> <%=f.getName()%></a> <%
 						}
 					%>
				</td>

				<td><input type="button" value="삭제"
					onclick="del('<%=f.getName()%>')" /></td>
			</tr>

			<%
				}
			%>

		</tbody>
	</table>


	<!-- 상위이동, 폴더만들기, 다운로드 기능 등을 사용하기 위한 폼객체  -->
	<form name="myForm" method="post">
		<input type="hidden" name="cPath" value="<%=cPath%>" /> 
		<input type="hidden" name="f_name" />
		<!-- f_name은 스크립트 함수에 value값을 지정한다.
		  submit또한 스크립트 함수에서 처리한다. -->
	</form>


	<!-- 파일올리기 기능의 팝업창 -->
	<div id="file_win">
		<form action="upload.jsp" method="post" encType="multipart/form-data" name="ff">
			<input type="hidden" name="cPath" value="<%=cPath%>" /> 
			첨부파일:<input type="file" name="file" /><br /><br /> 
			<input type="submit" value="저 장" />
			<input type="button" value="취 소" onclick="noView()" />
		</form>
	</div>
	
	
	<!-- 파일만들기 기능의 팝업창 -->
	<div id="file_win2">
		<form action="newFile.jsp" method="post">
			<input type="hidden" name="cPath" value="<%=cPath%>" /> 
			파일명 : <input type="text" name="f_name" />
			<select name="ext">
				<option value=".txt">txt</option>
				<option value=".html">html</option>
				<option value=".css">css</option>
			</select><hr/>			
			<textarea rows="12" cols="40" name="content"></textarea>
			<br/><br/>
			
			<input type="submit" value="저 장" />
			<input type="button" value="취 소" onclick="noView2()" />
		</form>
	</div>
</body>
</html>

<%
	}
%>
