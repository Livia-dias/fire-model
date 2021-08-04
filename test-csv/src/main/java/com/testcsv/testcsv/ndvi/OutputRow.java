package com.testcsv.testcsv.ndvi;

import com.univocity.parsers.annotations.Parsed;
import lombok.*;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class OutputRow {

    @Parsed(index = 0)
    private Integer hasFire;
    @Parsed(index = 1)
    private Double elevation;
    @Parsed(index = 2)
    private Double slope;
    @Parsed(index = 3)
    private Double ndvi;
    @Parsed(index = 4)
    private Double road;
    @Parsed(index = 5)
    private Double hydrography;
    @Parsed(index = 6)
    private Double popDens;
    @Parsed(index = 7)
    private Double ocupations;
    @Parsed(index = 8)
    private Integer lulc;
    @Parsed(index = 9)
    private Integer year;
}
