package com.testcsv.testcsv.newreader;

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
public class FocosWithDayRow  extends FocosWithClimaRow{

    @Parsed(index = 21)
    private LocalDateTime date = null;
}
