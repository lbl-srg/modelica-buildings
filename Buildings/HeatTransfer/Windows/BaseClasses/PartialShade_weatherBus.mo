within Buildings.HeatTransfer.Windows.BaseClasses;
partial model PartialShade_weatherBus
  "Partial model to implement overhang and side fins with weather bus connector"
  extends Buildings.HeatTransfer.Windows.BaseClasses.ShadeInterface_weatherBus;
  // Window dimensions
  parameter Modelica.Units.SI.Length hWin "Window height"
    annotation (Dialog(tab="General", group="Window"));
  parameter Modelica.Units.SI.Length wWin "Window width"
    annotation (Dialog(tab="General", group="Window"));

protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Wall solar azimuth"  annotation (Placement(transformation(extent={{-60,-60},
            {-40,-40}})));

  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation
  connect(weaBus.solAlt, walSolAzi.alt) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-45.2},{-62,-45.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(walSolAzi.incAng, incAng) annotation (Line(
      points={{-62,-54.8},{-80,-54.8},{-80,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, HDirTil) annotation (Line(
      points={{81,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u1, HDirTilUns) annotation (Line(
      points={{58,66},{-80,66},{-80,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
Partial model to implement overhang and side fin model with weather bus as a connector.
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 25, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialShade_weatherBus;
