package com.testcsv.testcsv.newreader;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class RandomFoco {

    @Parsed(index = 0)
    private Integer hasFire;
    @Parsed(index = 1)
    private String elevation;
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
    private Double occupations;
    @Parsed(index = 8)
    private Integer lulc;
    @Parsed(index = 9)
    private Integer year;

}
