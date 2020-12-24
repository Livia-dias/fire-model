package com.testcsv.testcsv;

import lombok.Data;

@Data
public class FileData {
    private String climaFile;
    private String focoFile;
    private String outFile;

    public FileData(String climaFile, String focoFile, String outFile){
        String path = "src/main/resources/";
        this.climaFile = path + climaFile;
        this.focoFile = path + focoFile;
        this.outFile = path + outFile;
    }
}
