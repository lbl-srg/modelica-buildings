within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model MultiplePumpsSpeed
  "Model of multiple identical pumps in parallel with speed-controlled pump model"
  extends
    Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.PartialMultiplePumps(
    redeclare final Buildings.Fluid.Movers.SpeedControlled_y pum,
    cst(final k=1));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    final unit="1",
    final min=0,
    final max=1)
    if have_var
    "Pump speed (common to all pumps)"
    annotation (
     Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(
          extent={{-140,20},{-100,60}})));

equation
  connect(y, inp.u1) annotation (Line(points={{-120,60},{-6,60},{-6,52}},
        color={0,0,127}));
  connect(inp.y, pum.y)
    annotation (Line(points={{-8.88178e-16,28},{0,28},{0,12}},
                                                     color={0,0,127}));
  annotation (
    defaultComponentName="pum", Documentation(info="<html>
<p>
This model represents a set of identical speed-controlled 
pumps that are piped in parallel.
The model may be configured to represent either constant speed
pumps or variable speed pumps.
An optional check valve in series with each pump is included. 
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Start command (VFD Run for variable speed pumps or Starter contact for constant speed pumps) <code>y1</code>: 
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
(Optionally if <code>have_var</code> is <code>true</code>) Speed command <code>y</code>:
AO signal common to all units, with a dimensionality of zero
</li>
<li>
Pump status <code>y1_actual</code>: 
DI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
<h4>Details</h4>
<p>
See the base class 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.PartialMultiplePumps\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.PartialMultiplePumps</a>.
for a description of the modeling approach.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiplePumpsSpeed;
