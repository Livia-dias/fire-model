package com.testcsv.testcsv.ndviwithclima.main;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class DataPaths {

    private String dataFidPath;
    private String infoPath;
    private String ndviPath;
    private String output;

}
