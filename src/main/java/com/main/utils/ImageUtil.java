package com.main.utils;

import java.util.Locale;

public class ImageUtil {
	public String getExtensionFromURL(String imageUrl) {
        String lowercase = imageUrl.toLowerCase(Locale.ROOT);
        if(lowercase.endsWith(".jpg") || lowercase.endsWith(".jpeg"))
             return "jpg";
        if(lowercase.endsWith(".png"))
             return "png";
        if(lowercase.endsWith(".gif"))
             return "gif";
        if(lowercase.endsWith(".bmp"))
             return "bmp";
        return "unknown";
    }

}
