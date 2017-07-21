within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow
  "Validation model for the Single zone VAV AHU minimum outdoor air control - damper position limits"
  extends Modelica.Icons.Example;

  parameter Real minFanSpe=0.1 "Minimum supply fan operation speed";
  parameter Real maxFanSpe=0.9 "Maximum supply fan operation speed";
  parameter Real delFanSpe = maxFanSpe - minFanSpe "Delta between the min and max supply fan speed";
  parameter Real fanSpe = (maxFanSpe + minFanSpe)/2 "Constant supply fan speed";
  parameter Modelica.SIunits.VolumeFlowRate desVOut_flow=2.0 "Calculated design outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=1.0 "Calculated minimum outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate delVOut_flow = desVOut_flow - minVOut_flow
    "Delta between minimum and design outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=(desVOut_flow + minVOut_flow)/2
    "Constant minimum outdoor airflow setpoint";

  CDL.Continuous.Sources.Constant VOutMinSetSig(k=VOutSet_flow)
    "Constant minimum outdoor airflow setpoint" annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Sources.Ramp SupFanSpeSig(
    duration=1800,
    offset=minFanSpe,
    height=delFanSpe) "Supply fan speed signal" annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  EconDamperPositionLimitsSingleZone ecoDamLim(
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

protected
  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "Operation mode is Occupied";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for Occupied operation mode";

  CDL.Logical.Sources.Constant fanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Integers.Sources.Constant freProSta(k=freProDisabledNum) "Freeze protection status - disabled"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  CDL.Integers.Sources.Constant operationMode(k=occupiedNum) "Operation mode - occupied"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

public
  CDL.Continuous.Sources.Constant SupFanSpeSig1(k=fanSpe)                    "Supply fan speed signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Ramp VOutMinSetSig1(
    duration=1800,
    offset=minVOut_flow,
    height=delVOut_flow) "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  EconDamperPositionLimitsSingleZone ecoDamLim1(
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow)
    "Single zone VAV AHU minimum outdoor air control - damper position limits"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

equation
  connect(freProSta.y, ecoDamLim.uFreProSta)
    annotation (Line(points={{-99,-90},{-60,-90},{-60,-18},{-41,-18}},
                                                                   color={255,127,0}));
  connect(ecoDamLim.uSupFan, fanStatus.y)
    annotation (Line(points={{-41,-12},{-70,-12},{-70,-10},{-99,-10}}, color={255,0,255}));
  connect(operationMode.y, ecoDamLim.uOpeMod)
    annotation (Line(points={{-99,-50},{-70,-50},{-70,-16},{-70,-16},{-70,-15},{-56,-15},{-41,-15}},
                                                                       color={255,127,0}));
  connect(fanStatus.y, ecoDamLim1.uSupFan)
    annotation (Line(points={{-99,-10},{-80,-10},{-80,-30},{60,-30},{60,-12},{99,-12}}, color={255,0,255}));
  connect(operationMode.y, ecoDamLim1.uOpeMod)
    annotation (Line(points={{-99,-50},{70,-50},{70,-16},{70,-15},{80,-15},{99,-15}}, color={255,127,0}));
  connect(freProSta.y, ecoDamLim1.uFreProSta)
    annotation (Line(points={{-99,-90},{80,-90},{80,-18},{99,-18}}, color={255,127,0}));
  connect(VOutMinSetSig.y, ecoDamLim.uVOutMinSet_flow)
    annotation (Line(points={{-99,70},{-60,70},{-60,-3},{-41,-3}}, color={0,0,127}));
  connect(SupFanSpeSig.y, ecoDamLim.uSupFanSpe)
    annotation (Line(points={{-99,30},{-70,30},{-70,-6.2},{-41,-6.2}}, color={0,0,127}));
  connect(SupFanSpeSig1.y, ecoDamLim1.uSupFanSpe)
    annotation (Line(points={{41,30},{70,30},{70,-6.2},{99,-6.2}}, color={0,0,127}));
  connect(VOutMinSetSig1.y, ecoDamLim1.uVOutMinSet_flow)
    annotation (Line(points={{41,70},{80,70},{80,-3},{99,-3}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow.mos"
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
