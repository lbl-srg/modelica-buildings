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
        origin={-10,36})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-62,76},{-42,96}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{6,76},{26,96}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{32,-88},{52,-68}})));
  Modelica.Electrical.Analog.Basic.Resistor res(R=0.5)
    annotation (Placement(transformation(extent={{-14,-18},{6,2}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-38,-70},{-18,-50}})));
  Modelica.Electrical.Analog.Sensors.PowerSensor powSen "Power sensor"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-42,86},{16,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.winSpe,tur. vWin) annotation (Line(
      points={{16,86},{16,60},{-10,60},{-10,48}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ground.p,res. n) annotation (Line(
      points={{42,-68},{42,-8},{6,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tur.p, res.p) annotation (Line(
      points={{-20,36},{-56,36},{-56,-8},{-14,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tur.n, ground.p) annotation (Line(
      points={{0,36},{42,36},{42,-68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.p, res.p) annotation (Line(
      points={{-38,-60},{-56,-60},{-56,-8},{-14,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n,powSen. pc) annotation (Line(
      points={{-18,-60},{0,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.nc, res.n) annotation (Line(
      points={{20,-60},{42,-60},{42,-8},{6,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.nv,sou. p) annotation (Line(
      points={{10,-70},{10,-80},{-38,-80},{-38,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.pv,powSen. nc) annotation (Line(
      points={{10,-50},{20,-50},{20,-60}},
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
