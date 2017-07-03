within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model EconomizerMultiZone_Disable
  "Validates modulation and damper limit control loop disable conditions for the multizone economizer model"
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
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "Zone state is deadband";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for deadband zone state (=2)";
  parameter Types.ZoneState heating = Types.ZoneState.heating
    "Zone state is heating";
  parameter Integer heatingNum = Integer(heating)
    "Numerical value for heating zone state (=1)";

  EconomizerMultiZone economizer(fixEnt=true)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Integers.Constant FreProSta(k=freProDisabledNum)
                                       "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  CDL.Integers.Constant ZoneState(k=heatingNum) "Zone State is heating"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  CDL.Integers.Constant OperationMode(k=occupiedNum)
                                           "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 40000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 30)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  CDL.Continuous.Constant VOutMinSet(k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    height=0.2,
    offset=airflowSetpoint - 0.1)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=4,
    offset=TSupSet - 2,
    duration=1800) "This supply air temperature would cause modulation if the economizer was enabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Constant TSupSetSig(k=TSupSet) "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  EconomizerMultiZone economizer1
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Integers.Constant FreProSta1(k=freProDisabledNum)
                                       "Freeze Protection Status"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
equation
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-50},{-10,-50},{-10,-34},{19,-34}},
                                   color={255,0,255}));
  connect(FreProSta.y, economizer.uFreProSta) annotation (Line(points={{-19,-90},{0,-90},{0,-40},{19,-40}},
                                      color={255,127,0}));
  connect(OperationMode.y, economizer.uOperationMode) annotation (Line(points={{-59,-90},{-50,-90},{-50,-70},{-4,-70},{
          -4,-36},{19,-36}},                          color={255,127,0}));
  connect(ZoneState.y, economizer.uZoneState) annotation (Line(points={{-59,-60},{-50,-60},{-50,-70},{-2,-70},{-2,-38},
          {19,-38}},                   color={255,127,0}));
  connect(TOutBellowCutoff.y, economizer.TOut) annotation (Line(points={{-99,70},{-6,70},{-6,-18},{19,-18}},
                                 color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-99,30},{-90,30},{-8,30},{-8,-20},{19,-20}},
                                               color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-99,-10},{-52,-10},{-52,-22},{-4,-22},{19,-22}},
                                                      color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-99,-50},{-90,-50},{-90,-40},{-52,-40},{-52,-24},{19,
          -24}},                                      color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{-19,50},{-8,50},{-8,-30},{19,-30}},
                          color={0,0,127}));
  connect(VOutMinSet.y, economizer.uVOutMinSet) annotation (Line(points={{-19,10},{-10,10},{-10,-32},{19,-32}},
                                      color={0,0,127}));
  connect(TSup.y, economizer.TSup) annotation (Line(points={{-59,50},{-50,50},{-50,-26},{19,-26}},
                        color={0,0,127}));
  connect(TSupSetSig.y, economizer.TCooSet) annotation (Line(points={{-59,10},{-50,10},{-50,-28},{19,-28}},
                                 color={0,0,127}));
  connect(FreProSta1.y, economizer1.uFreProSta)
    annotation (Line(points={{81,20},{81,20},{99,20}},                 color={255,127,0}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}}),
        graphics={Text(
          extent={{52,106},{86,84}},
          lineColor={28,108,200}),
        Text(
          extent={{-120,120},{-36,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Disable modulation (uZoneState is Heating), 
enable minimal outdoor air control"),
        Text(
          extent={{60,120},{144,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Disable modulation, 
disable minimal outdoor air control")}),
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
end EconomizerMultiZone_Disable;
