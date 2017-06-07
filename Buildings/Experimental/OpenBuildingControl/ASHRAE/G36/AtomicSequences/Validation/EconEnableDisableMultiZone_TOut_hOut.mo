within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisableMultiZone_TOut_hOut
  "Validation model for disabling the economizer if any of the outdoor air conditions are above the cutoff "
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", displayUnit="degC", quantity="Temperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy")=65100 "Outdoor air enthalpy high limit cutoff";

  CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  EconEnableDisableMultiZone econEnableDisableMultiZone
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Continuous.Constant retDamPosMax(k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  CDL.Continuous.Constant retDamPosMin(k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Integers.Constant FreProSta(k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Ramp TOut(
    duration=1800,
    height=6,
    offset=TOutCutoff - 3)
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  CDL.Continuous.Constant TOutCut(k=TOutCutoff) annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Modelica.Blocks.Sources.Ramp hOut(
    duration=1800,
    height=4000,
    offset=hOutCutoff - 2200)
                    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));


  CDL.Integers.Constant ZoneState(k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(TOut.y, econEnableDisableMultiZone.TOut) annotation (Line(points={{
          -39,150},{-10,150},{-10,20},{19,20}}, color={0,0,127}));
  connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
        points={{-39,110},{-12,110},{-12,18},{19,18}}, color={0,0,127}));
  connect(hOut.y, econEnableDisableMultiZone.hOut) annotation (Line(points={{
          -119,110},{-80,110},{-80,90},{-30,90},{-30,16},{19,16}}, color={0,0,
          127}));
  connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
        points={{-119,70},{-50,70},{-50,14},{19,14}}, color={0,0,127}));
  connect(FreProSta.y, econEnableDisableMultiZone.uFreProSta) annotation (Line(
        points={{-79,50},{-20,50},{-20,12},{19,12}}, color={255,127,0}));
  connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation
    (Line(points={{-119,-30},{-50,-30},{-50,8},{19,8}}, color={0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin) annotation
    (Line(points={{-119,-70},{-110,-70},{-110,-40},{-40,-40},{-40,6},{19,6}},
        color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-39,-70},{-10,-70},{-10,4},{19,4}}, color={0,0,
          127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax) annotation
    (Line(points={{-39,-110},{-6,-110},{-6,2},{19,2}}, color={0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation
    (Line(points={{-39,-150},{-2,-150},{-2,0},{19,0}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.uZoneState, ZoneState.y)
    annotation (Line(points={{19,10},{-79,10},{-79,10}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconEnableDisable_TOut.mos"
    "Simulate and plot"),
  Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}}), graphics={Text(
          extent={{-176,190},{-44,128}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Example high limit cutoff conditions:
ASHRAE 90.1-2013:
Device Type: Fixed Enthalpy + Fixed Drybulb
TOut > 75 degF [24 degC] [297 K]
hOut > 28 Btu/lb [65.1 kJ/kg]")}),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconEnableDisable\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconEnableDisable</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisableMultiZone_TOut_hOut;
