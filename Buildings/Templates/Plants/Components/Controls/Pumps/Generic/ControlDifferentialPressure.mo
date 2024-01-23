within Buildings.Templates.Plants.Components.Controls.Pumps.Generic;
block ControlDifferentialPressure
  "Differential pressure control for variable speed pumps"
  parameter Boolean have_senDpLoc
    "Set to true for local differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true);
  parameter Integer nPum(
    final min=1)
    "Number of pumps that operate at design conditions"
    annotation (Evaluate=true);
  parameter Integer nSenDpRem(
    final min=1)
    "Number of remote loop differential pressure sensors used for pump speed control"
    annotation (Evaluate=true);
  parameter Real dpLocSet_min(
    start=0,
    final unit="Pa",
    final min=0)=5 * 6895
    "Minimum loop differential pressure setpoint local to the plant"
    annotation (Dialog(enable=have_senDpLoc));
  parameter Real dpLocSet_max(
    start=1E5,
    final unit="Pa",
    final min=0)
    "Maximum loop differential pressure setpoint local to the plant"
    annotation (Dialog(enable=have_senDpLoc));
  parameter Real y_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Pump minimum speed command signal";
  final parameter Real y_max(
    final unit="1",
    final min=0,
    final max=1)=1
    "Pump maximum speed command signal";
  parameter Real k(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps)=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1_actual[nPum]
    "Pump status"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRemSet[nSenDpRem](
    each final unit="Pa")
    "Remote loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpLoc(
    final unit="Pa")
    if have_senDpLoc
    "Loop differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-160,-140},{-120,-100}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRem[nSenDpRem](
    each final unit="Pa")
    "Remote loop differential pressure"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1")
    "Pump speed command"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{98,-20},{138,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOn(
    final nin=nPum)
    "Return true when any pump is proven on"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Buildings.Templates.Plants.Components.Controls.Utilities.PIDWithEnable ctlDpRem[nSenDpRem](
    each final k=k,
    each final Ti=Ti,
    each r=dpSca)
    "Remote loop differential pressure controller"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Templates.Plants.Components.Controls.Utilities.PIDWithEnable ctlDpLoc(
    final k=k,
    final Ti=Ti,
    r=dpLocSet_max)
    if have_senDpLoc
    "Local loop differential pressure controller"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repEna(
    final nout=nSenDpRem)
    "Replicate"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line dpLocSet
    if have_senDpLoc
    "Local loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxY(
    nin=nSenDpRem)
    "Maximum control loop output"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpLocSetMin(
    final k=dpLocSet_min)
    "Constant"
    annotation (Placement(transformation(extent={{10,-36},{-10,-16}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpLocSetMax(
    final k=dpLocSet_max)
    "Constant"
    annotation (Placement(transformation(extent={{10,-100},{-10,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter pas(
    final nin=1,
    final nout=1)
    if not have_senDpLoc
    "Direct pass-through"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line out
    "Calculate speed command signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yMin(
    final k=y_min)
    "Constant"
    annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yMax(
    final k=y_max)
    "Constant"
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert to real"
    annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply neu
    "Set to neutral when control loop is disabled"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
protected
  parameter Real dpSca(
    final unit="Pa",
    final min=0)=1E4
    "Differential pressure used as a scaling factor for PI control";
equation
  connect(y1_actual, anyOn.u)
    annotation (Line(points={{-140,100},{-112,100}},color={255,0,255}));
  connect(dpRem, ctlDpRem.u_m)
    annotation (Line(points={{-140,20},{-10,20},{-10,88}},color={0,0,127}));
  connect(dpLoc, ctlDpLoc.u_m)
    annotation (Line(points={{-140,-120},{40,-120},{40,-72}},color={0,0,127}));
  connect(anyOn.y, ctlDpLoc.uEna)
    annotation (Line(points={{-88,100},{-80,100},{-80,-116},{36,-116},{36,-72}},
      color={255,0,255}));
  connect(anyOn.y, repEna.u)
    annotation (Line(points={{-88,100},{-72,100}},color={255,0,255}));
  connect(ctlDpRem.y, maxY.u)
    annotation (Line(points={{2,100},{8,100}},color={0,0,127}));
  connect(dpLocSet.y, ctlDpLoc.u_s)
    annotation (Line(points={{12,-60},{28,-60}},color={0,0,127}));
  connect(zer.y, dpLocSet.x1)
    annotation (Line(points={{-48,-20},{-30,-20},{-30,-52},{-12,-52}},color={0,0,127}));
  connect(dpLocSetMin.y, dpLocSet.f1)
    annotation (Line(points={{-12,-26},{-16,-26},{-16,-56},{-12,-56}},color={0,0,127}));
  connect(one.y, dpLocSet.x2)
    annotation (Line(points={{-48,-60},{-26,-60},{-26,-64},{-12,-64}},color={0,0,127}));
  connect(dpLocSetMax.y, dpLocSet.f2)
    annotation (Line(points={{-12,-90},{-16,-90},{-16,-68},{-12,-68}},color={0,0,127}));
  connect(maxY.y, dpLocSet.u)
    annotation (Line(points={{32,100},{40,100},{40,60},{-20,60},{-20,-60},{-12,-60}},
      color={0,0,127}));
  connect(maxY.y, pas.u[1])
    annotation (Line(points={{32,100},{48,100}},color={0,0,127}));
  connect(pas.y[1], out.u)
    annotation (Line(points={{72,100},{80,100},{80,80},{60,80},{60,0},{78,0}},
      color={0,0,127}));
  connect(ctlDpLoc.y, out.u)
    annotation (Line(points={{52,-60},{60,-60},{60,0},{78,0}},color={0,0,127}));
  connect(zer.y, out.x1)
    annotation (Line(points={{-48,-20},{-30,-20},{-30,8},{78,8}},color={0,0,127}));
  connect(one.y, out.x2)
    annotation (Line(points={{-48,-60},{-26,-60},{-26,-4},{78,-4}},color={0,0,127}));
  connect(yMax.y, out.f2)
    annotation (Line(points={{78,-30},{74,-30},{74,-8},{78,-8}},color={0,0,127}));
  connect(dpRemSet, ctlDpRem.u_s)
    annotation (Line(points={{-140,60},{-30,60},{-30,100},{-22,100}},color={0,0,127}));
  connect(anyOn.y, booToRea.u)
    annotation (Line(points={{-88,100},{-80,100},{-80,40},{-70,40}},color={255,0,255}));
  connect(repEna.y, ctlDpRem.uEna)
    annotation (Line(points={{-48,100},{-40,100},{-40,80},{-14,80},{-14,88}},
      color={255,0,255}));
  connect(yMin.y, neu.u1)
    annotation (Line(points={{78,40},{24,40},{24,26},{28,26}},color={0,0,127}));
  connect(booToRea.y, neu.u2)
    annotation (Line(points={{-46,40},{20,40},{20,14},{28,14}},color={0,0,127}));
  connect(neu.y, out.f1)
    annotation (Line(points={{52,20},{74,20},{74,4},{78,4}},color={0,0,127}));
  connect(out.y, y)
    annotation (Line(points={{102,0},{140,0}},color={0,0,127}));
  annotation (
    defaultComponentName="ctlDp",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
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
<p>Used in Guideline 36 for:
</p>
<ul>
<li>
primary-only chiller and boiler plants with variable speed primary pumps
where the remote DP sensor(s) is hardwired to the plant controller,
</li>
<li>
primary-only chiller and boiler plants with variable speed primary pumps where
the remote DP sensor(s) is not hardwired to the plant controller, but a local
DP sensor is hardwired to the plant controller,
</li>
<li>
primary-secondary chiller and boiler plants plants with variable speed
secondary pumps where a remote DP sensor(s) is hardwired to the secondary pump
controller,
</li>
<li>
primary-secondary chiller and boiler plants plants with variable speed
secondary pumps where a remote DP sensor is not hardwired to the secondary pump controller,
but a local DP sensor is hardwired to the secondary pump controller.
</li>
</ul>
<p>
Where more than one remote DP sensor serves a given set of primary or secondary pumps,
remote DP setpoints for all remote sensors serving those pumps shall increase in unison.
Note: if remote sensors have different CHW-DPmax values, then the amount each DP setpoint
changes per percent loop output will differ.
</p>
<p>
The minimum local differential pressure setpoint <code>dpLocSet_min</code> is dictated
by minimum flow control in primary-only plants but has no lower
limit in primary-secondary plants.
In primary-only plants, the minimum setpoint needs to be high enough to drive design
minimum flow for the largest equipment through the minimum flow bypass valve.
</p>
</html>
"),
    Diagram(
      coordinateSystem(
        extent={{-120,-140},{120,140}})));
end ControlDifferentialPressure;
