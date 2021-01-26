within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetcalcsFuzzy_V3 "Wet coil model using esilon_C.mo function"
  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";

  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow
    "None-zero Mass flow rate for water";
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
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow
    "None-zero Mass flow rate for water";
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

  // - regularization
  /* When water flow goes to inf or air flow goes to 0, water temperature diff between inlet and outlet goes to 0. 
  This leads to a singlular point of Csta_water. 
  This problem could be avoided by considering the fact that 
  C*_water at the condition is the deriviate at TWatIn and is the minimal"*/
  parameter Modelica.SIunits.TemperatureDifference dTWat=0.1;
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatIn_dT_M(p=pAir,TSat=TWatIn+dTWat)
    "model to calculate derivative of saturated specific enthalpy of air at water inlet tempreature";
  Modelica.SIunits.SpecificHeatCapacity dhSatdTWatIn
   "deriviative of saturated water enthalpy at water inlet temp";
  Real NonZerDelWatTem
  " regularization water temperature difference betwee inlet and outlet";


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
   Modelica.SIunits.SpecificEnthalpy hAirOut
    "Specific enthalpy of air at outlet conditions";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatOutM(p=pAir,TSat=TWatOutHat)
    "model to calculate saturated specific enthalpy of air at water outlet tempreature";
  Modelica.SIunits.SpecificEnthalpy hSatWatOut
    "saturated specific enthalpy of air at water outlet tempreature";

  Modelica.SIunits.Temperature TSurEff
   "Effective surface temperature of the coil";

  Modelica.SIunits.SpecificEnthalpy hSatSurEff;
  //Modelica.SIunits.MassFlowRate mAir_flow_NonZero(min=0);

  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffM(p=pAir,TSat=TSurEff);
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffMinM(p=pAir,TSat=273.15+1);

  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";
  constant Real cpEff0=2050;
  constant Real cpWat0=4200;

  Modelica.SIunits.MassFlowRate UASta
    "Overall mass transfer coefficient for dry coil";

  Real NTUAirSta
    "Number of transfer units for air-side only (NTU_a*)";

  Real epsSta(start=0.66, unit="1")
    "Effectiveness for heat exchanger (e*)";
  input Real delta = 1E-3 "Small value used for smoothing";
  input Modelica.SIunits.MassFlowRate mAir_flow_nominal;
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal;
  output Modelica.SIunits.Temperature TSurAirIn
    "Surface Temperature at air outlet";

  parameter Modelica.SIunits.SpecificHeatCapacity CpDum=1
  " dummy cp to eliminate the warning message of the unit mismatch when using the eps-NTU model for the wet coil";
  Modelica.SIunits.MassFlowRate CStaMin
      "min of product of mass flow rates and specific
    heats; analogous to Cmin";

  Modelica.SIunits.MassFlowRate CStaMin_flow_nominal= min(mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
  "analogus to CMin_flow_nominal, only for a regularization";
  Modelica.SIunits.MassFlowRate CStaMax_flow_nominal= max(mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
  "analogus to CMax_flow_nominal, only for a regularization";
  Modelica.SIunits.MassFlowRate deltaCStaMin=delta*min(mAir_flow_nominal,mWat_flow_nominal*cpEff0/cpWat0)
      "min of product of mass flow rates and specific heats, analogous to Cmin";
  Modelica.SIunits.Temperature TWatOutHat(start=273.15+10)
    "state_estimation of Temperature of water at outlet";
  parameter Real tau=60
    "time constant of the state estimation";

equation

    hAirIn=Buildings.Media.Air.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn,1-wAirIn});
    hSatWatIn=hSatWatInM.hSat;
    dhSatdTWatIn=(hSatWatIn_dT_M.hSat-hSatWatInM.hSat)/dTWat; // dTWat is a parameter
    hSatWatOut= hSatWatOutM.hSat;
    NonZerDelWatTem=Buildings.Utilities.Math.Functions.regNonZeroPower(x=TWatOutHat-TWatIn,n=1,delta=0.1);
    cpEff = Buildings.Utilities.Math.Functions.smoothMax(
    (hSatWatOut - hSatWatIn)/NonZerDelWatTem,
    dhSatdTWatIn,
    cpEff0*delta);
    //cpEff = 2050;

    CStaMin=Buildings.Utilities.Math.Functions.smoothMin(
    mAir_flow,
    mWat_flow*cpWat/cpEff,
    deltaCStaMin/4);

    UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));

    epsSta=epsilon_C(
    UA=UASta*CpDum,
    C1_flow=mWat_flow*cpWat/cpEff*CpDum,
    C2_flow=mAir_flow*CpDum,
    flowRegime=Integer(cfg),
    CMin_flow_nominal=CStaMin_flow_nominal*CpDum,
    CMax_flow_nominal=CStaMax_flow_nominal*CpDum,
    delta=delta);

    QTot_flow = epsSta*CStaMin*(hAirIn  - hSatWatIn);

    QTot_flow = mAir_flow*(hAirIn- hAirOut);     //hAirOut=hAirIn-QTot_flow/mAirNonZer_flow;
    QTot_flow = mWat_flow*cpWat*(TWatOut-TWatIn);     //TWatOut=TWatIn+QTot_flow/(mWatNonZer_flow*cpWat);

    //mAir_flow_NonZero=Buildings.Utilities.Math.Functions.smoothMax(x1=mAir_flow,x2=mAir_flow_nominal*delta,deltaX=mAir_flow_nominal*delta/2);
    //mAir_flow_NonZero=Buildings.Utilities.Math.Functions.regNonZeroPower(x=mAir_flow,n=1,delta=mAir_flow_nominal*delta);
    //NTUAirSta = UAAir/(mAir_flow_NonZero*cpAir);
    NTUAirSta = UAAir/(mAir_flow*cpAir);


    //hSatSurEff = hAirIn  +(hAirOut - hAirIn) /(1 - exp(-NTUAirSta)); // NTUAirSta is bounded as long as UAAir>0 due to the regularization of mAir_flow
    hSatSurEff = Buildings.Utilities.Math.Functions.smoothMax(hSatSurEffMinM.hSat, hAirIn  +(hAirOut - hAirIn) /(1 - exp(-NTUAirSta)),delta*1E4); // NTUAirSta is bounded as long as UAAir>0 due to the regularization of mAir_flow


    hSatSurEffM.hSat=hSatSurEff;
    TAirOut = TSurEff +(TAirIn  - TSurEff)*exp(-NTUAirSta);
    QSen_flow= Buildings.Utilities.Math.Functions.smoothMin(mAir_flow*cpAir*(TAirIn-TAirOut),QTot_flow,delta*mWatNonZer_flow*cpWat0*5); // the last term is only for regularization with DTWater=5oC

    (TAirIn-TSurAirIn)*UAAir=(TSurAirIn-TWatOut)*UAWat;
    der(TWatOutHat)=-1/tau*TWatOutHat+1/tau*TWatOut;

  annotation (Icon(graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}));
end WetcalcsFuzzy_V3;
