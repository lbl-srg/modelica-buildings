within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCalcs "Wet effectiveness-NTU calculations"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component: the 'water'"
    annotation (choicesAllMatching = true);

  //replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium;
  // INPUTS
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
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The configuration of the heat exchanger";

  // OUTPUTS
  output Modelica.SIunits.HeatFlowRate QTot
    "Total heat flow from 'air' into 'water' stream";
  output Modelica.SIunits.HeatFlowRate QSen
     "Sensible heat flow from 'water' into 'air' stream";
  output Medium1.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Modelica.SIunits.Temperature TSurAirIn
    "Surface temperature of the coil at inlet, Braun 1988, eq 4.1.22";
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
  Modelica.SIunits.SpecificEnthalpy hAirSatSurIn
    "Specific enthalpy of saturated air at inlet at coil surface";
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
  Modelica.SIunits.HeatFlowRate Q
    "Total heat flow rate from air to water for dry coil";
  Real NtuSta
    "Number of transfer units (NTU*)";
  Real NtuAirSta
    "Number of transfer units (NTU_a*)";
  Real NtuAirHat
    "Number of transfer units (NTU_a_hat)";
  Real NtuWat
    "Ntu for water side, referred to as Ntu_i in Braun 1988 eq 4.1.6";
  Real NtuAir
    "Ntu for air side, referred to as Ntu_o in Braun 1988 eq 4.1.5";
  Real NtuWet
    "Overall Ntu for a wet coil, defined in eq 4.1.13 of Braun 1988";
  Modelica.SIunits.MassFraction XOut[2]
    "Mass fraction of air at outlet";
  Modelica.SIunits.MassFraction XAirSatIn[2]
    "Mass fractions of components at inlet";
  Modelica.SIunits.MassFraction XAirSatOut[2]
    "Mass fractions of components at outlet";
  Modelica.SIunits.AbsolutePressure pSatWatIn
    "Saturation pressure of water vapor at inlet";
  Modelica.SIunits.AbsolutePressure pSatWatOut
    "Saturation pressure of water vapor at outlet";
  Modelica.SIunits.MassFraction wAirOut
    "Mass fraction of water in air at outlet";

equation
  if noEvent(
      masFloWat < 1e-4 or masFloAir < 1e-4 or UAAir < 1e-4
      or UAWat < 1e-4 or (abs(TAirIn - TWatIn) < 1e-4)) then
    QTot = 0;
    QSen = 0;
    TWatOut = TWatIn;
    TAirOut = TAirIn;
    TSurAirIn = (TWatIn + TAirIn) / 2;
    masFloCon = 0;
    TCon = TSurAirIn;
    // Other Equations
    cpEff = 0;
    hAirOut = hAirIn;
    hAirSatSurIn = hAirIn;
    hAirSatSurOut = hAirIn;
    hSurEff = hAirIn;
    effSta = 0;
    TSurEff = TAirIn;
    pSatOut = 0;
    mSta = 0;
    UAsta = 0;
    Q = 0;
    NtuSta = 0;
    NtuAirSta = 0;
    NtuAirHat = 0;
    NtuWat = 0;
    NtuAir = 0;
    NtuWet = 0;
    XOut[watIdx] = wAirIn;
    XOut[othIdx] = 1 - wAirIn;
    XAirSatIn[watIdx] = wAirIn;
    XAirSatIn[othIdx] = 1 - wAirIn;
    XAirSatOut[watIdx] = wAirIn;
    XAirSatOut[othIdx] = 1 - wAirIn;
    pSatWatIn = 0;
    pSatWatOut = 0;
    wAirOut = wAirIn;
  else
    pSatWatIn =
      Buildings.Utilities.Psychrometrics.Functions.saturationPressure(
        TWatIn);
    XAirSatIn[watIdx] =  Buildings.Utilities.Psychrometrics.Functions.X_pW(
      p_w=pSatWatIn, p=pAir);
    XAirSatIn[othIdx] =  1 - XAirSatIn[watIdx];
    hAirSatSurIn =  Buildings.Media.Air.specificEnthalpy_pTX(
      p=pAir, T=TWatIn, X=XAirSatIn);
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
    effSta =  effCalc(CSta=mSta, Ntu=NtuSta, cfg=cfg);
    Q =  effSta * masFloAir * (hAirIn - hAirSatSurIn);
    hAirOut =  hAirIn - (Q / masFloAir);
    NtuAirSta =  UAAir / (masFloAir * cpAir);
    hSurEff =  hAirIn + (hAirOut - hAirIn) / (1 - exp(-NtuAirSta));
    NtuAirHat =  UAAir / (masFloAir * cpAir);
    // The effective surface temperature Ts,eff or TSurEff is the saturation
    // temperature at the value of an effective surface enthalpy, hs,eff or
    // hSurEff, which is given by the relation similar to that for temperature.
    TSurEff =  Buildings.Utilities.Psychrometrics.Functions.TSat_ph(
      p=pAir, h=hSurEff);
    TAirOut =  TSurEff + (TAirIn - TSurEff) * exp(-NtuAirHat);
    pSatOut =  Buildings.Media.Air.saturationPressure(TAirOut);
    XOut[watIdx] =  Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=pSatOut, p=pAir, phi=phiSat);
    XOut[othIdx] =  1 - XOut[watIdx];
    wAirOut =  XOut[watIdx];
    NtuWat =  UAWat / (masFloWat * cpWat);
    NtuAir =  UAAir / (masFloAir * cpAir);
    NtuWet =  NtuAir / (1 + mSta * (NtuAir / NtuWat))
      "Braun 1988 eq 4.1.13";
    TSurAirIn =  TWatOutGuess +
      (masFloAir * NtuWet * (hAirIn - hAirSatSurOut))
      / (masFloWat * cpWat * NtuWat)
      "Braun 1988, eq 4.1.22";
    masFloCon =  masFloAir * (wAirIn - wAirOut);
    QSen =  -(Q - (masFloCon * Buildings.Media.Air.enthalpyOfLiquid(TSurEff)));
    QTot =  Q;
    TCon =  TSurEff;
    TWatOut = (QTot / (masFloWat * cpWat)) + TWatIn;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WetCalcs;
