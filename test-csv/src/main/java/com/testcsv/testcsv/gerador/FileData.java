package com.testcsv.testcsv.gerador;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class FileData {
    private String input;
    private String mesOutput;
    private String anoOutput;
}
