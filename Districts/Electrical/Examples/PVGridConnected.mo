within Districts.Electrical.Examples;
model PVGridConnected
  "Example for the simple PV model that is connected to the grid"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Sources.PVSimple     pv(A=10) "PV module"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-10,40})));
  Districts.Electrical.DC.Loads.Resistor    res(R=0.5)
    annotation (Placement(transformation(extent={{2,-10},{-18,10}})));
  Districts.Electrical.AC.OnePhase.Sources.Grid
               grid(
    V=380,
    f=60,
    Phi=0)
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Districts.Electrical.AC.OnePhase.Conversion.ACDCConverter
    conACDC(conversionFactor=12/380, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{64,-10},{44,10}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam="modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-128,100},{-108,120}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
      points={{-108,110},{-80,110}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus,HDirTil. weaBus) annotation (Line(
      points={{-108,110},{-94,110},{-94,70},{-80,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{-59,110},{-52,110},{-52,96},{-42,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{-59,70},{-52,70},{-52,84},{-42,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, pv.G) annotation (Line(
      points={{-19,90},{-10,90},{-10,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.terminal, conACDC.terminal_p) annotation (Line(
      points={{0,40},{22,40},{22,0},{44,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.terminal, conACDC.terminal_p) annotation (Line(
      points={{2,0},{44,0},{44,5.55112e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conACDC.terminal_n, grid.terminal) annotation (Line(
      points={{64,4.44089e-16},{80,4.44089e-16},{80,20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=172800, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of the photovoltaic model
connected to a AC circuit.
</p>
<p>
The total solar irradiation is computed based on a weather data file
for San Francisco, CA. 
The PV is connected to a circuit that has resistance which may emulate a load, and an AC/DC converter.
The AC/DC converter converts 12 Volts AC to 380 Volts DC.
The block called <code>grid</code> has an output connector <code>P</code>
that shows the amount of power exchanged with the grid.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 4, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/Examples/PVGridConnected.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end PVGridConnected;
