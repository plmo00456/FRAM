package com.main.service;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.main.repository.FileMasterRepository;
import com.main.vo.FileMaster;

@Service
public class FileMasterService {
	@Value("${file.upload.dir}")
	private String fileDir;

	@Autowired
	private FileMasterRepository fileMasterRepository;

	public FileMaster saveFile(MultipartFile files, Long userSeq) throws IOException {
		if (files.isEmpty()) {
			return null;
		}
		String origName = files.getOriginalFilename();
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
		files.transferTo(new File(savedFullPath));
		FileMaster savedFile = fileMasterRepository.save(file);

		return savedFile;
	}
}
