within Buildings.HeatTransfer.Convection.Examples;
model Exterior "Test model for exterior heat transfer coefficients"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant T1(k=290.15)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    annotation (Placement(transformation(extent={{120,40},{100,60}})));
  Buildings.HeatTransfer.Convection.Exterior nor(
    A=1,
    azi=Buildings.Types.Azimuth.N,
    til=Buildings.Types.Tilt.Wall,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "North-facing wall"                       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={30,30})));
  Buildings.HeatTransfer.Convection.Exterior wes(
    A=1,
    azi=Buildings.Types.Azimuth.W,
    til=Buildings.Types.Tilt.Wall,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "West facing wall"                                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-10,0})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA3
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA4
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.HeatTransfer.Convection.Exterior sou(
    A=1,
    azi=Buildings.Types.Azimuth.S,
    til=Buildings.Types.Tilt.Wall,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "South facing wall"                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={30,-30})));
  Buildings.HeatTransfer.Convection.Exterior eas(
    A=1,
    azi=Buildings.Types.Azimuth.E,
    til=Buildings.Types.Tilt.Wall,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "East facing wall"                          annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={70,-14})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB1(T=293.15)
    annotation (Placement(transformation(extent={{120,0},{100,20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB2(T=293.15)
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB3(T=293.15)
    annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  Modelica.Blocks.Sources.Ramp direction(duration=3600, height=2*3.14159)
    "Wind direction (0=from north)"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Modelica.Blocks.Sources.Constant vWin(k=2) "Wind speed"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(T1.y, TA4.T)   annotation (Line(
      points={{-79,50},{-72,50},{-72,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, TA3.T)   annotation (Line(
      points={{-79,50},{-72,50},{-72,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, TA2.T)   annotation (Line(
      points={{-79,50},{-72,50},{-72,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, TA1.T)   annotation (Line(
      points={{-79,50},{-62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA1.port, nor.solid) annotation (Line(
      points={{-40,50},{-10,50},{-10,30},{20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.port, wes.solid) annotation (Line(
      points={{-40,10},{-30,10},{-30,6.10623e-16},{-20,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA3.port, sou.solid) annotation (Line(
      points={{-40,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA4.port, eas.solid) annotation (Line(
      points={{-40,-70},{50,-70},{50,-14},{60,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.fluid, TB.port) annotation (Line(
      points={{40,30},{70,30},{70,50},{100,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wes.fluid, TB1.port) annotation (Line(
      points={{5.55112e-16,6.10623e-16},{20,6.10623e-16},{20,10},{100,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.fluid, TB2.port) annotation (Line(
      points={{80,-14},{90,-14},{90,-30},{100,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.fluid, TB3.port) annotation (Line(
      points={{40,-30},{70,-30},{70,-70},{100,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vWin.y, wes.v) annotation (Line(
      points={{-39,90},{-30,90},{-30,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin.y, nor.v) annotation (Line(
      points={{-39,90},{10,90},{10,40},{18,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin.y, eas.v) annotation (Line(
      points={{-39,90},{10,90},{10,-4},{58,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin.y, sou.v) annotation (Line(
      points={{-39,90},{10,90},{10,-20},{18,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(direction.y, nor.dir)
                           annotation (Line(
      points={{-39,130},{4,130},{4,35},{18,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(direction.y, sou.dir)
                           annotation (Line(
      points={{-39,130},{4,130},{4,-25},{18,-25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(direction.y, wes.dir)
                           annotation (Line(
      points={{-39,130},{-34,130},{-34,5},{-22,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(direction.y, eas.dir)
                           annotation (Line(
      points={{-39,130},{50,130},{50,-9},{58,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},
            {140,180}})),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Convection/Examples/Exterior.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests the convective heat transfer models for exterior surfaces.
From <i>t=0...3600</i> seconds, the wind traverses from North to West to South to East and back to
North. The plot shows the influence of the wind direction on the forced convection
coefficient for wall surfaces that face North, West, East and South.
</html>", revisions="<html>
<ul>
<li>
March 9 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Exterior;
