within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Validation;
model Alarms "Validate block for generating alarms"

  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Alarms zonAla(
    final have_CO2Sen=true) "Block that generates alarms"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final duration=7200) "Generate ramp output"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=0.75)
    "Check if input is greater than 0.75"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=2)
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=295.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine zonTem(
    final amplitude=8,
    final freqHz=1/7200,
    final offset=273.15 + 15) "Zone temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=7200,
    final width=0.05)
    "Generate signal indicating suppressing status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine CO2(
    final amplitude=500,
    final freqHz=1/7200,
    final offset=600) "CO2 concentration"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

equation
  connect(ram.y, greThr.u)
    annotation (Line(points={{-98,-60},{-82,-60}}, color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,0,255}));
  connect(not1.y, booToInt.u)
    annotation (Line(points={{-18,-60},{-2,-60}},  color={255,0,255}));
  connect(booToInt.y, zonAla.uOpeMod) annotation (Line(points={{22,-60},{70,-60},
          {70,25},{98,25}}, color={255,127,0}));
  connect(zonTem.y, zonAla.TZon) annotation (Line(points={{-58,100},{80,100},{80,
          39},{98,39}}, color={0,0,127}));
  connect(TZonCooSetOcc.y, zonAla.TCooSet) annotation (Line(points={{-58,60},{
          60,60},{60,36},{98,36}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, zonAla.THeaSet) annotation (Line(points={{-58,20},{
          50,20},{50,33},{98,33}}, color={0,0,127}));
  connect(occSta.y, zonAla.u1ResSet) annotation (Line(points={{-58,-20},{60,-20},
          {60,28},{98,28}}, color={255,0,255}));
  connect(CO2.y, zonAla.ppmCO2) annotation (Line(points={{-58,-100},{80,-100},{80,
          22},{98,22}}, color={0,0,127}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ThermalZones/Validation/Alarms.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Alarms</a>
for generating alarms.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
        Ellipse(lineColor={75,138,73},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor={0,0,255},
                fillColor={75,138,73},
                pattern=LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end Alarms;
