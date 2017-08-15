within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.Validation;
model EconomizerMultiZone_Mod_DamLim
  "Validation model for multizone VAV AHU economizer operation: damper modulation and minimum ooutdoor air requirement damper position limits"
  extends Modelica.Icons.Example;

  EconomizerMultiZone economizer "Multizone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  EconomizerMultiZone economizer1(use_enthalpy=false) "Multizone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

protected
  final parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";
  final parameter Modelica.SIunits.Temperature THeaSet=291
    "Supply air temperature heating setpoint";
  final parameter Modelica.SIunits.Temperature TSup=290.15
    "Measured supply air temperature";
  final parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.61
    "Minimal measured volumetric airflow";
  final parameter Modelica.SIunits.VolumeFlowRate incVOutSet_flow=(minVOutSet_flow-minVOut_flow)*2.2
    "Maximum volumetric airflow increase during the example simulation";

  CDL.Logical.Sources.Constant fanSta(final k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Integers.Sources.Constant freProSta(final k=Constants.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Integers.Sources.Constant zonSta(final k=Constants.ZoneStates.deadband) "Zone State is deadband"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  CDL.Integers.Sources.Constant opeMod(final k=Constants.OperationModes.occModInd)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  CDL.Continuous.Sources.Constant hOutBelowCutoff(final k=hOutCutoff - 10000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Sources.Constant hOutCut(final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Continuous.Sources.Constant TOutBelowCutoff(final k=TOutCutoff - 5)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Sources.Constant TOutCut1(final k=TOutCutoff)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Sources.Constant VOutMinSet_flow(final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp VOut_flow(
    final offset=minVOut_flow,
    final duration=900,
    final height=incVOutSet_flow)
    "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Continuous.Sources.Constant TSupSetSig(final k=THeaSet) "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Sources.Constant TSupSig(final k=TSup) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Ramp TSupSig1(
    final duration=900,
    final height=3,
    final offset=THeaSet - 2) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

equation
  connect(fanSta.y, economizer.uSupFan)
    annotation (Line(points={{-59,-80},{-14,-80},{-14,6},{19,6}}, color={255,0,255}));
  connect(freProSta.y, economizer.uFreProSta)
    annotation (Line(points={{-59,-120},{0,-120},{0,0},{19,0}},color={255,127,0}));
  connect(opeMod.y, economizer.uOpeMod)
    annotation (Line(points={{-99,-100},{-50,-100},{-50,-30},{-4,-30},{-4,4},{19,4}},color={255,127,0}));
  connect(zonSta.y, economizer.uZonSta)
    annotation (Line(points={{-99,-60},{-48,-60},{-48,-32},{-2,-32},{-2,2},{19,2}}, color={255,127,0}));
  connect(TOutBelowCutoff.y, economizer.TOut)
    annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut)
    annotation (Line(points={{-99,70},{-10,70},{-10,20},{19,20}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut)
    annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut)
    annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},color={0,0,127}));
  connect(VOut_flow.y, economizer.VOut_flow)
    annotation (Line(points={{-19,90},{-8,90},{-8,10},{19,10}},color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow)
    annotation (Line(points={{-19,50},{-12,50},{-12,8},{19,8}},color={0,0,127}));
  connect(TSupSig.y, economizer.TSup)
    annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-99,110},{90,110},{90,-18},{99,-18}}, color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut)
    annotation (Line(points={{-99,70},{88,70},{88,-20},{99,-20}}, color={0,0,127}));
  connect(TSupSig1.y, economizer1.TSup) annotation (Line(points={{61,90},{80,90},{80,-26},{99,-26}}, color={0,0,127}));
  connect(VOut_flow.y, economizer1.VOut_flow)
    annotation (Line(points={{-19,90},{-10,90},{-10,-22},{18,-22},{18,-30},{99,-30}}, color={0,0,127}));
  connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow)
    annotation (Line(points={{-19,50},{-12,50},{-12,-24},{16,-24},{16,-32},{99,-32}}, color={0,0,127}));
  connect(fanSta.y, economizer1.uSupFan)
    annotation (Line(points={{-59,-80},{20,-80},{20,-34},{99,-34}}, color={255,0,255}));
  connect(freProSta.y, economizer1.uFreProSta)
    annotation (Line(points={{-59,-120},{26,-120},{26,-40},{99,-40}}, color={255,127,0}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-99,20},{0,20},{0,-22},{99,-22}}, color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut)
    annotation (Line(points={{-99,-20},{0,-20},{0,-24},{99,-24}}, color={0,0,127}));
  connect(opeMod.y, economizer1.uOpeMod)
    annotation (Line(points={{-99,-100},{22,-100},{22,-36},{99,-36}}, color={255,127,0}));
  connect(zonSta.y, economizer1.uZonSta)
    annotation (Line(points={{-99,-60},{24,-60},{24,-38},{99,-38}}, color={255,127,0}));
  connect(economizer.THeaSet, TSupSetSig.y)
    annotation (Line(points={{19,12},{-52,12},{-52,50},{-59,50}}, color={0,0,127}));
  connect(TSupSetSig.y, economizer1.THeaSet)
    annotation (Line(points={{-59,50},{-54,50},{-54,-28},{-48,-28},{99,-28}}, color={0,0,127}));
  annotation (
    experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/Validation/EconomizerMultiZone_Mod_DamLim.mos"
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
          extent={{52,106},{86,84}},
          lineColor={28,108,200}),
        Text(
          extent={{-128,-130},{-44,-158}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Enable both damper limit
and modulation control loops"),
        Text(
          extent={{100,4},{136,-16}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="Validate damper modulation
(example without
enthalpy measurement)"),
        Text(
          extent={{20,46},{56,26}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="Economizer fully enabled -
validate damper position limits")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone</a> control loops:
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
end EconomizerMultiZone_Mod_DamLim;
