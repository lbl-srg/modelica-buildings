within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the single zone VAV AHU economizer modulation and damper position limit control loops"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller economizer(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,0},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller economizer1(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,0}})));

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
    final quantity="ThermodynamicTemperature")=291.15
    "Supply air temperature setpoint";
  final parameter Real supFanSpe_min(
    final min=0,
    final max=1,
    final unit="1")=0.1 "Minimum supply fan operation speed";
  final parameter Real supFanSpe_max(
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
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection stage is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.heating)
    "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
     "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000)
    "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSetSig(
    final k=TSupSet) "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 30)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final offset=TSupSet - 2,
    final duration=1800) "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOutMinSetSig(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=supFanSpe_min,
    final height=supFanSpe_max - supFanSpe_min) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(fanSta.y, economizer.u1SupFan) annotation (Line(points={{-18,-140},{-10,
          -140},{-10,9},{18,9}}, color={255,0,255}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-98,20},{-86,20},{-86,34},{18,34}}, color={0,0,127}));
  connect(TSup.y, economizer.TAirSup) annotation (Line(points={{-58,100},{-48,100},
          {-48,24},{18,24}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-98,120},{76,120},{76,-1},{98,-1}},  color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-98,20},{-86,20},{-86,-6},{98,-6}},
    color={0,0,127}));
  connect(TSup.y, economizer1.TAirSup) annotation (Line(points={{-58,100},{-48,100},
          {-48,-16},{98,-16}}, color={0,0,127}));
  connect(fanSta.y, economizer1.u1SupFan) annotation (Line(points={{-18,-140},{90,
          -140},{90,-31},{98,-31}}, color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta)
    annotation (Line(points={{62,-120},{80,-120},{80,-39},{98,-39}}, color={255,127,0}));
  connect(zonSta.y, economizer.uZonSta)
    annotation (Line(points={{-58,-70},{0,-70},{0,3},{18,3}},   color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-98,-90},{-4,-90},{-4,5},{18,5}}, color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-98,-90},{-4,-90},{-4,-35},{98,-35}}, color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-58,-70},{0,-70},{0,-37},{98,-37}},   color={255,127,0}));
  connect(VOutMinSetSig.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-18,100},{4,100},{4,18},{18,18}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer.uSupFan_actual) annotation (Line(points={{
          -18,50},{10,50},{10,15},{18,15}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-18,100},{82,100},{82,-22},{98,-22}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer1.uSupFan_actual) annotation (Line(points={
          {-18,50},{88,50},{88,-25},{98,-25}}, color={0,0,127}));
  connect(freProSta.y, economizer.uFreProSta) annotation (Line(points={{-58,-120},
          {6,-120},{6,1},{18,1}}, color={255,127,0}));
  connect(TSupSetSig.y, economizer1.TSupHeaEcoSet) annotation (Line(points={{-58,
          60},{-54,60},{-54,-19},{98,-19}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer.TOut) annotation (Line(points={{-98,120},
          {14,120},{14,39},{18,39}}, color={0,0,127}));
  connect(TSupSetSig.y, economizer.TSupHeaEcoSet) annotation (Line(points={{-58,
          60},{-54,60},{-54,21},{18,21}}, color={0,0,127}));
annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Validation/Controller_Disable.mos"
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
(freeze protection is at stage2)")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller</a>
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
