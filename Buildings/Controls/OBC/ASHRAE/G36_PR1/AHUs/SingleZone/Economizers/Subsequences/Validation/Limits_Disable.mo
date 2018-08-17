within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Validation;
model Limits_Disable
  "Validation model for the Single zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim1(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim2(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim3(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));

protected
  final parameter Real yFanMin=0.1 "Minimum supply fan operation speed";
  final parameter Real yFanMax=0.9 "Maximum supply fan operation speed";
  final parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
    "Calculated design outdoor airflow rate";
  final parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
    "Calculated minimum outdoor airflow rate";
  final parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.61
    "Volumetric airflow sensor output, minimum value in the example";
  final parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=0.2
    "Maximum increase in airflow volume during the example simulation";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=yFanMin,
    final height=yFanMax - yFanMin) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOutMinSetSig(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow) "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus1(
    final k=false) "Fan is off"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta1(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus2(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage is 1"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode2(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "AHU operation mode is NOT occupied"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus3(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta3(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode3(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

equation
  connect(SupFanSpeSig.y, damLim1.uSupFanSpe)
    annotation (Line(points={{-139,30},{-120,30},{-120,-6},{-120,-6.2},{-110,-6.2},{-101,-6.2}},
    color={0,0,127}));
  connect(VOutMinSetSig.y, damLim2.VOutMinSet_flow)
    annotation (Line(points={{-139,70},{-10,70},{-10,-3},{6,-3},{19,-3}}, color={0,0,127}));
  connect(fanStatus1.y, damLim1.uSupFan)
    annotation (Line(points={{-139,-30},{-130,-30},{-130,-12},{-130,-12},{-102,-12},{-101,-12}},
    color={255,0,255}));
  connect(freProSta1.y, damLim1.uFreProSta)
    annotation (Line(points={{-139,-90},{-110,-90},{-110,-18},{-101,-18}}, color={255,127,0}));
  connect(operationMode1.y, damLim1.uOpeMod)
    annotation (Line(points={{-139,-60},{-120,-60},{-120,-15},{-101,-15}}, color={255,127,0}));
  connect(fanStatus2.y,damLim2. uSupFan)
    annotation (Line(points={{-19,-30},{-10,-30},{-10,-12},{19,-12}}, color={255,0,255}));
  connect(freProSta2.y,damLim2. uFreProSta)
    annotation (Line(points={{-19,-90},{10,-90},{10,-18},{19,-18}}, color={255,127,0}));
  connect(operationMode2.y,damLim2. uOpeMod)
    annotation (Line(points={{-19,-60},{0,-60},{0,-58},{0,-15},{10,-15},{19,-15}},
      color={255,127,0}));
  connect(fanStatus3.y,damLim3. uSupFan)
    annotation (Line(points={{101,-30},{102,-30},{110,-30},{110,-12},{139,-12}},
    color={255,0,255}));
  connect(freProSta3.y,damLim3. uFreProSta)
    annotation (Line(points={{101,-90},{130,-90},{130,-18},{139,-18}},color={255,127,0}));
  connect(operationMode3.y,damLim3. uOpeMod)
    annotation (Line(points={{101,-60},{120,-60},{120,-16},{120,-15},{130,-15},{139,-15}},
    color={255,127,0}));
  connect(VOutMinSetSig.y, damLim3.VOutMinSet_flow)
    annotation (Line(points={{-139,70},{130,70},{130,40},{130,-3},{134,-3},{139,-3}},
    color={0,0,127}));
  connect(VOutMinSetSig.y, damLim1.VOutMinSet_flow)
    annotation (Line(points={{-139,70},{-110,70},{-110,14},{-110,-3},{-104,-3},{-101,-3}},
    color={0,0,127}));
  connect(SupFanSpeSig.y, damLim2.uSupFanSpe)
    annotation (Line(points={{-139,30},{-20,30},{-20,-6},{0,-6},{0,-6.2},{19,-6.2}},
    color={0,0,127}));
  connect(SupFanSpeSig.y, damLim3.uSupFanSpe)
    annotation (Line(points={{-139,30},{120,30},{120,-6},{130,-6},{130,-6.2},{139,-6.2}},
    color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/Economizers/Subsequences/Validation/Limits_Disable.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}), graphics={
        Text(
          extent={{-160,112},{-126,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Fan status"),
        Text(
          extent={{-40,112},{-6,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Operation mode"),
        Text(
          extent={{80,112},{114,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Freeze protection stage")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>.
The control loop is always enabled in this example.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Limits_Disable;
