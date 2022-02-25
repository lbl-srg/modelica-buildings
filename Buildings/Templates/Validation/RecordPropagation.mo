within Buildings.Templates.Validation;
model RecordPropagation
  extends Modelica.Icons.Example;

  record DataTopLevel
    "Parameters for all systems"
    parameter DataVAV vav;
  end DataTopLevel;

  record DataAirHandler
    "Parameters for AHU"
  end DataAirHandler;

  record DataVAV
    "Parameters for VAV"
    extends DataAirHandler;

    parameter Integer typCoi;
    parameter DataCoil coi(final typ=typCoi);
  end DataVAV;

  record DataCoil
    "Parameters for coil"
    parameter Integer typ;
  end DataCoil;

  model AirHandler
    replaceable parameter DataAirHandler dat;
  end AirHandler;

  model VAV
    /* 
    We propagate UP the type of coil in the AHU record 
    so that the structure of parameters exposed to the user
    be consistent with the type of coil. 
    */
    extends AirHandler(
      redeclare DataVAV dat(
        final typCoi=coi.typ));

    Coil coi(
      final dat=dat.coi);
  end VAV;

  model Coil
    parameter Integer typ;
    parameter DataCoil dat(
      final typ=typ);
  end Coil;

  /*
  Translation fails only when using that top level record,
  and only with Dymola (OCT and OMC do not issue any warning).
  Why dat(final typ=typ) in Coil is valid (should yield
  an overriding error with coi(final dat=dat.coi) in VAV)?
  And why vav(dat=dat.vav) is invalid then?
  This is just because of the redeclare statement in VAV,
  see RecordPropagationNoRedeclare.
  */

  parameter DataTopLevel dat(
    vav(final typCoi=vav.coi.typ));

  VAV vav(
    dat=dat.vav,
    coi(typ=1));

end RecordPropagation;
