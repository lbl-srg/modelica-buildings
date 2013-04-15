within Districts.Electrical.DC.Sources.Examples;
model PVSimple "Example for the PVSimple model with constant load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Sources.PVSimple     pv(A=10) "PV module"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,40})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{70,-80},{90,-60}})));
  Modelica.Electrical.Analog.Basic.Resistor res(R=0.5)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Electrical.Analog.Sensors.PowerSensor powSen "Power sensor"
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-128,90},{-108,110}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(pv.p, res.p) annotation (Line(
      points={{0,40},{-20,40},{-20,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.n, pv.n) annotation (Line(
      points={{20,-40},{80,-40},{80,40},{20,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ground.p, res.n) annotation (Line(
      points={{80,-60},{80,-40},{20,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.p, res.p) annotation (Line(
      points={{0,0},{-20,0},{-20,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, powSen.pc) annotation (Line(
      points={{20,0},{38,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.nc, res.n) annotation (Line(
      points={{58,0},{80,0},{80,-40},{20,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.nv, sou.p) annotation (Line(
      points={{48,-10},{48,-20},{0,-20},{0,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.pv, powSen.nc) annotation (Line(
      points={{48,10},{58,10},{58,0}},
      color={0,0,255},
      smooth=Smooth.None));
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
      points={{-19,80},{10,80},{10,52}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=172800, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
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
January 4, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/PVSimple.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end PVSimple;
