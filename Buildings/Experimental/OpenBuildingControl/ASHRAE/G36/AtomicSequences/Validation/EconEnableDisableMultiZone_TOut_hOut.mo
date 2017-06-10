within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisableMultiZone_TOut_hOut
  "Validation model for disabling the economizer if any of the outdoor air conditions are above the cutoff "
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", displayUnit="degC", quantity="Temperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy")=65100 "Outdoor air enthalpy high limit cutoff";

  CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-280,-120},{-260,-100}})));

  EconEnableDisableMultiZone econEnableDisableMultiZone
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Continuous.Constant retDamPosMax(k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  CDL.Continuous.Constant retDamPosMin(k=0)   "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-180}})));
  CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  CDL.Integers.Constant FreProSta(k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  CDL.Continuous.Constant TOutCut(k=TOutCutoff) annotation (Placement(transformation(extent={{-200,60},
            {-180,80}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-280,20},
            {-260,40}})));


  CDL.Integers.Constant ZoneState(k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{-240,-40},{-220,-20}})));
  EconEnableDisableMultiZone econEnableDisableMultiZone1
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-40,60},
            {-20,80}})));
  CDL.Continuous.Constant hOutCut1(
                                  k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-120,20},
            {-100,40}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Logical.TriggeredTrapezoid TOut(
    rising=1000,
    falling=800,
    amplitude=4,
    offset=TOutCutoff - 2) "Outoor air temperature, varying"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  CDL.Sources.BooleanPulse booPul(startTime=10, period=2000)
    "Generates one constant true signal between a rising and a falling edge (since simulation time is 1800 in the example)"
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));
  CDL.Sources.BooleanPulse booPul1(
                                  startTime=10, period=2000)
    "Generates one constant true signal between a rising and a falling edge (since simulation time is 1800 in the example)"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Logical.TriggeredTrapezoid hOut1(
    amplitude=4000,
    offset=hOutCutoff - 2200,
    rising=1000,
    falling=800) "Outdoor air enthalpy, varying"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  EconEnableDisableMultiZone econEnableDisableMultiZone2(fixEnt=false)
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
equation
  connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
        points={{-179,70},{-152,70},{-152,-22},{-121,-22}},
                                                       color={0,0,127}));
  connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
        points={{-259,30},{-190,30},{-190,-26},{-121,-26}},
                                                      color={0,0,127}));
  connect(FreProSta.y, econEnableDisableMultiZone.uFreProSta) annotation (Line(
        points={{-219,10},{-160,10},{-160,-28},{-121,-28}},
                                                     color={255,127,0}));
  connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation (
     Line(points={{-259,-70},{-190,-70},{-190,-32},{-121,-32}},
                                                        color={0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin) annotation (
     Line(points={{-259,-110},{-250,-110},{-250,-80},{-180,-80},{-180,-34},{
          -121,-34}},
        color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-179,-110},{-150,-110},{-150,-36},{-121,-36}},
                                                                  color={0,0,
          127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax) annotation (
     Line(points={{-179,-150},{-146,-150},{-146,-38},{-121,-38}},
                                                       color={0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation (
     Line(points={{-179,-190},{-142,-190},{-142,-40},{-121,-40}},
                                                       color={0,0,127}));
  connect(econEnableDisableMultiZone.uZoneState, ZoneState.y)
    annotation (Line(points={{-121,-30},{-219,-30}},     color={255,127,0}));
  connect(TOutCut1.y, econEnableDisableMultiZone1.TOutCut) annotation (Line(
        points={{-19,70},{8,70},{8,-22},{39,-22}},      color={0,0,127}));
  connect(hOutCut1.y, econEnableDisableMultiZone1.hOutCut) annotation (Line(
        points={{-99,30},{-30,30},{-30,-26},{39,-26}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, econEnableDisableMultiZone.hOut) annotation (Line(
        points={{-259,70},{-220,70},{-220,46},{-170,46},{-170,-24},{-121,-24}},
        color={0,0,127}));
  connect(TOutBellowCutoff.y, econEnableDisableMultiZone1.TOut) annotation (
      Line(points={{-19,110},{10,110},{10,-20},{40,-20},{39,-20}}, color={0,0,
          127}));
  connect(booPul.y, TOut.u)
    annotation (Line(points={{-219,110},{-202,110}}, color={255,0,255}));
  connect(TOut.y, econEnableDisableMultiZone.TOut) annotation (Line(points={{-179,
          110},{-150,110},{-150,-20},{-121,-20}},
                                               color={0,0,127}));
  connect(booPul1.y, hOut1.u)
    annotation (Line(points={{-99,70},{-90,70},{-82,70}}, color={255,0,255}));
  connect(hOut1.y, econEnableDisableMultiZone1.hOut) annotation (Line(points={{
          -59,70},{-50,70},{-50,40},{-10,40},{-10,-24},{39,-24}}, color={0,0,
          127}));
  connect(FreProSta.y, econEnableDisableMultiZone1.uFreProSta) annotation (Line(
        points={{-219,10},{-92,10},{-92,-28},{39,-28}}, color={255,127,0}));
  connect(ZoneState.y, econEnableDisableMultiZone1.uZoneState) annotation (Line(
        points={{-219,-30},{-200,-30},{-200,0},{120,0},{120,-30},{39,-30}},
        color={255,127,0}));
  connect(outDamPosMax.y, econEnableDisableMultiZone1.uOutDamPosMax)
    annotation (Line(points={{-259,-70},{-34,-70},{-34,-32},{39,-32}}, color={0,
          0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone1.uOutDamPosMin)
    annotation (Line(points={{-259,-110},{-230,-110},{-230,-84},{-30,-84},{-30,
          -34},{39,-34}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone1.uRetDamPhyPosMax)
    annotation (Line(points={{-179,-110},{-24,-110},{-24,-36},{39,-36}}, color=
          {0,0,127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone1.uRetDamPosMax)
    annotation (Line(points={{-179,-150},{-20,-150},{-20,-38},{39,-38}}, color=
          {0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone1.uRetDamPosMin)
    annotation (Line(points={{-179,-190},{-8,-190},{-8,-40},{39,-40}}, color={0,
          0,127}));
  connect(TOut.y, econEnableDisableMultiZone2.TOut) annotation (Line(points={{
          -179,110},{-122,110},{-122,140},{158,140},{158,-20},{179,-20}}, color=
         {0,0,127}));
  connect(TOutCut.y, econEnableDisableMultiZone2.TOutCut) annotation (Line(
        points={{-179,70},{-222,70},{-222,134},{148,134},{148,-22},{179,-22}},
        color={0,0,127}));
  connect(FreProSta.y, econEnableDisableMultiZone2.uFreProSta) annotation (Line(
        points={{-219,10},{130,10},{130,-28},{179,-28}}, color={255,127,0}));
  connect(ZoneState.y, econEnableDisableMultiZone2.uZoneState) annotation (Line(
        points={{-219,-30},{-30,-30},{179,-30}}, color={255,127,0}));
  connect(outDamPosMax.y, econEnableDisableMultiZone2.uOutDamPosMax)
    annotation (Line(points={{-259,-70},{138,-70},{138,-32},{179,-32}}, color={
          0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone2.uOutDamPosMin)
    annotation (Line(points={{-259,-110},{-220,-110},{-220,-90},{148,-90},{148,
          -58},{148,-34},{179,-34}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone2.uRetDamPhyPosMax)
    annotation (Line(points={{-179,-110},{152,-110},{152,-36},{179,-36}}, color=
         {0,0,127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone2.uRetDamPosMax)
    annotation (Line(points={{-179,-150},{156,-150},{156,-38},{179,-38}}, color=
         {0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone2.uRetDamPosMin)
    annotation (Line(points={{-179,-190},{158,-190},{158,-40},{179,-40}}, color=
         {0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconEnableDisable_TOut_hOut.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-220},{300,
            220}}),                                                                  graphics={Text(
          extent={{-278,226},{-146,164}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="Example high limit cutoff conditions:
ASHRAE 90.1-2013:
Device Type: Fixed Enthalpy + Fixed Drybulb
TOut > 75 degF [24 degC] [297 K]
hOut > 28 Btu/lb [65.1 kJ/kg]"),                                                               Text(
          extent={{-280,170},{-156,142}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Temperature"),                                                           Text(
          extent={{-120,170},{8,142}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Entahlpy"),                                                              Text(
          extent={{160,170},{288,142}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="No fixed entahlpy sensor")}),
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
