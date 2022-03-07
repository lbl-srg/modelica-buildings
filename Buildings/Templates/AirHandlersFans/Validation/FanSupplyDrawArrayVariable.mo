within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyDrawArrayVariable
  extends BaseNoEconomizer(redeclare
      UserProject.AHUs.FanSupplyDrawArrayVariable VAV_1, dat(VAV_1(fanSup(
            nFan=2))));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawArrayVariable;
