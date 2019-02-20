within Buildings.Media.Examples;
model PropyleneGlycolWaterTestImplementation
  "Model that tests the medium implementation"
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
     redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
      X_a=0.60,
      property_T=293.15));

      annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/PropyleneGlycolWaterTestImplementation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a simple test for the medium model. It uses the test model described in
<a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition.TestOfMedium\">
Modelica.Media.UsersGuide.MediumDefinition.TestOfMedium</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 13, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PropyleneGlycolWaterTestImplementation;
