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
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/AirHandlersFans/Validation/VAVMZCoilEvaporatorMultiStage.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorMultiStage</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
However, due to the open-loop controls a correct physical behavior
is not expected and the plotted variables are for non-regression testing only.
</p>
</html>"));
end VAVMZCoilEvaporatorMultiStage;
