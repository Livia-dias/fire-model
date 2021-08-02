package com.testcsv.testcsv.utils;

import com.univocity.parsers.common.processor.BeanListProcessor;
import com.univocity.parsers.csv.CsvParser;
import com.univocity.parsers.csv.CsvParserSettings;
import lombok.experimental.UtilityClass;

import java.io.File;
import java.util.List;

@UtilityClass
public class Utils {

    public static <T> List<T> readFoco(File file, Class<T> clazz) {
        BeanListProcessor<T> rowProcessor = new BeanListProcessor<>(clazz);
        CsvParserSettings settings = new CsvParserSettings();
        settings.setDelimiterDetectionEnabled(true, ',');
        settings.setProcessor(rowProcessor);
        settings.setHeaderExtractionEnabled(true);
        CsvParser parser = new CsvParser(settings);
        parser.parse(file);
        return rowProcessor.getBeans();
    }
}
