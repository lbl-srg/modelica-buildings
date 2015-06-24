within Buildings.Electrical.AC.OnePhase.Examples;
model GridDCLoad "Model of a DC load connected to the grid"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.Grid
               grid(
    f=60,
    phiSou=0,
    V=120)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter
                                                   idealACDCConverter1(
                               eta=0.9,
    ground_AC=false,
    conversionFactor=12/120)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Buildings.Electrical.DC.Loads.Resistor    resistor(R=1, V_nominal=12)
                                                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
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
  annotation (experiment(
      StopTime=1.0,
      Tolerance=1e-05),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Examples/GridDCLoad.mos"
        "Simulate and plot"),
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
</html>"));
end GridDCLoad;
