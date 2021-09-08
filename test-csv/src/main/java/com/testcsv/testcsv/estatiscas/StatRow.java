package com.testcsv.testcsv.estatiscas;

import com.univocity.parsers.annotations.Parsed;
import lombok.*;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
@EqualsAndHashCode
public class StatRow {

    @Parsed(index = 0)
    @EqualsAndHashCode.Exclude
    private Integer fid;
    @Parsed(index = 1)
    @EqualsAndHashCode.Include
    private String datahora;
    @Parsed(index = 2)
    @EqualsAndHashCode.Exclude
    private String satelite;
    @Parsed(index = 3)
    @EqualsAndHashCode.Exclude
    private String pais;
    @Parsed(index = 4)
    @EqualsAndHashCode.Exclude
    private String estado;
    @Parsed(index = 5)
    @EqualsAndHashCode.Exclude
    private String municipio;
    @Parsed(index = 6)
    @EqualsAndHashCode.Exclude
    private String bioma;
    @Parsed(index = 7)
    @EqualsAndHashCode.Exclude
    private String diasemchuva;
    @Parsed(index = 8)
    @EqualsAndHashCode.Exclude
    private String precipitacao;
    @Parsed(index = 9)
    @EqualsAndHashCode.Exclude
    private String riscofogo;
    @Parsed(index = 10)
    @EqualsAndHashCode.Include
    private Double latitude;
    @Parsed(index = 11)
    @EqualsAndHashCode.Include
    private Double longitude;
    @Parsed(index = 12)
    @EqualsAndHashCode.Exclude
    private String frp;
    @Parsed(index = 13)
    @EqualsAndHashCode.Exclude
    private String areaprotegida;
}
