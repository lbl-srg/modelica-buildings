within Buildings.Fluid;
package HeatPumps "Package with chiller models"
  extends Modelica.Icons.VariantsPackage;
annotation (preferredView="info", Documentation(info="<html>
This package contains components models for chillers.
The model
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot\">
Buildings.Fluid.HeatPumps.Carnot</a> computes the coefficient of performance
based on a change in the Carnot effectiveness.
The models
<a href=\"modelica://Buildings.Fluid.HeatPumps.ElectricReformulatedEIR\">
Buildings.Fluid.HeatPumps.ElectricReformulatedEIR</a>
and
<a href=\"modelica://Buildings.Fluid.HeatPumps.ElectricEIR\">
Buildings.Fluid.HeatPumps.ElectricEIR</a>
use performance curves from the package
<a href=\"modelica://Buildings.Fluid.HeatPumps.Data\">
Buildings.Fluid.HeatPumps.Data</a>
to compute the chiller performance.
</html>"));
end HeatPumps;
