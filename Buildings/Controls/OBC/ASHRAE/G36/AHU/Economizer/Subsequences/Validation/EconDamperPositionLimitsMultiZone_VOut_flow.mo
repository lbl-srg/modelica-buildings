within Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.Validation;
model EconDamperPositionLimitsMultiZone_VOut_flow
  "Validation model for the multiple zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  CDL.Continuous.Sources.Constant VOutMinSet_flow(k=minVOutSet_flow)
    "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Ramp VOut_flow(
    duration=1800,
    offset=minVOut_flow,
    height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  EconDamperPositionLimitsMultiZone ecoDamLim
    "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.61
    "Minimal measured volumetric airflow";
  parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=(minVOutSet_flow-minVOut_flow)*2
    "Maximum volumetric airflow increase during the example simulation";

  CDL.Logical.Sources.Constant fanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Integers.Sources.Constant freProSta(k=Constants.FreezeProtectionStages.stage0)
    "Freeze protection status 0 - disabled"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  CDL.Integers.Sources.Constant operationMode(k=Constants.OperationModes.occModInd)
    "Operation mode is Occupied"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(VOut_flow.y, ecoDamLim.VOut_flow) annotation (Line(points={{-39,80},{0,80},{0,8},{19,8}},color={0,0,127}));
  connect(VOutMinSet_flow.y, ecoDamLim.VOutMinSet_flow)
    annotation (Line(points={{-39,40},{-10,40},{-10,5},{19,5}},color={0,0,127}));
  connect(fanStatus.y, ecoDamLim.uSupFan)
    annotation (Line(points={{-39,0},{-20,0},{19,0}},color={255,0,255}));
  connect(freProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-39,-80},{0,-80},{0,-8},{19,-8}},    color={255,127,0}));
  connect(operationMode.y, ecoDamLim.uOpeMod)
    annotation (Line(points={{-39,-40},{-10,-40},{-10,-5},{19,-5}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/Economizer/Subsequences/Validation/EconDamperPositionLimitsMultiZone_VOut_flow.mos"
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconDamperPositionLimitsMultiZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconDamperPositionLimitsMultiZone</a>
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
end EconDamperPositionLimitsMultiZone_VOut_flow;
