within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorMultiStage "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage,
      _VAV_1(coiCoo(redeclare
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.DoubleSpeed.Lennox_SCA240H4B
        datCoi))),
    redeclare
      UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage</a>
</p>
</html>"));
end VAVMZCoilEvaporatorMultiStage;
