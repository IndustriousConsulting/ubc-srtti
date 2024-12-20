"! <p class="shorttext synchronized" lang="en">Serializable RTTI object type</p>
CLASS /ubc/cl_srtti_objectdescr DEFINITION
  PUBLIC
  INHERITING FROM /ubc/cl_srtti_typedescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA interfaces LIKE cl_abap_objectdescr=>interfaces .
    DATA types LIKE cl_abap_objectdescr=>types .
    DATA attributes LIKE cl_abap_objectdescr=>attributes .
    DATA methods LIKE cl_abap_objectdescr=>methods .
    DATA events LIKE cl_abap_objectdescr=>events .

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_objectdescr.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /ubc/cl_srtti_objectdescr IMPLEMENTATION.


  METHOD constructor.

    super->constructor( rtti ).
    interfaces  = rtti->interfaces.
    types       = rtti->types.
    attributes  = rtti->attributes.
    methods     = rtti->methods.
    events      = rtti->events.
    IF NOT line_exists( interfaces[ name = 'IF_SERIALIZABLE_OBJECT' ] ).
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
