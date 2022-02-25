within Buildings.Templates.Validation;
model RecordPropagationConstant

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

    constant Integer typCoi;
    parameter DataCoil coi(typ=typCoi);
  end DataVAV;

  record DataCoil
    "Parameters for coil"
    constant Integer typ;
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
        typCoi=coi.typ));

    Coil coi(
      final dat=dat.coi);
  end VAV;

  model Coil
    constant Integer typ;
    parameter DataCoil dat(
      typ=typ);
  end Coil;

  parameter DataTopLevel dat(
    vav(typCoi=vav.coi.typ));

  VAV vav(
    dat=dat.vav,
    coi(typ=1))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
end RecordPropagationConstant;
