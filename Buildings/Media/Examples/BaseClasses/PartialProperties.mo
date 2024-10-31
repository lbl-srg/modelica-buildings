within Buildings.Media.Examples.BaseClasses;
partial model PartialProperties
  "Partial model that contains common parameters of the fluid properties"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;

  parameter Modelica.Units.SI.Temperature TMin
    "Minimum temperature for the simulation";
  parameter Modelica.Units.SI.Temperature TMax
    "Maximum temperature for the simulation";
  parameter Modelica.Units.SI.Pressure p=Medium.p_default "Pressure";
  parameter Modelica.Units.SI.MassFraction X[Medium.nX]=Medium.X_default
    "Mass fraction";
  parameter Real errAbs=1E-8 "Absolute error used in the check of the state calculations";
  Medium.Temperature T "Temperature";
  Modelica.Units.NonSI.Temperature_degC T_degC "Celsius temperature";

  Medium.ThermodynamicState state_pTX "Medium state";

  Modelica.Units.SI.Density d "Density";
  Modelica.Units.SI.DynamicViscosity eta "Dynamic viscosity";
  Modelica.Units.SI.SpecificEnthalpy h "Specific enthalpy";
  Modelica.Units.SI.SpecificInternalEnergy u "Specific internal energy";
  Modelica.Units.SI.SpecificEntropy s "Specific entropy";
  Modelica.Units.SI.SpecificEnergy g "Specific Gibbs energy";
  Modelica.Units.SI.SpecificEnergy f "Specific Helmholtz energy";

  Modelica.Units.SI.SpecificEnthalpy hIse "Isentropic enthalpy";

  Modelica.Media.Interfaces.Types.IsobaricExpansionCoefficient beta
    "Isobaric expansion coefficient";
  Modelica.Units.SI.IsothermalCompressibility kappa
    "Isothermal compressibility";

  Modelica.Units.SI.SpecificHeatCapacity cp "Specific heat capacity";
  Modelica.Units.SI.SpecificHeatCapacity cv "Specific heat capacity";
  Modelica.Units.SI.ThermalConductivity lambda "Thermal conductivity";

  Modelica.Units.SI.AbsolutePressure pMed "Pressure";
  Medium.Temperature TMed "Temperature";
  Modelica.Units.SI.MolarMass MM "Mixture molar mass";

  Medium.BaseProperties basPro "Medium base properties";
protected
  constant Real conv(unit="1/s") = 1 "Conversion factor to satisfy unit check";

  function checkState "This function checks the absolute error in the state calculations"
    extends Modelica.Icons.Function;
    input Medium.ThermodynamicState state1 "Medium state";
    input Medium.ThermodynamicState state2 "Medium state";
    input Real errAbs "Absolute error threshold";
    input String message "Message for error reporting";

  protected   Real TErrAbs=abs(Medium.temperature(state1)-Medium.temperature(state2))
      "Absolute error in temperature";
  protected   Real pErrAbs=abs(Medium.pressure(state1)-Medium.pressure(state2))
      "Absolute error in pressure";
  algorithm
    assert(TErrAbs < errAbs, "Absolute temperature error: " + String(TErrAbs) +
       " K. Error in temperature of " + message);
    assert(pErrAbs < errAbs, "Absolute pressure error: " + String(pErrAbs) +
       " Pa. Error in pressure of " + message);
  end checkState;

equation
    // Compute temperatures that are used as input to the functions
    T = TMin + conv*time * (TMax-TMin);
    T_degC =Modelica.Units.Conversions.to_degC(T);

    // Check the implementation of the functions
    d = Medium.density(state_pTX);
    eta = Medium.dynamicViscosity(state_pTX);
    h = Medium.specificEnthalpy(state_pTX);

    u = Medium.specificInternalEnergy(state_pTX);
    s = Medium.specificEntropy(state_pTX);
    g = Medium.specificGibbsEnergy(state_pTX);
    f = Medium.specificHelmholtzEnergy(state_pTX);
    hIse = Medium.isentropicEnthalpy(p, state_pTX);
    beta = Medium.isobaricExpansionCoefficient(state_pTX);
    kappa = Medium.isothermalCompressibility(state_pTX);

    cp = Medium.specificHeatCapacityCp(state_pTX);
    cv = Medium.specificHeatCapacityCv(state_pTX);
    lambda = Medium.thermalConductivity(state_pTX);
    pMed = Medium.pressure(state_pTX);
    assert(abs(p-pMed) < errAbs, "Error in pressure computation.");
    TMed = Medium.temperature(state_pTX);
    assert(abs(T-TMed) < errAbs, "Error in temperature computation.");
    MM = Medium.molarMass(state_pTX);
    // Check the implementation of the base properties
    assert(abs(h-basPro.h) < errAbs, "Error in enthalpy computation in BaseProperties.");
    assert(abs(u-basPro.u) < errAbs, "Error in internal energy computation in BaseProperties.");

   annotation (
Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 5, 2023 by Hongxiang Fu:<br/>
Removed a self-dependent input binding in the function <code>checkState</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3384\">#3384</a>.
</li>
<li>
March 24, 2020, by Kathryn Hinkelman:<br/>
Expand error message for checkState and added absolute error as input.
</li>
<li>
September 16, 2019, by Yangyang Fu:<br/>
Reconstruct the implementation structure to avoid duplicated codes for different media.
This fixes <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1206\">#1206</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Changed type of <code>T</code> from
<code>Modelica.Units.SI.Temperature</code> to <code>Medium.Temperature</code>.
Otherwise, it has a different start value than <code>BaseProperties.T</code>, which
causes an error if
<a href=\"modelica://Buildings.Media.Examples.WaterProperties\">
Buildings.Media.Examples.WaterProperties</a>
is translated in pedantic mode.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
October 16, 2014, by Michael Wetter:<br/>
Removed call to <code>setState_dTX</code> as this
function is physically not defined for incompressible media.
</li>
<li>
December 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialProperties;
