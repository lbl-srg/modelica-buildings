within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the single zone VAV AHU economizer modulation and damper position limit control loops"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    economizer(
    final use_enthalpy=true,
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=false,
    use_G36FrePro=true) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    economizer1(
    final use_enthalpy=true,
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=false,
    use_G36FrePro=true) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    economizer2(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    use_TMix=true,
    use_G36FrePro=false,
    final use_enthalpy=false) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));

protected
  final parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";
  final parameter Real TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15 "Supply air temperature setpoint";
  final parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1")=0.1 "Minimum supply fan operation speed";
  final parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1")=0.9 "Maximum supply fan operation speed";
  final parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate";
  final parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection stage is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
                                                                            "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
                                                                                 "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000)
    "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetSig(
    final k=TSupSet) "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 30)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSup(
    final height=4,
    final offset=TSupSet - 2,
    final duration=1800) "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOutMinSetSig(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=yFanMin,
    final height=yFanMax - yFanMin) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    amplitude=20,
    freqHz=1/1800,
    offset=272.15,
    startTime=0) "Mixed air temperature"
    annotation (Placement(transformation(extent={{140,-78},{160,-60}})));

equation
  connect(fanSta.y, economizer.uSupFan)
    annotation (Line(points={{-18,-10},{-10,-10},{-10,4.4},{19,4.4}},
                                                                 color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta)
    annotation (Line(points={{-58,-120},{0,-120},{0,0.4},{19,0.4}},
                                                                 color={255,127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut)
    annotation (Line(points={{-98,110},{-6,110},{-6,19.4},{19,19.4}},
                                                                 color={0,0,127}));
  connect(TOutCut1.y,economizer.TCut)
    annotation (Line(points={{-98,70},{-98,70},{-8,70},{-8,17.8},{19,17.8}},
                                                                        color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-98,20},{-60,20},{-60,18},{19,18},{19,14.6}},
                                                                         color={0,0,127}));
  connect(hOutCut.y,economizer.hCut)
    annotation (Line(points={{-98,-20},{-60,-20},{-60,2},{-60,13},{19,13}},color={0,0,127}));
  connect(TSup.y, economizer.TSup)
    annotation (Line(points={{-58,90},{-50,90},{-50,11.4},{19,11.4}},
                                                                 color={0,0,127}));
  connect(TSupSetSig.y, economizer.THeaSupSet)
    annotation (Line(points={{-58,50},{-52,50},{-52,9.8},{19,9.8}},
                                                                 color={0,0,127}));
  connect(TOutCut1.y,economizer1.TCut)
    annotation (Line(points={{-98,70},{74,70},{74,-2.2},{99,-2.2}},
                                                              color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-98,110},{80,110},{80,-0.6},{99,-0.6}},
                                                                color={0,0,127}));
  connect(hOutCut.y,economizer1.hCut)
    annotation (Line(points={{-98,-20},{-90,-20},{-90,-28},{76,-28},{76,-7},{99,
          -7}},
    color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-98,20},{-88,20},{-88,-26},{74,-26},{74,-5.4},{99,
          -5.4}},
    color={0,0,127}));
  connect(TSup.y, economizer1.TSup)
    annotation (Line(points={{-58,90},{-50,90},{-50,118},{82,118},{82,-8.6},{99,
          -8.6}},
    color={0,0,127}));
  connect(TSupSetSig.y, economizer1.THeaSupSet)
    annotation (Line(points={{-58,50},{-52,50},{-52,68},{72,68},{72,-10.2},{99,-10.2}},
    color={0,0,127}));
  connect(fanSta.y, economizer1.uSupFan)
    annotation (Line(points={{-18,-10},{20,-10},{20,-15.6},{99,-15.6}},
                                                                    color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta)
    annotation (Line(points={{82,-120},{90,-120},{90,-19.6},{99,-19.6}},
                                                                     color={255,127,0}));
  connect(zonSta.y, economizer.uZonSta)
    annotation (Line(points={{-58,-60},{-2,-60},{-2,1.8},{19,1.8}},
                                                                color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-58,-90},{-4,-90},{-4,3},{19,3}}, color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-58,-90},{20,-90},{20,-17},{99,-17}}, color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-58,-60},{22,-60},{22,-18.2},{99,-18.2}},
                                                                    color={255,127,0}));
  connect(VOutMinSetSig.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-18,90},{0,90},{0,8.4},{19,8.4}},
                                                              color={0,0,127}));
  connect(SupFanSpeSig.y, economizer.uSupFanSpe)
    annotation (Line(points={{-18,50},{0,50},{0,7},{19,7}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-18,90},{78,90},{78,-11.6},{99,-11.6}},
                                                                  color={0,0,127}));
  connect(SupFanSpeSig.y, economizer1.uSupFanSpe)
    annotation (Line(points={{-18,50},{68,50},{68,-13},{99,-13}}, color={0,0,127}));
  connect(fanSta.y, economizer2.uSupFan)
    annotation (Line(points={{-18,-10},{-10,-10},{-10,-35.6},{179,-35.6}},
                                                                       color={255,0,255}));
  connect(TOutBelowCutoff.y, economizer2.TOut)
    annotation (Line(points={{-98,110},{164,110},{164,-20.6},{179,-20.6}},
                                                                       color={0,0,127}));
  connect(TOutCut1.y,economizer2.TCut)
    annotation (Line(points={{-98,70},{162,70},{162,-22.2},{179,-22.2}},
                                                                     color={0,0,127}));
  connect(TSup.y, economizer2.TSup)
    annotation (Line(points={{-58,90},{-52,90},{-52,-28.6},{179,-28.6}},
    color={0,0,127}));
  connect(TSupSetSig.y, economizer2.THeaSupSet)
    annotation (Line(points={{-58,50},{-54,50},{-54,-30.2},{179,-30.2}},
                                                                     color={0,0,127}));
  connect(VOutMinSetSig.y, economizer2.VOutMinSet_flow)
    annotation (Line(points={{-18,90},{150,90},{150,-31.6},{179,-31.6}},
                                                                     color={0,0,127}));
  connect(SupFanSpeSig.y, economizer2.uSupFanSpe)
    annotation (Line(points={{-18,50},{148,50},{148,-33},{179,-33}}, color={0,0,127}));
  connect(sin1.y, economizer2.TMix)
    annotation (Line(points={{162,-69},{170,-69},{170,-34.4},{179,-34.4}},
                                                                       color={0,0,127}));
  connect(opeMod.y, economizer2.uOpeMod)
    annotation (Line(points={{-58,-90},{60,-90},{60,-37},{179,-37}}, color={255,127,0}));
  connect(zonSta.y, economizer2.uZonSta)
    annotation (Line(points={{-58,-60},{62,-60},{62,-38.2},{179,-38.2}},
                                                                     color={255,127,0}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Validation/Controller_Disable.mos"
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
          extent={{20,148},{166,124}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable modulation
(zone state is heating),
enable minimal
outdoor air control"),
        Text(
          extent={{100,148},{212,120}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable modulation
(zone state is heating)
disable minimal
outdoor air control
(freeze protection is at stage2)"),
        Text(
          extent={{180,10},{238,-18}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Overide damper positions
based on the TMix tracking
freeze protection ")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller</a>
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
