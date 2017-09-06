within Buildings.Media.Examples.BaseClasses;
partial model FluidProperties
  "Model that tests the implementation of the fluid properties"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;

  parameter Modelica.SIunits.Temperature TMin
    "Minimum temperature for the simulation";
  parameter Modelica.SIunits.Temperature TMax
    "Maximum temperature for the simulation";
  parameter Modelica.SIunits.Pressure p = Medium.p_default "Pressure";
  parameter Modelica.SIunits.MassFraction X[Medium.nX]=
    Medium.X_default "Mass fraction";
  Medium.Temperature T "Temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC
    "Celsius temperature";

  Medium.ThermodynamicState state_pTX "Medium state";
  Medium.ThermodynamicState state_phX "Medium state";
  Medium.ThermodynamicState state_psX "Medium state";

  Modelica.SIunits.Density d "Density";
  Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  Modelica.SIunits.SpecificInternalEnergy u "Specific internal energy";
  Modelica.SIunits.SpecificEntropy s "Specific entropy";
  Modelica.SIunits.SpecificEnergy g "Specific Gibbs energy";
  Modelica.SIunits.SpecificEnergy f "Specific Helmholtz energy";

  Modelica.SIunits.SpecificEnthalpy hIse "Isentropic enthalpy";

  Modelica.Media.Interfaces.Types.IsobaricExpansionCoefficient beta
    "Isobaric expansion coefficient";
  Modelica.SIunits.IsothermalCompressibility kappa "Isothermal compressibility";

  Modelica.Media.Interfaces.Types.DerDensityByPressure ddpT
    "Density derivative w.r.t. pressure";
  Modelica.Media.Interfaces.Types.DerDensityByTemperature ddTp
    "Density derivative w.r.t. temperature";
  Modelica.SIunits.Density[Medium.nX] dddX
    "Density derivative w.r.t. mass fraction";

  Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
  Modelica.SIunits.SpecificHeatCapacity cv "Specific heat capacity";
  Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";

  Modelica.SIunits.AbsolutePressure pMed "Pressure";
  Medium.Temperature TMed "Temperature";
  Modelica.SIunits.MolarMass MM "Mixture molar mass";

  Medium.BaseProperties basPro "Medium base properties";
protected
  constant Real conv(unit="1/s") = 1 "Conversion factor to satisfy unit check";

  function checkState
    extends Modelica.Icons.Function;
    input Medium.ThermodynamicState state1 "Medium state";
    input Medium.ThermodynamicState state2 "Medium state";
    input String message "Message for error reporting";
  algorithm
    assert(abs(Medium.temperature(state1)-Medium.temperature(state2))
       < 1e-8, "Error in temperature of " + message);
    assert(abs(Medium.pressure(state1)-Medium.pressure(state2))
       < 1e-8, "Error in pressure of " + message);
  end checkState;
equation
    // Compute temperatures that are used as input to the functions
    T = TMin + conv*time * (TMax-TMin);
    T_degC = Modelica.SIunits.Conversions.to_degC(T);

    // Check setting the states
    state_pTX = Medium.setState_pTX(p=p, T=T, X=X);
    state_phX = Medium.setState_phX(p=p, h=h, X=X);
    state_psX = Medium.setState_psX(p=p, s=s, X=X);
    checkState(state_pTX, state_phX, "state_phX");
    checkState(state_pTX, state_psX, "state_psX");

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

    ddpT = Medium.density_derp_T(state_pTX);
    ddTp = Medium.density_derT_p(state_pTX);
    dddX   = Medium.density_derX(state_pTX);

    cp = Medium.specificHeatCapacityCp(state_pTX);
    cv = Medium.specificHeatCapacityCv(state_pTX);
    lambda = Medium.thermalConductivity(state_pTX);
    pMed = Medium.pressure(state_pTX);
    assert(abs(p-pMed) < 1e-8, "Error in pressure computation.");
    TMed = Medium.temperature(state_pTX);
    assert(abs(T-TMed) < 1e-8, "Error in temperature computation.");
    MM = Medium.molarMass(state_pTX);
    // Check the implementation of the base properties
    assert(abs(h-basPro.h) < 1e-8, "Error in enthalpy computation in BaseProperties.");
    assert(abs(u-basPro.u) < 1e-8, "Error in internal energy computation in BaseProperties.");

   annotation (
Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 6, 2015, by Michael Wetter:<br/>
Changed type of <code>T</code> from
<code>Modelica.SIunits.Temperature</code> to <code>Medium.Temperature</code>.
Otherwise, it has a different start value than <code>BaseProperties.T</code>, which
causes an error if
<a href=\"Buildings.Media.Examples.WaterProperties\">
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
end FluidProperties;
