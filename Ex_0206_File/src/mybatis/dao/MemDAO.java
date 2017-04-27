package mybatis.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import mybatis.vo.MemVO;

public class MemDAO {
	
	private static SqlSessionFactory factory;
	
	static {		
		try {
			
			Reader r = Resources.getResourceAsReader("mybatis/config/config.xml");
			factory = new SqlSessionFactoryBuilder().build(r);
			r.close();
			
		} catch (Exception e) {
			e.printStackTrace();			
		}		
	} // static 초기화
	
	
	// 1) 로그인
	public static MemVO login(String id, String pwd){
		
		Map<String, String> map = new HashMap<>();		
		map.put("id", id);
		map.put("pwd", pwd);
		
		SqlSession ss = factory.openSession(true);
		MemVO vo = ss.selectOne("mem.login", map);
		ss.close();
		
		return vo;
		
	}
	
	// 2) 회원가입
	public static boolean regMember(String id, String pwd, String name, String email, String phone){
		
		MemVO vo = new MemVO();
		vo.setId(id);
		vo.setPwd(pwd);
		vo.setName(name);
		vo.setEmail(email);
		vo.setPhone(phone);
		
		SqlSession ss = factory.openSession(true);
		
		boolean v1 = getMember(id);
		boolean v2 = false;
		
		if(!v1){
			int cnt = ss.insert("mem.regMem", vo);
			
			if(cnt == 1)
				v2 = true;
			
			ss.close();
			
		}
		
		return v2;
		
	}
	
	
	// 3) 아이디 중복확인
	public static boolean getMember(String id){
		
		SqlSession ss = factory.openSession(true);
		
		MemVO vo = ss.selectOne("mem.getMem", id);
		
		boolean value = false;
		if(vo != null)
			value = true;
		
		return value;
		
	}
}
