within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilWaterHeating3WVReheat "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZCoilWaterHeating3WVReheat),
    redeclare UserProject.AirHandlersFans.VAVMZCoilWaterHeating3WVReheat VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilWaterHeating3WVReheat\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilWaterHeating3WVReheat</a>
</p>
</html>"));
end VAVMZCoilWaterHeating3WVReheat;
