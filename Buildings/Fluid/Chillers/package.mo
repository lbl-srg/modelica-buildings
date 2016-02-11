within Buildings.Fluid;
package Chillers "Package with chiller models"
  extends Modelica.Icons.VariantsPackage;

annotation (preferredView="info", Documentation(info="<html>
This package contains components models for chillers.
The models
<a href=\"modelica://Buildings.Fluid.Chillers.Carnot_TEva\">
Buildings.Fluid.Chillers.Carnot_TEva</a> and
<a href=\"modelica://Buildings.Fluid.Chillers.Carnot_y\">
Buildings.Fluid.Chillers.Carnot_y</a>
compute the coefficient of performance
based on a change in the Carnot effectiveness.
The first takes as a control signal the evaporator leaving water temperature,
and the second takes as the control signal the compressor speed.
The models
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>
and
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>
use performance curves from the package
<a href=\"modelica://Buildings.Fluid.Chillers.Data\">
Buildings.Fluid.Chillers.Data</a>
to compute the chiller performance.
</html>"));
end Chillers;
