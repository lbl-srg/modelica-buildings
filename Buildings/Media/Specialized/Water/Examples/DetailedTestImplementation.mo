within Annex60.Media.Water.Examples;
model DetailedTestImplementation "Model that tests the medium implementation"
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
     redeclare package Medium = Annex60.Media.Water.Detailed);

      annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Media/Water/Examples/DetailedTestImplementation.mos"
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
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DetailedTestImplementation;
