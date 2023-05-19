within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanSupplyBlowThrough "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough),
    redeclare UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough VAV_1);

  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/AirHandlersFans/Validation/VAVMZFanSupplyBlowThrough.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
However, due to the open-loop controls a correct physical behavior
is not expected and the plotted variables are for non-regression testing only.
</p>
</html>"));
end VAVMZFanSupplyBlowThrough;
