within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the multi zone VAV AHU economizer modulation and damper position limit control loops"

  Controller economizer(
    final use_enthalpy=true,
    final retDamPhyPosMax=1,
    final retDamPhyPosMin=0,
    final outDamPhyPosMax=1,
    final outDamPhyPosMin=0,
    final use_TMix=false,
    final use_G36FrePro=true) "Multi zone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,40}})));
  Controller economizer1(
    final use_enthalpy=true,
    final retDamPhyPosMax=1,
    final retDamPhyPosMin=0,
    final outDamPhyPosMax=1,
    final outDamPhyPosMin=0,
    final use_TMix=false,
    final use_G36FrePro=true) "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,0}})));
  Controller economizer2(
    final retDamPhyPosMax=1,
    final retDamPhyPosMin=0,
    final outDamPhyPosMax=1,
    final outDamPhyPosMin=0,
    final use_TMix=true,
    final use_G36FrePro=false,
    final use_enthalpy=false)
    "Multi zone VAV AHU economizer with TMix freeze protection"
    annotation (Placement(transformation(extent={{160,-80},{180,-40}})));

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
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage1)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000) "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 30) "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final height=incVOutSet_flow,
    final offset=VOutMin_flow,
    final duration=1800) "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup(
    final duration=1800,
    final height=1,
    final offset=0) "Supply air temperature control signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=20,
    freqHz=1/1800,
    offset=272.15,
    startTime=0) "Mixed air temerature"
    annotation (Placement(transformation(extent={{90,-98},{110,-80}})));

equation
  connect(fanSta.y, economizer.uSupFan) annotation (Line(points={{-18,-10},{0,
          -10},{0,7},{18,7}},               color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta) annotation (Line(points={{-58,
          -100},{-10,-100},{-10,1},{18,1}},                         color={255,
          127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut) annotation (Line(points={{-98,110},
          {0,110},{0,18},{18,18}},               color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-98,70},{-2,
          70},{-2,16},{18,16}},                     color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-98,20},
          {-80,20},{-80,16},{18,16},{18,13}},             color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-98,-20},{
          -90,-20},{-90,11},{18,11}},                 color={0,0,127}));
  connect(VOut_flow.y, economizer.VOut_flow_normalized) annotation (Line(points={{-18,90},
          {-8,90},{-8,36},{18,36}},                    color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow_normalized) annotation (
     Line(points={{-18,50},{-10,50},{-10,39},{18,39}},     color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut) annotation (Line(points={{-98,70},{
          74,70},{74,-24},{98,-24}},           color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut) annotation (Line(points={{-98,110},
          {80,110},{80,-22},{98,-22}},                color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut) annotation (Line(points={{-98,-20},{
          -90,-20},{-90,-28},{76,-28},{76,-29},{98,-29}},       color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut) annotation (Line(points={{-98,20},
          {-80,20},{-80,-26},{74,-26},{74,-27},{98,-27}},           color={0,0,
          127}));
  connect(VOut_flow.y, economizer1.VOut_flow_normalized) annotation (Line(
        points={{-18,90},{78,90},{78,-4},{98,-4}},           color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow_normalized)
    annotation (Line(points={{-18,50},{70,50},{70,-1},{98,-1}},       color={0,
          0,127}));
  connect(fanSta.y, economizer1.uSupFan) annotation (Line(points={{-18,-10},{0,
          -10},{0,-33},{98,-33}},              color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta) annotation (Line(points={{22,-90},
          {40,-90},{40,-32},{80,-32},{80,-39},{98,-39}},             color={255,
          127,0}));
  connect(opeMod.y, economizer.uOpeMod) annotation (Line(points={{-58,-70},{-4,
          -70},{-4,4},{18,4}},             color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod) annotation (Line(points={{-58,-70},{-4,
          -70},{-4,-36},{98,-36}},             color={255,127,0}));
  connect(uTSup.y, economizer.uTSup) annotation (Line(points={{-58,90},{-50,90},
          {-50,24},{18,24}},            color={0,0,127}));
  connect(uTSup.y, economizer1.uTSup) annotation (Line(points={{-58,90},{-50,90},
          {-50,28},{60,28},{60,-16},{98,-16}},           color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer2.TOut) annotation (Line(points={{-98,110},
          {152,110},{152,-62},{158,-62}},
        color={0,0,127}));
  connect(TOutCut1.y, economizer2.TOutCut) annotation (Line(points={{-98,70},{
          150,70},{150,-64},{158,-64}},
        color={0,0,127}));
  connect(VOut_flow.y, economizer2.VOut_flow_normalized) annotation (Line(
        points={{-18,90},{140,90},{140,-44},{158,-44}},
        color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer2.VOutMinSet_flow_normalized)
    annotation (Line(points={{-18,50},{136,50},{136,-41},{158,-41}},
        color={0,0,127}));
  connect(uTSup.y, economizer2.uTSup) annotation (Line(points={{-58,90},{-50,90},
          {-50,106},{142,106},{142,-56},{158,-56}},             color={0,0,127}));
  connect(fanSta.y, economizer2.uSupFan) annotation (Line(points={{-18,-10},{0,
          -10},{0,-73},{158,-73}},                               color={255,0,
          255}));
  connect(opeMod.y, economizer2.uOpeMod) annotation (Line(points={{-58,-70},{-4,
          -70},{-4,-76},{158,-76}},             color={255,127,0}));
  connect(sin1.y, economizer2.TMix) annotation (Line(points={{112,-89},{136,-89},
          {136,-59},{158,-59}},             color={0,0,127}));

  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Economizers/Validation/Controller_Disable.mos"
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
            220,160}}), graphics={
        Text(
          extent={{20,140},{104,112}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable modulation
enable minimal
outdoor air control"),
        Text(
          extent={{100,140},{184,112}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable modulation
and minimal outdoor air control
(freeze protection is at stage2)"),
        Text(
          extent={{160,-12},{218,-40}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Overide damper positions
based on the TMix tracking
freeze protection ")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller</a>
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
