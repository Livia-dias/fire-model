package com.testcsv.testcsv.newreader;

import com.univocity.parsers.annotations.Parsed;
import lombok.*;

import java.time.LocalDateTime;

@EqualsAndHashCode(callSuper = true)
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper = true)
public class FocosWithDayRow  extends FocosWithClimaRow{

    @Parsed(index = 21)
    private LocalDateTime date = null;
}
