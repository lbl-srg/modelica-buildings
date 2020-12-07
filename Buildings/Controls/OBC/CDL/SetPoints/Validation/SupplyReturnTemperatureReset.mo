within Buildings.Controls.OBC.CDL.SetPoints.Validation;
model SupplyReturnTemperatureReset "Test model for the heating curve"
  Buildings.Controls.OBC.CDL.SetPoints.SupplyReturnTemperatureReset heaCur(
    m=1,
    TSup_nominal=333.15,
    TRet_nominal=313.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with varying outdoor temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    height=40,
    duration=1,
    offset=263.15,
    y(unit="K")) "Outdoor temperature varying from -10 degC to 30 degC"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.SetPoints.SupplyReturnTemperatureReset
  heaCur1(
    m=1,
    dTOutHeaBal=15,
    TSup_nominal=333.15,
    TRet_nominal=313.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with changing room setpoint temperature"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse TRoo1(
    offset=273.15 + 20,
    delay=0.5,
    amplitude=-5,
    period=1,
    y(unit="K"))  "Night set back from 20 degC to 15 degC"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    k=273.15 - 10,
    y(unit="K"))
    "Constant outdoor air temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  TRoo(
    k=273.15 + 20,
    y(unit="K"))
    "Room temperature 20 degC"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(TOut1.y, heaCur1.TOut)
    annotation (Line(points={{-38,-20},{-38,-20},{0,-20},{0,-34},{18,-34}},
      color={0,0,127}));
  connect(TOut.y, heaCur.TOut)
    annotation (Line(points={{-38,60},{-38,60},{0,60},{0,46},{18,46}},
      color={0,0,127}));
  connect(TRoo.y, heaCur.TSetZon)
    annotation (Line(points={{-38,20},{0,20},{0,34},{18,34}},
      color={0,0,127}));
  connect(TRoo1.y, heaCur1.TSetZon)
    annotation (Line(points={{-38,-60},{0,-60},{0,-46},{18,-46}},
      color={0,0,127}));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/SetPoints/Validation/SupplyReturnTemperatureReset.mos"
      "Simulate and plot"),
  Documentation(info="<html>
<p>
Example that demonstrates the use of the hot water temperature reset
for a heating system.
The parameters of the block <code>heaCur</code>
are for a heating system with
<i>60</i>&deg;C supply water temperature and
<i>40</i>&deg;C return water temperature at
an outside temperature of
<i>-10</i>&deg;C and a room temperature of
<i>20</i>&deg;C. The offset for the temperature reset is
<i>8</i> Kelvin, i.e., above
<i>12</i>&deg;C outside temperature, there is no heating load.
The figure below shows the computed supply and return water temperatures.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/SetPoints/SupplyReturnTemperatureReset.png\"
border=\"1\"
alt=\"Supply and return water temperatures.\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end SupplyReturnTemperatureReset;
