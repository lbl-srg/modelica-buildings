within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples;
model TransformerStepDownDY
  "Test for the AC/AC transformer model with Delta-Wye configuration (step-down voltage)"
  extends BaseClasses.TransformerExample(
  redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probe_2,
  redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY
  tra(VHigh=V_primary,
      VLow=V_secondary,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000));

equation
  connect(probe_2.term, load.terminal) annotation (Line(
      points={{30,31},{30,0},{50,0}},
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
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY</a> model.
</p>
</html>"),
experiment(Tolerance=1e-05),
__Dymola_Commands(file=
 "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepDownDY.mos"
        "Simulate and plot"));
end TransformerStepDownDY;
