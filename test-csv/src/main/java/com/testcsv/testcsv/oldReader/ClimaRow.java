package com.testcsv.testcsv.oldReader;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ClimaRow {

    @Parsed(index = 0)
    private Double temperature;
    @Parsed(index = 1)
    private Double rh;
    @Parsed(index = 2)
    private Double precipitation;
    @Parsed(index = 3)
    private Double ws;
    @Parsed(index = 4)
    private int month;
    @Parsed(index = 5)
    private int year;
    @Parsed(index = 6)
    private int focusesQnt = 0;
    @Parsed(index = 7)
    private boolean hasFire = false;

    private int day;

    public void incrementFocuses(int focusesQnt){
        this.focusesQnt+=focusesQnt;
    }

}
