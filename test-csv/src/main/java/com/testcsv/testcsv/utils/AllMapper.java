package com.testcsv.testcsv.utils;

import com.testcsv.testcsv.newOne.FidWithDateTime;
import com.testcsv.testcsv.newOne.FocosWithDayAndFidRow;
import com.testcsv.testcsv.newreader.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AllMapper {

    List<FocosWithDayAndFidRow> toFocosWithDayAndFidRow(List<FidWithDateTime> dateTime);

    FocosWithClimaRow toFocoWithClima(RandomFoco foco, RandomClima clima);

    @Mapping(source = "clima.year", target = "year")
    @Mapping(source = "foco.hasFire", target = "hasFire")
    FocosWithDayRow toFocoWithDay(ClimaWithALot clima, FocoWithDate foco);
}
