within Buildings.HeatTransfer.Windows.Examples;
model FixedShade "Test model for the fixed shade model"
  extends Modelica.Icons.Example;

  Buildings.HeatTransfer.Windows.FixedShade sha[4](
    final conPar=conPar,
    azi=conPar.azi) "Shade model"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=Buildings.Types.Tilt.Wall,
    azi=Buildings.Types.Azimuth.S) "Direct solar irradiation"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Routing.Replicator H(nout=4) "Replicator"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Routing.Replicator incAng(nout=4) "Replicator"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow conPar[4](
    each til=Buildings.Types.Tilt.Wall,
    each azi=Buildings.Types.Azimuth.S,
    each A=20,
    each hWin=1.5,
    each wWin=2,
    each glaSys=glaSys,
    each layers=insCon,
    ove(
      wR = {0.1, 0.1,   0, 0},
      wL = {0.1, 0.1,   0, 0},
      gap= {0.1, 0.1,   0, 0},
      dep= {1,   1,     0, 0}),
    sidFin(
      dep= {0,   1,     1, 0},
      gap= {0,   0.1, 0.1, 0},
      h =  {0,   0.1, 0.1, 0})) "Construction parameters"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys
    "Glazing system"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  parameter Data.OpaqueConstructions.Insulation100Concrete200 insCon
    "Insulation and concrete material"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(weaDat.weaBus, sha[1].weaBus) annotation (Line(
      points={{-40,0},{60,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, sha[2].weaBus) annotation (Line(
      points={{-40,0},{60,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, sha[3].weaBus) annotation (Line(
      points={{-40,0},{60,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus, weaDat.weaBus) annotation (Line(
      points={{-20,70},{-30,70},{-30,0},{-40,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.H, H.u) annotation (Line(
      points={{1,70},{18,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, incAng.u) annotation (Line(
      points={{1,66},{10,66},{10,30},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y,sha. incAng) annotation (Line(
      points={{41,30},{48,30},{48,-6},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(H.y,sha. HDirTilUns) annotation (Line(
      points={{41,70},{50,70},{50,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, sha[4].weaBus) annotation (Line(
      points={{-40,0},{60,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/FixedShade.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests window overhang and side fins. There are four instances of <code>sha</code>.
The first instance models an overhang only, the second models side fins and
an overhang, the third models side fins only and the fourth has neither an overhang
nor a side fin.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
October 20, 2014, by Michael Wetter:<br/>
Corrected error in the documentation.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Removed <code>redeclare</code> statement for <code>conPar.layer</code>.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed values of <code>wL</code> and <code>wR</code> for overhang
and <code>h</code> for window, to be
measured from the corner of the window.
</li>
<li>
March 6, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedShade;
