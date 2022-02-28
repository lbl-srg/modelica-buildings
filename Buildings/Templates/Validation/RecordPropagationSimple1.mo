within Buildings.Templates.Validation;
model RecordPropagationSimple1

  record DataTopLevel
    "Parameters for all systems"
    parameter DataVAV vav;
  end DataTopLevel;

  record DataVAV
    "Parameters for VAV"
    parameter Integer typCoi;
  end DataVAV;

  model VAV
    parameter DataVAV dat(final typCoi=1);
  end VAV;

  parameter DataTopLevel dat(
    vav(typCoi=2));

  VAV vav(
    dat=dat.vav);

end RecordPropagationSimple1;
