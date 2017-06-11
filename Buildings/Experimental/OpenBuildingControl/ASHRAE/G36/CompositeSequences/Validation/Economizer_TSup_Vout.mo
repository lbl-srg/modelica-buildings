within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model Economizer_TSup_Vout
  "Validation model for disabling the economizer if the supply temperature remains below a predefined limit for longer than a predefined time duration."
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", displayUnit="degC", quantity="Temperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy")=65100 "Outdoor air enthalpy high limit cutoff";


  Modelica.Blocks.Sources.Ramp TSup(
    height=-10,
    duration=1800,
    offset=300)
    "TSup falls below 38 F and remains there for longer than 5 min. "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  EconomizerMultiZone economizer
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Constant VOutMinSet(k=0.5)
    "Outdoor air temperature, constant below example 75 F"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    startTime=0,
    height=0.05,
    offset=0.47)
    "TSup falls below 38 F and remains there for longer than 5 min. "
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  CDL.Continuous.Constant TSupSet(k=294)
    "Supply air temperature setpoint. The economizer control uses cooling supply temperature. fixme: change to a more realistic supply profile in the control domain"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp TOut(
    startTime=0,
    height=9,
    duration=1800,
    offset=292)  "297K is the cut off temeprature to disable the econ. "
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  CDL.Integers.Constant FreProSta(k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Integers.Constant ZoneState(k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Integers.Constant AHUMode(k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-120,2},{-100,22}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-122,
            -36},{-102,-16}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-122,92},{-102,112}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-124,58},
            {-104,78}})));
equation
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/CompositeSequences/Validation/fixme.mos"
  //     "Simulate and plot"),
  connect(TOut.y, economizer.TOut) annotation (Line(points={{21,70},{42,70},{42,
          22},{59,22}}, color={0,0,127}));
  connect(TSupSet.y, economizer.TCooSet) annotation (Line(points={{-59,70},{-50,
          70},{-50,50},{-10,50},{-10,12},{59,12}}, color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{-19,30},{20,30},{20,
          10},{59,10}}, color={0,0,127}));
  connect(TSup.y, economizer.TSup) annotation (Line(points={{-59,30},{-50,30},{-50,
          10},{4,10},{4,14},{59,14}}, color={0,0,127}));
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-30},{-10,
          -30},{-10,6},{59,6}}, color={255,0,255}));
  connect(economizer.uVOutMinSet, VOutMinSet.y) annotation (Line(points={{59,8},{
          -10,8},{-10,70},{-19,70}},   color={0,0,127}));
  connect(FreProSta.y, economizer.uFreProSta) annotation (Line(points={{-19,-70},
          {20,-70},{20,0},{59,0}}, color={255,127,0}));
  connect(AHUMode.y, economizer.uAHUMode) annotation (Line(points={{-59,-70},{-50,
          -70},{-50,-52},{16,-52},{16,4},{59,4}}, color={255,127,0}));
  connect(ZoneState.y, economizer.uZoneState) annotation (Line(points={{-59,-40},
          {0,-40},{0,2},{59,2}}, color={255,127,0}));
  connect(TOutBellowCutoff.y, economizer.TOut) annotation (Line(points={{-101,102},
          {-20,102},{-20,22},{59,22}}, color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-103,68},{-22,
          68},{-22,20},{59,20}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-99,12},
          {-20,12},{-20,18},{59,18}}, color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-101,-26},{-20,
          -26},{-20,16},{59,16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable</a>
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
end Economizer_TSup_Vout;
