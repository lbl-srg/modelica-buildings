within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorMultiStage
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage VAV_1, dat(
        VAV_1(coiCoo(redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_SCA240H4B
            datCoi))));

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZCoilEvaporatorMultiStage;
