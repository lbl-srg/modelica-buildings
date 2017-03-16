within Buildings.Fluid.HeatExchangers.BaseClasses;
function wetCoilInitial
  "Initial wet coil effectiveness-NTU calculations; to be conducted while
  iterating on TWatOut"

  // INPUTS
  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Modelica.SIunits.MassFlowRate masFloWat
    "Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  input Modelica.SIunits.Temperature TWatOutGuess
    "A guess variable for the outlet water temperature";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate masFloAir
    "Mass flow rate of air";
  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  input Modelica.SIunits.Pressure pAir
    "Pressure on air-side of coil";
  input Modelica.SIunits.SpecificEnthalpy hAirIn
    "Specific enthalpy of air at inlet conditions";
  input Modelica.SIunits.SpecificEnthalpy hAirSatSurIn
    "Specific enthalpy of saturated air at inlet at coil surface";
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The configuration of the heat exchanger";

  // OUTPUTS
  output Modelica.SIunits.HeatFlowRate QTot
    "Total heat flow from 'air' into 'water' stream";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";

protected
  constant Integer watIdx = 1
    "Index of Water for Air medium";
  constant Integer othIdx = 2
    "Index of Other component of Air medium";
  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";
  Modelica.SIunits.SpecificEnthalpy hAirSatSurOut
    "Specific enthalpy of saturated air at outlet at coil surface";
  Real effSta
    "Effectiveness for heat exchanger (e*)";
  Real mSta
    "ratio of product of mass flow rates and specific
    heats; analogous to capacitance rate ratio Cmin/Cmax
    (Braun 2013 Ch02 eq 2.20)";
  Modelica.SIunits.MassFlowRate UAsta
    "Overall mass transfer coefficient for dry coil";
  Real NtuSta
    "Number of transfer units (NTU*)";
  Modelica.SIunits.AbsolutePressure pSatWatOut
    "Saturation pressure of water vapor at outlet";
  Modelica.SIunits.MassFraction XAirSatOut[2]
    "Mass fractions of components at outlet";

algorithm
  if masFloWat < 1e-4 or masFloAir < 1e-4 or UAAir < 1e-4 or UAWat < 1e-4 or
     (abs(TAirIn - TWatIn) < 1e-4) then
    QTot := 0;
    // stop iteration immediately by returning the guess value
    TWatOut := TWatOutGuess;
  else
    pSatWatOut :=
      Buildings.Utilities.Psychrometrics.Functions.saturationPressure(
        TWatOutGuess);
    XAirSatOut[watIdx] := Buildings.Utilities.Psychrometrics.Functions.X_pW(
      p_w=pSatWatOut, p=pAir);
    XAirSatOut[othIdx] := 1 - XAirSatOut[watIdx];
    hAirSatSurOut := Buildings.Media.Air.specificEnthalpy_pTX(
      p=pAir, T=TWatOutGuess, X=XAirSatOut);
    cpEff := abs(hAirSatSurOut - hAirSatSurIn)
      / max(abs(TWatOutGuess - TWatIn), 0.1);
    mSta := max((masFloAir * cpEff) / (masFloWat * cpWat), 0.01)
      "Braun et al 2013 eq 2.20";
    UAsta := (UAAir / cpAir) / (1 + (cpEff * UAAir) / (cpAir * UAWat))
      "Mitchell 2012 eq 13.19";
    NtuSta := UAsta / masFloAir
      "Mitchell 2012 eq 13.20";
    effSta := effCalc(CSta=mSta, Ntu=NtuSta, cfg=cfg);
    QTot := effSta * masFloAir * (hAirIn - hAirSatSurIn);
    TWatOut := (QTot / (masFloWat * cpWat)) + TWatIn;
  end if;
end wetCoilInitial;
