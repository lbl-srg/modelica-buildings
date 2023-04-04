within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Validation;
model Controller_Mod_DamLim
  "Validation model for multi zone VAV AHU economizer operation: damper modulation and minimum ooutdoor air requirement damper position limits"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller
    economizer(
    final use_TMix=true,
    final use_enthalpy=true,
    final use_G36FrePro=true) "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller
    economizer1(
    final use_enthalpy=false,
    final use_TMix=true,
    final use_G36FrePro=true) "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

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

  final parameter Real minVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.61
    "Minimal measured volumetric airflow";
  final parameter Real incVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=(minVOutSet_flow - VOutMin_flow)*2.2
    "Maximum volumetric airflow increase during the example simulation";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(final k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 10000) "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 5) "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff) "OA temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMixMea(
    final k=303.15)
    "Measured mixed air temperature above cutoff"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final offset=VOutMin_flow,
    final duration=900,
    final height=incVOutSet_flow) "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup(
    final duration=1800,
    final height=1,
    final offset=0) "Supply air temperature control signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  connect(fanSta.y, economizer.uSupFan) annotation (Line(points={{-58,-80},{-14,
          -80},{-14,5},{18.75,5}},          color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta) annotation (Line(points={{-58,-120},
          {0,-120},{0,0.625},{18.75,0.625}},  color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod) annotation (Line(points={{-98,-100},{-4,
          -100},{-4,3.125},{18.75,3.125}},  color={255,127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut) annotation (Line(points={{-98,110},
          {0,110},{0,19.375},{18.75,19.375}},    color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-98,70},{-10,
          70},{-10,17.5},{18.75,17.5}},      color={0,0,127}));
  connect(VOut_flow.y, economizer.VOut_flow_normalized) annotation (Line(points={{-18,90},
          {-8,90},{-8,10.625},{18.75,10.625}},         color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow_normalized) annotation (
     Line(points={{-18,50},{-12,50},{-12,8.75},{18.75,8.75}},
                                                           color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut) annotation (Line(points={{-98,110},
          {86,110},{86,-20.625},{98.75,-20.625}},       color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut) annotation (Line(points={{-98,70},{80,
          70},{80,-22.5},{98.75,-22.5}},         color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow_normalized)
    annotation (Line(points={{-18,50},{-12,50},{-12,-31.25},{98.75,-31.25}},
      color={0,0,127}));
  connect(fanSta.y, economizer1.uSupFan) annotation (Line(points={{-58,-80},{-14,
          -80},{-14,-35},{98.75,-35}},         color={255,0,255}));
  connect(freProSta.y, economizer1.uFreProSta) annotation (Line(points={{-58,-120},
          {0,-120},{0,-39.375},{98.75,-39.375}},    color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod) annotation (Line(points={{-98,-100},{-4,
          -100},{-4,-36.875},{98.75,-36.875}},   color={255,127,0}));
  connect(uTSup.y, economizer.uTSup) annotation (Line(points={{-58,90},{-50,90},
          {-50,12.5},{18.75,12.5}},      color={0,0,127}));
  connect(uTSup.y, economizer1.uTSup) annotation (Line(points={{-58,90},{-50,90},
          {-50,-27.5},{98.75,-27.5}},      color={0,0,127}));
  connect(economizer1.TMix, TMixMea.y) annotation (Line(points={{98.75,-33.125},
          {-20,-33.125},{-20,0},{-58,0}},  color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-98,-20},{-40,
          -20},{-40,14.375},{18.75,14.375}},
                                       color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-98,20},
          {-40,20},{-40,15.625},{18.75,15.625}},  color={0,0,127}));
  connect(TMixMea.y, economizer.TMix) annotation (Line(points={{-58,0},{-20,0},{
          -20,6.875},{18.75,6.875}},   color={0,0,127}));
  connect(VOut_flow.y, economizer1.VOut_flow_normalized) annotation (Line(
        points={{-18,90},{-8,90},{-8,-29.375},{98.75,-29.375}},color={0,0,127}));

  annotation (
    experiment(StopTime=900.0, Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Economizers/Validation/Controller_Mod_DamLim.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{
            140,140}}), graphics={
        Rectangle(
          extent={{-136,-44},{-44,-156}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-128,-132},{-36,-152}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable both damper limit
and modulation control loops"),
        Text(
          extent={{92,14},{140,-10}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Economizer fully enabled -
validate damper position
and damper position limits
(example without
enthalpy measurement)"),
        Text(
          extent={{20,46},{70,24}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Economizer fully enabled -
validate damper position
and damper position limits")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller</a> control loops:
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
