within Buildings.Templates.AirHandlersFans.Validation;
model CoilCoolingDXMultiStage
  extends BaseNoEconomizer(redeclare UserProject.AHUs.CoilCoolingDXMultiStage
      VAV_1(coiCoo(mAir_flow_nominal=2, redeclare replaceable
          Buildings.Templates.Components.HeatExchangers.DXCoilMultiStage hex(
            redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_TCA240S
            datCoi))));

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilCoolingDXMultiStage;
