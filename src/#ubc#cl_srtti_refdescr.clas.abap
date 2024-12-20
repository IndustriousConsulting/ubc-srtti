"! <p class="shorttext synchronized" lang="en">Serializable RTTI reference</p>
CLASS /ubc/cl_srtti_refdescr DEFINITION
  PUBLIC
  INHERITING FROM /ubc/cl_srtti_datadescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA referenced_type TYPE REF TO /ubc/cl_srtti_typedescr .

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_refdescr.
    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ubc/cl_srtti_refdescr IMPLEMENTATION.


  METHOD constructor.

    super->constructor( rtti ).
    referenced_type = NEW /ubc/cl_srtti_typedescr( rtti->get_referenced_type( ) ).
    IF referenced_type->not_serializable = abap_true.
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_rtti.

    IF referenced_type->type_kind = cl_abap_typedescr=>typekind_data.
      rtti = cl_abap_refdescr=>get_ref_to_data( ).
    ELSEIF referenced_type->absolute_name = '\CLASS=OBJECT'.
      rtti = cl_abap_refdescr=>get_ref_to_object( ).
    ELSE.
      rtti = referenced_type->get_rtti( ).
    ENDIF.
    rtti = cl_abap_refdescr=>create( rtti ).

  ENDMETHOD.
ENDCLASS.
