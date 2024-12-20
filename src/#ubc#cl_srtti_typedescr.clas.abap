"! <p class="shorttext synchronized" lang="en">Serializable RTTI any type</p>
CLASS /ubc/cl_srtti_typedescr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .

    DATA:
      absolute_name    LIKE cl_abap_typedescr=>absolute_name READ-ONLY,
      type_kind        LIKE cl_abap_typedescr=>type_kind READ-ONLY,
      length           LIKE cl_abap_typedescr=>length READ-ONLY,
      decimals         LIKE cl_abap_typedescr=>decimals READ-ONLY,
      kind             LIKE cl_abap_typedescr=>kind READ-ONLY,
      "! True if it's an object type which doesn't implement the interface IF_SERIALIZABLE_OBJECT
      not_serializable TYPE abap_bool READ-ONLY,
      is_ddic_type     TYPE abap_bool READ-ONLY,
      "! True if the absolute name is %_T...
      technical_type   TYPE abap_bool READ-ONLY.

    METHODS constructor
      IMPORTING
        rtti TYPE REF TO cl_abap_typedescr .
    METHODS get_rtti
      RETURNING
        VALUE(rtti) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS create_by_rtti
      IMPORTING
        rtti         TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(srtti) TYPE REF TO /ubc/cl_srtti_typedescr.
    CLASS-METHODS create_by_data_object
      IMPORTING
        data_object  TYPE any
      RETURNING
        VALUE(srtti) TYPE REF TO /ubc/cl_srtti_typedescr.
  PROTECTED SECTION.
  PRIVATE SECTION.

*    TYPES:
*      BEGIN OF ty_is_repository,
*        o_type     TYPE REF TO cl_abap_typedescr,
*        o_loc_type TYPE REF TO zcl_srtti_typedescr,
*      END OF ty_is_repository .
*
*    CLASS-DATA:
*      kit_repository TYPE TABLE OF ty_is_repository .
ENDCLASS.



CLASS /ubc/cl_srtti_typedescr IMPLEMENTATION.


  METHOD constructor.

    absolute_name = rtti->absolute_name.
    type_kind     = rtti->type_kind.
    length        = rtti->length.
    decimals      = rtti->decimals.
    kind          = rtti->kind.
    is_ddic_type  = rtti->is_ddic_type( ).
    IF rtti->absolute_name CP '\TYPE=%_T*'.
      technical_type = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD create_by_rtti.

    CASE rtti->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        IF rtti->type_kind = cl_abap_typedescr=>typekind_enum.
          srtti = NEW /ubc/cl_srtti_enumdescr( CAST #( rtti ) ).
        ELSE.
          srtti = NEW /ubc/cl_srtti_elemdescr( CAST #( rtti ) ).
        ENDIF.
      WHEN cl_abap_typedescr=>kind_struct.
        srtti = NEW /ubc/cl_srtti_structdescr( CAST #( rtti ) ).
      WHEN cl_abap_typedescr=>kind_table.
        srtti = NEW /ubc/cl_srtti_tabledescr( CAST #( rtti ) ).
      WHEN cl_abap_typedescr=>kind_ref.
        srtti = NEW /ubc/cl_srtti_refdescr( CAST #( rtti ) ).
      WHEN cl_abap_typedescr=>kind_class.
        srtti = NEW /ubc/cl_srtti_classdescr( CAST #( rtti ) ).
      WHEN cl_abap_typedescr=>kind_intf.
        srtti = NEW /ubc/cl_srtti_intfdescr( CAST #( rtti ) ).
      WHEN OTHERS.
        " Unsupported (new ABAP features in the future)
        RAISE EXCEPTION TYPE /ubc/cx_srtti.
    ENDCASE.

  ENDMETHOD.


  METHOD create_by_data_object.

    srtti = create_by_rtti( cl_abap_typedescr=>describe_by_data( data_object ) ).

  ENDMETHOD.


  METHOD get_rtti.

    " default behavior
    IF technical_type = abap_false."absolute_name NP '\TYPE=%_T*'.
      rtti = cl_abap_typedescr=>describe_by_name( absolute_name ).
    ENDIF.

  ENDMETHOD.


ENDCLASS.
