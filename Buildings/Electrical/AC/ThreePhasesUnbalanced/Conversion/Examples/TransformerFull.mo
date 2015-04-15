within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples;
model TransformerFull "Test for the AC/AC transformer full model"
  extends BaseClasses.TransformerExample(
  redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probe_2,
  redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull
  tra(VHigh=V_primary,
      VLow=V_secondary,
      VABase=6000000,
      f=60,
      R1=0.005,
      L1=0.005*6,
      R2=0.005,
      L2=0.005*6,
      magEffects=true,
      Rm=10,
      Lm=10),
      load(initMode=Buildings.Electrical.Types.InitMode.linearized));

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
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull</a> model.
</p>
</html>"),
experiment(Tolerance=1e-05),
__Dymola_Commands(file=
 "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerFull.mos"
        "Simulate and plot"));
end TransformerFull;
