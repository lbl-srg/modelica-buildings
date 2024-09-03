within Buildings.Media.Examples;
model PropyleneGlycolWaterProperties
  "Model that tests the implementation of the fluid properties"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.FluidProperties(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
      X_a=0.60,
      property_T=293.15),
    TMin=273.15,
    TMax=373.15);
equation
  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;
   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/PropyleneGlycolWaterProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 13, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PropyleneGlycolWaterProperties;
