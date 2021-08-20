package com.testcsv.testcsv.gerador;

import com.univocity.parsers.annotations.Parsed;
import lombok.*;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
@EqualsAndHashCode
public class DadosGerados {

    @Parsed(index = 0)
    private Integer mes;
    @Parsed(index = 1)
    private Integer ano;
    @Parsed(index = 2)
    private Integer diasSemChuva;
    @Parsed(index = 3)
    private Integer focos;
    @Parsed(index = 4)
    private Double umidadeMedia;
    @Parsed(index = 5)
    private Double temperaturaMedia;
    @Parsed(index = 6)
    private Double temperaturaMaxima;
    @Parsed(index = 7)
    private Double mediaTempComFogo;
    @Parsed(index = 8)
    private Double mediaPrecComFogo;
    @Parsed(index = 9)
    private Double mediaUmidadeComFogo;
    @Parsed(index = 10)
    private Double umidadeMinima;
    @Parsed(index = 11)
    private Double precipitacaoMedia;
    @Parsed(index = 12)
    private Integer quantidadeDeFocos;
    @Parsed(index = 13)
    private Double totalPluviosidade;
}
