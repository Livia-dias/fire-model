package com.testcsv.testcsv.ndvi;

import com.univocity.parsers.annotations.Parsed;
import lombok.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class OutputWithDataRow extends OutputRow{
    @Parsed(index = 10)
    private String data;

    public LocalDateTime getData(){
        try{
            return LocalDateTime.parse(data);
        } catch (Exception e){
            DateTimeFormatter format2 = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            DateTimeFormatter format1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            DateTimeFormatter format3 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
            List<DateTimeFormatter> formatters = new ArrayList<>();
            formatters.add(format1);
            formatters.add(format2);
            formatters.add(format3);

            for (DateTimeFormatter formatter : formatters) {
                if(getDateTimeConverted(data, formatter)){
                    return LocalDateTime.parse(data, formatter);
                }
            }
            throw new RuntimeException(data);
        }

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
