within Districts.Electrical.AC.OnePhase.Examples;
model GeneratorLoadGrid "Generator with a load and grid connection"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.AC.OnePhase.Sources.Grid
               grid(
    f=60,
    V=220,
    Phi=0.5235987755983)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Districts.Electrical.AC.OnePhase.Sources.Generator
                                   sou(f=60, Phi=0.17453292519943)
    "Gas turbine"   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-30,-10})));
  Districts.Electrical.AC.OnePhase.Loads.InductiveLoadP
                                                     res(P_nominal=5e3,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=220) "Resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-10})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1e4,
    duration=0.6,
    startTime=0.1)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(ramp.y, sou.P) annotation (Line(
      points={{-59,-10},{-40,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, grid.terminal) annotation (Line(
      points={{-20,-10},{10,-10},{10,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(res.terminal, grid.terminal) annotation (Line(
      points={{20,-10},{10,-10},{10,40}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                     graphics), Documentation(info="<html>
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
January 10, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/Examples/GeneratorLoadGrid.mos"
        "Simulate and plot"));
end GeneratorLoadGrid;
