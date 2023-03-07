within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Validation;
model SeparateWithAFMS
  "Validation model for the minimum outdoor air control - damper position limits for the units with separated outdoor air control"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS disMinCon(
    final minSpe=0.1)
    "Disable the minimum outdoor air control due to that the supply fan is not proven on"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS disMinCon1(
    final minSpe=0.1)
    "Disable the minimum outdoor air control due to that it is not in occupied mode"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS minCon(
    final minSpe=0.1)
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{200,10},{220,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

protected
  parameter Real minVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.61
    "Minimal measured volumetric airflow";
  parameter Real incVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=(minVOutSet_flow-VOutMin_flow)*2
    "Maximum volumetric airflow increase during the example simulation";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Operation mode is Occupied"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow1(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    final k=false)
    "Fan is off"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow1(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDamPos(
    final duration=1800,
    final offset=0.1,
    final height=0.5) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supFanSpe(
    final k=0) "Supply fan speed"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow2(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta1(
    final k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow2(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow) "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDamPos1(
    final duration=1800,
    final offset=0.1,
    final height=0.5) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supFanSpe1(
    final k=0.2) "Supply fan speed"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp outDamPos2(
    final duration=1800,
    final offset=0.1,
    final height=0.5) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp supFanSpe2(
    final height=0.5,
    final duration=1800,
    final offset=0.1)
    "Supply fan speed"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));

equation
  connect(VOut_flow.y,minCon. VOut_flow_normalized)
    annotation (Line(points={{142,100},{170,100},{170,26},{198,26}}, color={0,0,127}));
  connect(VOutMinSet_flow.y,minCon. VOutMinSet_flow_normalized) annotation (
      Line(points={{142,60},{160,60},{160,29},{198,29}}, color={0,0,127}));
  connect(fanStatus.y, minCon.u1SupFan) annotation (Line(points={{142,20},{160,
          20},{160,23},{198,23}}, color={255,0,255}));
  connect(operationMode.y,minCon. uOpeMod)
    annotation (Line(points={{142,-20},{160,-20},{160,17},{198,17}},color={255,127,0}));
  connect(VOutMinSet_flow1.y, disMinCon.VOutMinSet_flow_normalized) annotation (
     Line(points={{-198,60},{-180,60},{-180,29},{-142,29}}, color={0,0,127}));
  connect(VOut_flow1.y, disMinCon.VOut_flow_normalized) annotation (Line(points=
         {{-198,100},{-170,100},{-170,26},{-142,26}}, color={0,0,127}));
  connect(fanSta.y, disMinCon.u1SupFan) annotation (Line(points={{-198,20},{-180,
          20},{-180,23},{-142,23}}, color={255,0,255}));
  connect(opeMod.y, disMinCon.uOpeMod) annotation (Line(points={{-198,-20},{-180,
          -20},{-180,17},{-142,17}}, color={255,127,0}));
  connect(outDamPos.y, disMinCon.uOutDam) annotation (Line(points={{-198,-60},{
          -170,-60},{-170,14},{-142,14}}, color={0,0,127}));
  connect(supFanSpe.y, disMinCon.uSupFan) annotation (Line(points={{-198,-100},
          {-160,-100},{-160,11},{-142,11}}, color={0,0,127}));
  connect(VOutMinSet_flow2.y, disMinCon1.VOutMinSet_flow_normalized)
    annotation (Line(points={{-38,60},{-20,60},{-20,29},{18,29}}, color={0,0,127}));
  connect(VOut_flow2.y, disMinCon1.VOut_flow_normalized) annotation (Line(
        points={{-38,100},{-10,100},{-10,26},{18,26}}, color={0,0,127}));
  connect(fanSta1.y, disMinCon1.u1SupFan) annotation (Line(points={{-38,20},{-20,
          20},{-20,23},{18,23}}, color={255,0,255}));
  connect(opeMod1.y, disMinCon1.uOpeMod) annotation (Line(points={{-38,-20},{-20,
          -20},{-20,17},{18,17}}, color={255,127,0}));
  connect(outDamPos1.y, disMinCon1.uOutDam) annotation (Line(points={{-38,-60},
          {-10,-60},{-10,14},{18,14}}, color={0,0,127}));
  connect(supFanSpe1.y, disMinCon1.uSupFan) annotation (Line(points={{-38,-100},
          {0,-100},{0,11},{18,11}}, color={0,0,127}));
  connect(outDamPos2.y, minCon.uOutDam) annotation (Line(points={{142,-60},{170,
          -60},{170,14},{198,14}}, color={0,0,127}));
  connect(supFanSpe2.y, minCon.uSupFan) annotation (Line(points={{142,-100},{
          180,-100},{180,11},{198,11}}, color={0,0,127}));

annotation (experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Limits/Validation/SeparateWithAFMS.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-120},{240,120}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithAFMS</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SeparateWithAFMS;
