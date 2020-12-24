package com.testcsv.testcsv;

import com.univocity.parsers.conversions.Conversion;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LocalDateTimeConverter implements Conversion<String, LocalDateTime> {

    private DateTimeFormatter formatter;

    public LocalDateTimeConverter() {
        String pattern = "yyyy/MM/dd HH:mm:ss";
        this.formatter = DateTimeFormatter.ofPattern(pattern);
    }


    @Override
    public LocalDateTime execute(String localDateTime) {
        return LocalDateTime.parse(localDateTime, formatter);
    }

    @Override
    public String revert(LocalDateTime o) {
        return formatter.format(o);
    }
}
