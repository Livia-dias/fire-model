package com.testcsv.testcsv.newreader;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class RandomClima {
    private Double temperature;
    private Double rh;
    private Double precipitation;
    private Double ws;
    private Double fuelMoistureCode;
    private Double duffMoistureCode;
    private Double droughtCode;
    private Double fwi;
    private Double initialSpread;
    private Double buildUpIndex;
    private Double dailySeverityRating;
}
