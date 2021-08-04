package com.testcsv.testcsv.utils;

import com.testcsv.testcsv.ndvi.OutputRow;
import com.testcsv.testcsv.ndvi.OutputWithDataRow;
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

    @Mapping(source = "row.year", target = "year")
    @Mapping(source = "year", target = "data")
    OutputWithDataRow toOutWithData(OutputRow row, String year);

    @Mapping(target = "hasFire", source = "foco.hasFire")
    @Mapping(source = "clima.year", target = "year")
    @Mapping(source = "foco.data", target = "date")
    @Mapping(source = "foco.ocupations", target = "occupations")
    FocosWithDayRow toFocoWithDay(ClimaWithALot clima, OutputWithDataRow foco);

    @Mapping(target = "hasFire", source = "foco.hasFire")
    @Mapping(source = "foco.ocupations", target = "occupations")
    FocosWithDayRow toFocoWithDay(RandomClima clima, OutputRow foco);
}
