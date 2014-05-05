within Districts.Electrical.DC.Sources.Examples;
model WindTurbine "Example for the WindTurbine model"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Sources.WindTurbine           tur(
    table=[3.5, 0;
           5.5,   100;
           12, 900;
           14, 1000;
           25, 1000], h=10) "Wind turbine"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={50,40})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-62,76},{-42,96}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{6,76},{26,96}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Districts.Electrical.DC.Loads.Resistor    res(R=0.5)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Districts.Electrical.DC.Lines.TwoPortResistance lin(R=0.05)
    "Transmission line"
    annotation (Placement(transformation(extent={{-32,30},{-12,50}})));
  Districts.Electrical.DC.Sensors.GeneralizedSensor sen
    annotation (Placement(transformation(extent={{-2,30},{18,50}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-42,86},{16,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.winSpe,tur. vWin) annotation (Line(
      points={{16,86},{50,86},{50,52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ground.p, sou.n) annotation (Line(
      points={{-80,4.44089e-16},{-80,20},{-80,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal) annotation (Line(
      points={{-60,20},{-40,20},{-40,0},{-20,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_n, res.terminal) annotation (Line(
      points={{-32,40},{-40,40},{-40,0},{-20,0},{-20,5.55112e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_p, sen.terminal_n) annotation (Line(
      points={{-12,40},{-2,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, tur.terminal) annotation (Line(
      points={{18,40},{40,40}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=172800, Tolerance=1e-05),
Documentation(info="<html>
<p>
This model illustrates the use of the wind turbine model which is connected to a DC voltage source and a resistance.
This voltage source may be a DC grid to which the
circuit is connected.
Wind data for San Francisco, CA, are used.
The turbine cut-in wind speed is <i>3.5</i> m/s,
and hence it is off in the first day when the wind speed is low.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/WindTurbine.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end WindTurbine;
