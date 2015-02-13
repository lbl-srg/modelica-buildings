within Annex60.Media.Water.Examples;
model DetailedProperties
  "Model that tests the implementation of the fluid properties"
  extends Modelica.Icons.Example;
  extends Annex60.Media.Water.Examples.BaseClasses.FluidProperties(
    redeclare package Medium = Annex60.Media.Water.Detailed,
    TMin=273.15,
    TMax=373.15);
equation
  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;
   annotation(experiment(StopTime=1),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Media/Water/Examples/DetailedProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DetailedProperties;
