within Buildings.Fluid.Data;
package Fuels "Package with properties of fuels"
    extends Modelica.Icons.MaterialPropertiesPackage;

    annotation (
preferedView="info",
Documentation(info="<html>
<p>
Package with records for fuel properties.
Note that the heating value and the mass density can vary for individual fuels.
The parameter <code>mCO2</code> are the CO<sub>2</sub> emission in kilograms 
that are released per kilogram fuel that is burnt.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  record NaturalGasLowerHeatingValue = Buildings.Fluid.Data.Fuels.Generic (
      h=50E6,
      d=0.84,
      mCO2=2.23) "Natural gas, lower heating value";
  record NaturalGasHigherHeatingValue = NaturalGasLowerHeatingValue (
      h=55.5E6) "Natural gas, higher heating value";

  record HeatingOilLowerHeatingValue = Buildings.Fluid.Data.Fuels.Generic (
      h=42.6E6,
      d=845,
      mCO2=3.136) "Heating oil, lower heating value";
  record HeatingOilHigherHeatingValue = HeatingOilLowerHeatingValue (
      h=45.4E6) "Heating oil, higher heating value";

// fixme: add wood and pellet, review the provided data, add reference for source data,
// such as ASHRAE or Recknagel.

record Generic "Generic record of fuel properties"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.SpecificEnthalpy h
      "Heating value (lower or upper, depending on fuel)";
    parameter Modelica.SIunits.Density d "Mass density";
    parameter Modelica.SIunits.MassFraction mCO2
      "CO2 emission at combustion, in kg/kg fuel";
    annotation (Documentation(info="<html>
<p>
This is a generic record where the fuel properties need to be specified by the user.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Generic;

end Fuels;
