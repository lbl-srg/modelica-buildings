within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences;
block ActiveAirFlow
  "Output the active airflow setpoint for variable-volume series fan-powered terminal unit"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOccMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{140,-70},{180,-30}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal actCooMax(
    final realTrue=VCooMax_flow)
    "Active cooling maximum flow"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal occModInd(
    final realTrue=1)
    "If in occupied mode, output 1"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Active cooling minimum, minimum airflow setpoint"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifCooDow
    "Check if current operation mode is cooldown mode"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetUp
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(occMod.y, ifOcc.u1)
    annotation (Line(points={{-78,70},{-62,70}}, color={255,127,0}));
  connect(cooDowMod.y, ifCooDow.u1)
    annotation (Line(points={{-78,0},{-62,0}}, color={255,127,0}));
  connect(setUpMod.y, ifSetUp.u1)
    annotation (Line(points={{-78,-60},{-62,-60}}, color={255,127,0}));
  connect(uOpeMod, ifOcc.u2) annotation (Line(points={{-160,30},{-70,30},{-70,62},
          {-62,62}}, color={255,127,0}));
  connect(uOpeMod, ifCooDow.u2) annotation (Line(points={{-160,30},{-70,30},{-70,
          -8},{-62,-8}}, color={255,127,0}));
  connect(uOpeMod, ifSetUp.u2) annotation (Line(points={{-160,30},{-70,30},{-70,
          -68},{-62,-68}}, color={255,127,0}));
  connect(ifOcc.y, or3.u1) annotation (Line(points={{-38,70},{0,70},{0,58},{18,58}},
          color={255,0,255}));
  connect(ifCooDow.y, or3.u2) annotation (Line(points={{-38,0},{-10,0},{-10,50},
          {18,50}}, color={255,0,255}));
  connect(ifSetUp.y, or3.u3) annotation (Line(points={{-38,-60},{10,-60},{10,42},
          {18,42}}, color={255,0,255}));
  connect(or3.y, actCooMax.u)
    annotation (Line(points={{42,50},{78,50}},   color={255,0,255}));
  connect(ifOcc.y, occModInd.u) annotation (Line(points={{-38,70},{0,70},{0,10},
          {18,10}}, color={255,0,255}));
  connect(VOccMin_flow, pro.u2) annotation (Line(points={{-160,-80},{60,-80},{60,
          -56},{78,-56}}, color={0,0,127}));
  connect(occModInd.y, pro.u1) annotation (Line(points={{42,10},{60,10},{60,-44},
          {78,-44}},  color={0,0,127}));
  connect(actCooMax.y, VActCooMax_flow)
    annotation (Line(points={{102,50},{160,50}}, color={0,0,127}));
  connect(pro.y, VActMin_flow) annotation (Line(points={{102,-50},{160,-50}},
          color={0,0,127}));

annotation (
  defaultComponentName="actAirSet",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,68},{-54,52}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{34,70},{98,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{50,-54},{98,-64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-98,-52},{-36,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccMin_flow")}),
Documentation(info="<html>
<p>
This sequence sets the active cooling maximum and minimum setpoints
for series fan-powered terminal unit with variable volume fan. The implementation
is according to the Section 5.10.4 of ASHRAE Guideline 36, May 2020.
</p>
<p>The setpoints shall vary depending on the mode of the zone group.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cooldown</th>
<th>Setup</th><th>Warm-up</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (<code>VActCooMax_flow</code>)</td><td><code>VCooMax_flow</code></td>
<td><code>VCooMax_flow</code></td><td><code>VCooMax_flow</code></td>
<td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (<code>VActMin_flow</code>)</td><td><code>VOccMin_flow</code></td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
