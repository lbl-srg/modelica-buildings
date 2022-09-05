within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Validation;
model Limits_FanSpe_VOut_flow
  "Validation model for the Single zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
    damLim(
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
    damLim1(
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

protected
  final parameter Real supFanSpe_min=0.1 "Minimum supply fan operation speed";
  final parameter Real supFanSpe_max=0.9 "Maximum supply fan operation speed";
  final parameter Real fanSpe = (supFanSpe_max + supFanSpe_min)/2 "Constant supply fan speed";
  final parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate";
  final parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate";
  final parameter Real VOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=(VOutDes_flow + VOutMin_flow)/2
    "Constant minimum outdoor airflow setpoint";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Operation mode - occupied"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSetSig(
    final k=VOutSet_flow)
    "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=supFanSpe_min,
    final height=supFanSpe_max - supFanSpe_min) "Supply fan speed signal"
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
    annotation (Line(points={{-98,-90},{-60,-90},{-60,-14},{-42,-14}}, color={255,127,0}));
  connect(damLim.u1SupFan, fanStatus.y) annotation (Line(points={{-42,-10},{-70,
          -10},{-70,-10},{-98,-10}}, color={255,0,255}));
  connect(operationMode.y, damLim.uOpeMod)
    annotation (Line(points={{-98,-50},{-70,-50},{-70,-18.2},{-42,-18.2}},
    color={255,127,0}));
  connect(fanStatus.y, damLim1.u1SupFan) annotation (Line(points={{-98,-10},{-80,
          -10},{-80,-30},{60,-30},{60,-10},{98,-10}}, color={255,0,255}));
  connect(operationMode.y, damLim1.uOpeMod)
    annotation (Line(points={{-98,-50},{70,-50},{70,-18.2},{98,-18.2}}, color={255,127,0}));
  connect(freProSta.y, damLim1.uFreProSta)
    annotation (Line(points={{-98,-90},{80,-90},{80,-14},{98,-14}}, color={255,127,0}));
  connect(VOutMinSetSig.y, damLim.VOutMinSet_flow)
    annotation (Line(points={{-98,70},{-60,70},{-60,-2},{-42,-2}}, color={0,0,127}));
  connect(SupFanSpeSig.y, damLim.uSupFan_actual) annotation (Line(points={{-98,
          30},{-70,30},{-70,-6},{-42,-6}}, color={0,0,127}));
  connect(SupFanSpeSig1.y, damLim1.uSupFan_actual) annotation (Line(points={{42,
          30},{70,30},{70,-6},{98,-6}}, color={0,0,127}));
  connect(VOutMinSetSig1.y, damLim1.VOutMinSet_flow)
    annotation (Line(points={{42,70},{80,70},{80,-2},{98,-2}}, color={0,0,127}));
annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/Validation/Limits_FanSpe_VOut_flow.mos"
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
          extent={{-126,114},{-2,98}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Variable supply fan speed,
constant minimum outdoor airflow setpoint"),
        Text(
          extent={{8,110},{140,96}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Variable minimum outdoor airflow setpoint,
constant supply fan speed
")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits</a>
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
