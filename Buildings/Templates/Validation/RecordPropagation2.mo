within Buildings.Templates.Validation;
model RecordPropagation2
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
    extends AirHandler(
      redeclare DataVAV dat(final typCoi=coi.typ));

    Coil coi(final dat=dat.coi);
  end VAV;

  model Coil
    parameter Integer typ;
    parameter DataCoil dat(final typ=typ);
  end Coil;

  parameter DataTopLevel dat(
    vav(final typCoi=2));

  VAV vav(
    dat=dat.vav,
    coi(typ=1));

end RecordPropagation2;
