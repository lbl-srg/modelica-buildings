within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
model LoadTwoWayValveControl
  "Model of a load on hydronic circuit with flow rate modulation by two-way valve"
  extends PartialLoadValveControl(
    redeclare HydronicConfigurations.ActiveNetworks.Throttle con);
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model of a thermal load on a hydronic circuit that
is composed of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load\">
Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load</a>
and a throttle circuit with a two-way valve 
that is used to modulate the flow rate through the load component.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end LoadTwoWayValveControl;
