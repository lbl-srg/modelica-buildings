within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilUARated
  "Model that calculates the UA-value from cooling coil data at rated conditions."

  replaceable package MediumA=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air-side medium";
  replaceable package MediumW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Water-side medium";

  parameter Boolean use_UA_nominal = false
    "Set to true to specify UA_nominal, or to false to use nominal conditions"
    annotation (Evaluate=true,
                Dialog(group="Nominal thermal performance"));
  parameter Modelica.SIunits.Temperature TAirIn
    "Air inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TAirOut
    "Air outlet temperature  at a rated condition";
  parameter Modelica.SIunits.MassFraction X_wAirIn
    "Mass fraction of water in inlet air at a rated condition";
  parameter Modelica.SIunits.Temperature TWatIn
    "Water inlet temperature at a rated condition";
  parameter Modelica.SIunits.Temperature TWatOut
    "Water outlet temperature at a rated condition";
  parameter Modelica.SIunits.MassFlowRate mAir_flow
    "Air mass flow rate at a rated condition";
  parameter Modelica.SIunits.MassFlowRate mWat_flow
    "Water mass flow rate at a rated condition";
  parameter Modelica.SIunits.ThermalConductance UA
    "the overall heat transfer coefficient for a fully dry condition";
  parameter Real r_nominal(min=0, max=1)
    "Ratio between air-side and water-side convective heat transfer at nominal condition";
protected
  constant Modelica.SIunits.SpecificEnthalpy hfg=
    Buildings.Utilities.Psychrometrics.Constants.h_fg
    "Enthapy of vaporization of water";
  constant Modelica.SIunits.SpecificEnthalpy hUnit=1
    "Physical dimension of specific enthalpy used for a unit conversion";
  constant Modelica.SIunits.Temperature TUnit=1
    "Physical dimension of temperature used for a unit conversion";
  constant Modelica.SIunits.SpecificHeatCapacity cpUnit=1
    "Physical dimension of specific heat capacity used for a unit conversion";

  /*parameter Modelica.SIunits.MassFraction X_wAirOut(fixed=false)
    "Mass fraction of water in outgoing air at a rated condition";*/
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn = MediumA.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TAirIn, X={X_wAirIn, 1-X_wAirIn})
    "Enthalpy of incoming moist air at a rated condition";
  parameter Modelica.SIunits.SpecificEnthalpy hAirOut = hAirIn- QTot_flow/mAir_flow
    "Enthalpy of outgoing moist air at a rated condition";

  // calculates all thermodynamic properties based on inputs
  parameter MediumA.ThermodynamicState staAir=MediumA.setState_phX(
    p=MediumA.p_default,h=MediumA.h_default,X=MediumA.X_default[1:MediumA.nXi])
    "Air media object";
  parameter MediumW.ThermodynamicState staWat=MediumW.setState_phX(
    p=MediumW.p_default,h=MediumW.h_default,X=MediumW.X_default[1:MediumW.nXi])
    "Water media object";

  parameter Modelica.SIunits.SpecificHeatCapacity cpAir=
    MediumA.specificHeatCapacityCp(staAir)
    "Isobaric specific heat capacity of air";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat=
      MediumW.specificHeatCapacityCp(staWat)
    "Isobaric specific heat capacity of water";
  parameter Modelica.SIunits.SpecificHeatCapacity cpEff(fixed=false, min= 0)
    "Effective specific heat: change in saturated moist air enthalpy with respect to
    temperature along the saturation line between inlet and outlet water temperatures";

  parameter Modelica.SIunits.SpecificEnthalpy LMED(fixed=false)
    "Log mean enthalpy difference";

  parameter Modelica.SIunits.MassFlowRate UASta(fixed=false, min=0)
    "Overall heat transfer coefficient for enthalpy difference";
  parameter Modelica.SIunits.HeatFlowRate QTot_flow=mWat_flow*cpWat*(TWatOut -
      TWatIn) "Total heat flow from air to water stream";

  parameter Modelica.SIunits.ThermalConductance UAAir(min=0,start=10,fixed=false)
  "Air side convective heat transfer coefficient, including fin resistance";
  parameter Modelica.SIunits.ThermalConductance UAWat(min=0,start=20,fixed=false)
  "Water side convective heat transfer coefficient";

  parameter Boolean isFulDry(fixed=false)
  "Indicator of the fully-dry coil regime";
  parameter Boolean isFulWet(fixed=false)
  "Indicator of the fully-wet coil regime";

  Modelica.SIunits.AbsolutePressure pSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatIn)
    "Saturation pressure of water at the water inlet temperature";
  Modelica.SIunits.MassFraction X_wSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatIn, p=MediumA.p_default, phi=1)
    "Mass fraction of water in saturated moist air at the water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatIn=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatIn, X={X_wSatTWatIn,1-X_wSatTWatIn})
    "Enthalpy of saturated moist air at the water inlet temperature";

  Modelica.SIunits.AbsolutePressure pSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatOut)
    "Saturation pressure of water at the water oulet temperature";
  Modelica.SIunits.MassFraction X_wSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatOut, p=MediumA.p_default, phi=1)
    "Mass fraction of water in saturated moist air at the water outlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSatTWatOut=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatOut, X={X_wSatTWatOut,1-X_wSatTWatOut})
    "Enthalpy of saturated moist air at the water oulet temperature";

