package com.testcsv.testcsv.oldReader;

import com.univocity.parsers.annotations.Convert;
import com.univocity.parsers.annotations.Parsed;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Objects;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class NewFocoRow {

    @Parsed(index = 0)
    private Integer fid;
    @Parsed(index = 1)
    @Convert(conversionClass = LocalDateTimeConverter.class)
    private LocalDateTime datahora;
    @Parsed(index = 2)
    private String satelite;
    @Parsed(index = 3)
    private String pais;
    @Parsed(index = 4)
    private String estado;
    @Parsed(index = 5)
    private String municipio;
    @Parsed(index = 6)
    private String bioma;
    @Parsed(index = 7)
    private String diasemchuva;
    @Parsed(index = 8)
    private String precipitacao;
    @Parsed(index = 9)
    private String riscofogo;
    @Parsed(index = 10)
    private Double latitude;
    @Parsed(index = 11)
    private Double longitude;
    @Parsed(index = 12)
    private String frp;
    @Parsed(index = 13)
    private String areaprotegida;

    @Override
    public boolean equals(Object o){
        if(o instanceof NewFocoRow){
            NewFocoRow compare = (NewFocoRow) o;
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
