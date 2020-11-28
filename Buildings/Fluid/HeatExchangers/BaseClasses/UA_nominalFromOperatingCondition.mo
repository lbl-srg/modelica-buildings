within Buildings.Fluid.HeatExchangers.BaseClasses;
model UA_nominalFromOperatingCondition
  "This block is to calculate UA_nominal using operating conditions"
  replaceable package MediumW=Buildings.Media.Water;
  replaceable package MediumA=Buildings.Media.Air;
  Real TAirIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC");
  Real TAirOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC");
  Real wAirIn(min=0,
    max=1,
    unit="1")
    "Humidity ratio of water at inlet (kg water/kg moist air)";
  Real wAirOut(min=0,
    max=1,
    unit="1")
    "Humidity ratio of water at outlet (kg water/kg moist air)";

  Real TWatIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC");
  Real TWatOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC");

   Real mAirFlo(
    quantity="MassFlowRate",
    final unit="kg/s");

   Real mWatFlo(
    quantity="MassFlowRate",
    final unit="kg/s");

  //-- define indpendent, thermodynamic intensive property object
  MediumA.ThermodynamicState staAir=MediumA.setState_phX(p=MediumA.p_default,h=MediumA.h_default,X=MediumA.X_default[1:MediumA.nXi]);
  MediumW.ThermodynamicState staWat=MediumW.setState_phX(p=MediumW.p_default,h=MediumW.h_default,X=MediumW.X_default[1:MediumW.nXi]);

  Modelica.SIunits.SpecificHeatCapacity Cpa=MediumA.specificHeatCapacityCp(staAir);
  Modelica.SIunits.SpecificHeatCapacity Cpw=MediumW.specificHeatCapacityCp(staWat);
  Modelica.SIunits.SpecificHeatCapacity Cs;

  Modelica.SIunits.SpecificEnthalpy hAirIn=MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirIn,X={wAirIn,1-wAirIn});
  Modelica.SIunits.SpecificEnthalpy hAirOut=MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirOut,X={wAirOut,1-wAirOut});


  Modelica.SIunits.SpecificEnthalpy hfg=Buildings.Utilities.Psychrometrics.Constants.h_fg;


  Buildings.Utilities.Psychrometrics.hSat_pTSat hsatdeleq(p=MediumA.p_default, TSat=Tdeleq);
  Modelica.SIunits.Temperature Tdeleq(start=273.15+5);

  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewAirIn(p_w= pWAirIn.p_w);
  Buildings.Utilities.Psychrometrics.pW_X pWAirIn(X_w=wAirIn,p_in=MediumA.p_default);

  Buildings.Utilities.Psychrometrics.hSat_pTSat hsatTWatIn(p=MediumA.p_default,TSat=TWatIn);
  Buildings.Utilities.Psychrometrics.hSat_pTSat hsatTWatOut(p=MediumA.p_default,TSat=TWatOut);


  output Modelica.SIunits.ThermalConductance UA_Air_nominal;
  output Modelica.SIunits.ThermalConductance UA_Wat_nominal;
  output Modelica.SIunits.MassFlowRate UA_Sta_nominal;
  output Modelica.SIunits.ThermalConductance UA_nominal;

  Modelica.SIunits.SpecificEnthalpy LMED;
  Modelica.SIunits.SpecificEnthalpy hunit=1;
  Modelica.SIunits.Temperature Tunit=1;

  Real SHR;
  Real LHR;
  Modelica.SIunits.HeatFlowRate Qtot;
  output Modelica.SIunits.HeatFlowRate Qsen;

equation
  //- inputs
  TAirIn = 273.15+25;
  TAirOut= 273.15+15;
  wAirIn=0.010;
  wAirOut=0.008;

  TWatIn = 273.15+5;
  TWatOut = 273.15+10;
  //- calculation
  assert(TAirIn>TAirOut and wAirIn>wAirOut and TWatIn<TWatOut and TAirOut>TWatIn,"check data");

  // -- caluclation of UA_air_nominal by bypass approximation

  mAirFlo=0.1;
  Qtot=mAirFlo*(hAirIn-hAirOut);
  Qsen=mAirFlo*Cpa*(TAirIn-TAirOut);

  mWatFlo*Cpw*(TWatOut-TWatIn)=Qtot; // energy balance to calculate mWatFlo

  SHR=Cpa*(TAirIn-TAirOut)/(hAirIn-hAirOut);
  LHR=hfg*(wAirIn-wAirOut)/(hAirIn-hAirOut);

  //if TWatOut<TDewAirIn.T //fully wet, then use the following approximation which defines Tdeltaeq
  SHR=Cpa*(TAirIn-Tdeleq)/(hAirIn-hsatdeleq.hSat);
  //else TWatIn> TDewAirIn.T //fully dry, then what we  can say about Tdeltaeq?

  Qsen=(1-exp(-UA_Air_nominal/(mAirFlo*Cpa)))*mAirFlo*Cpa*(TAirIn-Tdeleq); // This defines UA_air_norminal

  //-- calucation of UA_wat_nominal by the def of overall UA star
    //-- cacluation of UA star from LMED
  Cs=(hsatTWatOut.hSat-hsatTWatIn.hSat)/(TWatOut-TWatIn);
  LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(hAirIn/hunit*Tunit,
                    hAirOut/hunit*Tunit,
                    hsatTWatIn.hSat/hunit*Tunit,
                    hsatTWatOut.hSat/hunit*Tunit)/Tunit*hunit; //Q: HX configuration?
  UA_Sta_nominal*LMED=Qtot;
    //-- calculation of UA water nomianl by the def of overall UA star
  UA_Sta_nominal=1/(1/(UA_Air_nominal/Cpa)+1/(UA_Wat_nominal/Cs));

  //-= calculation of UA_nominal
  UA_nominal=1/(1/(UA_Air_nominal)+1/(UA_Wat_nominal));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UA_nominalFromOperatingCondition;
