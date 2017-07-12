within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.Validation;
model EconomizerSingleZone_Disable
  "Validation model for disabling the single zone VAV AHU economizer modulation and damper position limit control loops"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TOutCutoff=297
    "Outdoor temperature high limit cutoff";
  parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";
  parameter Modelica.SIunits.Temperature TSupSet=291 "Supply air temperature setpoint";
  parameter Real delFanSpe = maxFanSpe - minFanSpe "Delta between the min and max supply fan speed";
  parameter Modelica.SIunits.VolumeFlowRate delVOut_flow = desVOut_flow - minVOut_flow
    "Delta between minimum and design outdoor airflow rate";

  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0";
  parameter Types.FreezeProtectionStage freProEnabled = Types.FreezeProtectionStage.stage2
    "Indicates that the freeze protection is enabled";
  parameter Integer freProEnabledNum = Integer(freProEnabled)-1
    "Numerical value for freeze protection stage 2";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "AHU operation mode is Occupied";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for Occupied AHU operation mode";
  parameter Types.ZoneState heating = Types.ZoneState.heating
    "Zone state is heating";
  parameter Integer heatingNum = Integer(heating)
    "Numerical value for heating zone state";

  EconomizerSingleZone economizer(use_enthalpy=true,
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow)                      "Singlezone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Logical.Constant fanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Integers.Constant ZoneState(k=heatingNum) "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  CDL.Integers.Constant OperationMode(k=occupiedNum) "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 40000)
    "Outdoor air enthalpy is below the cufoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 30)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Constant TOutCut1(k=TOutCutoff)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=4,
    offset=TSupSet - 2,
    duration=1800)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Continuous.Constant TSupSetSig(k=TSupSet) "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  EconomizerSingleZone economizer1(
    minFanSpe=minFanSpe,
    maxFanSpe=maxFanSpe,
    minVOut_flow=minVOut_flow,
    desVOut_flow=desVOut_flow)    "Singlezone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  CDL.Integers.Constant freProSta2(k=freProEnabledNum) "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

  parameter Real minFanSpe=0.1 "Minimum supply fan operation speed";
  parameter Real maxFanSpe=0.9 "Maximum supply fan operation speed";
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=1.0 "Calculated minimum outdoor airflow rate";
  parameter Modelica.SIunits.VolumeFlowRate desVOut_flow=2.0 "Calculated design outdoor airflow rate";
public
  Modelica.Blocks.Sources.Ramp VOutMinSetSig(
    duration=1800,
    offset=minVOut_flow,
    height=delVOut_flow) "Constant minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Ramp SupFanSpeSig(
    duration=1800,
    offset=minFanSpe,
    height=delFanSpe) "Supply fan speed signal" annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(fanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-10},{-10,-10},{-10,6},{19,6}},
    color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta)
    annotation (Line(points={{-59,-120},{0,-120},{0,0},{19,0}},color={255,127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut)
    annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut)
    annotation (Line(points={{-99,70},{-90,70},{-8,70},{-8,20},{19,20}},color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut)
    annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},color={0,0,127}));
  connect(TSup.y, economizer.TSup)
    annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}},color={0,0,127}));
  connect(TSupSetSig.y, economizer.TCooSet)
    annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut)
    annotation (Line(points={{-99,70},{74,70},{74,0},{99,0}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-99,110},{80,110},{80,2},{99,2}}, color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,-28},{76,-28},{76,-4},{99,-4}},color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-99,20},{-88,20},{-88,-26},{74,-26},{74,-2},{99,-2}},color={0,0,127}));
  connect(TSup.y, economizer1.TSup)
    annotation (Line(points={{-59,90},{-50,90},{-50,118},{82,118},{82,-6},{99,-6}}, color={0,0,127}));
  connect(TSupSetSig.y, economizer1.TCooSet)
    annotation (Line(points={{-59,50},{-52,50},{-52,68},{72,68},{72,-8},{99,-8}}, color={0,0,127}));
  connect(fanStatus.y, economizer1.uSupFan)
    annotation (Line(points={{-19,-10},{20,-10},{20,-14},{99,-14}}, color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta)
    annotation (Line(points={{81,-120},{90,-120},{90,-20},{99,-20}}, color={255,127,0}));
  connect(ZoneState.y, economizer.uZonSta)
    annotation (Line(points={{-59,-60},{-2,-60},{-2,2},{19,2}}, color={255,127,0}));
  connect(OperationMode.y, economizer.uOpeMod)
    annotation (Line(points={{-59,-90},{-4,-90},{-4,4},{19,4}}, color={255,127,0}));
  connect(OperationMode.y, economizer1.uOpeMod)
    annotation (Line(points={{-59,-90},{20,-90},{20,-16},{99,-16}}, color={255,127,0}));
  connect(ZoneState.y, economizer1.uZonSta)
    annotation (Line(points={{-59,-60},{22,-60},{22,-18},{99,-18}}, color={255,127,0}));
  connect(VOutMinSetSig.y, economizer.uVOutMinSet_flow)
    annotation (Line(points={{-19,90},{0,90},{0,10},{19,10}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer.uSupFanSpe)
    annotation (Line(points={{-19,50},{0,50},{0,8},{19,8}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer1.uVOutMinSet_flow)
    annotation (Line(points={{-19,90},{78,90},{78,-10},{99,-10}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer1.uSupFanSpe)
    annotation (Line(points={{-19,50},{68,50},{68,-12},{99,-12}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/Validation/EconomizerSingleZone_Disable.mos"
    "Simulate and plot"),
  Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}}),
        graphics={Text(
          extent={{52,106},{86,84}},
          lineColor={28,108,200}),
        Text(
          extent={{2,156},{86,128}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is Heating),
enable minimal
outdoor air control"),
        Text(
          extent={{82,152},{166,124}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is Heating)
disable minimal
outdoor air control
(uFreProSta is Stage2)")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerSingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerSingleZone</a>
for control signals which disable modulation control loop only (<code>economizer</code> block)
and both minimum outdoor airflow and modulation control loops (<code>economizer1</code> block).
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerSingleZone_Disable;
