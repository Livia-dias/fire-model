package com.testcsv.testcsv.newOne;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class FocosWithDayAndFidRow {

    @Parsed(index = 0)
    private Integer hasFire = 1;
    @Parsed(index = 1)
    private LocalDateTime datahora;
    @Parsed(index = 2)
    private Double elevation;
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
    private Double ocupations;
    @Parsed(index = 9)
    private Integer lulc;
    @Parsed(index = 10)
    private Integer year;
    @Parsed(index = 11)
    private Integer fid;

}
