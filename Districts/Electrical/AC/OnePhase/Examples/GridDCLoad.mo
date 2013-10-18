within Districts.Electrical.AC.OnePhase.Examples;
model GridDCLoad "Model of a DC load connected to the grid"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.OnePhase.Sources.Grid
               grid(
    V=380,
    f=60,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Districts.Electrical.AC.OnePhase.Conversion.ACDCConverter
                                                   idealACDCConverter1(
      conversionFactor=12/380, eta=0.9,
    ground_AC=false)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Districts.Electrical.DC.Loads.Resistor    resistor(R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
equation
  connect(grid.terminal, idealACDCConverter1.terminal_n) annotation (Line(
      points={{-70,-20},{-70,-30},{-50,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(idealACDCConverter1.terminal_p, resistor.terminal) annotation (Line(
      points={{-30,-30},{0,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),      graphics),
    experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model for inductive load. The circuit on the left hand side
uses an inductive load, whereas the circuit on the right hand side uses a resistor and inductance in
series.
The parameters of the inductor and resistor are such that the real power and the phase angle are
identical (up to the numerical precision of the parameters) for the two systems.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/Examples/GridDCLoad.mos"
        "Simulate and plot"));
end GridDCLoad;
