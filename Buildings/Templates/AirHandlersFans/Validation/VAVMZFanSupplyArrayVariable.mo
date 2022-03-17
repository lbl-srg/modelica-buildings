within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanSupplyArrayVariable
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZFanSupplyArrayVariable VAV_1, dat(VAV_1(
          fanSup(nFan=2))));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZFanSupplyArrayVariable;
