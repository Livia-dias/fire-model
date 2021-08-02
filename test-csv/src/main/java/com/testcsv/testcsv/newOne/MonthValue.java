package com.testcsv.testcsv.newOne;

public enum MonthValue {

    JAN(1),
    FEV(2),
    MAR(3),
    ABR(4),
    MAI(5),
    JUN(6),
    JUL(7),
    AGO(8),
    SET(9),
    OUT(10),
    NOV(11),
    DEZ(12);

    private final int value;

    MonthValue(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
