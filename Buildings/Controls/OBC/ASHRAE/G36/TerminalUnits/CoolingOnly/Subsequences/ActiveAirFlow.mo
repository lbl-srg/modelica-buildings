within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences;
block ActiveAirFlow
  "Active maximum and minimum setpoints for cooling only terminal unit"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOccMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{120,50},{160,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{120,-50},{160,-10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active heating maximum airflow"
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal actCooMax(
    final realTrue=VCooMax_flow)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1)
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply actMin
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

equation
  connect(occMod.y, intEqu.u1)
    annotation (Line(points={{-78,100},{-62,100}}, color={255,127,0}));
  connect(intEqu2.u1, setUpMod.y)
    annotation (Line(points={{-62,-30},{-78,-30}}, color={255,127,0}));
  connect(cooDowMod.y, intEqu1.u1)
    annotation (Line(points={{-78,40},{-62,40}}, color={255,127,0}));
  connect(uOpeMod, intEqu.u2)
    annotation (Line(points={{-140,0},{-70,0},{-70,92},{-62,92}}, color={255,127,0}));
  connect(uOpeMod, intEqu1.u2) annotation (Line(points={{-140,0},{-70,0},{-70,32},
          {-62,32}},        color={255,127,0}));
  connect(uOpeMod, intEqu2.u2) annotation (Line(points={{-140,0},{-70,0},{-70,-38},
          {-62,-38}},     color={255,127,0}));
  connect(intEqu.y, or3.u1) annotation (Line(points={{-38,100},{-30,100},{-30,70},
          {-2,70}}, color={255,0,255}));
  connect(intEqu1.y, or3.u2) annotation (Line(points={{-38,40},{-20,40},{-20,62},
          {-2,62}},  color={255,0,255}));
  connect(intEqu.y, booToRea.u) annotation (Line(points={{-38,100},{-30,100},{-30,
          -60},{18,-60}},color={255,0,255}));
  connect(booToRea.y, actMin.u1) annotation (Line(points={{42,-60},{50,-60},{50,
          -74},{58,-74}}, color={0,0,127}));
  connect(VOccMin_flow, actMin.u2) annotation (Line(points={{-140,-100},{41,-100},
          {41,-86},{58,-86}}, color={0,0,127}));
  connect(actCooMax.y, VActCooMax_flow)
    annotation (Line(points={{102,70},{140,70}}, color={0,0,127}));
  connect(actMin.y, VActHeaMax_flow)
    annotation (Line(points={{82,-80},{140,-80}}, color={0,0,127}));
  connect(actMin.y, VActMin_flow) annotation (Line(points={{82,-80},{100,-80},{100,
          -30},{140,-30}}, color={0,0,127}));
  connect(or3.y, or2.u1)
    annotation (Line(points={{22,70},{38,70}}, color={255,0,255}));
  connect(intEqu2.y, or2.u2) annotation (Line(points={{-38,-30},{30,-30},{30,62},
          {38,62}}, color={255,0,255}));
  connect(or2.y, actCooMax.u)
    annotation (Line(points={{62,70},{78,70}}, color={255,0,255}));
annotation (defaultComponentName="actAirSet",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-54},{-32,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccMin_flow"),
        Text(
          extent={{-96,8},{-60,-4}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{32,-52},{98,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{32,68},{98,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{48,8},{98,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
Documentation(info="<html>
<p>
This block outputs the active maximum and minimum airflow setpoint for cooling only
terminal unit. The implementation is according to the Section 5.5.4 of ASHRAE
Guideline 36, May 2020.
</p>

<p>The setpoints shall vary depending on the mode of the zone group.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cooldown</th>
<th>Setup</th><th>Warm-up</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (<code>VActCooMax_flow</code>)</td><td><code>VCooMax_flow</code></td>
<td><code>VCooMax_flow</code></td><td><code>VCooMax_flow</code></td>
<td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (<code>VActMin_flow</code>)</td><td><code>VOccMin_flow</code></td>
<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Heating maximum (<code>VActHeaMax_flow</code>)</td><td><code>VOccMin_flow</code></td>
<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
</table>
<br/>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
