within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples;
model Converter "Test for the AC/AC converter model"
  extends BaseClasses.TransformerExample(
  V_primary = 480,
  V_secondary = 240,
  redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probe_2,
  redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter
  tra(conversionFactor=0.5,eta=0.9));

equation
  connect(probe_2.term, tra.terminal_p) annotation (Line(
      points={{30,31},{30,4.44089e-16},{10,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example model tests the
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter</a> model.
</p>
</html>"),
experiment(Tolerance=1e-05),
__Dymola_Commands(file=
 "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/Converter.mos"
        "Simulate and plot"));
end Converter;
