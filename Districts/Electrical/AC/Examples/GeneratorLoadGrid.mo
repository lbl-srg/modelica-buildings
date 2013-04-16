within Districts.Electrical.AC.Examples;
model GeneratorLoadGrid "Generator with a load and grid connection"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.AC.Sources.Grid
               grid(
    V=380,
    f=60,
    phi=0.5235987755983)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar volSenGriCon
    annotation (Placement(transformation(
        origin={50,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Districts.Electrical.AC.Sources.Generator
                                   sou(P_nominal=10e3) "Gas turbine"
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-10})));
  Districts.Electrical.AC.Loads.InductorResistor     res(P_nominal=5e3)
    "Resistance"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={10,-10})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{-78,-46},{-58,-26}})));
equation
  connect(ramp.y, sou.y) annotation (Line(
      points={{-57,-36},{-30,-36},{-30,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(grid.sPhasePlug, res.sPhasePlug) annotation (Line(
      points={{9.9,40},{9.9,20},{10,20},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(grid.sPhasePlug, sou.sPhasePlug) annotation (Line(
      points={{9.9,40},{10,40},{10,20},{-30,20},{-30,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(res.v, volSenGriCon.u) annotation (Line(
      points={{15,-5},{25.5,-5},{25.5,-10},{38,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -80},{120,80}}),        graphics), Documentation(info="<html>
<p>
This model illustrates a generator, an inductive load and a grid connection.
The power output of the generator is equal to its input signal, which is 
a ramp function.
The output <code>grid.P</code> shows
the actual and apparent power, the power factor and
the phase angle.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/Examples/GeneratorLoadGrid.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-80},{120,80}})));
end GeneratorLoadGrid;
