package com.testcsv.testcsv.ndvi.main;

import com.testcsv.testcsv.ndvi.InputRow;
import com.testcsv.testcsv.ndvi.OutputRow;
import com.testcsv.testcsv.ndvi.OutputWithDataRow;
import com.testcsv.testcsv.newOne.PathData;
import com.testcsv.testcsv.utils.AllMapper;
import com.testcsv.testcsv.utils.Utils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class NdviFixer {

    private static final String outFile = "ndvi_arrumado.csv";
    private final AllMapper allMapper;

    public NdviFixer(AllMapper allMapper) {
        this.allMapper = allMapper;
    }

    @SneakyThrows
    //@EventListener(ApplicationReadyEvent.class)
    public void readAll() {

        List<PathData> caminhos = List.of(
                new PathData("src/main/resources/NDVI/Pandeiros/entrada", "src/main/resources/NDVI/Pandeiros/saída", "src/main/resources/NDVI/Pandeiros/pandeiros " + outFile),
                new PathData("src/main/resources/NDVI/Cocha/entrada", "src/main/resources/NDVI/Cocha/saída", "src/main/resources/NDVI/Cocha/cocha " + outFile),
                new PathData("src/main/resources/NDVI/Cavernas/entrada", "src/main/resources/NDVI/Cavernas/saída", "src/main/resources/NDVI/Cavernas/cavernas " + outFile)
        );

        for (PathData caminho : caminhos) {
            List<Path> arquivos = Files.walk(Paths.get(caminho.getDataFidPath()))
                    .filter(Files::isRegularFile)
                    .collect(Collectors.toList());
            List<InputRow> rows = new LinkedList<>();
            for (Path arquivo : arquivos) {
                rows.addAll(fillNdvi(arquivo.toFile()));
            }

            System.out.println(caminho.getDataFidPath());
            System.out.printf("Total: %d%n", rows.size());
            Set<InputRow> diff = new HashSet<>(rows);
            System.out.printf("Entradas únicas: %d%n", diff.size());

            Collection<InputRow> result = CollectionUtils.subtract(rows, diff);
            System.out.printf("Duplicatas: %s%n",result.size());


            Comparator<InputRow> comparator = Comparator.comparing(i -> i.getDatahora().getYear());
            comparator.thenComparing(InputRow::getFid);
            rows.sort(comparator);
            File outputFile = Files.walk(Paths.get(caminho.getInfoPath()))
                    .filter(Files::isRegularFile)
                    .collect(Collectors.toList()).get(0).toFile();
            List<OutputWithDataRow> output = createNewOutput(outputFile, rows);
            List<String> headers = Arrays.asList(
                    "hasFire",
                    "elevation",
                    "slope",
                    "ndvi",
                    "road",
                    "hydrography",
                    "popDens",
                    "ocupations",
                    "lulc",
                    "year",
                    "data");
            Utils.write(caminho, output, OutputWithDataRow.class, headers);
        }
    }

    private List<OutputWithDataRow> createNewOutput(File outFile, List<InputRow> inputRows) {
        List<OutputRow> rowsToChange = Utils.readFoco(outFile, OutputRow.class);
        List<OutputRow> toChange = rowsToChange.stream().filter(r -> r.getHasFire() == 1).collect(Collectors.toList());

        List<OutputWithDataRow> out = new LinkedList<>();
        Map<Integer, List<InputRow>> lido = inputRows.stream().collect(Collectors.groupingBy(i -> i.getDatahora().getYear()));
        Map<Integer, List<OutputRow>> praMudar = toChange.stream().collect(Collectors.groupingBy(OutputRow::getYear));
        for (Integer key : lido.keySet()) {
            List<InputRow> input = lido.get(key);
            List<OutputRow> output = praMudar.get(key);
            if (input.size() != output.size()) {
                throw new RuntimeException("Bagulho tá errado!");
            }
            for (int i = 0; i < input.size(); i++) {
                Double ndvi = input.get(i).getNdvi();
                output.get(i).setNdvi(ndvi);
                LocalDateTime data = input.get(i).getDatahora();
                out.add(allMapper.toOutWithData(output.get(i), data.toString()));
            }
        }
        return out;
    }

    private List<InputRow> fillNdvi(File file) {
        List<InputRow> rows = Utils.readFoco(file, InputRow.class);
        Optional<InputRow> opt = rows.stream().filter(d -> d == null || d.getDatahora() == null).findFirst();
        if (opt.isPresent()) {
            log.info(opt.get().toString());
        }
        Map<Integer, List<InputRow>> map = rows.stream().collect(Collectors.groupingBy(d -> d.getDatahora().getMonthValue()));
        for (Map.Entry<Integer, List<InputRow>> entry : map.entrySet()) {
            switch (entry.getKey()) {
                case 1:
                    entry.getValue().forEach(e -> e.setNdvi(e.getJanNdvi() / 10000));
                    break;
                case 2:
                    entry.getValue().forEach(e -> e.setNdvi(e.getFevNdvi() / 10000));
                    break;
                case 3:
                    entry.getValue().forEach(e -> e.setNdvi(e.getMarNdvi() / 10000));
                    break;
                case 4:
                    entry.getValue().forEach(e -> e.setNdvi(e.getAbrNdvi() / 10000));
                    break;
                case 5:
                    entry.getValue().forEach(e -> e.setNdvi(e.getMaiNdvi() / 10000));
                    break;
                case 6:
                    entry.getValue().forEach(e -> e.setNdvi(e.getJunNdvi() / 10000));
                    break;
                case 7:
                    entry.getValue().forEach(e -> e.setNdvi(e.getJulNdvi() / 10000));
                    break;
                case 8:
                    entry.getValue().forEach(e -> e.setNdvi(e.getAgoNdvi() / 10000));
                    break;
                case 9:
                    entry.getValue().forEach(e -> e.setNdvi(e.getSetNdvi() / 10000));
                    break;
                case 10:
                    entry.getValue().forEach(e -> e.setNdvi(e.getOutNdvi() / 10000));
                    break;
                case 11:
                    entry.getValue().forEach(e -> e.setNdvi(e.getNovNdvi() / 10000));
                    break;
                case 12:
                    entry.getValue().forEach(e -> e.setNdvi(e.getDezNdvi() / 10000));
                    break;
                default:
                    log.error("Zoou o role");
                    log.error(String.valueOf(entry.getKey()));
                    break;
            }
        }
        List<InputRow> fixed = new ArrayList<>();
        for (List<InputRow> value : map.values()) {
            fixed.addAll(value);
        }
        fixed.sort(Comparator.comparing(InputRow::getFid));

        for (int i = 0; i < fixed.size(); i++) {
            if (!Objects.equals(fixed.get(i).getFid(), rows.get(i).getFid())) {
                log.info(String.format("TA ERRADO MANO %s %s", fixed.get(i).getFid(), rows.get(i).getFid()));
            }
        }
        return rows;
    }
}
