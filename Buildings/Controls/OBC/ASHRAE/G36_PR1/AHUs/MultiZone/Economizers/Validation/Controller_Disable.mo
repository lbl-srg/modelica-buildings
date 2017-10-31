within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the multi zone VAV AHU economizer modulation and damper position limit control loops"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller economizer(
    use_enthalpy=true,
    retDamPhyPosMax=1,
    retDamPhyPosMin=0,
    outDamPhyPosMax=1,
    outDamPhyPosMin=0) "Multi zone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller economizer1(
    use_enthalpy=true,
    retDamPhyPosMax=1,
    retDamPhyPosMin=0,
    outDamPhyPosMax=1,
    outDamPhyPosMin=0) "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

protected
  final parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";
  final parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=0.61
    "Minimal measured volumetric airflow";
  final parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=(minVOutSet_flow-VOutMin_flow)*2.2
    "Maximum volumetric airflow increase during the example simulation";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(
    final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Constants.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Constants.ZoneStates.heating)
    "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Constants.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000)
    "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp VOut_flow(
    final height=incVOutSet_flow,
    final offset=VOutMin_flow,
    final duration=1800)
    "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Ramp uTSup(
    final duration=1800,
    final height=1,
    final offset=0) "Supply air temperature control signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Constants.FreezeProtectionStages.stage2) "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

public
  CDL.Continuous.Sources.Constant TMixMea(final k=303.15)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
equation
  connect(fanSta.y, economizer.uSupFan)
    annotation (Line(points={{-19,-10},{-10,-10},{-10,6.25},{19.375,6.25}},
      color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta)
    annotation (Line(points={{-59,-120},{0,-120},{0,1.25},{19.375,1.25}},
                                                               color={255,127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut)
    annotation (Line(points={{-99,110},{-6,110},{-6,18.75},{19.375,18.75}},
                                                                 color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut)
    annotation (Line(points={{-99,70},{-90,70},{-8,70},{-8,17.5},{19.375,17.5}},
                                                                        color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-99,20},{-60,20},{-60,18},{19.375,18},{19.375,
          16.25}},                                                       color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut)
    annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,15},{19.375,15}},
                                                                           color={0,0,127}));
  connect(VOut_flow.y, economizer.VOut_flow)
    annotation (Line(points={{-19,90},{-8,90},{-8,11.25},{19.375,11.25}},
                                                               color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-19,50},{-10,50},{-10,10},{19.375,10}},
                                                               color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut)
    annotation (Line(points={{-99,70},{74,70},{74,-2.5},{99.375,-2.5}},
                                                              color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-99,110},{80,110},{80,-1.25},{99.375,-1.25}},
                                                                color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,-28},{76,-28},{76,-5},{
          99.375,-5}},                                                               color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-99,20},{-88,20},{-88,-26},{74,-26},{74,-3.75},{
          99.375,-3.75}},                                                          color={0,0,127}));
  connect(VOut_flow.y, economizer1.VOut_flow)
    annotation (Line(points={{-19,90},{78,90},{78,-8.75},{99.375,-8.75}},
                                                                  color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-19,50},{70,50},{70,-10},{99.375,-10}},
                                                                  color={0,0,127}));
  connect(fanSta.y, economizer1.uSupFan)
    annotation (Line(points={{-19,-10},{20,-10},{20,-13.75},{99.375,-13.75}},
                                                                    color={255,0,255}));
  connect(freProSta2.y, economizer1.uFreProSta)
    annotation (Line(points={{81,-120},{90,-120},{90,-18.75},{99.375,-18.75}},
                                                                     color={255,127,0}));
  connect(zonSta.y, economizer.uZonSta)
    annotation (Line(points={{-59,-60},{-2,-60},{-2,2.5},{19.375,2.5}},
                                                                color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-59,-90},{-4,-90},{-4,3.75},{19.375,3.75}},
                                                                color={255,127,0}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-59,-90},{20,-90},{20,-16.25},{99.375,-16.25}},
                                                                    color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-59,-60},{22,-60},{22,-17.5},{99.375,-17.5}},
                                                                    color={255,127,0}));
  connect(uTSup.y, economizer.uTSup) annotation (Line(points={{-59,90},{-50,90},
          {-50,13.125},{19.375,13.125}},
                             color={0,0,127}));
  connect(uTSup.y, economizer1.uTSup) annotation (Line(points={{-59,90},{-50,90},
          {-50,28},{60,28},{60,-6.875},{99.375,-6.875}},
                                             color={0,0,127}));
  connect(economizer.TMix, TMixMea.y) annotation (Line(points={{19.375,8.125},{
          -56,8.125},{-56,40},{-71,40}}, color={0,0,127}));
  connect(economizer1.TMix, TMixMea.y) annotation (Line(points={{99.375,-11.875},
          {-14,-11.875},{-14,8},{-56,8},{-56,40},{-71,40}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Validation/Controller_Disable.mos"
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
        Text(
          extent={{2,156},{86,128}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is heating),
enable minimal
outdoor air control"),
        Text(
          extent={{82,152},{166,124}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(zone state is heating)
disable minimal
outdoor air control
(freeze protection is at stage2)")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Controller</a>
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
