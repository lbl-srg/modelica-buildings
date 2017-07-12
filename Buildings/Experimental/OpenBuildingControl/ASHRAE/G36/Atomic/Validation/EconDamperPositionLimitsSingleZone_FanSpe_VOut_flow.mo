within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow
  "Validation model for the Singleple zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.61
    "Minimal measured volumetric airflow";
  parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=0.2
    "Maximum volumetric airflow increase during the example simulation";

  CDL.Continuous.Constant VOutMinSet_flow(k=minVOutSet_flow)
    "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.Ramp VOut_flow(
    duration=1800,
    offset=minVOut_flow,
    height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  EconDamperPositionLimitsSingleZone ecoDamLim
    "Singleple zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

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
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  CDL.Integers.Constant operationMode(k=occupiedNum) "Operation mode - occupied"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

public
  CDL.Continuous.Constant VOutMinSet_flow1(
                                          k=minVOutSet_flow)
    "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Sources.Ramp VOut_flow1(
    duration=1800,
    offset=minVOut_flow,
    height=incVOutSet_flow)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  EconDamperPositionLimitsSingleZone ecoDamLim1
    "Singleple zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  CDL.Logical.Constant fanStatus1(
                                 k=true) "Fan is on"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Integers.Constant freProSta1(
                                  k=freProDisabledNum) "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  CDL.Integers.Constant operationMode1(
                                      k=occupiedNum) "Operation mode - occupied"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(VOut_flow.y, ecoDamLim.VOut_flow) annotation (Line(points={{-99,80},{-60,80},{-60,8},{-41,8}},
                                                                                                   color={0,0,127}));
  connect(VOutMinSet_flow.y, ecoDamLim.VOutMinSet_flow)
    annotation (Line(points={{-99,40},{-70,40},{-70,5},{-41,5}},
                                                               color={0,0,127}));
  connect(fanStatus.y, ecoDamLim.uSupFan)
    annotation (Line(points={{-99,0},{-36.1111,0},{-36.1111,-1.76471}},
                                                     color={255,0,255}));
  connect(freProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-99,-80},{-60,-80},{-60,-6.47059},{-36.1111,-6.47059}},
                                                                   color={255,127,0}));
  connect(operationMode.y, ecoDamLim.uOpeMod)
    annotation (Line(points={{-99,-40},{-70,-40},{-70,-5},{-41,-5}},color={255,127,0}));
  connect(VOut_flow1.y, ecoDamLim1.VOut_flow)
    annotation (Line(points={{41,80},{80,80},{80,8},{99,8}}, color={0,0,127}));
  connect(VOutMinSet_flow1.y, ecoDamLim1.VOutMinSet_flow)
    annotation (Line(points={{41,40},{70,40},{70,5},{99,5}}, color={0,0,127}));
  connect(fanStatus1.y, ecoDamLim1.uSupFan) annotation (Line(points={{41,0},{103.889,0},{103.889,-1.76471}},
                                                                                            color={255,0,255}));
  connect(freProSta1.y, ecoDamLim1.uFreProSta)
    annotation (Line(points={{41,-80},{80,-80},{80,-6.47059},{103.889,-6.47059}},
                                                                 color={255,127,0}));
  connect(operationMode1.y, ecoDamLim1.uOpeMod)
    annotation (Line(points={{41,-40},{70,-40},{70,-5},{99,-5}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsSingleZone_VOut_flow.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{160,120}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsSingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsSingleZone</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>. The control loop is always enabled in this
example.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow;
