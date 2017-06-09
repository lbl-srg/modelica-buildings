within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisableMultiZone_TOut_hOut
  "Validation model for disabling the economizer if any of the outdoor air conditions are above the cutoff "
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", displayUnit="degC", quantity="Temperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy")=65100 "Outdoor air enthalpy high limit cutoff";

  CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));

  EconEnableDisableMultiZone econEnableDisableMultiZone
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Continuous.Constant retDamPosMax(k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  CDL.Continuous.Constant retDamPosMin(k=0)   "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Integers.Constant FreProSta(k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Modelica.Blocks.Sources.Ramp TOut(
    duration=1800,
    height=6,
    offset=TOutCutoff - 3)
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Constant TOutCut(k=TOutCutoff) annotation (Placement(transformation(extent={{-140,60},
            {-120,80}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-220,20},
            {-200,40}})));


  CDL.Integers.Constant ZoneState(k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  CDL.Continuous.Constant outDamPosMax1(
                                       k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Continuous.Constant outDamPosMin1(
                                       k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  EconEnableDisableMultiZone econEnableDisableMultiZone1
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  CDL.Continuous.Constant retDamPosMax1(
                                       k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  CDL.Continuous.Constant retDamPosMin1(
                                       k=0)   "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  CDL.Continuous.Constant retDamPhyPosMax1(
                                          k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  CDL.Integers.Constant FreProSta1(
                                  k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{100,60},
            {120,80}})));
  Modelica.Blocks.Sources.Ramp hOut1(
    duration=1800,
    height=4000,
    offset=hOutCutoff - 2200)
                    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  CDL.Continuous.Constant hOutCut1(
                                  k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{20,20},
            {40,40}})));
  CDL.Integers.Constant ZoneState1(
                                  k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  CDL.Continuous.Constant TOut1(k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
equation
  connect(TOut.y, econEnableDisableMultiZone.TOut) annotation (Line(points={{-119,
          110},{-90,110},{-90,-20},{-61,-20}},  color={0,0,127}));
  connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
        points={{-119,70},{-92,70},{-92,-22},{-61,-22}},
                                                       color={0,0,127}));
  connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
        points={{-199,30},{-130,30},{-130,-26},{-61,-26}},
                                                      color={0,0,127}));
  connect(FreProSta.y, econEnableDisableMultiZone.uFreProSta) annotation (Line(
        points={{-159,10},{-100,10},{-100,-28},{-61,-28}},
                                                     color={255,127,0}));
  connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation (
     Line(points={{-199,-70},{-130,-70},{-130,-32},{-61,-32}},
                                                        color={0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin) annotation (
     Line(points={{-199,-110},{-190,-110},{-190,-80},{-120,-80},{-120,-34},{-61,
          -34}},
        color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-119,-110},{-90,-110},{-90,-36},{-61,-36}},
                                                                  color={0,0,
          127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax) annotation (
     Line(points={{-119,-150},{-86,-150},{-86,-38},{-61,-38}},
                                                       color={0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation (
     Line(points={{-119,-190},{-82,-190},{-82,-40},{-61,-40}},
                                                       color={0,0,127}));
  connect(econEnableDisableMultiZone.uZoneState, ZoneState.y)
    annotation (Line(points={{-61,-30},{-159,-30}},      color={255,127,0}));
  connect(TOutCut1.y, econEnableDisableMultiZone1.TOutCut) annotation (Line(
        points={{121,70},{148,70},{148,-22},{179,-22}}, color={0,0,127}));
  connect(hOut1.y, econEnableDisableMultiZone1.hOut) annotation (Line(points={{
          41,70},{80,70},{80,50},{130,50},{130,-24},{179,-24}}, color={0,0,127}));
  connect(hOutCut1.y, econEnableDisableMultiZone1.hOutCut) annotation (Line(
        points={{41,30},{110,30},{110,-26},{179,-26}}, color={0,0,127}));
  connect(FreProSta1.y, econEnableDisableMultiZone1.uFreProSta) annotation (
      Line(points={{81,10},{140,10},{140,-28},{179,-28}}, color={255,127,0}));
  connect(outDamPosMax1.y, econEnableDisableMultiZone1.uOutDamPosMax)
    annotation (Line(points={{41,-70},{110,-70},{110,-32},{179,-32}}, color={0,
          0,127}));
  connect(outDamPosMin1.y, econEnableDisableMultiZone1.uOutDamPosMin)
    annotation (Line(points={{41,-110},{50,-110},{50,-80},{120,-80},{120,-34},{
          179,-34}}, color={0,0,127}));
  connect(retDamPhyPosMax1.y, econEnableDisableMultiZone1.uRetDamPhyPosMax)
    annotation (Line(points={{121,-110},{150,-110},{150,-36},{179,-36}}, color=
          {0,0,127}));
  connect(retDamPosMax1.y, econEnableDisableMultiZone1.uRetDamPosMax)
    annotation (Line(points={{121,-150},{154,-150},{154,-38},{179,-38}}, color=
          {0,0,127}));
  connect(retDamPosMin1.y, econEnableDisableMultiZone1.uRetDamPosMin)
    annotation (Line(points={{121,-190},{158,-190},{158,-40},{179,-40}}, color=
          {0,0,127}));
  connect(econEnableDisableMultiZone1.uZoneState, ZoneState1.y)
    annotation (Line(points={{179,-30},{81,-30}}, color={255,127,0}));
  connect(hOutBelowCutoff.y, econEnableDisableMultiZone.hOut) annotation (Line(
        points={{-199,70},{-160,70},{-160,46},{-110,46},{-110,-24},{-61,-24}},
        color={0,0,127}));
  connect(TOut1.y, econEnableDisableMultiZone1.TOut) annotation (Line(points={{
          121,110},{150,110},{150,-20},{180,-20},{179,-20}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-220},{240,
            220}}),                                                                  graphics={Text(
          extent={{-220,226},{-88,164}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Example high limit cutoff conditions:
ASHRAE 90.1-2013:
Device Type: Fixed Enthalpy + Fixed Drybulb
TOut > 75 degF [24 degC] [297 K]
hOut > 28 Btu/lb [65.1 kJ/kg]"),                                                               Text(
          extent={{-220,170},{-96,142}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Temperature"),                                                           Text(
          extent={{20,170},{148,142}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Entahlpy")}),
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
