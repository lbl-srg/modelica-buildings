within Buildings.Templates.Validation;
model RecordPropagationSimple2
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
  end DataVAV;

  model AirHandler
    replaceable parameter DataAirHandler dat;
  end AirHandler;

  model VAV
    extends AirHandler(
      redeclare DataVAV dat(final typCoi=1));
  end VAV;

  parameter DataTopLevel dat(
    vav(typCoi=2));

  VAV vav(
    dat=dat.vav);

end RecordPropagationSimple2;