initial equation

/*  hAirIn=MediumA.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TAirIn, X={X_wAirIn, 1-X_wAirIn});
  hAirOut=MediumA.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TAirOut, X={X_wAirOut, 1-X_wAirOut});*/

  //QTot_flow = mAir_flow*(hAirIn-hAirOut);



  isFulDry = if not use_UA_nominal then (X_wSatTWatIn >= X_wAirIn) else true;
  isFulWet = if not use_UA_nominal then (X_wSatTWatOut <= X_wAirIn) else true;
  assert( hAirOut >= hSatTWatIn and hAirIn >= hSatTWatOut or use_UA_nominal,
       "The provided data indicates thtat the air enthlapy either at the air inlet or
        at the outlet is unrealistically low. Check the rated condition.");

  assert(
    isFulDry or isFulWet,
    "In " + getInstanceName() +
    ": The nominal conditions correspond to a partially-wet coil regime. " +
    "The modeling uncertainty under such conditions has not been assessed. " +
    "Rather specify nominal conditions in fully-dry or fully-wet regime.",
    level=AssertionLevel.warning);

//   assert(use_UA_nominal or TAirOut<TAirIn and TWatOut>TWatIn and TWatIn<TAirIn,
//     "The rated condition is not for a cooling coil. " +
//     "For a heating coil, use Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU.");

  if not use_UA_nominal then
    if isFulDry then
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        TAirIn,
        TAirOut,
        TWatIn,
        TWatOut)/TUnit*hUnit;
      QTot_flow=LMED*UASta;
      cpEff= 0;
      UA= UASta*cpUnit;
    else //fully wet
      // calculation of overall UAsta based on log mean enthalpy difference
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        hAirIn/hUnit*TUnit,
        hAirOut/hUnit*TUnit,
        hSatTWatIn/hUnit*TUnit,
        hSatTWatOut/hUnit*TUnit)/TUnit*hUnit;
      QTot_flow=LMED*UASta;
      cpEff= (hSatTWatOut-hSatTWatIn)/(TWatOut-TWatIn);
      UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));
    end if;
  else
    TAirIn=MediumA.T_default;
    TAirOut=MediumA.T_default;
    X_wAirIn=MediumA.X_default[1];
    //X_wAirOut=MediumA.X_default[1];
    TWatIn=MediumA.T_default;
    TWatOut=MediumA.T_default;
    hAirIn=MediumA.h_default;
    hAirOut=MediumA.h_default;
    LMED=hUnit;
    QTot_flow=LMED*UASta;
    cpEff= 0;
  end if;

  UAWat = UAAir / r_nominal;
  UA = 1/ (1/UAAir  + 1/UAWat);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
        Rectangle(
        extent={{100,-98},{-100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
February 18, 2021 by Donghun Kim:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model calculates the overall heat transfer coefficient, i.e., 
<i>UA</i>-value, from cooling coil data at rated conditions.
</p>
<p>
The main limitation of the current implementation is that the rated 
conditions should correspond to a fully-dry or a fully-wet coil regime.
The modeling uncertainty yielded by partially-wet rated conditions
has not been assessed yet.
</p>
</html>"));
end WetCoilUARated;
