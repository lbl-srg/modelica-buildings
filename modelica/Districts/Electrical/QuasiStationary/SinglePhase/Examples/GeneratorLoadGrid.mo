within Districts.Electrical.QuasiStationary.SinglePhase.Examples;
model GeneratorLoadGrid "Generator with a load and grid connection"
  extends Modelica.Icons.Example;

  Sources.Grid grid(
    V=380,
    f=60,
    phi=0.5235987755983)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.VoltageSensor
    volSenGri annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={46,-10})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar volSenGriCon
    annotation (Placement(transformation(
        origin={80,-10},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));
  Sources.Generator                sou(P_nominal=10e3) "Gas turbine"
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-10})));
  Loads.InductorResistor                             res(P_nominal=5e3)
    "Resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-10})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(volSenGri.y, volSenGriCon.u) annotation (Line(
      points={{57,-10},{68,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(volSenGri.pin_p, ground.pin) annotation (Line(
      points={{46,-20},{46,-32},{-30,-32},{-30,-56}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(grid.pin, sou.pin_p) annotation (Line(
      points={{10,40},{10,14},{-30,14},{-30,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(grid.pin, volSenGri.pin_n) annotation (Line(
      points={{10,40},{10,14},{46,14},{46,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.pin_n,ground. pin)           annotation (Line(
      points={{-30,-20},{-30,-33},{-30,-33},{-30,-56}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(res.pin_p,sou. pin_p) annotation (Line(
      points={{10,0},{10,14},{-30,14},{-30,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(res.pin_n,ground. pin) annotation (Line(
      points={{10,-20},{10,-32},{-30,-32},{-30,-56}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ramp.y, sou.y) annotation (Line(
      points={{-59,-10},{-50,-10},{-50,-10},{-40,-10}},
      color={0,0,127},
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
January 10, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Examples/GeneratorLoadGrid.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-80},{120,80}})));
end GeneratorLoadGrid;
