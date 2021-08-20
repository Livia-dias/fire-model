package com.testcsv.testcsv.oldReader;

import com.univocity.parsers.annotations.Convert;
import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class FocoRow {

    @Parsed(index = 0)
    @Convert(conversionClass = LocalDateTimeConverter.class)
    private LocalDateTime datahora;
    @Parsed(index = 1)
    private String satelite;
    @Parsed(index = 2)
    private String pais;
    @Parsed(index = 3)
    private String estado;
    @Parsed(index = 4)
    private String municipio;
    @Parsed(index = 5)
    private String bioma;
    @Parsed(index = 6)
    private String diasemchuva;
    @Parsed(index = 7)
    private String precipitacao;
    @Parsed(index = 8)
    private String riscofogo;
    @Parsed(index = 9)
    private Double latitude;
    @Parsed(index = 10)
    private Double longitude;
    @Parsed(index = 11)
    private String frp;
    @Parsed(index = 12)
    private String areaprotegida;

    private LocalDate soData;

    @Override
    public boolean equals(Object o){
        if(o instanceof FocoRow){
            FocoRow compare = (FocoRow) o;
            return Objects.equals(this.getLatitude(), compare.getLatitude()) && Objects.equals(this.getLongitude(), compare.getLongitude())
                    && Objects.equals(this.getDatahora(), compare.getDatahora());
        }
        return false;
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
