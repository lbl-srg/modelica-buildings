within Buildings.Templates.Plants.Controls.Pumps.Generic;
block StagingHeaderedDeltaP
  "Staging logic for headered variable speed pumps using ∆p pump speed control"
  parameter Integer nPum(
    final min=1)
    "Number of pumps that operate at design conditions"
    annotation (Evaluate=true);
  parameter Real V_flow_nominal(
    final min=1E-6,
    final unit="m3/s")
    "Design flow rate";
  parameter Real dtRun(
    final min=0,
    final unit="s")=10 * 60
    "Runtime before triggering stage command";
  parameter Real dVOffUp(
    final min=0,
    final max=1,
    final unit="1")=0.03
    "Stage up flow point offset";
  parameter Real dVOffDow(
    final min=0,
    final max=1,
    final unit="1")=dVOffUp
    "Stage down flow point offset";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s")
    "Flow rate"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual[nPum]
    "Pump status"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norV(
    final k=1 / V_flow_nominal)
    "Normalize to design value"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norN(
    final k=1 / nPum)
    "Normalize to design value"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Convert to real value"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Compare to stage up flow point"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Less les
    "Compare to stage down flow point"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter poiDow(
    p=- 1 / nPum - dVOffDow)
    "Calculate stage down flow point"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter poiUp(
    p=- dVOffUp)
    "Calculate stage up flow point"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset runUp(
    final t=dtRun)
    "Return true if stage up condition is true for specified duration"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset runDow(
    final t=dtRun)
    "Return true if stage down condition is true for specified duration"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nPum]
    "Return true when pump status changes"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nOpe(
    nin=nPum)
    "Return number of operating pumps"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCha(
    nin=nPum)
    "Return true when any pump status changes"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
equation
  connect(norN.y, poiDow.u)
    annotation (Line(points={{-38,40},{-30,40},{-30,20},{-22,20}},color={0,0,127}));
  connect(norN.y, poiUp.u)
    annotation (Line(points={{-38,40},{-30,40},{-30,60},{-22,60}},color={0,0,127}));
  connect(norV.y, gre.u1)
    annotation (Line(points={{-38,0},{28,0}},color={0,0,127}));
  connect(poiUp.y, gre.u2)
    annotation (Line(points={{2,60},{20,60},{20,-8},{28,-8}},color={0,0,127}));
  connect(poiDow.y, les.u2)
    annotation (Line(points={{2,20},{10,20},{10,-48},{28,-48}},color={0,0,127}));
  connect(norV.y, les.u1)
    annotation (Line(points={{-38,0},{0,0},{0,-40},{28,-40}},color={0,0,127}));
  connect(les.y, runDow.u)
    annotation (Line(points={{52,-40},{68,-40}},color={255,0,255}));
  connect(V_flow, norV.u)
    annotation (Line(points={{-140,0},{-62,0}},color={0,0,127}));
  connect(gre.y, runUp.u)
    annotation (Line(points={{52,0},{68,0}},color={255,0,255}));
  connect(runUp.passed, y1Up)
    annotation (Line(points={{92,-8},{100,-8},{100,40},{140,40}},color={255,0,255}));
  connect(runDow.passed, y1Dow)
    annotation (Line(points={{92,-48},{100,-48},{100,-40},{140,-40}},color={255,0,255}));
  connect(booToRea.y, nOpe.u)
    annotation (Line(points={{-68,100},{-62,100}},color={0,0,127}));
  connect(u1_actual, booToRea.u)
    annotation (Line(points={{-140,100},{-92,100}},color={255,0,255}));
  connect(u1_actual, cha.u)
    annotation (Line(points={{-140,100},{-100,100},{-100,-60},{-92,-60}},color={255,0,255}));
  connect(nOpe.y, norN.u)
    annotation (Line(points={{-38,100},{-30,100},{-30,70},{-70,70},{-70,40},{-62,40}},
      color={0,0,127}));
  connect(cha.y, anyCha.u)
    annotation (Line(points={{-68,-60},{-52,-60}},color={255,0,255}));
  connect(anyCha.y, runUp.reset)
    annotation (Line(points={{-28,-60},{60,-60},{60,-8},{68,-8}},color={255,0,255}));
  connect(anyCha.y, runDow.reset)
    annotation (Line(points={{-28,-60},{60,-60},{60,-48},{68,-48}},color={255,0,255}));
  annotation (
    defaultComponentName="staPum",
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
<p>Used in Guideline 36 for staging:
</p>
<ul>
<li>
headered variable speed primary pumps in primary-only chiller
and boiler plants using differential pressure pump speed control,
</li>
<li>
variable speed secondary pumps in primary-secondary chiller plants
with one or more sets of secondary loop pumps serving downstream
control valves,
</li>
<li>
variable speed secondary pumps in primary-secondary boiler plants
plants with serving a secondary loop with a flow meter.
</li>
</ul>
<p>
For other plant configurations, the pumps are staged with the equipment,
i.e., the number of pumps matches the number of chillers or boilers.
The actual logic for generating the pump enable commands is part of the
staging event sequencing.
</p>
<p>
If desired, the stage down flow point <code>dVOffDow</code> can be
offset slightly below the stage up point <code>dVOffUp</code> to
prevent cycling between pump stages in applications with highly variable loads.
</p>
<p>
The timers are reset to zero when the status of a pump changes.
This is necessary to ensure the minimum pump runtime with rapidly changing loads.
</p>
<h4>Implementation details</h4>
<p>
A \"if\" condition is used to generate the stage up and down command as opposed
to a \"when\" condition. This means that the command remains true as long as the
condition is verified. This is necessary, for example, if no higher stage is 
available when a stage up command is triggered. Using a \"when\" condition &ndash;
which is only valid at the point in time at which the condition becomes true &ndash; 
would prevent the plant from staging when a higher stage becomes available again.
To avoid multiple consecutive stage changes, the block that receives the stage up
and down command and computes the stage index must enforce a minimum stage runtime
of <code>dtRun</code>.
</p>
</html>
"),
    Diagram(
      coordinateSystem(
        extent={{-120,-120},{120,120}})));
end StagingHeaderedDeltaP;
