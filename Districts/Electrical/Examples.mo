within Districts.Electrical;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
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
          origin={-52,0})));
    Modelica.Electrical.Analog.Basic.Ground groDC "Ground for DC grid"
      annotation (Placement(transformation(extent={{-22,-32},{-2,-12}})));
    Districts.Electrical.AC.Sources.Grid
      grid(V=380, f=60, phi=0)
      annotation (Placement(transformation(extent={{30,28},{50,48}})));
    Districts.Electrical.AC.Conversion.ACDCConverter
      conACDC(       conversionFactor=240/380, eta=0.9) "AC/DC converter"
      annotation (Placement(transformation(extent={{24,-10},{4,10}})));
    Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
      annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
    Districts.BoundaryConditions.WeatherData.Bus weaBus
      annotation (Placement(transformation(extent={{-62,60},{-42,80}})));
    Districts.Electrical.DC.Interfaces.DCplug dCplug1
      annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  equation
    connect(weaDat.weaBus, weaBus) annotation (Line(
        points={{-70,70},{-52,70}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(weaBus.winSpe, tur.vWin) annotation (Line(
        points={{-52,70},{-52,12}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(conACDC.plug1, grid.sPhasePlug) annotation (Line(
        points={{24,8.88178e-16},{39.9,8.88178e-16},{39.9,28}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(tur.dcPlug, conACDC.dCplug) annotation (Line(
        points={{-42,0},{-20,0},{-20,8.88178e-16},{4,8.88178e-16}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(conACDC.dCplug, dCplug1) annotation (Line(
        points={{4,0},{-12,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(groDC.p, dCplug1.n) annotation (Line(
        points={{-12,-12},{-12,8.88178e-16}},
        color={0,0,255},
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
January 10, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
      Commands(file=
            "Resources/Scripts/Dymola/Electrical/Examples/WindTurbineGridConnected.mos"
          "Simulate and plot"),
      experiment(StopTime=259200, Tolerance=1e-05),
      __Dymola_experimentSetupOutput);
  end WindTurbineGridConnected;

  model PVGridConnected
    "Example for the simple PV model that is connected to the grid"
    import Districts;
    extends Modelica.Icons.Example;
    Districts.Electrical.DC.Sources.PVSimple     pv(A=10) "PV module"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-10,40})));
    Modelica.Electrical.Analog.Basic.Ground groDC "Ground for DC grid"
      annotation (Placement(transformation(extent={{22,-36},{42,-16}})));
    Districts.Electrical.DC.Loads.Resistor    res(R=0.5)
      annotation (Placement(transformation(extent={{2,-10},{-18,10}})));
    Districts.Electrical.AC.Sources.Grid
                 grid(
      V=380,
      f=60,
      phi=0)
      annotation (Placement(transformation(extent={{70,20},{90,40}})));
    Districts.Electrical.AC.Conversion.ACDCConverter
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
        computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
      annotation (Placement(transformation(extent={{-128,100},{-108,120}})));
    Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
    Districts.Electrical.DC.Interfaces.DCplug dCplug1
      annotation (Placement(transformation(extent={{22,-10},{42,10}})));
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
    connect(conACDC.plug1, grid.sPhasePlug) annotation (Line(
        points={{64,8.88178e-16},{79.9,8.88178e-16},{79.9,20}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(res.dcPlug, conACDC.dCplug) annotation (Line(
        points={{2,0},{44,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(conACDC.dCplug, pv.dcPlug) annotation (Line(
        points={{44,8.88178e-16},{30,8.88178e-16},{30,0},{20,0},{20,40},{
            4.44089e-16,40}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(conACDC.dCplug, dCplug1) annotation (Line(
        points={{44,0},{32,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dCplug1.n, groDC.p) annotation (Line(
        points={{32,8.88178e-16},{32,-16}},
        color={0,0,255},
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
January 4, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
      Commands(file=
            "Resources/Scripts/Dymola/Electrical/Examples/PVGridConnected.mos"
          "Simulate and plot"),
      Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
  end PVGridConnected;
end Examples;
