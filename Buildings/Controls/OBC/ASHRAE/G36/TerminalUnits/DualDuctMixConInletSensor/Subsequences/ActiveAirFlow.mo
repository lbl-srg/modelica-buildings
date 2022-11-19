within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences;
block ActiveAirFlow
  "Output the active airflow setpoint for dual-duct terminal unit using mixing control with inlet flow sensor"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOccMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,54},{-140,94}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{140,-130},{180,-90}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal actCooMax(
    final realTrue=VCooMax_flow)
    "Active cooling maximum flow"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal occModInd(
    final realTrue=1)
    "If in occupied mode, output 1"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Active cooling minimum, minimum airflow setpoint"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMaxFlo(
    final realTrue=VHeaMax_flow)
    "Heating maximum flow when input is true"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setBacMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setBack)
    "Setback mode"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant warUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm up mode"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifCooDow
    "Check if current operation mode is cooldown mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetUp
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifWarUp
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetBac
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    "Check if it is in occupied, warm-up, or setback mode"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

equation
  connect(occMod.y, ifOcc.u1)
    annotation (Line(points={{-78,120},{-62,120}},   color={255,127,0}));
  connect(cooDowMod.y, ifCooDow.u1)
    annotation (Line(points={{-78,50},{-62,50}},   color={255,127,0}));
  connect(setUpMod.y, ifSetUp.u1)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={255,127,0}));
  connect(warUpMod.y, ifWarUp.u1)
    annotation (Line(points={{-78,-70},{-62,-70}},   color={255,127,0}));
  connect(uOpeMod, ifOcc.u2) annotation (Line(points={{-160,-40},{-70,-40},{-70,
          112},{-62,112}},  color={255,127,0}));
  connect(uOpeMod, ifCooDow.u2) annotation (Line(points={{-160,-40},{-70,-40},{-70,
          42},{-62,42}},  color={255,127,0}));
  connect(uOpeMod, ifSetUp.u2) annotation (Line(points={{-160,-40},{-70,-40},{-70,
          -18},{-62,-18}}, color={255,127,0}));
  connect(uOpeMod, ifWarUp.u2) annotation (Line(points={{-160,-40},{-70,-40},{-70,
          -78},{-62,-78}},  color={255,127,0}));
  connect(uOpeMod, ifSetBac.u2) annotation (Line(points={{-160,-40},{-70,-40},{-70,
          -148},{-62,-148}}, color={255,127,0}));
  connect(setBacMod.y, ifSetBac.u1)
    annotation (Line(points={{-78,-140},{-62,-140}}, color={255,127,0}));
  connect(ifOcc.y, or3.u1) annotation (Line(points={{-38,120},{0,120},{0,138},{38,
          138}},      color={255,0,255}));
  connect(ifCooDow.y, or3.u2) annotation (Line(points={{-38,50},{-10,50},{-10,130},
          {38,130}},  color={255,0,255}));
  connect(ifSetUp.y, or3.u3) annotation (Line(points={{-38,-10},{10,-10},{10,122},
          {38,122}},  color={255,0,255}));
  connect(or3.y, actCooMax.u)
    annotation (Line(points={{62,130},{98,130}}, color={255,0,255}));
  connect(ifOcc.y, occModInd.u) annotation (Line(points={{-38,120},{0,120},{0,90},
          {38,90}},        color={255,0,255}));
  connect(VOccMin_flow, pro.u2)
    annotation (Line(points={{-160,74},{98,74}}, color={0,0,127}));
  connect(occModInd.y, pro.u1) annotation (Line(points={{62,90},{80,90},{80,86},
          {98,86}},   color={0,0,127}));
  connect(actCooMax.y, VActCooMax_flow)
    annotation (Line(points={{122,130},{160,130}}, color={0,0,127}));
  connect(pro.y, VActMin_flow) annotation (Line(points={{122,80},{160,80}},
          color={0,0,127}));
  connect(ifOcc.y, or1.u1) annotation (Line(points={{-38,120},{0,120},{0,-102},{
          38,-102}}, color={255,0,255}));
  connect(ifWarUp.y, or1.u2) annotation (Line(points={{-38,-70},{-20,-70},{-20,-110},
          {38,-110}}, color={255,0,255}));
  connect(ifSetBac.y, or1.u3) annotation (Line(points={{-38,-140},{0,-140},{0,-118},
          {38,-118}}, color={255,0,255}));
  connect(or1.y, heaMaxFlo.u)
    annotation (Line(points={{62,-110},{98,-110}}, color={255,0,255}));
  connect(heaMaxFlo.y, VActHeaMax_flow)
    annotation (Line(points={{122,-110},{160,-110}}, color={0,0,127}));

annotation (
  defaultComponentName="actAirSet",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})),
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
          extent={{-96,-72},{-54,-88}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{34,90},{98,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{50,6},{98,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{34,-70},{98,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,88},{-36,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccMin_flow")}),
Documentation(info="<html>
<p>
This sequence sets the active cooling and heating maximum and the active minimum setpoints
for dual-duct terminal unit using mixing control with inlet flow sensor.
The implementation is according to the Section 5.12.4 of ASHRAE Guideline 36, May 2020.
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
<tr><td>Heating maximum (<code>VActHeaMax_flow</code>)</td><td><code>VHeaMax_flow</code></td>
<td>0</td><td>0</td><td><code>VHeaMax_flow</code></td><td><code>VHeaMax_flow</code></td>
<td>0</td></tr>
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
