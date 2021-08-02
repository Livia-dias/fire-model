package com.testcsv.testcsv.newreader;

import com.testcsv.testcsv.oldReader.ClimaRow;
import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ClimaWithALot {

    @Parsed(index = 0)
    private Double temperature;
    @Parsed(index = 1)
    private Double rh;
    @Parsed(index = 2)
    private Double precipitation;
    @Parsed(index = 3)
    private Double ws;
    @Parsed(index = 4)
    private Double fuelMoistureCode;
    @Parsed(index = 5)
    private Double duffMoistureCode;
    @Parsed(index = 6)
    private Double droughtCode;
    @Parsed(index = 7)
    private Double fwi;
    @Parsed(index = 8)
    private Double initialSpread;
    @Parsed(index = 9)
    private Double buildUpIndex;
    @Parsed(index = 10)
    private Double dailySeverityRating;
    @Parsed(index = 11)
    private int day;
    @Parsed(index = 12)
    private int month;
    @Parsed(index = 13)
    private int year;
    @Parsed(index = 14)
    private int focusesQnt;
    @Parsed(index = 15)
    private boolean hasFire;


    public ClimaWithALot(ClimaRow climaRow){
        this.temperature = climaRow.getTemperature();
        this.rh = climaRow.getRh();
        this.precipitation = climaRow.getPrecipitation();
        this.ws = climaRow.getWs();
        this.month = climaRow.getMonth();
        this.year = climaRow.getYear();
        this.focusesQnt = climaRow.getFocusesQnt();
        this.hasFire = climaRow.isHasFire();
        this.day = climaRow.getDay();
    }

}
