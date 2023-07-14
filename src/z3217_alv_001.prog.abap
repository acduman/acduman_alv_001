*&---------------------------------------------------------------------*
*& Report Z3217_ALV_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z3217_alv_001.
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    DATA:
      mt_alv  TYPE TABLE OF scarr,
      mr_grid TYPE  REF TO cl_gui_alv_grid,
      mr_cont TYPE REF TO cl_gui_docking_container,
      mt_fcat TYPE lvc_t_fcat,
      ms_layo TYPE lvc_s_layo
      .
    METHODS:
      start_of_selection,
      set_fcat,
      get_data,
      display_alv
      .
ENDCLASS.
CLASS lcl_main IMPLEMENTATION.
  METHOD start_of_selection.
    set_fcat( ).
    get_data( ).
    CALL SCREEN 100.
  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name   = 'SCARR'
        i_bypassing_buffer = abap_true
      CHANGING
        ct_fieldcat        = mt_fcat.
  ENDMETHOD.
  METHOD get_data.
    SELECT * FROM scarr INTO TABLE @mt_alv.
  ENDMETHOD.
  METHOD display_alv.
    IF mr_grid IS NOT BOUND.
      ms_layo = VALUE lvc_s_layo(
        cwidth_opt = abap_true
        zebra      = abap_true
        detailinit = abap_true ).

      mr_cont  = NEW #(
        dynnr     = sy-dynnr
        side      = cl_gui_docking_container=>ws_maximizebox
        extension = cl_gui_docking_container=>ws_maximizebox ).

      mr_grid = NEW #(
       i_parent      = mr_cont
       i_appl_events = abap_true ) .

      mr_grid->set_table_for_first_display(
         EXPORTING is_layout = ms_layo i_save = 'A'
         CHANGING it_outtab = mt_alv  it_fieldcatalog = mt_fcat ).

    ELSE.
      mr_grid->refresh_table_display( is_stable = VALUE #( col = abap_true row = abap_true ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

INITIALIZATION.
  DATA(go_main) = NEW lcl_main( ).

START-OF-SELECTION.
  go_main->start_of_selection( ).

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '100'.
  SET TITLEBAR '100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE alv OUTPUT.
  go_main->display_alv( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.
