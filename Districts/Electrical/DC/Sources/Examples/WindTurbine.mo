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
        rotation=0,
        origin={-10,40})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-62,76},{-42,96}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{6,76},{26,96}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Districts.Electrical.DC.Loads.Resistor    res(R=0.5)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-60,10},{-80,30}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-42,86},{16,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.winSpe,tur. vWin) annotation (Line(
      points={{16,86},{16,60},{-10,60},{-10,52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ground.p, sou.n) annotation (Line(
      points={{-80,4.44089e-16},{-80,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.term, res.term) annotation (Line(
      points={{-60,20},{-44,20},{-44,6.66134e-16},{-20,6.66134e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.term, tur.term) annotation (Line(
      points={{-60,20},{-44,20},{-44,40},{-20,40}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=172800, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
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
January 29, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/WindTurbine.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end WindTurbine;
