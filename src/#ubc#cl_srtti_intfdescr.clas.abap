"! <p class="shorttext synchronized" lang="en">Serializable RTTI interface</p>
CLASS /ubc/cl_srtti_intfdescr DEFINITION
  PUBLIC
  INHERITING FROM /ubc/cl_srtti_objectdescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA intf_kind LIKE cl_abap_intfdescr=>intf_kind .

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_intfdescr.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ubc/cl_srtti_intfdescr IMPLEMENTATION.

  METHOD constructor.

    super->constructor( rtti ).
    intf_kind = rtti->intf_kind.

  ENDMETHOD.

ENDCLASS.
