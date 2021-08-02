package com.testcsv.testcsv.newreader;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class FocoWithDate {

    @Parsed(index = 0)
    private Integer hasFire;
    @Parsed(index = 1)
    private String date;
    @Parsed(index = 2)
    private String elevation;
    @Parsed(index = 3)
    private Double slope;
    @Parsed(index = 4)
    private Double ndvi;
    @Parsed(index = 5)
    private Double road;
    @Parsed(index = 6)
    private Double hydrography;
    @Parsed(index = 7)
    private Double popDens;
    @Parsed(index = 8)
    private Double occupations;
    @Parsed(index = 9)
    private Integer lulc;
    @Parsed(index = 10)
    private Integer year;

    public LocalDateTime getDate(){
        DateTimeFormatter format1 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        DateTimeFormatter format2 = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        DateTimeFormatter format3 = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        DateTimeFormatter format4 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        DateTimeFormatter format5 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        List<DateTimeFormatter> formatters = new ArrayList<>();
        formatters.add(format1);
        formatters.add(format2);
        formatters.add(format3);
        formatters.add(format4);
        formatters.add(format5);
        for (DateTimeFormatter formatter : formatters) {
            if(getDateTimeConverted(date, formatter)){
                return LocalDateTime.parse(date, formatter);
            }
        }
        throw new RuntimeException(date);
    }

    private boolean getDateTimeConverted(String date, DateTimeFormatter formatter){
        try{
            LocalDateTime.parse(date, formatter);
            return true;
        }catch (Exception e){
            return false;
        }
    }

}
