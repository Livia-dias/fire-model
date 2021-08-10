package com.testcsv.testcsv.gerador;

import lombok.*;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
@EqualsAndHashCode
public class MesAno implements Comparable<MesAno> {
    private Integer mes;
    private Integer ano;

    @Override
    public int compareTo(MesAno o) {
        return this.mes - o.mes + (this.ano-o.ano);
    }
}
