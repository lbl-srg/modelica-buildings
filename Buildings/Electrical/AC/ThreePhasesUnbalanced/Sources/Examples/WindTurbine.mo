within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Examples;
model WindTurbine "Example for the WindTurbine AC model"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.WindTurbine tur(
    table=[3.5, 0;
           5.5,   100;
           12, 900;
           14, 1000;
           25, 1000], h=10,
    scale=10,
    V_nominal=480,
    scaleFraction={0.5,0.25,0.25}) "Wind turbine"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={60,0})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-52,36},{-32,56}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus";
  Loads.Resistive                           res(P_nominal=-500, V_nominal=480)
    "Resistive line"
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  Grid                                                     sou(f=60, V=480)
    "Voltage source"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Sensors.GeneralizedSensor                         sen "Generalized sensor"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line line(
    l=200,
    P_nominal=5000,
    V_nominal=480)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-32,46},{26,46}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.winSpe,tur. vWin) annotation (Line(
      points={{26,46},{60,46},{60,12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal) annotation (Line(
      points={{-70,10},{-70,-20},{-22,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen.terminal_p, tur.terminal) annotation (Line(
      points={{28,0},{50,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, line.terminal_n) annotation (Line(
      points={{-70,10},{-70,0},{-40,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, sen.terminal_n) annotation (Line(
      points={{-20,5.55112e-16},{8,0},{8,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=172800, Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model illustrates the use of the wind turbine model,
which is connected to a AC voltage source and a resistive load.
This voltage source can represent the grid to which the
circuit is connected.
Wind data for San Francisco, CA, are used.
The turbine cut-in wind speed is <i>3.5</i> m/s,
and hence it is off in the first day when the wind speed is low.
</p>
<p>
The wind turbines produce different amounts of power on each phase according to the fractions
specified by the vector <code>scaleFraction={0.5,0.25,0.25}</code>. In this example, 50%
of the power generation is on phase 1, 30% on phase 2 and 20% on phase 3.
As expected the phase with the higher power production has the higher voltage deviation
from the nominal condition.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/WindTurbine.mos"
        "Simulate and plot"));
end WindTurbine;
