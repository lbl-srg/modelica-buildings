within Districts.Electrical.Examples;
model WindTurbineGridConnected
  "Test model for wind turbine whose power is specified by a table"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Sources.WindTurbine           tur(
    table=[3.5, 0;
           5.5,   100;
           12, 900;
           14, 1000;
           25, 1000], h=10) "Wind turbine"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,0})));
  Districts.Electrical.AC.OnePhase.Sources.Grid
    grid(V=380, f=60, Phi=0)
    annotation (Placement(transformation(extent={{30,28},{50,48}})));
  Districts.Electrical.AC.OnePhase.Conversion.ACDCConverter
    conACDC(       conversionFactor=240/380, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{24,-10},{4,10}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-62,60},{-42,80}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-70,70},{-52,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.winSpe, tur.vWin) annotation (Line(
      points={{-52,70},{-52,12},{-50,12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tur.terminal, conACDC.terminal_p) annotation (Line(
      points={{-40,4.44089e-16},{-20,4.44089e-16},{-20,0},{4,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conACDC.terminal_n, grid.terminal) annotation (Line(
      points={{24,4.44089e-16},{40,4.44089e-16},{40,28}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
This model illustrates the use of the wind turbine model, 
connected to an alternate current grid
using an AC/DC converter.
Wind data for San Francisco, CA, are used.
The turbine cut-in wind speed is <i>3.5</i> m/s,
and hence it is off in the first day when the wind speed is low.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 10, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/Examples/WindTurbineGridConnected.mos"
        "Simulate and plot"),
    experiment(StopTime=259200, Tolerance=1e-05),
    __Dymola_experimentSetupOutput);
end WindTurbineGridConnected;
