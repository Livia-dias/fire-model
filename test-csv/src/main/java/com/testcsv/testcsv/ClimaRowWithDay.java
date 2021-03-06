package com.testcsv.testcsv;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ClimaRowWithDay {

    @Parsed(index = 0)
    private Double temperature;
    @Parsed(index = 1)
    private Double rh;
    @Parsed(index = 2)
    private Double precipitation;
    @Parsed(index = 3)
    private Double ws;
    @Parsed(index = 4)
    private int day;
    @Parsed(index = 5)
    private int month;
    @Parsed(index = 6)
    private int year;
    @Parsed(index = 7)
    private int focusesQnt;
    @Parsed(index = 8)
    private boolean hasFire;


    public ClimaRowWithDay(ClimaRow climaRow){
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
