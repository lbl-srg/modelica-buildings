within Buildings.Media.Antifreeze.Validation;
model PropyleneGlycolWater
  "Model that tests the implementation of propylene glycol-water properties"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Antifreeze.Validation.BaseClasses.FluidProperties(
    redeclare package Medium =
        Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater
        ( property_T=300,
          X_a=0.05),
    nX_a=7,
    X_a={0.05,0.10,0.20,0.30,0.40,0.50,0.60},
    T_min=223.15,
    T_max=373.15);

   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Antifreeze/Validation/PropyleneGlycolWater.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks the implementation of functions that evaluate the
temperature- and concentration-dependent thermophysical properties of the
medium.
</p>
<p>
Thermophysical properties (density, specific heat capacity, thermal conductivity
and dynamic viscosity) are shown as 0 if the temperature is below the fusion
temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 14, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));

end PropyleneGlycolWater;
