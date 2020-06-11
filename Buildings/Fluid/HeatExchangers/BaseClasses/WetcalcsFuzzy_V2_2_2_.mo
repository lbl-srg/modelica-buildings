within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetcalcsFuzzy_V2_2_2_ "Description"
  //WetcalcsFuzzy_V2_2 wet(pAir=pAir, TAirIn=TAirIn, wAirIn=wAirIn,
  // mAir_flow=mAir_flow, TWatIn=TWatIn, mWat_flow=mWat_flow,UAAir=UAAir,UAWat=UAWat,cpAir=cpAir,cpWat=cpWat,dryfra=dryfra)

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Real dryfra(min=0, max=1)
    "Fraction of heat exchanger to which UA is to be applied";

  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)
   "Mass flow rate for water, bounded away from zero";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";

  // -- air
  input Modelica.SIunits.Pressure pAir
    "Pressure on air-side of coil";
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
  input Modelica.SIunits.MassFraction wAirIn
    "Mass fraction of water in moist air at inlet";

  Modelica.SIunits.SpecificEnthalpy hAirIn
    "Specific enthalpy of air at inlet conditions";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatInM(p=pAir,TSat=TWatIn)
    "model to calculate saturated specific enthalpy of air at water inlet tempreature";
  Modelica.SIunits.SpecificEnthalpy hSatWatIn
    "saturated specific enthalpy of air at water inlet tempreature";

  // -- misc.
  //input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
  //  "The configuration of the heat exchanger";
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The configuration of the heat exchanger";

  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Total heat flow from water to air stream";
   output Modelica.SIunits.HeatFlowRate QSen_flow
    "Sensible heat flow from water to air stream";
  input Modelica.SIunits.Temperature TWatOut0;
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  //output Modelica.SIunits.MassFlowRate mCon_flow
  //  "The amount of condensate removed from air stream";
  //output Modelica.SIunits.MassFraction wAirOut
  //  "Mass fraction of water in air at outlet";// DK added to calculate dew point temp at air outlet

  Modelica.SIunits.SpecificEnthalpy hAirOut
    "Specific enthalpy of air at outlet conditions";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatOutM(p=pAir,TSat=TWatOut0)
    "model to calculate saturated specific enthalpy of air at water outlet tempreature";
  Modelica.SIunits.SpecificEnthalpy hSatWatOut
    "saturated specific enthalpy of air at water outlet tempreature";

  Modelica.SIunits.Temperature TSurEff
    "Effective surface temperature of the coil";
  Modelica.SIunits.SpecificEnthalpy hSatSurEff;

  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffM(p=pAir,TSat=TSurEff);

  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";

  Real mStaRat(min=Modelica.Constants.eps)
    "Ratio of product of mass flow rates and specific
    heats; analogous to capacitance rate ratio Cmin/Cmax
    (Braun 2013 Ch02 eq 2.20)";
  Real mStaMax
      "max of product of mass flow rates and specific
    heats; analogous to Cmax";
  Real mStaMin
      "min of product of mass flow rates and specific
    heats; analogous to Cmin";
  Real mStaMinNonZero;
  Real mStaMaxNonZero;
  Real wetfraNonZero;
  Modelica.SIunits.MassFlowRate UASta
    "Overall mass transfer coefficient for dry coil";
  Real NTUSta
    "Number of transfer units (NTU*)";
  Real NTUAirSta
    "Number of transfer units for air-side only (NTU_a*)";
//  Real mStaNonZerMin_flow "Utilized to prevent zero-division for NTU calculation";

  Real epsSta(start=0.66, unit="1")
    "Effectiveness for heat exchanger (e*)";
  input Real delta = 1E-3 "Small value used for smoothing";
  input Modelica.SIunits.MassFlowRate mAir_flow_nominal;
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal;
  Modelica.SIunits.ThermalConductance deltamStaMin
    "Small number for capacity flow rate";
  Modelica.SIunits.ThermalConductance deltamStaMax
    "Small number for capacity flow rate";
  Real gai(min=0, max=1)
    "Gain used to force UA to zero for very small flow rates";

  output Modelica.SIunits.Temperature TSurAirIn
    "Surface Temperature at air outlet";

