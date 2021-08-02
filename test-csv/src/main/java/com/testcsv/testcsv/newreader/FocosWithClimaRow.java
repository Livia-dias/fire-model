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
public class FocosWithClimaRow {

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
    private Double temperature;
    @Parsed(index = 10)
    private Double rh;
    @Parsed(index = 11)
    private Double precipitation;
    @Parsed(index = 12)
    private Double ws;
    @Parsed(index = 13)
    private Double fuelMoistureCode;
    @Parsed(index = 14)
    private Double duffMoistureCode;
    @Parsed(index = 15)
    private Double droughtCode;
    @Parsed(index = 16)
    private Double fwi;
    @Parsed(index = 17)
    private Double initialSpread;
    @Parsed(index = 18)
    private Double buildUpIndex;
    @Parsed(index = 19)
    private Double dailySeverityRating;
    @Parsed(index = 20)
    private Integer year;
}
