within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Validation;
model Limits_VOut_flow
  "Validation model for the multi zone VAV AHU minimum outdoor air control - damper position limits"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    k=minVOutSet_flow)
    "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=VOutMin_flow,
    height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits
    damLim
    "Multi zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

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

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection status 0 - disabled"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant operationMode(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Operation mode is Occupied"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(VOut_flow.y, damLim.VOut_flow_normalized)
    annotation (Line(points={{-38,80},{0,80},{0,4},{18,4}}, color={0,0,127}));
  connect(VOutMinSet_flow.y, damLim.VOutMinSet_flow_normalized) annotation (
      Line(points={{-38,40},{-10,40},{-10,8},{18,8}}, color={0,0,127}));
  connect(fanStatus.y, damLim.uSupFan)
    annotation (Line(points={{-38,0},{18,0}},  color={255,0,255}));
  connect(freProSta.y, damLim.uFreProSta)
    annotation (Line(points={{-38,-80},{0,-80},{0,-4},{18,-4}},    color={255,127,0}));
  connect(operationMode.y, damLim.uOpeMod)
    annotation (Line(points={{-38,-40},{-10,-40},{-10,-8},{18,-8}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Economizers/Subsequences/Validation/Limits_VOut_flow.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},{80,100}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>. The control loop is always enabled in this
example.
</p>
</html>", revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Limits_VOut_flow;
