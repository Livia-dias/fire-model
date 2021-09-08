package com.testcsv.testcsv.estatiscas;

import com.testcsv.testcsv.utils.Utils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

@Component
@Slf4j
public class Stats {

    @SneakyThrows
    @EventListener(ApplicationReadyEvent.class)
    public void readAll() {

        List<String> caminhos = List.of(
                "src/main/resources/FOCOS NOVOS/cavernas_FOCOS_1999_2019_novo.csv",
                "src/main/resources/FOCOS NOVOS/cocha_FOCOS_1999_2019_novo.csv",
                "src/main/resources/FOCOS NOVOS/pand_FOCOS_1999_2019_novo.csv"
        );

        for (String caminho : caminhos) {
            List<StatRow> rows = new LinkedList<>(parse(new File(caminho)));

            System.out.println(caminho);
            System.out.printf("Total: %d%n", rows.size());
            Set<StatRow> diff = new HashSet<>(rows);
            System.out.printf("Entradas únicas: %d%n", diff.size());

            Collection<StatRow> result = CollectionUtils.subtract(rows, diff);
            System.out.printf("Duplicatas: %s%n",result.size());
        }
    }

    private List<StatRow> parse(File file) {
        List<StatRow> rows = Utils.readFoco(file, StatRow.class);
        Optional<StatRow> opt = rows.stream().filter(d -> d == null || d.getDatahora() == null).findFirst();
        opt.ifPresent(row -> log.info(row.toString()));
        Map<Integer, List<StatRow>> map = rows.stream().collect(Collectors.groupingBy(d -> Utils.convert(d.getDatahora()).getMonthValue()));
        List<StatRow> fixed = new ArrayList<>();
        for (List<StatRow> value : map.values()) {
            fixed.addAll(value);
        }
        fixed.sort(Comparator.comparing(StatRow::getFid));

        for (int i = 0; i < fixed.size(); i++) {
            if (!Objects.equals(fixed.get(i).getFid(), rows.get(i).getFid())) {
                log.info(String.format("TA ERRADO MANO %s %s", fixed.get(i).getFid(), rows.get(i).getFid()));
            }
        }
        return rows;
    }
}
