package com.testcsv.testcsv.newOne;

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
public class FidWithDateTime {

    @Parsed(index = 0)
    private Integer fid;

    @Parsed(index = 1)
    private String datahora;

    public LocalDateTime getDatahora(){
        DateTimeFormatter format1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter format2 = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        DateTimeFormatter format3 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        List<DateTimeFormatter> formatters = new ArrayList<>();
        formatters.add(format1);
        formatters.add(format2);
        formatters.add(format3);
        for (DateTimeFormatter formatter : formatters) {
            if(getDateTimeConverted(datahora, formatter)){
                return LocalDateTime.parse(datahora, formatter);
            }
        }
        throw new RuntimeException(datahora);
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
