within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model UA_nominalFromOperatingCondition
  "This block is to calculate UA_nominal using operating conditions"
  replaceable package MediumW=Buildings.Media.Water;
  replaceable package MediumA=Buildings.Media.Air;

   Modelica.Blocks.Interfaces.RealInput TAirIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 273.15+25,
    displayUnit="degC")
    annotation (Placement(transformation(extent={{-110,82},{-90,102}}),
        iconTransformation(extent={{-112,90},{-92,110}})));

    Modelica.Blocks.Interfaces.RealInput TAirOut0(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 273.15+15,
    displayUnit="degC")
    annotation (Placement(transformation(extent={{-110,62},{-90,82}}),
        iconTransformation(extent={{-112,66},{-92,86}})));

    Modelica.SIunits.Temperature TAirOut=TAirOut0+epsilon;




  Modelica.Blocks.Interfaces.RealInput TWatIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=200,
    start=273.15+5,
    displayUnit="degC")
    annotation (Placement(transformation(extent={{-110,48},{-90,68}}),
        iconTransformation(extent={{-112,42},{-92,62}})));

    Modelica.Blocks.Interfaces.RealInput TWatOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=200,
    start=273.15+10,
    displayUnit="degC")
    annotation (Placement(transformation(extent={{-110,16},{-90,36}}),
        iconTransformation(extent={{-112,18},{-92,38}})));


  Modelica.Blocks.Interfaces.RealInput mAirFlo(
    quantity="MassFlowRate",
    start=0.2,
    final unit="kg/s") annotation (Placement(transformation(extent={{-110,-6},{-90,
            14}}),       iconTransformation(extent={{-112,-6},{-92,14}})));

    Modelica.Blocks.Interfaces.RealInput mWatFlo(
    quantity="MassFlowRate",
    start=0.1,
    final unit="kg/s")
    annotation (Placement(transformation(extent={{-110,-24},{-90,-4}}),
        iconTransformation(extent={{-112,-30},{-92,-10}})));


  Modelica.Blocks.Interfaces.RealInput wAirIn(min=0,
    unit="kg/kg") "Humidity ratio of water at inlet (kg water/kg moist air)"
    annotation (
      Placement(transformation(extent={{-110,-42},{-90,-22}}),
                                                             iconTransformation(
          extent={{-112,-54},{-92,-34}})));

  Modelica.Blocks.Interfaces.RealInput wAirOut(
    min=0,
    unit="kg/kg") "Humidity ratio of water at outlet (kg water/kg moist air)"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}}),
        iconTransformation(extent={{-112,-78},{-92,-58}})));

  output Modelica.SIunits.MassFraction Qtot;
  output Modelica.SIunits.ThermalConductance UA_Air_nominal;
  output Modelica.SIunits.ThermalConductance UA_Wat_nominal;
  output Modelica.SIunits.MassFlowRate UA_Sta_nominal;


  Modelica.Blocks.Interfaces.RealOutput UA_nominal
    "overall sensible heat transfer coefficient"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,94}), iconTransformation(extent={{98,80},{118,100}})));

  Modelica.Blocks.Interfaces.RealOutput Qsen(final quantity="Power",
      final unit="W")
    "Sensible heat transfer from water into air"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={108,60}), iconTransformation(extent={{98,50},{118,70}})));




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



  Modelica.SIunits.MassFraction wAirOutMin;
  Modelica.SIunits.SpecificEnthalpy LMED;
  Modelica.SIunits.SpecificEnthalpy hunit=1;
  Modelica.SIunits.Temperature Tunit=1;

  Real SHR;
  Real LHR;

  parameter Real epsilon=1E-2;
equation
  /*
  //- inputs
  TAirIn = Modelica.SIunits.Conversions.from_degF(80);
  TAirOut= Modelica.SIunits.Conversions.from_degF(53);
  wAirIn = 0.01765; // dry case: 0.0035383;

  TWatIn=Modelica.SIunits.Conversions.from_degF(42);
  TWatOut=Modelica.SIunits.Conversions.from_degF(47.72);

  mAirFlo=2.646;
  mWatFlo=3.78;
  Qtot=82722;
  */
  //wAirOut=0.01;
  //Qtot=mAirFlo*(Cpa*(TAirIn-TAirOut)+hfg*(wAirIn-wAirOut));// calculates wAirOut or Qtot
  Qtot=mAirFlo*(hAirIn-hAirOut);// calculates wAirOut or Qtot

  wAirOutMin=Buildings.Fluid.HeatExchangers.H_Example.DummyExample.wAirOut_min_checkup(TAirIn=TAirIn, TAirOut=TAirOut, wAirIn=wAirIn, wAirOut=wAirOut); //solution check up

  //assert(wAirOut>wAirOutMin, "No apparatus temperature exisits under the air in/out conditions.");

  //assert(TAirIn>TAirOut and wAirIn>wAirOut and TWatIn<TWatOut and TAirOut>TWatIn,"This is for cooling coil and check data.");




  // -- caluclation of UA_air_nominal by bypass approximation

  Qsen=mAirFlo*Cpa*(TAirIn-TAirOut);//calculate Qsen

  SHR=Cpa*(TAirIn-TAirOut)/(hAirIn-hAirOut);
  LHR=hfg*(wAirIn-wAirOut)/(hAirIn-hAirOut);


  //if TWatOut<TDewAirIn.T //fully wet, then use the following approximation which defines Tdeltaeq
  SHR=Cpa*(TAirIn-Tdeleq)/(hAirIn-hsatdeleq.hSat); // Q : does solution exist always? No.

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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,-98},{-100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UA_nominalFromOperatingCondition;
