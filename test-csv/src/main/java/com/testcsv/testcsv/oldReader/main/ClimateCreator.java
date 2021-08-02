package com.testcsv.testcsv.oldReader.main;

import com.testcsv.testcsv.oldReader.ClimaRow;
import com.testcsv.testcsv.oldReader.ClimaRowWithDay;
import com.testcsv.testcsv.oldReader.FileData;
import com.testcsv.testcsv.oldReader.FocoRow;
import com.univocity.parsers.common.processor.BeanListProcessor;
import com.univocity.parsers.common.processor.BeanWriterProcessor;
import com.univocity.parsers.csv.CsvParser;
import com.univocity.parsers.csv.CsvParserSettings;
import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.File;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class ClimateCreator {

    public void readFile() {
        FileData cavernasData = new FileData("clima_cavernas.csv","Focos-cavernas_1999-2019_TODOS_sat.csv","cavernas.csv");
        FileData cochaData = new FileData("clima_cochagibao.csv","Focos-cocha_1999-2019_TODOS_sat.csv","cocha.csv");
        FileData pandeirosData = new FileData("clima_pandeiros.csv","Focos-pandeiros_1999-2019_TODOS_sat.csv","pandeiros.csv");
        List<FileData> files = Arrays.asList(cavernasData, cochaData, pandeirosData);
        files.forEach(this::parse);
    }

    public void parse(FileData fileData){

        File focos = new File(fileData.getFocoFile());
        List<FocoRow> focoRows = readFoco(focos);
        Map<LocalDateTime, Long> unduplicated = removeDuplicates(focoRows);

        File cavernas = new File(fileData.getClimaFile());
        List<ClimaRow> parsedRows = readClima(cavernas);
        fixDays(parsedRows);

        parsedRows.forEach(e -> {
                    int amount = getAmount(unduplicated, e.getYear(), e.getMonth(), e.getDay());
                    e.setFocusesQnt(amount);
                    e.setHasFire(false);
                    if (amount > 0)
                        e.setHasFire(true);
                }
        );


        BeanWriterProcessor<ClimaRowWithDay> rowProcessor = new BeanWriterProcessor<>(ClimaRowWithDay.class);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        settings.setHeaders("temperature","Relative.Humidity","precipitation","Wind.speed","day","Month","Year","Focuses_qnt","HAS_FIRE");
        File outFile = new File(fileData.getOutFile());
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        List<ClimaRowWithDay> days = new ArrayList<>();
        parsedRows.forEach(p -> days.add(new ClimaRowWithDay(p)));
        csvWriter.processRecordsAndClose(days);
    }

    public Map<LocalDateTime, Long> removeDuplicates(List<FocoRow> focoRows) {
        Set<FocoRow> rows = new HashSet<>(focoRows);
        return rows.stream().collect(Collectors.groupingBy(FocoRow::getDatahora, Collectors.counting()));
    }

    public void fixDays(List<ClimaRow> rows) {
        rows.sort(Comparator.comparing(ClimaRow::getYear).thenComparing(ClimaRow::getMonth));
        Map<Integer, List<ClimaRow>> yearMap = rows.stream().collect(Collectors.groupingBy(ClimaRow::getYear));
        for (Map.Entry<Integer, List<ClimaRow>> integerListEntry : yearMap.entrySet()) {
            Map<Integer, List<ClimaRow>> monthMap = integerListEntry.getValue().stream().collect(Collectors.groupingBy(ClimaRow::getMonth));
            for (Map.Entry<Integer, List<ClimaRow>> listEntry : monthMap.entrySet()) {
                int count = 1;
                for (ClimaRow climaRow : listEntry.getValue()) {
                    climaRow.setDay(count++);
                }
            }
        }
    }

    public int getAmount(Map<LocalDateTime, Long> map, Integer year, Integer month, Integer day) {
        for (Map.Entry<LocalDateTime, Long> localDateTimeLongEntry : map.entrySet()) {
            LocalDateTime key = localDateTimeLongEntry.getKey();
            if(key.getYear() == year &&
            key.getMonthValue() == month &&
            key.getDayOfMonth() == day) {
                return Math.toIntExact(localDateTimeLongEntry.getValue());
            }
        }
        return 0;
    }

    public List<FocoRow> readFoco(File file) {
        BeanListProcessor<FocoRow> rowProcessor = new BeanListProcessor<>(FocoRow.class);
        CsvParserSettings settings = new CsvParserSettings();
        settings.setDelimiterDetectionEnabled(true, ',');
        settings.setProcessor(rowProcessor);
        settings.setHeaderExtractionEnabled(true);
        CsvParser parser = new CsvParser(settings);
        parser.parse(file);
        return rowProcessor.getBeans();
    }

    public List<ClimaRow> readClima(File file) {
        BeanListProcessor<ClimaRow> rowProcessor = new BeanListProcessor<>(ClimaRow.class);
        CsvParserSettings settings = new CsvParserSettings();
        settings.setDelimiterDetectionEnabled(true, ',');
        settings.setProcessor(rowProcessor);
        settings.setHeaderExtractionEnabled(true);
        CsvParser parser = new CsvParser(settings);
        parser.parse(file);
        return rowProcessor.getBeans();
    }

}
