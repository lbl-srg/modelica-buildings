within Buildings.Templates.Plants.Controls.Pumps.Generic;
block ControlDifferentialPressure
  "Differential pressure control for variable speed pumps"
  parameter Boolean have_senDpRemWir
    "Set to true for remote differential pressure sensor(s) hardwired to controller"
    annotation (Evaluate=true);
  parameter Integer nPum(
    min=1)
    "Number of pumps that operate at design conditions"
    annotation (Evaluate=true);
  parameter Integer nSenDpRem(
    min=1)
    "Number of remote loop differential pressure sensors used for pump speed control"
    annotation (Evaluate=true);
  parameter Real y_min(
    max=1,
    min=0,
    unit="1")=0.1
    "Minimum pump speed";
  final parameter Real y_max(
    final unit="1",
    final min=0,
    final max=1)=1
    "Maximum pump speed";
  parameter Real k(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps,
    unit="s")=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1_actual[nPum]
    "Pump status"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRemSet[nSenDpRem](
    each final unit="Pa")
    if have_senDpRemWir
    "Remote differential pressure setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpLoc(
    final unit="Pa")
    if not have_senDpRemWir
    "Loop differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRem[nSenDpRem](
    each final unit="Pa")
    if have_senDpRemWir
    "Remote loop differential pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpLocSet[nSenDpRem](
    each final unit="Pa")
    if not have_senDpRemWir
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1")
    "Pump speed command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{98,-20},{138,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOn(
    final nin=nPum)
    "Return true when any pump is proven on"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repEna(
    final nout=nSenDpRem)
    "Replicate"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxSet(
    nin=nSenDpRem)
    if not have_senDpRemWir
    "Maximum DP setpoint"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Utilities.PIDWithEnable ctlDpRem[nSenDpRem](
    each final k=k,
    each final Ti=Ti,
    each r=dpSca,
    each final yMin=y_min,
    each final yMax=y_max,
    each final y_reset=y_min,
    each final y_neutral=0)
    if have_senDpRemWir
    "Remote differential pressure control"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Utilities.PIDWithEnable ctlDpLoc(
    final k=k,
    final Ti=Ti,
    final r=dpSca,
    final yMin=y_min,
    final yMax=y_max,
    final y_reset=y_min,
    final y_neutral=0)
    if not have_senDpRemWir
    "Local differential pressure control"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxY(
    nin=nSenDpRem)
    if have_senDpRemWir
    "Maximum control loop output"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
protected
  parameter Real dpSca(
    final unit="Pa",
    final min=0)=1E4
    "Differential pressure used as a scaling factor for PI control";
equation
  connect(y1_actual, anyOn.u)
    annotation (Line(points={{-120,80},{-92,80}},color={255,0,255}));
  connect(anyOn.y, repEna.u)
    annotation (Line(points={{-68,80},{-52,80}},color={255,0,255}));
  connect(dpLocSet, maxSet.u)
    annotation (Line(points={{-120,-40},{-92,-40}},color={0,0,127}));
  connect(dpRemSet, ctlDpRem.u_s)
    annotation (Line(points={{-120,40},{-12,40}},color={0,0,127}));
  connect(maxSet.y, ctlDpLoc.u_s)
    annotation (Line(points={{-68,-40},{-12,-40}},color={0,0,127}));
  connect(dpRem, ctlDpRem.u_m)
    annotation (Line(points={{-120,0},{0,0},{0,28}},color={0,0,127}));
  connect(repEna.y, ctlDpRem.uEna)
    annotation (Line(points={{-28,80},{-20,80},{-20,20},{-4,20},{-4,28}},color={255,0,255}));
  connect(dpLoc, ctlDpLoc.u_m)
    annotation (Line(points={{-120,-80},{0,-80},{0,-52}},color={0,0,127}));
  connect(anyOn.y, ctlDpLoc.uEna)
    annotation (Line(points={{-68,80},{-60,80},{-60,-60},{-4,-60},{-4,-52}},
      color={255,0,255}));
  connect(ctlDpRem.y, maxY.u)
    annotation (Line(points={{12,40},{38,40}},color={0,0,127}));
  connect(ctlDpLoc.y, y)
    annotation (Line(points={{12,-40},{80,-40},{80,0},{120,0}},color={0,0,127}));
  connect(maxY.y, y)
    annotation (Line(points={{62,40},{80,40},{80,0},{120,0}},color={0,0,127}));
  annotation (
    defaultComponentName="ctlDp",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
For plants where a remote DP sensor(s) is hardwired to the pump controller
(<code>have_senDpRemHar=true</code>):
</p>
<ul>
<li>
When any pump is proven on, the pump speed is controlled by a reverse acting PI loop
maintaining the differential pressure signal at setpoint.
All pumps receive the same speed signal.
</li>
<li>
Where multiple DP sensors exist, a PI loop runs for each sensor.
The pumps are controlled to the highest signal output of all DP sensor loops.
</li>
</ul>
<p>
For plants where the remote DP sensor(s) is not hardwired to the plant controller, but
a local DP sensor is hardwired to the plant controller
(<code>have_senDpRemHar=false</code>):
</p>
<ul>
<li>
When any pump is proven on, the pump speed is controlled by a reverse acting PI
loop maintaining the local DP signal at the DP setpoint output from the
remote sensor control loop (see
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ResetLocalDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ResetLocalDifferentialPressure</a>).
All pumps receive the same speed signal.
</li>
<li>
Where multiple remote DP sensors exist, a PI loop shall run for each sensor.
The DP setpoint for the local DP sensor is the highest DP setpoint output
from each of the remote loops.
</li>
</ul>
<h4>Details</h4>
<p>This logic is prescribed in ASHRAE, 2021 for:
</p>
<ul>
<li>
variable speed primary pumps in primary-only chiller and boiler plants
where the remote DP sensor(s) is hardwired to the plant controller,
</li>
<li>
variable speed primary pumps in primary-only chiller and boiler plants
where the remote DP sensor(s) is not hardwired to the plant controller, but
a local DP sensor is hardwired to the plant controller,
</li>
<li>
variable speed secondary pumps in primary-secondary chiller and boiler
plants where a remote DP sensor(s) is hardwired to the secondary pump controller,
</li>
<li>
variable speed secondary pumps in primary-secondary chiller and boiler plants
where a remote DP sensor is not hardwired to the secondary pump controller,
but a local DP sensor is hardwired to the secondary pump controller.
</li>
</ul>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>
", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end ControlDifferentialPressure;
