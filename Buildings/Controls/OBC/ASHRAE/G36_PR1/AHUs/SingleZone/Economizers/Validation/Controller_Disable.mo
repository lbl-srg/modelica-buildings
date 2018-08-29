within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the single zone VAV AHU economizer modulation and damper position limit control loops"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller economizer(
    final use_enthalpy=true,
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=false,
    use_G36FrePro=true)
    "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller economizer1(
    final use_enthalpy=true,
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=false,
    use_G36FrePro=true)
    "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller economizer2(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=true,
    use_G36FrePro=false,
    final use_enthalpy=false)
    "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));

protected
  final parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";
  final parameter Modelica.SIunits.Temperature TSupSet=291.15 "Supply air temperature setpoint";
  final parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1")=0.1 "Minimum supply fan operation speed";
  final parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1")=0.9 "Maximum supply fan operation speed";
  final parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
    "Calculated minimum outdoor airflow rate";
  final parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
    "Calculated design outdoor airflow rate";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection stage is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating) "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied) "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000)
    "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSetSig(
    final k=TSupSet) "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 30)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final offset=TSupSet - 2,
    final duration=1800) "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOutMinSetSig(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=yFanMin,
    final height=yFanMax - yFanMin) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=20,
    freqHz=1/1800,
    offset=272.15,
    startTime=0)
    annotation (Placement(transformation(extent={{140,-78},{160,-60}})));

equation
  connect(fanSta.y, economizer.uSupFan)
    annotation (Line(points={{-19,-10},{-10,-10},{-10,4},{19,4}},color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta)
    annotation (Line(points={{-59,-120},{0,-120},{0,-2},{19,-2}},color={255,127,0}));
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
  connect(TSupSetSig.y, economizer.THeaSupSet)
    annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut)
    annotation (Line(points={{-99,70},{74,70},{74,0},{99,0}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-99,110},{80,110},{80,2},{99,2}}, color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,-28},{76,-28},{76,-4},{99,-4}},
    color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-99,20},{-88,20},{-88,-26},{74,-26},{74,-2},{99,-2}},
    color={0,0,127}));
  connect(TSup.y, economizer1.TSup)
    annotation (Line(points={{-59,90},{-50,90},{-50,118},{82,118},{82,-6},{99,-6}},
    color={0,0,127}));
  connect(TSupSetSig.y, economizer1.THeaSupSet)
    annotation (Line(points={{-59,50},{-52,50},{-52,68},{72,68},{72,-8},{99,-8}},
    color={0,0,127}));
  connect(fanSta.y, economizer1.uSupFan)
    annotation (Line(points={{-19,-10},{20,-10},{20,-16},{99,-16}}, color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta)
    annotation (Line(points={{81,-120},{90,-120},{90,-22},{99,-22}}, color={255,127,0}));
  connect(zonSta.y, economizer.uZonSta)
    annotation (Line(points={{-59,-60},{-2,-60},{-2,0},{19,0}}, color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-59,-90},{-4,-90},{-4,2},{19,2}}, color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-59,-90},{20,-90},{20,-18},{99,-18}}, color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-59,-60},{22,-60},{22,-20},{99,-20}}, color={255,127,0}));
  connect(VOutMinSetSig.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-19,90},{0,90},{0,10},{19,10}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer.uSupFanSpe)
    annotation (Line(points={{-19,50},{0,50},{0,8},{19,8}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-19,90},{78,90},{78,-10},{99,-10}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer1.uSupFanSpe)
    annotation (Line(points={{-19,50},{68,50},{68,-12},{99,-12}}, color={0,0,127}));
  connect(fanSta.y, economizer2.uSupFan)
    annotation (Line(points={{-19,-10},{-10,-10},{-10,-36},{179,-36}}, color={255,0,255}));
  connect(TOutBelowCutoff.y, economizer2.TOut)
    annotation (Line(points={{-99,110},{164,110},{164,-18},{179,-18}}, color={0,0,127}));
  connect(TOutCut1.y, economizer2.TOutCut)
    annotation (Line(points={{-99,70},{162,70},{162,-20},{179,-20}}, color={0,0,127}));
  connect(TSup.y, economizer2.TSup)
    annotation (Line(points={{-59,90},{-52,90},{-52,-26},{-44,-26},{-44,-26},{179,-26}},
    color={0,0,127}));
  connect(TSupSetSig.y, economizer2.THeaSupSet)
    annotation (Line(points={{-59,50},{-54,50},{-54,-28},{179,-28}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer2.VOutMinSet_flow)
    annotation (Line(points={{-19,90},{150,90},{150,-30},{179,-30}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer2.uSupFanSpe)
    annotation (Line(points={{-19,50},{148,50},{148,-32},{179,-32}}, color={0,0,127}));
  connect(sin1.y, economizer2.TMix)
    annotation (Line(points={{161,-69},{170,-69},{170,-34},{179,-34}}, color={0,0,127}));
  connect(opeMod.y, economizer2.uOpeMod)
    annotation (Line(points={{-59,-90},{60,-90},{60,-38},{179,-38}}, color={255,127,0}));
  connect(zonSta.y, economizer2.uZonSta)
    annotation (Line(points={{-59,-60},{62,-60},{62,-40},{179,-40}}, color={255,127,0}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/Economizers/Validation/Controller_Disable.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{220,160}}),
        graphics={
        Text(
          extent={{20,146},{104,118}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is heating),
enable minimal
outdoor air control"),
        Text(
          extent={{100,144},{184,116}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is heating)
disable minimal
outdoor air control
(freeze protection is at stage2)"),
        Text(
          extent={{180,10},{238,-18}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="Overide damper positions
based on the TMix tracking
freeze protection ")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Controller</a>
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
end Controller_Disable;
