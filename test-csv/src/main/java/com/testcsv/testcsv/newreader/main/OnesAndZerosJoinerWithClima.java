package com.testcsv.testcsv.newreader.main;

import com.testcsv.testcsv.newreader.*;
import com.testcsv.testcsv.oldReader.FileData;
import com.testcsv.testcsv.utils.AllMapper;
import com.univocity.parsers.common.processor.BeanWriterProcessor;
import com.univocity.parsers.csv.CsvWriter;
import com.univocity.parsers.csv.CsvWriterSettings;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomUtils;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.testcsv.testcsv.utils.Utils.readFoco;

@Component
@Slf4j
public class OnesAndZerosJoinerWithClima {

    private static final List<FileData> data = List.of(
            new FileData("Dados climaticos/clima_fwi_cavernas.csv", "APA Cavernas", "tudão_cavernas.csv"),
            new FileData("Dados climaticos/clima_fwi_cochagibao.csv", "APA Cocha", "tudão_cocha.csv"),
            new FileData("Dados climaticos/clima_fwi_pandeiros.csv", "APA Pandeiros", "tudão_pandeiros.csv")
    );

    private final AllMapper mapper;

    public OnesAndZerosJoinerWithClima(AllMapper mapper) {
        this.mapper = mapper;
    }

    //@EventListener(ApplicationReadyEvent.class)
    public void readAll() throws IOException {
        for (FileData datum : data) {
            List<ClimaWithALot> dadosClimaticos = getDadosClimáticos(datum.getClimaFile());
            List<FocosWithClimaRow> zeroes = createZeroes(dadosClimaticos, datum.getFocoFile());
            List<FocosWithClimaRow> ones = createOnes(dadosClimaticos, datum.getFocoFile());

            if(zeroes.size() != ones.size()){
                log.error(String.format("Zeros: %s", zeroes.size()));
                log.error(String.format("Ones: %s", ones.size()));
                throw new RuntimeException("Os bagulho tão com tamanho diferente");
            }

            zeroes.addAll(ones);

            Collections.sort(zeroes, Comparator.comparing(FocosWithClimaRow::getYear));
            writeData(zeroes, datum.getOutFile());
        }

    }

    private void writeData(List<FocosWithClimaRow> parsedRows, String file){
        BeanWriterProcessor<FocosWithClimaRow> rowProcessor = new BeanWriterProcessor<>(FocosWithClimaRow.class);
        CsvWriterSettings settings = new CsvWriterSettings();
        settings.setRowWriterProcessor(rowProcessor);
        File outFile = new File(file);
        CsvWriter csvWriter = new CsvWriter(outFile, settings);
        csvWriter.writeHeaders();
        csvWriter.processRecordsAndClose(parsedRows);
    }

    @SneakyThrows
    public List<FocosWithClimaRow> createOnes(List<ClimaWithALot> clima, String filePath){
        List<Path> paths1 = Files.walk(Paths.get(filePath))
                .filter(f -> f.toString().endsWith("1.csv"))
                .filter(Files::isRegularFile)
                .collect(Collectors.toList());
        List<FocosWithClimaRow> outputFile = new ArrayList<>();
        for (Path path : paths1) {
            File file = path.toFile();
            try {
                List<FocoWithDate> rows = readFoco(file, FocoWithDate.class); //arquivo _1
                for (FocoWithDate row : rows) {
                    ClimaWithALot climaData = findClimateData(clima, row.getDate());
                    outputFile.add(mapper.toFocoWithDay(climaData, row));
                }
            } catch (Exception e){
                log.error(file.getName(), e);
            }
        }
        return outputFile;
    }

    private ClimaWithALot findClimateData(List<ClimaWithALot> climateData, LocalDateTime dateTime) {
        Optional<ClimaWithALot> opt = climateData.stream()
                .filter(c -> c.getDay() == dateTime.getDayOfMonth())
                .filter(c -> c.getYear() == dateTime.getYear())
                .filter(c -> c.getMonth() == dateTime.getMonthValue())
                .findFirst();
        if(opt.isPresent()) return opt.get();
        else {
            log.info(String.format("Data %s sem valor encontrado", dateTime.toString()));
            throw new RuntimeException();
        }
    }

    @SneakyThrows
    public List<FocosWithClimaRow> createZeroes(List<ClimaWithALot> clima, String filePath){
        List<Path> paths0 = Files.walk(Paths.get(filePath))
                .filter(f -> f.toString().endsWith("0.csv"))
                .filter(Files::isRegularFile)
                .collect(Collectors.toList());

        List<FocosWithClimaRow> zeroesOutput = new ArrayList<>();
        for (Path path : paths0) {
            File file = path.toFile();
            List<RandomFoco> rows = readFoco(file, RandomFoco.class); //arquivo _0
            for (RandomFoco row : rows) {
                RandomClima randomClima = generateRandomValues(clima, Integer.valueOf(file.getName().substring(0, 4))); //valores aleatorios para o _0
                zeroesOutput.add(mapper.toFocoWithClima(row, randomClima));
            }
        }
        return zeroesOutput;
    }

    private List<ClimaWithALot> getDadosClimáticos(String path) {
        File data = new File(path);
        return readFoco(data, ClimaWithALot.class);
    }

    public RandomClima generateRandomValues(List<ClimaWithALot> clima, Integer year){
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
}