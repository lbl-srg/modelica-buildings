within Buildings.Templates.AirHandlersFans.Validation;
model CoilEvaporatorMultiStage
  extends BaseNoEconomizer(redeclare UserProject.AHUs.CoilEvaporatorMultiStage
      VAV_1, datTop(VAV_1(coiCoo(redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_SCA240H4B
            datCoi))));

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilEvaporatorMultiStage;
