within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorVariable "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable),
    redeclare UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable VAV_1);

  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/AirHandlersFans/Validation/VAVMZCoilEvaporatorVariable.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
However, due to the open-loop controls a correct physical behavior
is not expected and the plotted variables are for non-regression testing only.
</p>
</html>"));
end VAVMZCoilEvaporatorVariable;
