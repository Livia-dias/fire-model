package com.testcsv.testcsv.newOne.main;

import com.testcsv.testcsv.newOne.*;
import com.testcsv.testcsv.utils.AllMapper;
import com.univocity.parsers.common.processor.BeanWriterProcessor;
import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;
import java.util.stream.Collectors;

import static com.testcsv.testcsv.utils.Utils.readFoco;

@Component
@Slf4j
public class CreatorOfOneFiles {

    private final AllMapper allMapper;

    public CreatorOfOneFiles(AllMapper allMapper) {
        this.allMapper = allMapper;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void readAll() {

        List<PathData> caminhos = List.of(
                new PathData("src/main/resources/Excels/tabela focos pand/","src/main/resources/Excels/APA Pandeiros", "_focos_pand_ref_1.csv"),
                new PathData("src/main/resources/Excels/tabela focos cocha/","src/main/resources/Excels/APA Cocha", "_focos_cocha_ref_1.csv")
        );
        for (PathData caminho : caminhos) {
            Map<Integer, List<FocosWithDayAndFidRow>> anoFocos = getFidAndData(caminho.getDataFidPath());
            mountRest(anoFocos, caminho.getInfoPath());

            for (Map.Entry<Integer, List<FocosWithDayAndFidRow>> entry : anoFocos.entrySet()) {
                write(caminho, entry.getKey(), entry.getValue());
            }
        }



    }

    private void write(PathData data, Integer ano, List<FocosWithDayAndFidRow> parsedRows){
        BeanWriterProcessor<FocosWithDayAndFidRow> rowProcessor = new BeanWriterProcessor<>(FocosWithDayAndFidRow.class);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        settings.setHeaders(
                "hasFire",
                "datahora",
                "elevation",
                "slope",
                "ndvi",
                "road",
                "hydrography",
                "popDens",
                "ocupations",
                "lulc",
                "year",
                "fid"
        );
        File outFile = new File(ano.toString().concat(data.getOutput()));
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
    }

    @SneakyThrows
    private void addNdvi(Integer ano, List<FocosWithDayAndFidRow> rows, Path caminho) {
        List<Path> paths = Files.walk(caminho)
                .filter(Files::isRegularFile)
                .filter(f -> f.getFileName().toString().startsWith("1NDVI"))
                .collect(Collectors.toList());

        for (Path path : paths) {
            List<FidWithValue> values = readFoco(path.toFile(), FidWithValue.class);
            MonthValue month;
            if(caminho.toString().toUpperCase().contains("COCHA"))
             month = MonthValue.valueOf(path.getFileName().toString().substring(12, 15));
            else
                month = MonthValue.valueOf(path.getFileName().toString().substring(11, 14));
            List<FocosWithDayAndFidRow> rowsMeses = rows.stream()
                    .filter(r -> r.getDatahora().getMonthValue() == month.getValue() && r.getYear().equals(ano))
                    .collect(Collectors.toList());
            List<FidWithValue> filteredValues = values.stream().filter(r -> rowsMeses.stream().map(FocosWithDayAndFidRow::getFid).collect(Collectors.toList()).contains(r.getFid())).collect(Collectors.toList());
            for (FocosWithDayAndFidRow rowsMese : rowsMeses) {
                Optional<FidWithValue> opt = values.stream().filter(r -> r.getFid().equals(rowsMese.getFid())).findFirst();
                if(opt.isPresent()){
                    rowsMese.setNdvi(opt.get().getValue()/10000);
                } else {
                    System.out.println(rowsMese.getYear());
                    System.out.println(rowsMese.getDatahora().toString());
                }
            }
            if(filteredValues.size() != rowsMeses.size()) {
                System.out.println(filteredValues.size());
                System.out.println(rowsMeses.size());
                System.out.println(path);
            }
        }

    }

    @SneakyThrows
    public Map<Integer, List<FocosWithDayAndFidRow>> getFidAndData(String caminho){
        List<Path> paths = Files.walk(Paths.get(caminho))
                .filter(Files::isRegularFile)
                .collect(Collectors.toList());
        Map<Integer, List<FocosWithDayAndFidRow>> map = new TreeMap<>();
        for (Path path : paths) {
            try {
                List<FidWithDateTime> foco = readFoco(path.toFile(), FidWithDateTime.class);
                int ano;
                if(caminho.toUpperCase().contains("PAND"))
                 ano = Integer.parseInt(path.getFileName().toString().substring(12, 16));
                else {
                    ano = Integer.parseInt(path.getFileName().toString().substring(13, 17));
                }
                List<FocosWithDayAndFidRow> rows = allMapper.toFocosWithDayAndFidRow(foco);
                rows.forEach(a -> a.setYear(ano));
                map.put(ano, rows);
            } catch (Exception e) {
                log.error(path.toString(), e);
            }
        }
        return map;
    }

    @SneakyThrows
    public void mountRest(Map<Integer, List<FocosWithDayAndFidRow>> anoFocos, String caminho){
        for (Map.Entry<Integer, List<FocosWithDayAndFidRow>> entry : anoFocos.entrySet()) {
            Path resolved = Path.of(caminho, entry.getKey().toString(), "focos");
            List<Path> paths = Files.walk(resolved)
                    .filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith("1NDVI"))
                    .collect(Collectors.toList());

            for (Path path : paths) {
                List<FocosWithDayAndFidRow> focos = entry.getValue();
                String fileName = path.getFileName().toString();
                if(fileName.startsWith("1densidade")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setPopDens(value.getValue());
                    }
                } else if (fileName.startsWith("1elev")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setElevation(value.getValue());
                    }
                }else if (fileName.startsWith("1hidro")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setHydrography(value.getValue());
                    }
                }else if (fileName.startsWith("1ocupa")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setOcupations(value.getValue());
                    }
                }else if (fileName.startsWith("1road")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setRoad(value.getValue());
                    }
                }else if (fileName.startsWith("1slope")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setSlope(value.getValue());
                    }
                }else if (fileName.startsWith("1uso")) {
                    List<FidWithValue> valueList = readFoco(path.toFile(), FidWithValue.class);
                    for (int i = 0; i < valueList.size(); i++) {
                        FidWithValue value = valueList.get(i);
                        FocosWithDayAndFidRow row = focos.get(i);
                        row.setLulc(value.getValue().intValue());
                    }
                }
            }

            addNdvi(entry.getKey(), entry.getValue(), resolved);
        }

    }
}
