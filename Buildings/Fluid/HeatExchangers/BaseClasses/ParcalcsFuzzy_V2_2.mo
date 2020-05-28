within Buildings.Fluid.HeatExchangers.BaseClasses;
model ParcalcsFuzzy_V2_2 "Description"

  // Buildings.Fluid.HeatExchangers.BaseClasses.ParcalcsFuzzy_V2_2 par(pAir=pAir, TAirIn=TAirIn, wAirIn=wAirIn,
  //   mAir_flow=mAir_flow, TWatIn=TWatIn, mWat_flow=mWat_flow,UAAir=UAAir,UAWat=UAWat,cpAir=cpAir,cpWat=cpWat,
  //   final cfg = Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow,mWatNonZer_flow = mWatNonZer_flow,
  // mAirNonZer_flow = mAirNonZer_flow);

  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg=Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow
    "The configuration of the heat exchanger";

  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";

  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  //Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)
  //  "Mass flow rate for water, bounded away from zero";
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
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow;//=max(mWat_flow,1e-5);
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow;//=max(mAir_flow,1e-5);

  input Modelica.SIunits.MassFlowRate mAir_flow_nominal;
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal;
  //Modelica.SIunits.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps)
  //  "Mass flow rate for air, bounded away from zero";
  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  input Modelica.SIunits.MassFraction wAirIn
    "Mass fraction of water in moist air at inlet";

  input Modelica.SIunits.Temperature TSurAirOutDry
    "Surface temperature at air outlet under the dry coil assumption";

  input Modelica.SIunits.Temperature TSurAirInWet
    "Surface temperature at air inlet under the wet coil assumption";

  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Modelica.SIunits.HeatFlowRate QTot_flow;
  output Modelica.SIunits.HeatFlowRate QSen_flow;

  // -- misc
  Real dryfra(min=0, max=1, start=0.415)
    "Fraction of heat exchanger to which UA is to be applied";
  Modelica.SIunits.Temperature TSurTra(start=14.19+273.15);

  Buildings.Utilities.Psychrometrics.pW_X pWIn(X_w=wAirIn,p_in=pAir);
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewIn(p_w=pWIn.p_w);

  Buildings.Fluid.HeatExchangers.BaseClasses.DryCalcsFuzzy_V2_2 dry(
  UAWat = UAWat,
  final dryfra = dryfra,
  mWat_flow = mWat_flow,
  cpWat = cpWat,
  TWatIn = wet.TWatOut,
  UAAir = UAAir,
  mAir_flow = mAir_flow,
  mWatNonZer_flow = mWatNonZer_flow,
  mAirNonZer_flow = mAirNonZer_flow,
  cpAir = cpAir,
  TAirIn = TAirIn,
  final cfg = cfg,
   mAir_flow_nominal=mAir_flow_nominal,
  mWat_flow_nominal=mWat_flow_nominal);

  Buildings.Fluid.HeatExchangers.BaseClasses.WetcalcsFuzzy_V2_2 wet(
    pAir=pAir,
    TAirIn=dry.TAirOut,
    wAirIn=wAirIn,
    mAir_flow=mAir_flow,
    TWatIn=TWatIn,
    mWat_flow=mWat_flow,
    UAAir=UAAir,
    UAWat=UAWat,
    cpAir=cpAir,
    cpWat=cpWat,
    dryfra=dryfra,
    final cfg=cfg,
    mWatNonZer_flow=mWatNonZer_flow,
    mAirNonZer_flow=mAirNonZer_flow,
    mAir_flow_nominal=mAir_flow_nominal,
    mWat_flow_nominal=mWat_flow_nominal);

equation
  if noEvent(TSurAirOutDry>=(TDewIn.T-1e-2)) then //domain restriction
    dryfra  = 1-1e-3;
    TWatOut = dry.TWatOut;
    TAirOut = dry.TAirOut;
    TSurTra = 0.5*(dry.TSurAirOut + wet.TSurAirIn);
  elseif noEvent(TSurAirInWet<=(TDewIn.T+1e-2)) then //domain restriction
    dryfra  = 1e-3;
    TWatOut = wet.TWatOut;
    TAirOut = wet.TAirOut;
    TSurTra = 0.5*(dry.TSurAirOut + wet.TSurAirIn);
  else
    TWatOut = dry.TWatOut;
    TAirOut = wet.TAirOut;
    (dry.TAirOut-TSurTra)*UAAir=(TSurTra-wet.TWatOut)*UAWat;
    TDewIn.T = TSurTra;
  end if;

  QTot_flow=dry.QTot_flow+wet.QTot_flow;
  QSen_flow=dry.QTot_flow+wet.QSen_flow;

  annotation (Icon(graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid)}));
end ParcalcsFuzzy_V2_2;
