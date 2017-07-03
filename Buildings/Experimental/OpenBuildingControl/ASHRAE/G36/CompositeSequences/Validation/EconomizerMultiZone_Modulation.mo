within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model EconomizerMultiZone_Modulation
  "Validates multizone VAV AHU economizer model damper modulation and minimum ooutdoor air requirement damper position limits"
                                    //fixme: add mos file
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", quantity="TermodynamicTemperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", quantity="SpecificEnergy")=65100 "Outdoor air enthalpy high limit cutoff";
  parameter Real airflowSetpoint(unit="m3/s", displayUnit="m3/h")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real TSupSet(unit="K", quantity="TermodynamicTemperature")=291 "Supply air temperature setpoint";

  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0 (=0)";
  parameter Types.FreezeProtectionStage freProEnabled = Types.FreezeProtectionStage.stage2
    "Indicates that the freeze protection is enabled";
  parameter Integer freProEnabledNum = Integer(freProEnabled)-1
    "Numerical value for freeze protection stage 2 (=2)";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "AHU operation mode is \"Occupied\"";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for \"Occupied\" AHU operation mode";
  parameter Types.ZoneState deadband = Types.ZoneState.deadband
    "Zone state is deadband";
  parameter Integer deadbandNum = Integer(deadband)
    "Numerical value for deadband zone state (=2)";

  EconomizerMultiZone economizer(fixEnt=true) "Multizone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Integers.Constant FreProSta(k=freProDisabledNum) "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  CDL.Integers.Constant ZoneState(k=heatingNum) "Zone State is heating"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  CDL.Integers.Constant OperationMode(k=occupiedNum)
                                           "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 40000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 30)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Constant VOutMinSet(k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    height=0.2,
    offset=airflowSetpoint - 0.1)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=4,
    offset=TSupSet - 2,
    duration=1800) "This supply air temperature would cause modulation if the economizer was enabled"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Continuous.Constant TSupSetSig(k=TSupSet) "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  EconomizerMultiZone economizer1 "Multizone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
equation
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-10},{-10,-10},{-10,6},{19,6}},
                                   color={255,0,255}));
  connect(FreProSta.y, economizer.uFreProSta) annotation (Line(points={{-99,-140},{0,-140},{0,0},{19,0}},
                                      color={255,127,0}));
  connect(OperationMode.y, economizer.uOperationMode) annotation (Line(points={{-99,-100},{-50,-100},{-50,-30},{-4,-30},
          {-4,4},{19,4}},                             color={255,127,0}));
  connect(ZoneState.y, economizer.uZoneState) annotation (Line(points={{-99,-60},{-50,-60},{-50,-30},{-2,-30},{-2,2},{19,
          2}},                         color={255,127,0}));
  connect(TOutBellowCutoff.y, economizer.TOut) annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},
                                 color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-99,70},{-90,70},{-8,70},{-8,20},{19,20}},
                                               color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},
                                                      color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},
                                                      color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{-19,90},{-8,90},{-8,10},{19,10}},
                          color={0,0,127}));
  connect(VOutMinSet.y, economizer.uVOutMinSet) annotation (Line(points={{-19,50},{-10,50},{-10,8},{19,8}},
                                      color={0,0,127}));
  connect(TSup.y, economizer.TSup) annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}},
                        color={0,0,127}));
  connect(TSupSetSig.y, economizer.TCooSet) annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},
                                 color={0,0,127}));
  connect(TOutCut1.y, economizer1.TOutCut) annotation (Line(points={{-99,70},{72,70},{72,0},{99,0}}, color={0,0,127}));
  connect(TOutBellowCutoff.y, economizer1.TOut)
    annotation (Line(points={{-99,110},{80,110},{80,2},{99,2}}, color={0,0,127}));
  connect(hOutCut.y, economizer1.hOutCut)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,78},{76,78},{76,-4},{99,-4}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer1.hOut)
    annotation (Line(points={{-99,20},{-80,20},{-80,28},{-80,28},{68,28},{68,-2},{99,-2}}, color={0,0,127}));
  connect(TSup.y, economizer1.TSup)
    annotation (Line(points={{-59,90},{-50,90},{-50,118},{82,118},{82,-6},{99,-6}}, color={0,0,127}));
  connect(TSupSetSig.y, economizer1.TCooSet)
    annotation (Line(points={{-59,50},{-52,50},{-52,68},{74,68},{74,-8},{99,-8}}, color={0,0,127}));
  connect(VOut.y, economizer1.uVOut) annotation (Line(points={{-19,90},{78,90},{78,-10},{99,-10}}, color={0,0,127}));
  connect(VOutMinSet.y, economizer1.uVOutMinSet)
    annotation (Line(points={{-19,50},{70,50},{70,-12},{99,-12}}, color={0,0,127}));
  connect(FanStatus.y, economizer1.uSupFan)
    annotation (Line(points={{-19,-10},{20,-10},{20,-14},{99,-14}}, color={255,0,255}));
  connect(ZoneState.y, economizer1.uZoneState)
    annotation (Line(points={{-99,-60},{20,-60},{20,-18},{99,-18}}, color={255,127,0}));
  connect(OperationMode.y, economizer1.uOperationMode)
    annotation (Line(points={{-99,-100},{18,-100},{18,-16},{99,-16}},
                                                                    color={255,127,0}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/CompositeSequences/Validation/EconomizerMultiZone_TSup_VOut.mos"
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
        graphics={Text(
          extent={{52,106},{86,84}},
          lineColor={28,108,200}),
        Text(
          extent={{2,156},{86,128}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation 
(uZoneState is Heating), 
enable minimal 
outdoor air control"),
        Text(
          extent={{82,152},{166,124}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation
(uZoneState is Heating)
disable minimal 
outdoor air control
(uFreProSta is Stage2)")}),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerMultiZone_Modulation;
