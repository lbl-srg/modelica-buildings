within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconDamperPositionLimitsMultiZone_VOut_flow
  "Validation model for the multiple zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.61
    "Minimal measured volumetric airflow";
  parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=0.2
    "Maximum volumetric airflow increase during the example simulation";

  CDL.Continuous.Constant VOutMinSet_flow(k=minVOutSet_flow)
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
  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "Operation mode is Occupied";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for Occupied operation mode";

  CDL.Logical.Constant fanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  CDL.Integers.Constant operationMode(k=occupiedNum) "Operation mode - occupied"
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
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsMultiZone_VOut_flow.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(extent={{-80,-100},{80,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},{80,100}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a>
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
