within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model MultiplePumpsDp
  "Model of multiple identical pumps in parallel with dp-controlled pump model"
  extends BaseClasses.PartialMultiplePumps(
    final have_var=have_varSet,
    redeclare final Buildings.Fluid.Movers.FlowControlled_dp pum(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    cst(final k=dpPum_nominal));

  parameter Boolean have_varSet = true
    "Set to true for variable setpoint, false for constant setpoint (design value)"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dp_in(
    final unit="Pa",
    final min=0)
    if have_var
    "Differential pressure setpoint"
    annotation (
    Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
equation
  connect(dp_in, inp.u1) annotation (Line(points={{-120,60},{-6,60},{-6,52}},
                    color={0,0,127}));
  connect(inp.y, pum.dp_in)
    annotation (Line(points={{-8.88178e-16,28},{0,28},{0,12}},
                                                     color={0,0,127}));
  annotation (
    defaultComponentName="pum", Documentation(info="<html>
<p>
This model represents a set of identical dp-controlled
variable speed pumps that are piped in parallel.
An optional check valve in series with each pump is included.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Start command (VFD Run) <code>y1</code>:
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
(Optionally if <code>have_varSet</code> is <code>true</code>) Differential pressure setpoint <code>dp_in</code>:
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
end MultiplePumpsDp;
