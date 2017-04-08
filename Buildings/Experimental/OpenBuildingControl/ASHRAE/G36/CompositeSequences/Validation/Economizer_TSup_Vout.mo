within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model Economizer_TSup_Vout
  "Validation model for disabling the economizer if the supply temperature remains below a predefined limit for longer than a predefined time duration."
  extends Modelica.Icons.Example;

  CDL.Logical.Constant FreezestatStatus(k=false)
    "Keep freezestat alarm off for this validation test"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=-10,
    duration=1800,
    offset=75)
    "TSup falls below 38 F and remains there for longer than 5 min. "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Economizer economizer
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
  CDL.Logical.Constant AHUMode(k=true) "AHU is enabled"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Continuous.Constant uHea(k=0) "Heating signal, range 0 - 1"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Continuous.Constant uCoo(k=0.2) "Cooling signal, range 0 - 1"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Continuous.Constant TSupSet(k=70, unit="F", displayUnit="F")
    "Supply air temperature setpoint. The economizer control uses cooling supply temperature. fixme: change to a more realistic supply profile in the control domain"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp TOut(
    duration=800,
    height=6,
    offset=293,
    startTime=0) "297K is the cut off temeprature to disable the econ. "
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/CompositeSequences/Validation/fixme.mos"
  //     "Simulate and plot"),
  connect(TOut.y, economizer.TOut) annotation (Line(points={{21,70},{42,70},{42,
          20},{59,20}}, color={0,0,127}));
  connect(TSupSet.y, economizer.TCooSet) annotation (Line(points={{-59,70},{-50,
          70},{-50,50},{-10,50},{-10,18},{59,18}}, color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{-19,30},{20,30},{20,
          12},{59,12}}, color={0,0,127}));
  connect(VOutMinSet.y, economizer.uVOutMinSet) annotation (Line(points={{-19,70},
          {20,70},{20,14},{59,14}}, color={0,0,127}));
  connect(TSup.y, economizer.TSup) annotation (Line(points={{-59,30},{-50,30},{-50,
          10},{4,10},{4,16},{59,16}}, color={0,0,127}));
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-30},{-10,
          -30},{-10,4},{59,4}}, color={255,0,255}));
  connect(FreezestatStatus.y, economizer.uFre) annotation (Line(points={{-59,-30},
          {-50,-30},{-50,2},{59,2}}, color={255,0,255}));
  connect(AHUMode.y, economizer.uAHUMod) annotation (Line(points={{-19,-70},{0,-70},
          {0,10},{59,10}}, color={255,0,255}));
  connect(uCoo.y, economizer.uCoo) annotation (Line(points={{41,-30},{50,-30},{50,
          8},{59,8}}, color={0,0,127}));
  connect(uHea.y, economizer.uHea) annotation (Line(points={{41,-70},{50,-70},{50,
          6},{59,6}}, color={0,0,127}));
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
