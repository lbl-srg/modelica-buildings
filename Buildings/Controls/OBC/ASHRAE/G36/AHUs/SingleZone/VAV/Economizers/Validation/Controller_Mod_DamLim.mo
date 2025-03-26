within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Validation;
model Controller_Mod_DamLim
  "Validation model for single zone VAV AHU economizer operation: damper modulation and minimum ooutdoor air requirement damper position limits"

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
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow) "Single zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,0}})));

protected
  parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";
  parameter Real TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Supply air temperature Heating setpoint";
  parameter Real TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=290.15
    "Measured supply air temperature";
  parameter Real supFanSpe_min(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed";
  parameter Real supFanSpe_max(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed";
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 1.0 "Calculated minimum outdoor airflow rate";
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 2.0 "Calculated design outdoor airflow rate";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.deadband)
    "Zone State is deadband"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 10000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 5)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetSig(
    final k=TSupSet) "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSig(
    final k=TSup) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSupSig1(
    final duration=900,
    final height=2,
    final offset=TSupSet - 1) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOutMinSetSig(
    final duration=1800,
    final offset=VOutMin_flow,
    final height=VOutDes_flow - VOutMin_flow) "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp SupFanSpeSig(
    final duration=1800,
    final offset=supFanSpe_min,
    final height=supFanSpe_max - supFanSpe_min) "Supply fan speed signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(fanSta.y, economizer.u1SupFan) annotation (Line(points={{-58,-80},{-20,
          -80},{-20,9},{18,9}}, color={255,0,255}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-98,-100},{-10,-100},{-10,5},{18,5}},
    color={255,127,0}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-98,30},{-40,30},{-40,34},{18,34}},
                                                color={0,0,127}));
  connect(TSupSetSig.y, economizer.TSupHeaEcoSet) annotation (Line(points={{-58,
          50},{-50,50},{-50,21},{18,21}}, color={0,0,127}));
  connect(TSupSig.y, economizer.TAirSup) annotation (Line(points={{-58,90},{-46,
          90},{-46,24},{18,24}}, color={0,0,127}));
  connect(TSupSig1.y, economizer1.TAirSup) annotation (Line(points={{62,90},{80,
          90},{80,-16},{98,-16}}, color={0,0,127}));
  connect(fanSta.y, economizer1.u1SupFan) annotation (Line(points={{-58,-80},{-20,
          -80},{-20,-30},{98,-30},{98,-31}}, color={255,0,255}));
  connect(freProSta.y, economizer1.uFreProSta)
    annotation (Line(points={{-58,-120},{-2,-120},{-2,-39},{98,-39}}, color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-98,-100},{-10,-100},{-10,-35},{98,-35}}, color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-98,-60},{-6,-60},{-6,-37},{98,-37}}, color={255,127,0}));
  connect(VOutMinSetSig.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-18,90},{6,90},{6,18},{18,18}}, color={0,0,127}));
  connect(VOutMinSetSig.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-18,90},{6,90},{6,-22},{98,-22}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut) annotation (Line(points={{-98,120},
          {90,120},{90,-1},{98,-1}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer.uSupFan_actual) annotation (Line(points={{
          -18,50},{2,50},{2,15},{18,15}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer.TOut) annotation (Line(points={{-98,120},
          {14,120},{14,39},{18,39}}, color={0,0,127}));
  connect(zonSta.y, economizer.uZonSta) annotation (Line(points={{-98,-60},{-6,-60},
          {-6,3},{18,3}}, color={255,127,0}));
  connect(freProSta.y, economizer.uFreProSta) annotation (Line(points={{-58,-120},
          {-2,-120},{-2,1},{18,1}}, color={255,127,0}));
  connect(TSupSetSig.y, economizer1.TSupHeaEcoSet) annotation (Line(points={{-58,
          50},{-50,50},{-50,-19},{98,-19}}, color={0,0,127}));
  connect(SupFanSpeSig.y, economizer1.uSupFan_actual) annotation (Line(points={
          {-18,50},{2,50},{2,-25},{98,-25}}, color={0,0,127}));
annotation (
    experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Validation/Controller_Mod_DamLim.mos"
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
        graphics={
        Rectangle(
          extent={{-136,-44},{-44,-156}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-128,-132},{-22,-154}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable both damper limit
and modulation control loops"),
        Text(
          extent={{100,32},{154,10}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Validate damper modulation
(example without
enthalpy measurement)"),
        Text(
          extent={{20,70},{84,50}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Economizer fully enabled -
validate damper position limits")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller</a> control loops:
minimum outdoor air damper position limits control loop (<code>economizer</code> block) and modulation
control loop (<code>economizer1</code> block) for <code>VOut_flow</code> and <code>TSup</code> control signals.
Both control loops are enabled during the validation test.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller_Mod_DamLim;
