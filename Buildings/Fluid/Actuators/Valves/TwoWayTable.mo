within Buildings.Fluid.Actuators.Valves;
model TwoWayTable "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;

  parameter Real phiTab[:, 2] = [0, 0.0001; 0.5, 0.5-0.0001/2; 1, 1]
    "Table with first column being valve opening and second column normalized volume flow rate";
  Modelica.Blocks.Tables.CombiTable1D phiLooUp(
    final tableOnFile=false,
    final table=phiTab,
    final columns=2:2,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Normalized mass flow rate for the given valve position under the assumption of a constant pressure"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
initial equation
  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(phiTab[1,2] > 0, "Valve leakage phiTab[1,1] must be bigger than zero.");

equation
  phi = phiLooUp.y[1]; // fixme: should phi be an input of the base class?
  connect(phiLooUp.u[1], y_actual) annotation (Line(
      points={{68,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
fixme Two way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve model 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>. 
Check this model for more information, such
as the leakage flow or regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 26, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TwoWayTable;
