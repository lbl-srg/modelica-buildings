within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilUARated
  "This model calculates overall heat transfer coefficient, i.e., UA-value, from a rated condition for a cooling coil. 
  Specify a rated condition either in fully-dry or fully-wet coil regime. Avoid that on partially-wet regime."
  replaceable package MediumA=Buildings.Media.Air;
  replaceable package MediumW=Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature TAirIn=Modelica.SIunits.Conversions.from_degF(80)
                                                                                          " air inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TAirOut=273.15+13.5805 " air outlet temperature  at a rated condition";
  parameter Modelica.SIunits.MassFraction wAirIn=0.0173  "absolute humidity of inlet air at a rated condition";

  parameter Modelica.SIunits.Temperature TWatIn=Modelica.SIunits.Conversions.from_degF(42) " water inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TWatOut=273.15+11.0678
                                                         " water outlet temperature at a rated condition";

  parameter Modelica.SIunits.MassFlowRate mAir_flow=2.646 "air mass flow rate at a rated condition";
  parameter Modelica.SIunits.MassFlowRate mWat_flow=3.78
                                                        "water mass flow rate at a rated condition";
  parameter Modelica.SIunits.ThermalConductance UA(fixed=false, min=0,start=1/(1/10+1/20))
    "UA is for the overall coil (i.e., both sides)";
protected
  constant Modelica.SIunits.SpecificEnthalpy hfg = Buildings.Utilities.Psychrometrics.Constants.h_fg;
  parameter Modelica.SIunits.MassFraction wAirOut(fixed=false) "absolute humidity of outgoing air at a rated condition [to be calculated]";
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn(fixed=false) "enthalpy of incoming moist air at a rated condition [to be calculated]";
  parameter Modelica.SIunits.SpecificEnthalpy hAirOut(fixed=false)  "enthalpy of outgoing moist air at a rated condition [to be calculated]";

  // calculates all thermodynamic properties based on inputs
  parameter MediumA.ThermodynamicState staAir=MediumA.setState_phX(p=MediumA.p_default,h=MediumA.h_default,X=MediumA.X_default[1:MediumA.nXi]);
  parameter MediumW.ThermodynamicState staWat=MediumW.setState_phX(p=MediumW.p_default,h=MediumW.h_default,X=MediumW.X_default[1:MediumW.nXi]);

  parameter Modelica.SIunits.SpecificHeatCapacity cpAir=MediumA.specificHeatCapacityCp(staAir);
  parameter Modelica.SIunits.SpecificHeatCapacity cpw=MediumW.specificHeatCapacityCp(staWat);
  parameter Modelica.SIunits.SpecificHeatCapacity cpEff(fixed=false, min= 0)
    "Effective specific heat: change in saturated moist air enthalpy with respect to
    temperature along the saturation line between inlet and outlet water temperatures";

  constant Modelica.SIunits.SpecificEnthalpy hunit=1;
  constant Modelica.SIunits.Temperature Tunit=1;
  constant Modelica.SIunits.SpecificHeatCapacity cpunit=1;

  Modelica.SIunits.AbsolutePressure pSatTWatIn = Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatIn)
  "saturation pressure of water at the water inlet temperature";
  Modelica.SIunits.MassFraction wSatTWatIn = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(pSat=pSatTWatIn, p=MediumA.p_default, phi=1)
  "absolute humidity of the moist air at the water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatIn = Buildings.Media.Air.specificEnthalpy_pTX(p=MediumA.p_default, T=TWatIn, X={wSatTWatIn,1-wSatTWatIn})
  "enthalpy of saturated moist air at the water inlet temperature";

  Modelica.SIunits.AbsolutePressure pSatTWatOut = Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatOut)
  "saturation pressure of water at the water oulet temperature";
  Modelica.SIunits.MassFraction wSatTWatOut = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(pSat=pSatTWatOut, p=MediumA.p_default, phi=1)
  "absolute humidity of the moist air at the water oulet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatOut = Buildings.Media.Air.specificEnthalpy_pTX(p=MediumA.p_default, T=TWatOut, X={wSatTWatOut,1-wSatTWatOut})
  "enthalpy of saturated moist air at the water oulet temperature";

  parameter Modelica.SIunits.SpecificEnthalpy LMED(fixed=false) "log mean enthalpy difference";

  parameter Modelica.SIunits.MassFlowRate UASta(fixed=false, min=0) "overall heat transfer coefficient for enthalpy difference";
  parameter Modelica.SIunits.HeatFlowRate QTot_flow(fixed=false)
    "Total heat flow from air to water stream";

  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";

  parameter Modelica.SIunits.ThermalConductance UAAir(min=0,start=10,fixed=false)
  "Air side convective heat transfer coefficient, including fin resistance";
  parameter Modelica.SIunits.ThermalConductance UAWat(min=0,start=20,fixed=false)
  "Water side convective heat transfer coefficient";

  parameter Boolean IsFulDry(fixed=false);
  parameter Boolean IsFulWet(fixed=false);
  parameter Boolean IsParWet(fixed=false);

initial equation

  assert( TAirOut<TAirIn and TWatOut>TWatIn and TWatIn<TAirIn,  " The rated condition is not for a cooling coil. For a heating coil, use other heat exchanger models.");
  hAirIn =MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirIn,X={wAirIn,1-wAirIn});
  hAirOut=MediumA.specificEnthalpy_pTX(p=MediumA.p_default,T=TAirOut,X={wAirOut,1-wAirOut});

  mWat_flow*cpw*(TWatOut-TWatIn) = mAir_flow*(hAirIn-hAirOut);

  QTot_flow = mAir_flow*(hAirIn-hAirOut);// calculates wAirOut or Qtot

  IsFulDry=(wSatTWatIn>=wAirIn);
  IsFulWet=(wSatTWatOut<=wAirIn);
  IsParWet= (not IsFulDry) and (not IsFulWet);

  assert(not IsParWet, "partially dry nominal condition is not allowed at this moment. Specify either fully-dry or fully-wet nominal condition");

if IsFulDry then
  LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(TAirIn,
                    TAirOut,
                    TWatIn,
                    TWatOut)/Tunit*hunit; // The value of LMED calculated from this equation is used as that of LMTD.
  QTot_flow=LMED*UASta; // The value of UASta calculated from this equation is used as that of UA.
  cpEff= Modelica.Constants.inf*cpunit; // cpEff is not used for fully-dry
  UA= UASta*cpunit;
  UAWat=UAAir/r_nominal;
  UA = 1/ (1/UAAir  + 1/ UAWat);
else //fully wet
  // calculation of overall UAsta based on log mean enthalpy difference
  LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(hAirIn/hunit*Tunit,
                    hAirOut/hunit*Tunit,
                    hSatTWatIn/hunit*Tunit,
                    hSatTWatOut/hunit*Tunit)/Tunit*hunit;
  QTot_flow=LMED*UASta;
  cpEff= (hSatTWatOut-hSatTWatIn)/(TWatOut-TWatIn);

  UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));
  UAWat=UAAir/r_nominal;
  UA = 1/ (1/UAAir  + 1/ UAWat);
end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,-98},{-100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WetCoilUARated;
