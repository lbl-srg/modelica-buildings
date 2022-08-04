within Buildings.Fluid.Data;
package Fuels "Package with properties of fuels"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record NaturalGasLowerHeatingValue = Buildings.Fluid.Data.Fuels.Generic (
      h=50E6,
      d=0.84,
      mCO2=2.23) "Natural gas, lower heating value"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFue");

  record NaturalGasHigherHeatingValue = NaturalGasLowerHeatingValue (
      h=55.5E6) "Natural gas, higher heating value"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFue");

  record HeatingOilLowerHeatingValue = Buildings.Fluid.Data.Fuels.Generic (
      h=42.6E6,
      d=845,
      mCO2=3.136) "Heating oil, lower heating value"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFue");

  record HeatingOilHigherHeatingValue = HeatingOilLowerHeatingValue (
      h=45.4E6) "Heating oil, higher heating value"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFue");

  record WoodAirDriedLowerHeatingValue = Buildings.Fluid.Data.Fuels.Generic (
      h=14.6E6,
      d=700,
      mCO2=0) "Wood, air-dried, lower heating value" annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datFue",
    Documentation(info=
     "<html>
<p>
The lower heating value is based on Recknagel 2005, Tafel 1.3.6-1.
</p>
<h4>References</h4>
<p>
Hermann Recknagel, Eberhard Sprenger and Ernst-Rudolf Schramek. Taschenbuch fuer Heizung und Klimatechnik.72. Auflage. Oldenbourg Industrieverlage Muenchen. ISBN 3-486-26560-1. 2005.
</p>
</html>"));

  record Generic "Generic record of fuel properties"
    extends Modelica.Icons.Record;
    parameter Modelica.Units.SI.SpecificEnthalpy h
      "Heating value (lower or upper, depending on fuel)";
    parameter Modelica.Units.SI.Density d "Mass density";
    parameter Real mCO2(final min=0) "CO2 emission at combustion, in kg/kg fuel";
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFue",
      Documentation(info=
                   "<html>
<p>
This is a generic record where the fuel properties need to be specified by the user.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2013 by Michael Wetter:<br/>
Corrected wrong type for <code>mCO2</code>.
It was declared as <code>Modelica.Units.SI.MassFraction</code>,
which is incorrect.
</li>
<li>
December 22, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

    annotation (
preferredView="info",
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
December 22, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Fuels;
