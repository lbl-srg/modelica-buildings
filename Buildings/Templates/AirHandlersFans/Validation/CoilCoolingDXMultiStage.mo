within Buildings.Templates.AirHandlersFans.Validation;
model CoilCoolingDXMultiStage
  extends NoEconomizer(   redeclare
    UserProject.AHUs.CoilCoolingDXMultiStage ahu(coiCoo(redeclare replaceable
          Buildings.Templates.Components.HeatExchangers.DXMultiStage hex(
            redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
            datCoi))));

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilCoolingDXMultiStage;
