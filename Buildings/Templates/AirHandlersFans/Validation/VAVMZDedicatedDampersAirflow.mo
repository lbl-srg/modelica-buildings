within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZDedicatedDampersAirflow "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZDedicatedDampersAirflow),
    redeclare
      UserProject.AirHandlersFans.VAVMZDedicatedDampersAirflow VAV_1(secOutRel(
          redeclare model OutdoorSection_MAWD =
            Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow
            (test=1))));

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZDedicatedDampersAirflow\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZDedicatedDampersAirflow</a>
</p>
</html>"));
end VAVMZDedicatedDampersAirflow;
