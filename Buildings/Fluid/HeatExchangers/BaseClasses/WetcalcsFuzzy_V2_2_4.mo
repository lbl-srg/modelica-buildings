within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetcalcsFuzzy_V2_2_4 "Wet coil model using esilon_C.mo function"
  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Real dryfra(min=0, max=1)
    "Fraction of heat exchanger to which UA is to be applied";

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
   Modelica.SIunits.SpecificEnthalpy hAirOut
    "Specific enthalpy of air at outlet conditions";
  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatWatOutM(p=pAir,TSat=TWatOut)
    "model to calculate saturated specific enthalpy of air at water outlet tempreature";
  Modelica.SIunits.SpecificEnthalpy hSatWatOut
    "saturated specific enthalpy of air at water outlet tempreature";

  Modelica.SIunits.Temperature TSurEff
    "Effective surface temperature of the coil";
  Modelica.SIunits.SpecificEnthalpy hSatSurEff;
  Modelica.SIunits.MassFlowRate mAir_flow_NonZero(min=0);

  Buildings.Utilities.Psychrometrics.hSat_pTSat hSatSurEffM(p=pAir,TSat=TSurEff);

  Modelica.SIunits.SpecificHeatCapacity cpEff
    "Effective specific heat: change in enthalpy with respect to
     temperature along the saturation line at the local water
     temperature";

  Real wetfraNonZero;
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
  " to eliminate the warning message of the unit mismatch when using the eps-NTU model for the wet coil";

  Modelica.SIunits.MassFlowRate mStaMin
      "min of product of mass flow rates and specific
    heats; analogous to Cmin";

  Modelica.SIunits.MassFlowRate mStaMin_flow_nominal= min(mAir_flow_nominal,mWat_flow_nominal*2050/4200)
  "analogus to CMin_flow_nominal";
  Modelica.SIunits.MassFlowRate mStaMax_flow_nominal= max(mAir_flow_nominal,mWat_flow_nominal*2050/4200)
  "analogus to CMax_flow_nominal";
  Modelica.SIunits.MassFlowRate deltamStaMin=delta*min(mAir_flow_nominal,mWat_flow_nominal*2050/4200)
      "min of product of mass flow rates and specific heats, analogous to Cmin";


equation
  if (dryfra<=-1) then

    hAirIn=-1;
    hSatWatIn=-1;
    hSatWatOut=-1;
    cpEff=2050;
    wetfraNonZero=-1;
    
    UASta=-1;
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
    mAir_flow_NonZero=-1;
    mStaMin=-1;

  else

    hAirIn=Buildings.Media.Air.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn,1-wAirIn});
    hSatWatIn=hSatWatInM.hSat;

    hSatWatOut= hSatWatOutM.hSat;

    //cpEff = (hSatWatOut - hSatWatIn)/(TWatOut - TWatIn);
    cpEff = Buildings.Utilities.Math.Functions.spliceFunction(
            pos = abs(hSatWatOut - hSatWatIn)/(max(0.1, abs(TWatOut - TWatIn))),
            neg = 2050,
            x =   TWatOut - TWatIn - 0.2,
            deltax = 0.1); // It needs to be fixed. Q. Why it is so sensitive??
    //cpEff = 2050;
    

    wetfraNonZero = 1-Buildings.Utilities.Math.Functions.spliceFunction(
        pos = 1-delta,
        neg = dryfra,
        x =   dryfra-(1-delta),
        deltax = delta/2);

    mStaMin=Buildings.Utilities.Math.Functions.smoothMin(
    mAir_flow,
    mWat_flow*cpWat/cpEff,
    deltamStaMin/4);

    UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat))*wetfraNonZero;

    epsSta=epsilon_C(
    UA=UASta*CpDum,
    C1_flow=mWat_flow*cpWat/cpEff*CpDum,
    C2_flow=mAir_flow*CpDum,
    flowRegime=Integer(cfg),
    CMin_flow_nominal=mStaMin_flow_nominal*CpDum,
    CMax_flow_nominal=mStaMax_flow_nominal*CpDum,
    delta=delta);

    QTot_flow = epsSta*mStaMin*(hAirIn  - hSatWatIn);

    //hAirOut=hAirIn-QTot_flow/mAirNonZer_flow;
    //TWatOut=TWatIn+QTot_flow/(mWatNonZer_flow*cpWat);

    QTot_flow = mAir_flow*(hAirIn- hAirOut); // Q: Is this valid for any flow regimes and heating/cooling mode switch?
    QTot_flow = mWat_flow*cpWat*(TWatOut-TWatIn); // Q: Is this valid for any flow regimes and heating/cooling mode switch?

    mAir_flow_NonZero=Buildings.Utilities.Math.Functions.smoothMax(x1=mAir_flow,x2=mAir_flow_nominal*delta,deltaX=mAir_flow_nominal*delta/2);
    NTUAirSta = UAAir*wetfraNonZero/(mAir_flow_NonZero*cpAir);
    

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
end WetcalcsFuzzy_V2_2_4;
