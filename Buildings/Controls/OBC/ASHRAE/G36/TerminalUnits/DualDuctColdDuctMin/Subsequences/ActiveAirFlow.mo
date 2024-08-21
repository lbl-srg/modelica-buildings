within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences;
block ActiveAirFlow
  "Output the active airflow setpoint for dual-duct terminal unit with cold-duct minimum control"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";
  parameter Real floHys(unit="m3/s")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOccMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,64},{-140,104}}),
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
    annotation (Placement(transformation(extent={{140,120},{180,160}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
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
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal actCooMax(
    final realTrue=VCooMax_flow)
    "Active cooling maximum flow"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal occModInd(
    final realTrue=1)
    "If in occupied mode, output 1"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Active cooling minimum, minimum airflow setpoint"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMaxFlo(
    final realTrue=VHeaMax_flow)
    "Heating maximum flow when input is true"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setBacMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setBack)
    "Setback mode"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant warUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm up mode"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifCooDow
    "Check if current operation mode is cooldown mode"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetUp
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifWarUp
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetBac
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if it is in occupied, warm-up, or setback mode"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Sum of minimum flow and cooling maximum flow"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: the sum of minimum flow and heating maximum flow is greater than the cooling maximum flow.")
    "Generate warning when the cooling maximum is less than the sum of heating maximum and the minimum flow"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if cooling maximum is greater than the sum of minimum and heating maximum flow"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMax(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMax(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if it is in occupied, warm-up, or setback mode"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

equation
  connect(occMod.y, ifOcc.u1)
    annotation (Line(points={{-98,130},{-82,130}},   color={255,127,0}));
  connect(cooDowMod.y, ifCooDow.u1)
    annotation (Line(points={{-98,60},{-82,60}},   color={255,127,0}));
  connect(setUpMod.y, ifSetUp.u1)
    annotation (Line(points={{-98,-10},{-82,-10}}, color={255,127,0}));
  connect(warUpMod.y, ifWarUp.u1)
    annotation (Line(points={{-98,-80},{-82,-80}},   color={255,127,0}));
  connect(uOpeMod, ifOcc.u2) annotation (Line(points={{-160,-40},{-90,-40},{-90,
          122},{-82,122}},  color={255,127,0}));
  connect(uOpeMod, ifCooDow.u2) annotation (Line(points={{-160,-40},{-90,-40},{-90,
          52},{-82,52}},  color={255,127,0}));
  connect(uOpeMod, ifSetUp.u2) annotation (Line(points={{-160,-40},{-90,-40},{-90,
          -18},{-82,-18}}, color={255,127,0}));
  connect(uOpeMod, ifWarUp.u2) annotation (Line(points={{-160,-40},{-90,-40},{-90,
          -88},{-82,-88}},  color={255,127,0}));
  connect(uOpeMod, ifSetBac.u2) annotation (Line(points={{-160,-40},{-90,-40},{-90,
          -148},{-82,-148}}, color={255,127,0}));
  connect(setBacMod.y, ifSetBac.u1)
    annotation (Line(points={{-98,-140},{-82,-140}}, color={255,127,0}));
  connect(ifOcc.y, or3.u1) annotation (Line(points={{-58,130},{-30,130},{-30,140},
          {-2,140}},  color={255,0,255}));
  connect(ifCooDow.y, or3.u2) annotation (Line(points={{-58,60},{-20,60},{-20,132},
          {-2,132}},  color={255,0,255}));
  connect(ifOcc.y, occModInd.u) annotation (Line(points={{-58,130},{-30,130},{-30,
          100},{38,100}},  color={255,0,255}));
  connect(VOccMin_flow, pro.u2)
    annotation (Line(points={{-160,84},{98,84}}, color={0,0,127}));
  connect(occModInd.y, pro.u1) annotation (Line(points={{62,100},{80,100},{80,96},
          {98,96}},   color={0,0,127}));
  connect(actCooMax.y, VActCooMax_flow)
    annotation (Line(points={{122,140},{160,140}}, color={0,0,127}));
  connect(pro.y, VActMin_flow) annotation (Line(points={{122,90},{160,90}},
          color={0,0,127}));
  connect(ifOcc.y, or1.u1) annotation (Line(points={{-58,130},{-30,130},{-30,-110},
          {-2,-110}},color={255,0,255}));
  connect(ifWarUp.y, or1.u2) annotation (Line(points={{-58,-80},{-40,-80},{-40,-118},
          {-2,-118}}, color={255,0,255}));
  connect(heaMaxFlo.y, VActHeaMax_flow)
    annotation (Line(points={{122,-110},{160,-110}}, color={0,0,127}));
  connect(heaMax.y, add2.u2) annotation (Line(points={{2,-70},{10,-70},{10,-56},
          {18,-56}}, color={0,0,127}));
  connect(cooMax.y, gre.u1)
    annotation (Line(points={{22,10},{58,10}}, color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{42,-50},{50,-50},{50,2},{58,
          2}}, color={0,0,127}));
  connect(gre.y, assMes.u)
    annotation (Line(points={{82,10},{98,10}}, color={255,0,255}));
  connect(VOccMin_flow, add2.u1) annotation (Line(points={{-160,84},{-50,84},{-50,
          -44},{18,-44}}, color={0,0,127}));
  connect(or3.y, or2.u1)
    annotation (Line(points={{22,140},{38,140}}, color={255,0,255}));
  connect(or2.y, actCooMax.u)
    annotation (Line(points={{62,140},{98,140}}, color={255,0,255}));
  connect(ifSetUp.y, or2.u2) annotation (Line(points={{-58,-10},{30,-10},{30,132},
          {38,132}}, color={255,0,255}));
  connect(or4.y, heaMaxFlo.u)
    annotation (Line(points={{62,-110},{98,-110}}, color={255,0,255}));
  connect(or1.y, or4.u1)
    annotation (Line(points={{22,-110},{38,-110}}, color={255,0,255}));
  connect(ifSetBac.y, or4.u2) annotation (Line(points={{-58,-140},{30,-140},{30,
          -118},{38,-118}}, color={255,0,255}));
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
for dual-duct terminal unit with cold-duct minimum control.
The implementation is according to the Section 5.14.4 of ASHRAE Guideline 36, May 2020.
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
<p>
Note that the designer must ensure that the minimum (<code>VOccMin_flow</code>) and heating
maximum (<code>VHeaMax_flow</code>) sum to less
than the cooling maximum (<code>VCooMax_flow</code>) to avoid oversupplying the diffusers.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
