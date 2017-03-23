within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCalcs "Wet effectiveness-NTU calculations"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component: the 'water'"
    annotation (choicesAllMatching = true);

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Modelica.SIunits.MassFlowRate masFloWat
    "Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Medium1.Temperature TWatIn
    "Water temperature at inlet";
  input Medium1.Temperature TWatOutGuess
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
  input Modelica.SIunits.MassFraction wAirIn
    "Mass fraction of water in moist air at inlet";
  input Modelica.SIunits.SpecificEnthalpy hAirIn
    "Specific enthalpy of air at inlet conditions";
  input Modelica.SIunits.SpecificEnthalpy hAirSatSurIn
    "Specific enthalpy of saturated air at inlet at coil surface";
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The configuration of the heat exchanger";

  output Modelica.SIunits.HeatFlowRate QTot
    "Total heat flow from 'air' into 'water' stream";
  output Modelica.SIunits.HeatFlowRate QSen
     "Sensible heat flow from 'water' into 'air' stream";
  output Medium1.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Modelica.SIunits.MassFlowRate masFloCon
    "The amount of condensate removed from 'air' stream";
  output Modelica.SIunits.Temperature TCon
    "Temperature of the condensate leaving the air stream";

protected
  constant Real phiSat(min=0, max=1) = 1
    "Relative humidity at saturation conditions";
  constant Integer watIdx = 1
    "Index for water in Buildings.Media.Air";
  constant Integer othIdx = 2
    "Index for other component of Buildings.Media.Air";
  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";
  Modelica.SIunits.SpecificEnthalpy hAirOut
    "Specific enthalpy of air outlet";
  Modelica.SIunits.SpecificEnthalpy hAirSatSurOut
    "Specific enthalpy of saturated air at outlet at coil surface";
  Modelica.SIunits.SpecificEnthalpy hSurEff
    "Effective surface enthalpy; assumes coil surface is at a uniform
    temperature and enthalpy";
  Real effSta
    "Effectiveness for heat exchanger (e*)";
  Modelica.SIunits.Temperature TSurEff
    "Effective surface temperature of the coil";
  Modelica.SIunits.AbsolutePressure pSatOut
    "Saturation pressure at air outlet conditions";
  Real mSta
    "ratio of product of mass flow rates and specific
    heats; analogous to capacitance rate ratio Cmin/Cmax
    (Braun 2013 Ch02 eq 2.20)";
  Modelica.SIunits.MassFlowRate UAsta
    "Overall mass transfer coefficient for dry coil";
  Real NtuSta
    "Number of transfer units (NTU*)";
  Real NtuAirSta
    "Number of transfer units for air-side only (NTU_a*)";
  Modelica.SIunits.MassFraction XOut[2]
    "Mass fraction of air at outlet";
  Modelica.SIunits.MassFraction XAirSatOut[2]
    "Mass fractions of components at outlet";
  Modelica.SIunits.AbsolutePressure pSatWatOut
    "Saturation pressure of water vapor at outlet";
  Modelica.SIunits.MassFraction wAirOut
    "Mass fraction of water in air at outlet";
  Modelica.SIunits.AbsolutePressure pSatEff
    "Saturation pressure of water vapor at the effective surface temperature";
  Modelica.SIunits.MassFraction XSurEff[2]
    "Mass fraction of air at the surface effective conditions";

equation
  if noEvent(
      masFloWat < 1e-4 or masFloAir < 1e-4 or UAAir < 1e-4
      or UAWat < 1e-4 or (abs(TAirIn - TWatIn) < 1e-4)) then
    QTot = 0;
    QSen = 0;
    TWatOut = TWatIn;
    TAirOut = TAirIn;
    masFloCon = 0;
    TCon = TAirIn;
    // Other Equations
    cpEff = 0;
    hAirOut = hAirIn;
    hAirSatSurOut = hAirIn;
    hSurEff = hAirIn;
    effSta = 0;
    TSurEff = TAirIn;
    pSatEff = 0;
    XSurEff[1] = 0;
    XSurEff[2] = 0;
    pSatOut = 0;
    mSta = 0;
    UAsta = 0;
    NtuSta = 0;
    NtuAirSta = 0;
    XOut[watIdx] = wAirIn;
    XOut[othIdx] = 1 - wAirIn;
    XAirSatOut[watIdx] = wAirIn;
    XAirSatOut[othIdx] = 1 - wAirIn;
    pSatWatOut = 0;
    wAirOut = wAirIn;
  else
    pSatWatOut =
      Buildings.Utilities.Psychrometrics.Functions.saturationPressure(
        TWatOutGuess);
    XAirSatOut[watIdx] =  Buildings.Utilities.Psychrometrics.Functions.X_pW(
      p_w=pSatWatOut, p=pAir);
    XAirSatOut[othIdx] =  1 - XAirSatOut[watIdx];
    hAirSatSurOut =  Buildings.Media.Air.specificEnthalpy_pTX(
      p=pAir, T=TWatOutGuess, X=XAirSatOut);
    cpEff =  abs(hAirSatSurOut - hAirSatSurIn)
      / max(abs(TWatOutGuess - TWatIn), 0.1);
    mSta =  max((masFloAir * cpEff) / (masFloWat * cpWat), 0.01)
      "Braun et al 2013 eq 2.20";
    UAsta = (UAAir / cpAir) / (1 + (cpEff*UAAir) / (cpAir*UAWat))
      "Mitchell 2012 eq 13.19";
    NtuSta =  UAsta/masFloAir
      "Mitchell 2012 eq 13.20";
    effSta = epsilon_ntuZ(
      Z = mSta,
      NTU = NtuSta,
      flowRegime = Integer(cfg));
    QTot = effSta * masFloAir * (hAirIn - hAirSatSurIn);
    TWatOut = (QTot / (masFloWat * cpWat)) + TWatIn;
    hAirOut = hAirIn - (QTot / masFloAir);
    NtuAirSta = UAAir / (masFloAir * cpAir);
    hSurEff = hAirIn + (hAirOut - hAirIn) / (1 - exp(-NtuAirSta));
    // The effective surface temperature Ts,eff or TSurEff is the saturation
    // temperature at the value of an effective surface enthalpy, hs,eff or
    // hSurEff, which is given by the following relation:
    pSatEff = Buildings.Media.Air.saturationPressure(TSurEff);
    XSurEff[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatEff, p=pAir, phi=phiSat);
    XSurEff[othIdx] = 1 - XSurEff[watIdx];
    hSurEff = Buildings.Media.Air.specificEnthalpy_pTX(
      p=pAir, T=TSurEff, X=XSurEff);
    TAirOut = TSurEff + (TAirIn - TSurEff) * exp(-NtuAirSta);
    pSatOut = Buildings.Media.Air.saturationPressure(TAirOut);
    XOut[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=pSatOut, p=pAir, phi=phiSat);
    XOut[othIdx] = 1 - XOut[watIdx];
    wAirOut = XOut[watIdx];
    masFloCon = masFloAir * (wAirIn - wAirOut);
    QSen = -(QTot - (masFloCon * Buildings.Media.Air.enthalpyOfLiquid(TSurEff)));
    TCon = TSurEff;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WetCalcs;
