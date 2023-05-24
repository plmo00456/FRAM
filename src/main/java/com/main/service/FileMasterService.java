package com.main.service;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonObject;
import com.main.repository.FileMasterRepository;
import com.main.utils.Utils;
import com.main.vo.FileMaster;

@Service
public class FileMasterService {
	@Value("${file.upload.dir}")
	private String fileDir;
	
	@Value("${spring.servlet.multipart.max-file-size}")
    private String maxFileSize;

	@Autowired
	private FileMasterRepository fileMasterRepository;

	public FileMaster saveFile(MultipartFile mf, Long userSeq, HttpServletResponse res) {
		if (mf.isEmpty()) {
			return null;
		}
		Utils util = new Utils();
		String origName = mf.getOriginalFilename();
		String uuid = UUID.randomUUID().toString();
		String extension = origName.substring(origName.lastIndexOf("."));
		String savedName = uuid + extension;
		String savedPath = fileDir;
		String savedFullPath = fileDir + savedName;
		
		File dic = new File(savedPath);
		if(!dic.exists()) dic.mkdirs();
		
		FileMaster file = new FileMaster();
		file.setUserSeq(userSeq);
		file.setOriFilename(origName);
		file.setFilepath(fileDir);
		file.setFilename(savedName);
		
		try {
			mf.transferTo(new File(savedFullPath));
		}catch(IOException e) {
			e.printStackTrace();
			JsonObject result = new JsonObject();
        	result.addProperty("status", "N");
        	result.addProperty("msg", "이미지 업로드 중 오류가 발생했습니다.<br>관리자에게 문의해주세요." );
        	util.sendJsonResponse(res, result);
        	return null;
		}
		FileMaster savedFile = fileMasterRepository.save(file);

		return savedFile;
	}
}
