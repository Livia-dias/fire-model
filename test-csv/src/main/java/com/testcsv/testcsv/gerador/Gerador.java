package com.testcsv.testcsv.gerador;

import com.testcsv.testcsv.oldReader.ClimaRowWithDay;
import com.testcsv.testcsv.utils.Utils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.*;
import java.util.function.ToDoubleFunction;
import java.util.stream.Collectors;

@Component
@Slf4j
public class Gerador {


    @SneakyThrows
    //@EventListener(ApplicationReadyEvent.class)
    public void readAll() {
        List<FileData> arquivos = Arrays.asList(
                FileData.builder().input("src/main/resources/cavernas2.csv").mesOutput("src/main/resources/cavernas_gerado_por_mes2.csv").anoOutput("src/main/resources/cavernas_gerado_por_ano2.csv").build(),
                FileData.builder().input("src/main/resources/cocha2.csv").mesOutput("src/main/resources/cocha_gerado_por_mes2.csv").anoOutput("src/main/resources/cocha_gerado_por_ano2.csv").build(),
                FileData.builder().input("src/main/resources/pandeiros2.csv").mesOutput("src/main/resources/pandeiros_gerado_por_mes2.csv").anoOutput("src/main/resources/pandeiros_gerado_por_ano2.csv").build());

        for (FileData arquivo : arquivos) {
            List<ClimaRowWithDay> focos = Utils.readFoco(new File(arquivo.getInput()), ClimaRowWithDay.class);

            Map<MesAno, List<ClimaRowWithDay>> mapaMes = new HashMap<>();
            for (ClimaRowWithDay foco : focos) {
                MesAno mesAno = MesAno.builder().ano(foco.getYear()).mes(foco.getMonth()).build();
                if (!mapaMes.containsKey(mesAno)) {
                    mapaMes.put(mesAno, new ArrayList<>());
                }
                mapaMes.get(mesAno).add(foco);
            }

            List<DadosGerados> mapazao = new ArrayList<>();
            for (Map.Entry<MesAno, List<ClimaRowWithDay>> entry : mapaMes.entrySet()) {
                Integer dias = (int) entry.getValue().stream().filter(i -> i.getPrecipitation() == 0).count();
                Double tempMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getTemperature).average().orElse(0);
                Double tempMaxima = entry.getValue().stream().max(Comparator.comparingDouble(ClimaRowWithDay::getTemperature)).get().getTemperature();
                List<ClimaRowWithDay> focosComFogo = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).collect(Collectors.toList());
                int pegouFogo = focosComFogo.stream().mapToInt(ClimaRowWithDay::getFocusesQnt).sum();
                Double totalPluviosidade = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getPrecipitation).sum();
                Double umidadeMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getRh).average().orElse(0);
                Double umidadeMinima = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getRh).min().orElse(0);
                int quantidadeDeFocos = (int) entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).count();

                Double mediaTempFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getTemperature).average().orElse(0);
                Double mediaPrecFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getPrecipitation).average().orElse(0);
                Double mediaRhFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getRh).average().orElse(0);
                Double precipitacaoMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getPrecipitation).average().orElse(0);

                mapazao.add(DadosGerados.builder()
                        .mes(entry.getKey().getMes()).ano(entry.getKey().getAno())
                        .diasSemChuva(dias).temperaturaMedia(tempMedia).temperaturaMaxima(tempMaxima)
                        .focos(pegouFogo).umidadeMedia(umidadeMedia).mediaTempComFogo(mediaTempFogos)
                        .mediaPrecComFogo(mediaPrecFogos).mediaUmidadeComFogo(mediaRhFogos).umidadeMinima(umidadeMinima)
                        .precipitacaoMedia(precipitacaoMedia).quantidadeDeFocos(quantidadeDeFocos)
                                .totalPluviosidade(totalPluviosidade)
                        .build());
            }
            mapazao.sort(Comparator.comparing(DadosGerados::getAno).thenComparing(DadosGerados::getMes));

            Utils.write(arquivo.getMesOutput(), mapazao, DadosGerados.class,
                    Arrays.asList("mes", "ano", "diasSemChuva", "quantidadeFocos", "umidadeMedia",
                            "tempMedia", "tempMax", "mediaTempComFocos", "mediaPrecComFocos", "mediaUmidadeComFocos", "umidadeMinima",
                            "precipitacaoMedia", "diasComFogo", "totalPluviosidade"));

            Map<Integer, List<ClimaRowWithDay>> ano = focos.stream().collect(Collectors.groupingBy(ClimaRowWithDay::getYear));
            List<DadosGerados> mapaAno = new ArrayList<>();
            for (Map.Entry<Integer, List<ClimaRowWithDay>> entry : ano.entrySet()) {
                Integer dias = (int) entry.getValue().stream().filter(i -> i.getPrecipitation() == 0).count();
                Double tempMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getTemperature).average().orElse(0);
                Double tempMaxima = entry.getValue().stream().max(Comparator.comparingDouble(ClimaRowWithDay::getTemperature)).get().getTemperature();
                List<ClimaRowWithDay> focosComFogo = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).collect(Collectors.toList());
                int pegouFogo = focosComFogo.stream().mapToInt(ClimaRowWithDay::getFocusesQnt).sum();
                Double umidadeMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getRh).average().orElse(0);
                Double umidadeMinima = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getRh).min().orElse(0);
                int quantidadeDeFocos = (int) entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).count();

                Double mediaTempFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getTemperature).average().orElse(0);
                Double mediaPrecFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getPrecipitation).average().orElse(0);
                Double mediaRhFogos = entry.getValue().stream().filter(ClimaRowWithDay::isHasFire).mapToDouble(ClimaRowWithDay::getRh).average().orElse(0);
                Double precipitacaoMedia = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getPrecipitation).average().orElse(0);
                Double totalPluviosidade = entry.getValue().stream().mapToDouble(ClimaRowWithDay::getPrecipitation).sum();

                mapaAno.add(DadosGerados.builder().ano(entry.getKey())
                        .diasSemChuva(dias).temperaturaMedia(tempMedia).temperaturaMaxima(tempMaxima)
                        .focos(pegouFogo).umidadeMedia(umidadeMedia).mediaTempComFogo(mediaTempFogos)
                        .mediaPrecComFogo(mediaPrecFogos).mediaUmidadeComFogo(mediaRhFogos).umidadeMinima(umidadeMinima)
                        .precipitacaoMedia(precipitacaoMedia).quantidadeDeFocos(quantidadeDeFocos)
                                .totalPluviosidade(totalPluviosidade)
                        .build());

            }
            mapaAno.sort(Comparator.comparing(DadosGerados::getAno));

            Utils.write(arquivo.getAnoOutput(), mapaAno, DadosGerados.class,
                    Arrays.asList("mes", "ano", "diasSemChuva", "quantidadeFocos", "umidadeMedia",
                            "tempMedia", "tempMax", "mediaTempComFocos", "mediaPrecComFocos", "mediaUmidadeComFocos",
                            "umidadeMinima", "precipitacaoMedia", "diasComFogo", "totalPluviosidade"));

        }
    }

    private double calculate(ToDoubleFunction<ClimaRowWithDay> getter, Map.Entry<Integer, List<ClimaRowWithDay>> entry) {
        double sum = entry.getValue().stream().mapToDouble(getter).sum();
        double resultado = sum / entry.getValue().size();

        return resultado;
    }

    private double calculateMes(ToDoubleFunction<ClimaRowWithDay> getter, Map.Entry<MesAno, List<ClimaRowWithDay>> entry) {
        double sum = entry.getValue().stream().mapToDouble(getter).sum();
        double resultado = sum / entry.getValue().size();

        return resultado;
    }
}