equation
  if (dryfra<=-1) then
    deltamStaMin=-1;
    deltamStaMax=-1;
    hAirIn=-1;
    hSatWatIn=-1;
    hSatWatOut=-1;
    cpEff=-1;
    wetfraNonZero=-1;
    mStaMin=-1;
    mStaMax=-1;
    mStaMinNonZero=-1;
    mStaMaxNonZero=-1;
    mStaRat = -1;
    UASta=-1;
    gai=-1;
    NTUSta=-1;
    epsSta=-1;
    QTot_flow=-1;
    hAirOut=-1;
    TWatOut=30+273.15;
    NTUAirSta = -1;
    hSatSurEff = -1;
    TSurEff = 30+273.15; //    hSatSurEffM.hSat=hSatSurEff;
    TAirOut = -1;
    QSen_flow= -1;
    TSurAirIn=-1;

  else
  deltamStaMin= delta*min(mAir_flow_nominal,mWat_flow_nominal*2050/4200);
  deltamStaMax= delta*max(mAir_flow_nominal,mWat_flow_nominal*2050/4200);

  hAirIn=Buildings.Media.Air.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn,1-wAirIn});
  hSatWatIn=hSatWatInM.hSat;

  hSatWatOut= hSatWatOutM.hSat;

  //cpEff = (hSatWatOut - hSatWatIn)/(TWatOut - TWatIn);
  cpEff = Buildings.Utilities.Math.Functions.spliceFunction(
    pos = abs(hSatWatOut - hSatWatIn)/(max(0.1, abs(TWatOut0 - TWatIn))),
    neg = 2050,
    x =   TWatOut0 - TWatIn - 0.2,
    deltax = 0.1);
  wetfraNonZero = 1-Buildings.Utilities.Math.Functions.spliceFunction(
    pos = 1-delta,
    neg = dryfra,
    x =   dryfra-(1-delta),
    deltax = delta/2);
  //mStaMin=min(mAir_flow,mWat_flow*cpWat/cpEff);
  mStaMin=Buildings.Utilities.Math.Functions.smoothMin(
    mAir_flow,
    mWat_flow*cpWat/cpEff,
    deltamStaMin/4);

  //mStaMax=max(mAir_flow,mWat_flow*cpWat/cpEff);
  mStaMax=Buildings.Utilities.Math.Functions.smoothMax(
    mAir_flow,
    mWat_flow*cpWat/cpEff,
    deltamStaMax/4);

  //mStaMinNonZero=min(mAirNonZer_flow,mWatNonZer_flow*cpWat/cpEff);//min(mAir_flow,mWat_flow*cpWat/cpEff);
  mStaMinNonZero=Buildings.Utilities.Math.Functions.smoothMax(
    mStaMin,
    deltamStaMin,
    deltamStaMin/4);

  //mStaMaxNonZero=max(mAirNonZer_flow,mWatNonZer_flow*cpWat/cpEff);//max(mAir_flow,mWat_flow*cpWat/cpEff);

  mStaMaxNonZero= Buildings.Utilities.Math.Functions.smoothMax(
    mStaMax,
    deltamStaMax,
    deltamStaMax/4);

  mStaRat = mStaMin/mStaMaxNonZero;
  UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));

  gai= Buildings.Utilities.Math.Functions.spliceFunction(
           pos=1,
           neg=0,
           x=mStaMin-deltamStaMin,
           deltax=deltamStaMin/2);
  if (gai<=0) and (gai>=0) then
    NTUSta = 0;
    epsSta = 1; // around zero flow, eps=Q/(CMin*dT) should be one
  else
    NTUSta = gai*UASta/mStaMinNonZero*wetfraNonZero;
    epsSta = gai*epsilon_ntuZ(
        Z = mStaRat,
        NTU = NTUSta,
        flowRegime = Integer(cfg));
  end if;

  // epsSta = (1 - exp(-NTUSta*(1 - mStaRat)))/(1 - mStaRat*exp(-NTUSta*(1-mStaRat)));
  QTot_flow = epsSta*mStaMin*(hAirIn  - hSatWatIn);

  hAirOut=hAirIn-QTot_flow/mAirNonZer_flow;
  TWatOut=TWatIn+QTot_flow/(mWatNonZer_flow*cpWat);

  //QTot_flow = mAir_flow*(hAirIn- hAirOut);
  //QTot_flow = mWat_flow*cpWat*(TWatOut-TWatIn);

  NTUAirSta = UAAir/(mAirNonZer_flow*cpAir)*wetfraNonZero;
  hSatSurEff = hAirIn  +(hAirOut - hAirIn) /(1 - exp(-NTUAirSta));

  hSatSurEffM.hSat=hSatSurEff;
  TAirOut = TSurEff +(TAirIn  - TSurEff)*exp(-NTUAirSta);
  QSen_flow= min(mAir_flow*cpAir*(TAirIn-TAirOut),QTot_flow);

  (TAirIn-TSurAirIn)*UAAir=(TSurAirIn-TWatOut)*UAWat;

   end if;
  annotation (Icon(graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}));
end WetcalcsFuzzy_V2_2_2_;
