within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples;
model TransformerStepDownYD
  "Test for the AC/AC transformer model with Wye-Delta configuration (step-down voltage)"
  extends BaseClasses.TransformerExample(
  redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta probe_2,
  redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD
  tra(VHigh=V_primary,
      VLow=V_secondary,
      XoverR=6,
      Zperc=sqrt(0.01^2 + 0.06^2),
      VABase=6000000));

equation
  connect(probe_2.term, load.terminal) annotation (Line(
      points={{30,31},{30,0},{50,0},{50,5.55112e-16}},
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
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD</a> model.
</p>
<h4>Note:</h4>
<p>
When the secondary side of the transformer is in the Delta (D) configuration,
measuring the voltage with a Wye (Y) is not possible because the voltage vectors
in the connector do not have a neutral reference.
</p>
</html>"),
experiment(Tolerance=1e-05),
__Dymola_Commands(file=
 "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepDownYD.mos"
        "Simulate and plot"));
end TransformerStepDownYD;
