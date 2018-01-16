within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Validation;
model Limits_FanSpe_VOut_flow
  "Validation model for the Single zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow) "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim1(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow) "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

protected
  final parameter Real yFanMin=0.1 "Minimum supply fan operation speed";
  final parameter Real yFanMax=0.9 "Maximum supply fan operation speed";
  final parameter Real fanSpe = (yFanMax + yFanMin)/2 "Constant supply fan speed";
  final parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
    "Calculated design outdoor airflow rate";
  final parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
    "Calculated minimum outdoor airflow rate";
  final parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=(VOutDes_flow + VOutMin_flow)/2
    "Constant minimum outdoor airflow setpoint";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Operation mode - occupied"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSetSig(
    final k=VOutSet_flow)
    "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=yFanMin,
    final height=yFanMax - yFanMin) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOutMinSetSig1(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow) "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant SupFanSpeSig1(
    final k=fanSpe) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

equation
  connect(freProSta.y, damLim.uFreProSta)
    annotation (Line(points={{-99,-90},{-60,-90},{-60,-18},{-41,-18}}, color={255,127,0}));
  connect(damLim.uSupFan, fanStatus.y)
    annotation (Line(points={{-41,-12},{-70,-12},{-70,-10},{-99,-10}}, color={255,0,255}));
  connect(operationMode.y, damLim.uOpeMod)
    annotation (Line(points={{-99,-50},{-70,-50},{-70,-16},{-70,-15},{-56,-15},{-41,-15}},
    color={255,127,0}));
  connect(fanStatus.y, damLim1.uSupFan)
    annotation (Line(points={{-99,-10},{-80,-10},{-80,-30},{60,-30},{60,-12},{99,-12}}, color={255,0,255}));
  connect(operationMode.y, damLim1.uOpeMod)
    annotation (Line(points={{-99,-50},{70,-50},{70,-16},{70,-15},{80,-15},{99,-15}}, color={255,127,0}));
  connect(freProSta.y, damLim1.uFreProSta)
    annotation (Line(points={{-99,-90},{80,-90},{80,-18},{99,-18}}, color={255,127,0}));
  connect(VOutMinSetSig.y, damLim.VOutMinSet_flow)
    annotation (Line(points={{-99,70},{-60,70},{-60,-3},{-41,-3}}, color={0,0,127}));
  connect(SupFanSpeSig.y, damLim.uSupFanSpe)
    annotation (Line(points={{-99,30},{-70,30},{-70,-6.2},{-41,-6.2}}, color={0,0,127}));
  connect(SupFanSpeSig1.y, damLim1.uSupFanSpe)
    annotation (Line(points={{41,30},{70,30},{70,-6.2},{99,-6.2}}, color={0,0,127}));
  connect(VOutMinSetSig1.y, damLim1.VOutMinSet_flow)
    annotation (Line(points={{41,70},{80,70},{80,-3},{99,-3}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/Economizers/Subsequences/Validation/Limits_FanSpe_VOut_flow.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}}), graphics={
        Text(
          extent={{-120,116},{-86,104}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Variable supply fan speed,
constant minimum outdoor airflow setpoint"),
        Text(
          extent={{0,112},{34,100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=16,
          textString="Variable minimum outdoor airflow setpoint,
constant supply fan speed
")}),
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
end Limits_FanSpe_VOut_flow;
