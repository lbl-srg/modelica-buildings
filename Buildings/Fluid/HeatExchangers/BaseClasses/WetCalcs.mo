within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCalcs "Wet effectiveness-NTU calculations"

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Real fraHex(min=0, max=1)
    "Fraction of heat exchanger to which UA is to be applied";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for water, bounded away from zero";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  input Modelica.SIunits.Temperature TWatOutGuess(min=273.15)
    "A guess variable for the outlet water temperature";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate mAir_flow
    "Mass flow rate of air";
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for air, bounded away from zero";
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

  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Total heat flow from water to air stream";
  output Modelica.SIunits.HeatFlowRate QSen_flow
     "Sensible heat flow from water to air stream";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Modelica.SIunits.MassFlowRate mCon_flow
    "The amount of condensate removed from air stream";

protected
  constant Real phiSat(min=0, max=1) = 1
    "Relative humidity at saturation conditions";
    // fixme: add a function call
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
  Real epsSta(start=0.66, unit="1")
    "Effectiveness for heat exchanger (e*)";
  Modelica.SIunits.Temperature TSurEff
    "Effective surface temperature of the coil";
  Modelica.SIunits.AbsolutePressure pSatOut
    "Saturation pressure at air outlet conditions";
  Real mSta(min=Modelica.Constants.eps)
    "Ratio of product of mass flow rates and specific
    heats; analogous to capacitance rate ratio Cmin/Cmax
    (Braun 2013 Ch02 eq 2.20)";
  Modelica.SIunits.MassFlowRate UASta
    "Overall mass transfer coefficient for dry coil";
  Real NTUSta
    "Number of transfer units (NTU*)";
  Real NTUAirSta
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
  Modelica.SIunits.HeatFlowRate QLat_flow
    "Latent heat flow from water to air stream";

equation
    // fixme: check condition

  if noEvent(fraHex < 1e-10
      or (abs(TAirIn - TWatIn) < 1e-10)) then
    QTot_flow = 0;
    QSen_flow = 0;
    TWatOut = TWatIn;
    TAirOut = TAirIn;
    mCon_flow = 0;
    // Other Equations
    cpEff = 0;
    hAirOut = hAirIn;
    hAirSatSurOut = hAirIn;
    hSurEff = hAirIn;
    epsSta = 0;
    TSurEff = TAirIn;
    pSatEff = 0;
    XSurEff[1] = 0;
    XSurEff[2] = 0;
    pSatOut = 0;
    mSta = 0;
    UASta = 0;
    NTUSta = 0;
    NTUAirSta = 0;
    XOut[watIdx] = wAirIn;
    XOut[othIdx] = 1 - wAirIn;
    XAirSatOut[watIdx] = wAirIn;
    XAirSatOut[othIdx] = 1 - wAirIn;
    pSatWatOut = 0;
    wAirOut = wAirIn;
    QLat_flow = 0;
  else
  pSatWatOut =
    Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(
      TWatOutGuess);
  XAirSatOut[watIdx] =
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatWatOut,
      p=pAir,
      phi=phiSat);
  XAirSatOut[othIdx] =  1 - XAirSatOut[watIdx];
  hAirSatSurOut = Buildings.Media.Air.specificEnthalpy_pTX(
    p=pAir,
    T=TWatOutGuess,
    X=XAirSatOut);
  // If the difference in temperatures is near zero, use a constant cpEff
  cpEff = Buildings.Utilities.Math.Functions.spliceFunction(
    pos = abs(hAirSatSurOut - hAirSatSurIn)/(max(0.1, abs(TWatOutGuess - TWatIn))),
    neg = 2050,
    x =   TWatOutGuess - TWatIn - 0.2,
    deltax = 0.1);
  // fixme: why is there a max()? With the new model, mWat_flow > 0 always, hence
  // no division by zero is needed. Also, mAir_flow > 0
  mSta =  mAirNonZer_flow * cpEff / (mWatNonZer_flow * cpWat)
    "Braun et al 2013 eq 2.20";
  UASta = (UAAir / cpAir) / (1 + (cpEff*UAAir) / (cpAir*UAWat))
    "Mitchell 2012 eq 13.19";
  NTUSta =  fraHex * UASta/mAirNonZer_flow
    "Mitchell 2012 eq 13.20";
  epsSta = epsilon_ntuZ(
    Z = mSta,
    NTU = NTUSta,
    flowRegime = Integer(cfg));
  QTot_flow = epsSta * mAir_flow * (hAirSatSurIn - hAirIn);
  TWatOut = TWatIn - QTot_flow / (mWatNonZer_flow * cpWat);
  hAirOut = hAirIn + QTot_flow / mAirNonZer_flow;
  // The number of transfer units are usually of order 1. Hence, we can add a small
  // number to avoid division by zero in hSurEff
  NTUAirSta = fraHex * UAAir / (mAirNonZer_flow * cpAir)+1E-10;
  hSurEff = hAirIn + (hAirOut - hAirIn) / (1 - exp(-NTUAirSta));
  // The effective surface temperature Ts,eff or TSurEff is the saturation
  // temperature at the value of an effective surface enthalpy, hs,eff or
  // hSurEff, which is given by the following relation.
  // For the saturation pressure, we assume the surface is never below 2 degC.
  // This avoids problems in computing the saturationPressure
  pSatEff = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TSurEff);
  XSurEff[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
    pSat=pSatEff,
    p=pAir,
    phi=phiSat);
  XSurEff[othIdx] = 1 - XSurEff[watIdx];
  hSurEff = Buildings.Media.Air.specificEnthalpy_pTX(
    p=pAir,
    T=TSurEff,
    X=XSurEff);
  TAirOut = TSurEff + (TAirIn - TSurEff) * exp(-NTUAirSta);
  pSatOut = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TAirOut);
  XOut[watIdx] = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatOut,
      p=pAir,
      phi=phiSat);
  XOut[othIdx] = 1 - XOut[watIdx];
  wAirOut = XOut[watIdx];
  mCon_flow = mAir_flow * (wAirIn - wAirOut);
  QLat_flow = -Buildings.Utilities.Psychrometrics.Constants.h_fg * mCon_flow;
  QSen_flow = QTot_flow - QLat_flow;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
April 19, 2017, by Michael Wetter:<br/>
Renamed variables for consistency.
</li>
<li>
April 17, 2017, by Michael O'Keefe:<br/>
Merged changes from Michael Wetter into existing model. Fixed
calculation of sensible heat (QSen) to be correct.
</li>
<li>
April 14, 2017, by Michael Wetter:<br/>
Removed condensate temperature which is no longer needed.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This model implements the calculation for a 100% wet coil.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> for documentation.
</p>
</html>"));
end WetCalcs;
