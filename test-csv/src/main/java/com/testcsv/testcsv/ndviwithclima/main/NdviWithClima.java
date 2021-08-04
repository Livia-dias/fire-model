package com.testcsv.testcsv.ndviwithclima.main;

import com.testcsv.testcsv.ndvi.OutputRow;
import com.testcsv.testcsv.ndvi.OutputWithDataRow;
import com.testcsv.testcsv.newreader.ClimaWithALot;
import com.testcsv.testcsv.newreader.FocosWithDayRow;
import com.testcsv.testcsv.newreader.RandomClima;
import com.testcsv.testcsv.utils.AllMapper;
import com.testcsv.testcsv.utils.Utils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
@Slf4j
public class NdviWithClima {

    private static final String inFile = "ndvi_arrumado.csv";
    private static final String outFile = "nem_sei_mais_o_nome.csv";
    private final AllMapper allMapper;

    public NdviWithClima(AllMapper allMapper) {
        this.allMapper = allMapper;
    }

    @SneakyThrows
    @EventListener(ApplicationReadyEvent.class)
    public void readAll() {

        List<DataPaths> caminhos = List.of(
                new DataPaths("src/main/resources/NDVI/Pandeiros/pandeiros " + inFile, "src/main/resources/Dados climaticos/clima_fwi_cavernas.csv", "src/main/resources/NDVI/Pandeiros/saída", "src/main/resources/NDVI/Pandeiros/pandeiros " + outFile),
                new DataPaths("src/main/resources/NDVI/Cocha/cocha " + inFile, "src/main/resources/Dados climaticos/clima_fwi_cochagibao.csv", "src/main/resources/NDVI/Cocha/saída", "src/main/resources/NDVI/Cocha/cocha " + outFile),
                new DataPaths("src/main/resources/NDVI/Cavernas/cavernas " + inFile, "src/main/resources/Dados climaticos/clima_fwi_pandeiros.csv", "src/main/resources/NDVI/Cavernas/saída", "src/main/resources/NDVI/Cavernas/cavernas " + outFile)
        );
        for (DataPaths caminho : caminhos) {
            File ndviFile = Files.walk(Paths.get(caminho.getDataFidPath()))
                    .filter(Files::isRegularFile)
                    .collect(Collectors.toList()).get(0).toFile();
            File climaFile = Files.walk(Paths.get(caminho.getInfoPath()))
                    .filter(Files::isRegularFile)
                    .collect(Collectors.toList()).get(0).toFile();
            File zeroesFile = Files.walk(Paths.get(caminho.getNdviPath()))
                    .filter(Files::isRegularFile)
                    .collect(Collectors.toList()).get(0).toFile();

            List<OutputWithDataRow> rows = Utils.readFoco(ndviFile, OutputWithDataRow.class);
            List<ClimaWithALot> dadosClimaticos = Utils.readFoco(climaFile, ClimaWithALot.class);
            List<OutputRow> rowsToChange = Utils.readFoco(zeroesFile, OutputRow.class);

            List<FocosWithDayRow> ones = joinOne(rows, dadosClimaticos);
            List<FocosWithDayRow> zeroes = joinZeroes(rowsToChange, dadosClimaticos);

            List<FocosWithDayRow> outputRows = Stream.concat(ones.stream(), zeroes.stream())
                    .sorted(Comparator.comparing(FocosWithDayRow::getYear).thenComparing(i -> i.getHasFire()*-1)).collect(Collectors.toList());
            Utils.write(caminho, outputRows, FocosWithDayRow.class);
        }
    }

    private List<FocosWithDayRow> joinZeroes(List<OutputRow> rows, List<ClimaWithALot> dadosClimaticos) {
        List<FocosWithDayRow> zeroes = new LinkedList<>();
        Iterator<OutputRow> it1 = rows.stream().filter(i -> i.getHasFire() == 0).iterator();
        while (it1.hasNext()) {
            OutputRow row = it1.next();
            RandomClima clima = Utils.generateRandomValues(dadosClimaticos, row.getYear());
            FocosWithDayRow day = allMapper.toFocoWithDay(clima, row);
            zeroes.add(day);
        }
        return zeroes;
    }

    private List<FocosWithDayRow> joinOne(List<OutputWithDataRow> rows, List<ClimaWithALot> dadosClimaticos) {
        List<FocosWithDayRow> ones = new LinkedList<>();
        Iterator<OutputWithDataRow> it1 = rows.stream().filter(i -> i.getHasFire() == 1).iterator();
        while (it1.hasNext()) {
            OutputWithDataRow row = it1.next();
            ClimaWithALot clima = findClima(row.getData(), dadosClimaticos);
            FocosWithDayRow day = allMapper.toFocoWithDay(clima, row);
            ones.add(day);
        }
        return ones;
    }

    private ClimaWithALot findClima(LocalDateTime data, List<ClimaWithALot> dados) {
        Optional<ClimaWithALot> opt = dados.stream().filter(d -> d.getMonth() == data.getMonthValue() && d.getYear() == data.getYear() && d.getDay() == data.getDayOfMonth())
                .findFirst();
        if (opt.isPresent()) return opt.get();
        else throw new RuntimeException(String.format("N achei mano %s", data.toString()));
    }
}
