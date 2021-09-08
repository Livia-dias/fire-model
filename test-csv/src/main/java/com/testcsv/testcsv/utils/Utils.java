package com.testcsv.testcsv.utils;

import com.testcsv.testcsv.ndviwithclima.main.DataPaths;
import com.testcsv.testcsv.newOne.PathData;
import com.testcsv.testcsv.newreader.ClimaWithALot;
import com.testcsv.testcsv.newreader.RandomClima;
import com.univocity.parsers.common.processor.BeanListProcessor;
import com.univocity.parsers.common.processor.BeanWriterProcessor;
import com.univocity.parsers.csv.CsvParser;
import com.univocity.parsers.csv.CsvParserSettings;
import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import lombok.experimental.UtilityClass;
import org.apache.commons.lang3.RandomUtils;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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


    public static <T> void write(String path, List<T> parsedRows, Class<T> clazz, List<String> headers){
        BeanWriterProcessor<T> rowProcessor = new BeanWriterProcessor<>(clazz);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        String[] headerList = new String[headers.size()];
        settings.setHeaders(headers.toArray(headerList));
        File outFile = new File(path);
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
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

    public static <T> void write(PathData data, List<T> parsedRows, Class<T> clazz){
        BeanWriterProcessor<T> rowProcessor = new BeanWriterProcessor<>(clazz);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        File outFile = new File(data.getOutput());
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
    }

    public static <T> void write(DataPaths data, List<T> parsedRows, Class<T> clazz){
        BeanWriterProcessor<T> rowProcessor = new BeanWriterProcessor<>(clazz);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        File outFile = new File(data.getOutput());
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
    }

    public static RandomClima generateRandomValues(List<ClimaWithALot> clima, Integer year){
        List<ClimaWithALot> yearRows = clima.stream().filter(c -> c.getYear() == year).collect(Collectors.toList());

        Double minPrec = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getPrecipitation)).get().getPrecipitation();
        Double maxPrec = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getPrecipitation)).get().getPrecipitation();

        Double minTemp = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getTemperature)).get().getTemperature();
        Double maxTemp = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getTemperature)).get().getTemperature();

        Double minWs = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getWs)).get().getWs();
        Double maxWs = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getWs)).get().getWs();

        Double minRh = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getRh)).get().getRh();
        Double maxRh = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getRh)).get().getRh();

        Double minFmc = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getFuelMoistureCode)).get().getFuelMoistureCode();
        Double maxFmc = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getFuelMoistureCode)).get().getFuelMoistureCode();

        Double minDmc = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getDuffMoistureCode)).get().getDuffMoistureCode();
        Double maxDmc = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getDuffMoistureCode)).get().getDuffMoistureCode();

        Double minDc = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getDroughtCode)).get().getDroughtCode();
        Double maxDc = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getDroughtCode)).get().getDroughtCode();

        Double minFwi = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getFwi)).get().getFwi();
        Double maxFwi = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getFwi)).get().getFwi();

        Double minInitialSpread = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getInitialSpread)).get().getInitialSpread();
        Double maxInitialSpread = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getInitialSpread)).get().getInitialSpread();

        Double minBuildUp = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getBuildUpIndex)).get().getBuildUpIndex();
        Double maxBuildUp = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getBuildUpIndex)).get().getBuildUpIndex();

        Double minDsr = yearRows.stream().min(Comparator.comparingDouble(ClimaWithALot::getDailySeverityRating)).get().getDailySeverityRating();
        Double maxDsr = yearRows.stream().max(Comparator.comparingDouble(ClimaWithALot::getDailySeverityRating)).get().getDailySeverityRating();

        return RandomClima.builder()
                .rh(RandomUtils.nextDouble(minRh, maxRh))
                .ws(RandomUtils.nextDouble(minWs, maxWs))
                .temperature(RandomUtils.nextDouble(minTemp, maxTemp))
                .precipitation(RandomUtils.nextDouble(minPrec, maxPrec))
                .fuelMoistureCode(RandomUtils.nextDouble(minFmc, maxFmc))
                .duffMoistureCode(RandomUtils.nextDouble(minDmc, maxDmc))
                .droughtCode(RandomUtils.nextDouble(minDc, maxDc))
                .fwi(RandomUtils.nextDouble(minFwi, maxFwi))
                .initialSpread(RandomUtils.nextDouble(minInitialSpread, maxInitialSpread))
                .buildUpIndex(RandomUtils.nextDouble(minBuildUp, maxBuildUp))
                .dailySeverityRating(RandomUtils.nextDouble(minDsr, maxDsr))
                .build();
    }

    public static LocalDateTime convert(String dateTime){
        String pattern = "yyyy/MM/dd HH:mm:ss";
        return LocalDateTime.parse(dateTime, DateTimeFormatter.ofPattern(pattern));
    }
}
