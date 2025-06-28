CLASS zcl_insert_data_1119 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_insert_data_1119 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_travel     TYPE TABLE OF ztb_travel_1119,
          lt_booking    TYPE TABLE OF ztb_booking_1119,
          lt_book_suppl TYPE TABLE OF ztb_booksup_1119.


* Travel
    SELECT travel_id,
           agency_id,
           customer_id,
           begin_date,
           end_date,
           booking_fee,
           total_price,
           currency_code,
           description,
           status AS overall_status,
           createdby AS created_by,
           createdat AS created_at,
           lastchangedby AS last_changed_by,
           lastchangedat AS last_changed_at
    FROM /dmo/travel
    INTO CORRESPONDING FIELDS OF TABLE @lt_travel
    UP TO 50 ROWS.

    DELETE FROM ztb_travel_1119.
    INSERT ztb_travel_1119 FROM TABLE @lt_travel.

    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Registros insertados en tabla ZTB_TRAVEL_1119.| ).
    ENDIF.


* Booking
    SELECT *
    FROM /dmo/booking
    FOR ALL ENTRIES IN @lt_travel
    WHERE travel_id = @lt_travel-travel_id
    INTO CORRESPONDING FIELDS OF TABLE @lt_booking.

    DELETE FROM ztb_booking_1119.
    INSERT ztb_booking_1119 FROM TABLE @lt_booking.

    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Registros insertados en tabla ZTB_BOOKING_1119.| ).
    ENDIF.


* Book_suppl
    SELECT *
    FROM /dmo/book_suppl
    FOR ALL ENTRIES IN @lt_booking
    WHERE travel_id = @lt_booking-travel_id
    AND   booking_id = @lt_booking-booking_id
    INTO CORRESPONDING FIELDS OF TABLE @lt_book_suppl.

    DELETE FROM ztb_booksup_1119.
    INSERT ztb_booksup_1119 FROM TABLE @lt_book_suppl.

    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Registros insertados en tabla ZTB_BOOKSUP_1119.| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
