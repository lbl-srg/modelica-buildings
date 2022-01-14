within Buildings.HeatTransfer.Data;
package Gases "Package with thermophysical properties for window fill gases"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Thermal properties of fill gas for windows"
      extends Modelica.Icons.Record;
    parameter Modelica.Units.SI.Length x "Gas layer thickness";
    parameter Modelica.Units.SI.ThermalConductivity a_k
      "Constant coefficient for thermal conductivity";
      parameter Real b_k(unit="W/(m.K2)")
      "Temperature dependent coefficient for thermal conductivity";
    parameter Modelica.Units.SI.DynamicViscosity a_mu
      "Constant coefficient for dynamic viscosity";
      parameter Real b_mu(unit="N.s/(m2.K)")
      "Temperature dependent coefficient for dynamic viscosity";
    parameter Modelica.Units.SI.SpecificHeatCapacity a_c
      "Constant coefficient for specific heat capacity";
      parameter Real b_c(unit="J/(kg.K2)")
      "Temperature dependent coefficient for specific heat capacity";

    parameter Modelica.Units.SI.MolarMass MM
      "Molar mass (of mixture or single fluid)";

    parameter Modelica.Units.SI.Pressure P0=101325 "Normal pressure";

    annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datGas",
      Documentation(info="<html>
Generic record for thermophysical properties for window
gas fills.
The implementation is according to
<a href=\"http://www.iso.org/iso/catalogue_detail.htm?csnumber=26425\">ISO 15099:2003,
Thermal performance of windows, doors and shading devices -- Detailed calculations</a>.
</html>",
  revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed <code>P0</code> from a <code>constant</code> to a
<code>parameter</code> to avoid a compilation error in
OpenModelica.
</li>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Air = Generic(a_k= 2.873E-3, b_k= 7.760E-5,
                       a_mu=3.723E-6, b_mu=4.940E-8,
                       a_c=1002.737,  b_c= 1.2324E-2,
                       MM=28.97E-3) "Thermophysical properties for air"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGas");

  record Argon = Generic(a_k= 2.285E-3, b_k= 5.149E-5,
                         a_mu=3.379E-6, b_mu=6.451E-8,
                         a_c=521.9285,  b_c= 0,
                         MM=39.948E-3) "Thermophysical properties for argon"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGas");

  record Krypton = Generic(a_k= 9.443E-4, b_k= 2.826E-5,
                           a_mu=2.213E-6, b_mu=7.777E-8,
                           a_c=248.0907,  b_c= 0,
                           MM=83.80E-3) "Thermophysical properties for krypton"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGas");

  record Xenon = Generic(a_k= 4.538E-4, b_k= 1.723E-5,
                         a_mu=1.069E-6, b_mu=7.414E-8,
                         a_c=158.3397,  b_c= 0,
                         MM=131.3E-3) "Thermophysical properties for krypton"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGas");

 function thermalConductivity
    "Function to compute the thermal conductivity of gases"
  input Buildings.HeatTransfer.Data.Gases.Generic gas "Record of gas data";
    input Modelica.Units.SI.Temperature T "Gas temperature";
    output Modelica.Units.SI.ThermalConductivity k "Thermal conductivity";
 algorithm
  k := gas.a_k + gas.b_k*T;
 end thermalConductivity;

function density "Function to compute the mass density"
  input Buildings.HeatTransfer.Data.Gases.Generic gas "Record of gas data";
    input Modelica.Units.SI.Temperature T "Gas temperature";
    output Modelica.Units.SI.Density rho "Mass density";
algorithm
    rho := gas.P0*gas.MM/Modelica.Constants.R/T;
end density;

function dynamicViscosity "Function to compute the dynamic viscosity for gases"
  input Buildings.HeatTransfer.Data.Gases.Generic gas "Record of gas data";
    input Modelica.Units.SI.Temperature T "Gas temperature";
    output Modelica.Units.SI.DynamicViscosity mu "Dynamic viscosity";
algorithm
    mu := gas.a_mu + gas.b_mu*T;
end dynamicViscosity;

function specificHeatCapacity
    "Function to compute the specific heat capacity for gases"
  input Buildings.HeatTransfer.Data.Gases.Generic gas "Record of gas data";
    input Modelica.Units.SI.Temperature T "Gas temperature";
    output Modelica.Units.SI.SpecificHeatCapacity c_p "Specific heat capacity";
algorithm
  c_p := gas.a_c + gas.b_c*T;
end specificHeatCapacity;
  annotation (Documentation(info="<html>
Package with records for thermophysical properties for window
gas fills.
The implementation is according to
<a href=\"http://www.iso.org/iso/catalogue_detail.htm?csnumber=26425\">ISO 15099:2003,
Thermal performance of windows, doors and shading devices -- Detailed calculations</a>.
</html>",
  revisions="<html>
<ul>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Gases;
