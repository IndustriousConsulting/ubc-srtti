"! <p class="shorttext synchronized" lang="en">Serializable RTTI enumeration</p>
CLASS /ubc/cl_srtti_enumdescr DEFINITION
  PUBLIC
  INHERITING FROM /ubc/cl_srtti_elemdescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA base_type_kind LIKE cl_abap_enumdescr=>base_type_kind READ-ONLY .
    DATA members LIKE cl_abap_enumdescr=>members READ-ONLY .

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_enumdescr .

    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ubc/cl_srtti_enumdescr IMPLEMENTATION.


  METHOD constructor.

    super->constructor( rtti ).

    base_type_kind = rtti->base_type_kind.
    members = rtti->members.

  ENDMETHOD.


  METHOD get_rtti.

    rtti = super->get_rtti( ).
    CHECK rtti IS NOT BOUND.

    DATA(rtti_elem) = get_rtti_by_type_kind( base_type_kind ).
*    DATA(rtti_elem) = super->get_rtti( ).

    rtti = cl_abap_enumdescr=>get(
        p_base_type = CAST #( rtti_elem )
        p_members   = members ).

  ENDMETHOD.
ENDCLASS.
