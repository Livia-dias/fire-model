package com.testcsv.testcsv;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class LatLongKey {

    private Double latitude;
    private Double longitude;

    public LatLongKey(FocoRow row) {
        this.latitude = row.getLatitude();
        this.longitude = row.getLongitude();
    }

}
