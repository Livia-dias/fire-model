package com.testcsv.testcsv.oldReader.main;

import com.testcsv.testcsv.oldReader.FileData;
import com.testcsv.testcsv.oldReader.FocoRow;
import com.testcsv.testcsv.oldReader.NewFocoRow;
import com.testcsv.testcsv.utils.AllMapper;
import com.testcsv.testcsv.utils.Utils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.Arrays;
import java.util.List;

@Component
@Slf4j
@RequiredArgsConstructor
public class ClimateCreatorV2 {

    private final ClimateCreator climateCreator;
    private final AllMapper allMapperImpl;

    //@EventListener(ApplicationReadyEvent.class)
    public void readFile() {
        FileData cavernasData = new FileData("clima_cavernas.csv","FOCOS NOVOS/cavernas_FOCOS_1999_2019_novo.csv","cavernas2.csv");
        FileData cochaData = new FileData("clima_cochagibao.csv","FOCOS NOVOS/cocha_FOCOS_1999_2019_novo.csv","cocha2.csv");
        FileData pandeirosData = new FileData("clima_pandeiros.csv","FOCOS NOVOS/pand_FOCOS_1999_2019_novo.csv","pandeiros2.csv");
        List<FileData> files = Arrays.asList(cavernasData, cochaData, pandeirosData);
        files.forEach(this::parse);
    }

    public void parse(FileData fileData){
        List<FocoRow> focoRows = getNewFocos(fileData);
        climateCreator.parseFoco(fileData, focoRows);
    }

    private List<FocoRow> getNewFocos(FileData fileData){
        List<NewFocoRow> newRows = Utils.readFoco(new File(fileData.getFocoFile()), NewFocoRow.class);
        return allMapperImpl.toFocoRow(newRows);
    }
}
