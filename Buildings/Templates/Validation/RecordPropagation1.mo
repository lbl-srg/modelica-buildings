within Buildings.Templates.Validation;
model RecordPropagation1
  extends Modelica.Icons.Example;

  record DataTopLevel
    "Parameters for all systems"
    parameter DataVAV vav;
  end DataTopLevel;

  record DataVAV
    "Parameters for VAV"
    parameter Integer typCoi;
    parameter DataCoil coi(final typ=typCoi);
  end DataVAV;

  record DataCoil
    "Parameters for coil"
    parameter Integer typ;
  end DataCoil;

  model VAV
    parameter DataVAV dat(final typCoi=coi.typ);

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

end RecordPropagation1;
