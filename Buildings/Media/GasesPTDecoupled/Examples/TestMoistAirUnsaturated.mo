within Buildings.Media.GasesPTDecoupled.Examples;
model TestMoistAirUnsaturated
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
     redeclare package Medium =
          Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated);

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/GasesPTDecoupled/Examples/TestMoistAirUnsaturated.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This is a simple test for the medium model. It uses the test model described in
<a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition.TestOfMedium\">
Modelica.Media.UsersGuide.MediumDefinition.TestOfMedium</a>.
</html>", revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestMoistAirUnsaturated;
