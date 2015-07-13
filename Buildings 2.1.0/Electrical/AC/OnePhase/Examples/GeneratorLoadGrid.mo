within Buildings.Electrical.AC.OnePhase.Examples;
model GeneratorLoadGrid "Generator with a load and grid connection"
  extends Modelica.Icons.Example;

  Sources.Grid grid(
    f=60,
    V=120,
    phiSou=0.5235987755983) "Electrical grid"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Sources.Generator sou(f=60, phiGen(displayUnit="rad")) "Gas turbine"
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={-30,-10})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive res(
    mode=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    P_nominal=-5e3,
    V_nominal=120,
    pf=1) "Inductive load"      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={30,-10})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1e4,
    duration=0.6,
    startTime=0.1,
    offset=0)
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
  annotation (experiment(
      StopTime=1.0,
      Tolerance=1e-05),
      __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Examples/GeneratorLoadGrid.mos"
        "Simulate and plot"),
        Documentation(info="<html>
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
</html>"));
end GeneratorLoadGrid;
