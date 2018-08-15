within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model Limits_LoopDisable
  "Validation model for the multi zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(final k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet1_flow(final k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet2_flow(final k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  // Fan Status
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(final k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));

  // Operation Mode
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "AHU operation mode is NOT Occupied"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  // Freeze Protection Stage
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut1_flow(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut2_flow(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits damLim
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits damLim1
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits damLim2
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));

protected
  final parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  final parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=0.2
    "Maximum increase in airflow volume during the example simulation";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus1(final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus2(final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod2(final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

equation
  connect(VOut_flow.y, damLim.VOut_flow_normalized) annotation (Line(points={{-179,
          70},{-140,70},{-140,-2},{-121,-2}}, color={0,0,127}));
  connect(VOutMinSet_flow.y, damLim.VOutMinSet_flow_normalized) annotation (
      Line(points={{-179,30},{-150,30},{-150,-5},{-121,-5}}, color={0,0,127}));
  connect(fanSta.y, damLim.uSupFan)
    annotation (Line(points={{-179,-10},{-160,-10},{-121,-10}}, color={255,0,255}));
  connect(freProSta.y, damLim.uFreProSta)
    annotation (Line(points={{-179,-90},{-140,-90},{-140,-18},{-121,-18}}, color={255,127,0}));
  connect(VOut1_flow.y, damLim1.VOut_flow_normalized) annotation (Line(points={
          {-39,70},{0,70},{0,-2},{19,-2}}, color={0,0,127}));
  connect(VOutMinSet1_flow.y, damLim1.VOutMinSet_flow_normalized) annotation (
      Line(points={{-39,30},{-10,30},{-10,-5},{19,-5}}, color={0,0,127}));
  connect(fanStatus1.y, damLim1.uSupFan)
    annotation (Line(points={{-39,-10},{-20,-10},{19,-10}}, color={255,0,255}));
  connect(freProSta1.y, damLim1.uFreProSta)
    annotation (Line(points={{-39,-90},{0,-90},{0,-18},{19,-18}}, color={255,127,0}));
  connect(VOut2_flow.y, damLim2.VOut_flow_normalized) annotation (Line(points={
          {101,70},{140,70},{140,-2},{159,-2}}, color={0,0,127}));
  connect(VOutMinSet2_flow.y, damLim2.VOutMinSet_flow_normalized) annotation (
      Line(points={{101,30},{130,30},{130,-5},{159,-5}}, color={0,0,127}));
  connect(fanStatus2.y, damLim2.uSupFan)
    annotation (Line(points={{101,-10},{120,-10},{159,-10}}, color={255,0,255}));
  connect(freProSta2.y, damLim2.uFreProSta)
    annotation (Line(points={{101,-90},{140,-90},{140,-18},{159,-18}},color={255,127,0}));
  connect(opeMod.y, damLim.uOpeMod)
    annotation (Line(points={{-179,-50},{-150,-50},{-150,-15},{-121,-15}}, color={255,127,0}));
  connect(opeMod1.y, damLim1.uOpeMod)
    annotation (Line(points={{-39,-50},{-10,-50},{-10,-15},{19,-15}}, color={255,127,0}));
  connect(opeMod2.y, damLim2.uOpeMod)
    annotation (Line(points={{101,-50},{130,-50},{130,-15},{159,-15}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/Limits_LoopDisable.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{
            220,120}}), graphics={
        Text(
          extent={{-200,110},{-166,98}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Fan is off"),
        Text(
          extent={{-60,114},{68,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Operation mode is other than occupied"),
        Text(
          extent={{80,114},{208,96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Freeze protection status is higher than 1")}),
Documentation(info="<html>
<p>
This example validates enable/disable conditions for
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits</a>
for the following input signals: <code>uSupFan</code>, <code>uFreProSta</code>, <code>uOpeMod</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Limits_LoopDisable;
