within Buildings.Templates.Plants.Controls.Pumps.Generic;
block ResetLocalDifferentialPressure
  "Local differential pressure reset"
  parameter Real dpLocSet_min(
    start=0,
    final unit="Pa",
    final min=0)=5 * 6895
    "Minimum loop differential pressure setpoint local to the plant";
  parameter Real dpLocSet_max(
    start=1E5,
    final unit="Pa",
    final min=0)
    "Maximum loop differential pressure setpoint local to the plant";
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRemSet(
    each final unit="Pa")
    "Remote loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpRem(
    each final unit="Pa")
    "Remote loop differential pressure"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpLocSet(
    final unit="Pa")
    "Local differential pressure setpoint "
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{98,-20},{138,20}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlDpRem(
    final k=k,
    final Ti=Ti,
    final r=dpLocSet_max)
    "Remote loop differential pressure controller"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line dpLocRes
    "Local loop differential pressure reset"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpLocSetMin(
    final k=dpLocSet_min)
    "Constant"
    annotation (Placement(transformation(extent={{60,24},{40,44}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpLocSetMax(
    final k=dpLocSet_max)
    "Constant"
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
equation
  connect(dpRem, ctlDpRem.u_m)
    annotation (Line(points={{-120,-40},{-60,-40},{-60,-12}},color={0,0,127}));
  connect(zer.y, dpLocRes.x1)
    annotation (Line(points={{22,40},{30,40},{30,8},{38,8}},color={0,0,127}));
  connect(dpLocSetMin.y, dpLocRes.f1)
    annotation (Line(points={{38,34},{34,34},{34,4},{38,4}},color={0,0,127}));
  connect(one.y, dpLocRes.x2)
    annotation (Line(points={{22,-20},{30,-20},{30,-4},{38,-4}},color={0,0,127}));
  connect(dpLocSetMax.y, dpLocRes.f2)
    annotation (Line(points={{38,-30},{34,-30},{34,-8},{38,-8}},color={0,0,127}));
  connect(dpRemSet, ctlDpRem.u_s)
    annotation (Line(points={{-120,0},{-72,0}},color={0,0,127}));
  connect(ctlDpRem.y, dpLocRes.u)
    annotation (Line(points={{-48,0},{38,0}},color={0,0,127}));
  connect(dpLocRes.y, dpLocSet)
    annotation (Line(points={{62,0},{120,0}},color={0,0,127}));
  annotation (
    defaultComponentName="resDpLoc",
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
<p>
For plants where the remote DP sensor(s) is not hardwired to the plant controller, but 
a local DP sensor is hardwired to the plant controller,
remote DP is maintained at setpoint by a reverse acting PI loop <i>running in the controller 
to which the remote sensor is wired</i>.
</p>
<p>
The loop output is a DP setpoint for the local primary loop DP sensor hardwired to the 
plant controller.
</p>
<p>
The local DP setpoint is reset from <code>dpLocSet_min</code> at <i>0&nbsp;%</i> loop output
to <code>dpLocSet_max</code> at <i>100&nbsp;%</i> loop output.
</p>
<p>
The minimum local differential pressure setpoint <code>dpLocSet_min</code> is 
dictated by minimum flow control in primary-only plants but has no lower
limit in primary-secondary plants.
In primary-only plants, the minimum setpoint needs to be high enough to drive design
minimum flow for the largest equipment through the minimum flow bypass valve.
</p>
<h4>Details</h4>
<p>Used in Guideline 36 for controlling:
</p>
<ul>
<li>
variable speed primary pumps in primary-only chiller and boiler plants 
where the remote DP sensor(s) is not hardwired to the plant controller, but 
a local DP sensor is hardwired to the plant controller,
</li>
<li>
variable speed secondary pumps in primary-secondary chiller and boiler plants plants 
where a remote DP sensor is not hardwired to the secondary pump controller,
but a local DP sensor is hardwired to the secondary pump controller.
</li>
</ul>
</html>
"), Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end ResetLocalDifferentialPressure;
