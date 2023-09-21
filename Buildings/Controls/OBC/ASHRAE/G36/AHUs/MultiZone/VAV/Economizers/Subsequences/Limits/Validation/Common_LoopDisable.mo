within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Validation;
model Common_LoopDisable
  "Validation model for the multi zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VOutMinSet_flow(
    final k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VOutMinSet1_flow(
    final k=VOutSet_flow)
    "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  // Fan Status
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    final k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  // Operation Mode
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "AHU operation mode is NOT Occupied"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow) "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOut1_flow(
    final duration=1800,
    final offset=minVOutSet_flow,
    final height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common damLim
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common damLim1
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

protected
  final parameter Real VOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Real minVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  final parameter Real incVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.2
    "Maximum increase in airflow volume during the example simulation";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus1(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(VOut_flow.y, damLim.VOut_flow_normalized) annotation (Line(points={{-98,50},
          {-60,50},{-60,-26},{-42,-26}},      color={0,0,127}));
  connect(VOutMinSet_flow.y, damLim.VOutMinSet_flow_normalized) annotation (
      Line(points={{-98,10},{-70,10},{-70,-22},{-42,-22}},   color={0,0,127}));
  connect(fanSta.y, damLim.u1SupFan)
    annotation (Line(points={{-98,-30},{-42,-30}}, color={255,0,255}));
  connect(VOut1_flow.y, damLim1.VOut_flow_normalized) annotation (Line(points={{42,50},
          {80,50},{80,-26},{98,-26}},      color={0,0,127}));
  connect(VOutMinSet1_flow.y, damLim1.VOutMinSet_flow_normalized) annotation (
      Line(points={{42,10},{70,10},{70,-22},{98,-22}},  color={0,0,127}));
  connect(fanStatus1.y, damLim1.u1SupFan)
    annotation (Line(points={{42,-30},{98,-30}}, color={255,0,255}));
  connect(opeMod.y, damLim.uOpeMod)
    annotation (Line(points={{-98,-70},{-70,-70},{-70,-38},{-42,-38}},     color={255,127,0}));
  connect(opeMod1.y, damLim1.uOpeMod)
    annotation (Line(points={{42,-70},{70,-70},{70,-38},{98,-38}},    color={255,127,0}));

annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Limits/Validation/Common_LoopDisable.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
            120}}),     graphics={
        Text(
          extent={{-120,90},{-94,80}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Fan is off"),
        Text(
          extent={{20,94},{114,80}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Operation mode is other than occupied")}),
Documentation(info="<html>
<p>
This example validates enable/disable conditions for
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.Common</a>
for the following input signals: <code>u1SupFan</code>, <code>uFreProSta</code>, <code>uOpeMod</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Common_LoopDisable;
