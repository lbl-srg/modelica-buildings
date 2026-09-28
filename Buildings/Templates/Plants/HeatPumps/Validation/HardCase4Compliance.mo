within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4Compliance "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4(
    pla(use_cpl=true))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"));
end HardCase4Compliance;
