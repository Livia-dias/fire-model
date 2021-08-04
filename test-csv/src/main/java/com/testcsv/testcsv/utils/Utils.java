package com.testcsv.testcsv.utils;

import com.testcsv.testcsv.newOne.PathData;
import com.univocity.parsers.common.processor.BeanListProcessor;
import com.univocity.parsers.common.processor.BeanWriterProcessor;
import com.univocity.parsers.csv.CsvParser;
import com.univocity.parsers.csv.CsvParserSettings;
import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import lombok.experimental.UtilityClass;

import java.io.File;
import java.util.List;

@UtilityClass
public class Utils {

    public static <T> List<T> readFoco(File file, Class<T> clazz) {
        BeanListProcessor<T> rowProcessor = new BeanListProcessor<>(clazz);
        CsvParserSettings settings = new CsvParserSettings();
        settings.setDelimiterDetectionEnabled(true, ',', ';');
        settings.setProcessor(rowProcessor);
        settings.setHeaderExtractionEnabled(true);
        CsvParser parser = new CsvParser(settings);
        parser.parse(file);
        return rowProcessor.getBeans();
    }


    public static <T> void write(PathData data, List<T> parsedRows, Class<T> clazz, List<String> headers){
        BeanWriterProcessor<T> rowProcessor = new BeanWriterProcessor<>(clazz);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        String[] headerList = new String[headers.size()];
        settings.setHeaders(headers.toArray(headerList));
        File outFile = new File(data.getOutput());
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
    }
}
