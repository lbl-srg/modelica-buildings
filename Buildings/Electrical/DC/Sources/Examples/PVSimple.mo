within Buildings.Electrical.DC.Sources.Examples;
model PVSimple "Example for the PVSimple model with constant load"
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Sources.PVSimple     pv(A=10, V_nominal=12)
    "PV module"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={50,40})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}})));
  Buildings.Electrical.DC.Loads.Resistor    res(R=0.5, V_nominal=12)
    "Resistance"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-128,90},{-108,110}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Electrical.DC.Lines.TwoPortResistance lin(R=0.05)
    "Transmission line"
    annotation (Placement(transformation(extent={{-38,30},{-18,50}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen "Sensor"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  connect(weaDat.weaBus, HDifTil.weaBus) annotation (Line(
      points={{-108,100},{-80,100}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, HDirTil.weaBus) annotation (Line(
      points={{-108,100},{-94,100},{-94,60},{-80,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDifTil.H, G.u1) annotation (Line(
      points={{-59,100},{-52,100},{-52,86},{-42,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, G.u2) annotation (Line(
      points={{-59,60},{-52,60},{-52,74},{-42,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, pv.G) annotation (Line(
      points={{-19,80},{50,80},{50,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal) annotation (Line(
      points={{-62,0},{-2,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_n, res.terminal) annotation (Line(
      points={{-38,40},{-50,40},{-50,0},{-2,0},{-2,5.55112e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_p, sen.terminal_n) annotation (Line(
      points={{-18,40},{-4.44089e-16,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, pv.terminal) annotation (Line(
      points={{20,40},{40,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{-82,0},{-82,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=172800, Tolerance=1e-6),
Documentation(info="<html>
<p>
This model illustrates the use of the photovoltaic model.
The total solar irradiation is computed based
on a weather data file.
The PV is connected to a circuit that has a constant voltage
source and a resistance.
This voltage source may be a DC grid to which the
circuit is connected.
The power sensor shows how much electrical power is consumed or fed into the voltage source.
In actual systems, the voltage source may be an AC/DC converter.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/PVSimple.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end PVSimple;
