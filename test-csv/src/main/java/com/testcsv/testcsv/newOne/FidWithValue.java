package com.testcsv.testcsv.newOne;

import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class FidWithValue {
    @Parsed(index = 0)
    private Integer fid;

    @Parsed(index = 4)
    private Double value;
}
