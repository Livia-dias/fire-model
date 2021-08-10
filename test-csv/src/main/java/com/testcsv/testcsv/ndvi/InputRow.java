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
@Builder
@EqualsAndHashCode
public class InputRow {
    @EqualsAndHashCode.Exclude
    @Parsed(field = "FID")
    private Integer fid;
    @EqualsAndHashCode.Include
    @Parsed(field="datahora")
    private String datahora;
    @EqualsAndHashCode.Exclude
    @Parsed(field="JAN_NDVI_2")
    private Double janNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="FEV_NDVI_2")
    private Double fevNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="MAR_NDVI_2")
    private Double marNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="ABR_NDVI_2")
    private Double abrNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="MAI_NDVI_2")
    private Double maiNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="JUN_NDVI_2")
    private Double junNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="JUL_NDVI_2")
    private Double julNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="AGO_NDVI_2")
    private Double agoNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="SET_NDVI_2")
    private Double setNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="OUT_NDVI_2")
    private Double outNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="NOV_NDVI_2")
    private Double novNdvi;
    @EqualsAndHashCode.Exclude
    @Parsed(field="DEZ_NDVI_2")
    private Double dezNdvi;
    @EqualsAndHashCode.Include
    @Parsed(field = "latitude")
    private Double latitude;
    @EqualsAndHashCode.Include
    @Parsed(field = "longitude")
    private Double longitude;

    @EqualsAndHashCode.Exclude
    private Double ndvi;

    public LocalDateTime getDatahora() {
        DateTimeFormatter format1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter format2 = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        DateTimeFormatter format3 = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        List<DateTimeFormatter> formatters = new ArrayList<>();
        formatters.add(format1);
        formatters.add(format2);
        formatters.add(format3);
        for (DateTimeFormatter formatter : formatters) {
            if (getDateTimeConverted(datahora, formatter)) {
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
