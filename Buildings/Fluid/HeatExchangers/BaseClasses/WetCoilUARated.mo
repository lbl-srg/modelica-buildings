within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilUARated
  "Model that calculates the UA-value from cooling coil data at rated conditions."

  replaceable package MediumA=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air-side medium";
  replaceable package MediumW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Water-side medium";

  parameter Boolean use_Q_flow_nominal = false
    "Set to true to specify Q_flow_nominal and inlet conditions, or to false to specify UA_nominal"
    annotation (
      Evaluate=true,
      Dialog(group="Nominal thermal performance"));
  parameter Modelica.SIunits.HeatFlowRate QTot_flow
    "Nominal heat flow rate (positive for heat transfer from 1 to 2)";
  parameter Modelica.SIunits.Temperature TAirIn
    "Air inlet temperature at a rated condition";

  parameter Modelica.SIunits.MassFraction X_wAirIn
    "Mass fraction of water in inlet air at a rated condition";
  parameter Modelica.SIunits.Temperature TWatIn
    "Water inlet temperature at a rated condition";

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
  parameter Modelica.SIunits.Temperature TAirOut(fixed=false)
    "Air outlet temperature  at a rated condition";
  parameter Modelica.SIunits.Temperature TWatOut=
    TWatIn - QTot_flow / cpWat / mWat_flow
    "Water outlet temperature at a rated condition";
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn = MediumA.specificEnthalpy_pTX(
    p=MediumA.p_default, T=TAirIn, X={X_wAirIn, 1-X_wAirIn})
    "Enthalpy of incoming moist air at a rated condition";
  parameter MediumA.ThermodynamicState staAir=MediumA.setState_phX(
    p=MediumA.p_default, h=hAirIn, X={X_wAirIn, 1-X_wAirIn})
    "Inlet air thermodynamic state";
  parameter Modelica.SIunits.SpecificHeatCapacity cpAir=
    MediumA.specificHeatCapacityCp(staAir)
    "Isobaric specific heat capacity of air";
  parameter Modelica.SIunits.SpecificEnthalpy hAirOut=
    hAirIn + QTot_flow / mAir_flow
    "Enthalpy of outgoing moist air at a rated condition";
  parameter Modelica.SIunits.SpecificEnthalpy hWatIn = MediumW.specificEnthalpy_pTX(
    p=MediumW.p_default, T=TWatIn, X=MediumW.X_default)
    "Enthalpy of incoming moist air at a rated condition";
  parameter MediumW.ThermodynamicState staWat=MediumW.setState_phX(
    p=MediumW.p_default, h=hWatIn, X=MediumW.X_default)
    "Inlet water thermodynamic state";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat=
      MediumW.specificHeatCapacityCp(staWat)
    "Isobaric specific heat capacity of water";
  parameter Modelica.SIunits.SpecificHeatCapacity cpEff(fixed=false, min= 0)
    "Effective specific heat: change in saturated moist air enthalpy with respect to
    temperature along the saturation line between inlet and outlet water temperatures";
  parameter Modelica.SIunits.SpecificEnthalpy LMED(fixed=false)
    "Log mean enthalpy difference";
  parameter Modelica.SIunits.MassFlowRate UASta(fixed=false, min=0, start=1/(1/10+1/20))
    "Overall heat transfer coefficient for enthalpy difference";
  parameter Modelica.SIunits.ThermalConductance UAAir(min=0,start=10,fixed=false)
    "Air side convective heat transfer coefficient, including fin resistance";
  parameter Modelica.SIunits.ThermalConductance UAWat(min=0,start=20,fixed=false)
    "Water side convective heat transfer coefficient";
  parameter Boolean isFulDry(fixed=false)
    "Indicator of the fully-dry coil regime";
  parameter Boolean isFulWet(fixed=false)
    "Indicator of the fully-wet coil regime";
  parameter Modelica.SIunits.AbsolutePressure pSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatIn)
    "Saturation pressure of water at the water inlet temperature";
  parameter Modelica.SIunits.MassFraction X_wSatTWatIn=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatIn, p=MediumA.p_default, phi=1)
    "Mass fraction of water in saturated moist air at the water inlet temperature";
  parameter Modelica.SIunits.SpecificEnthalpy hSatTWatIn=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatIn, X={X_wSatTWatIn,1-X_wSatTWatIn})
    "Enthalpy of saturated moist air at the water inlet temperature";
  parameter Modelica.SIunits.AbsolutePressure pSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TWatOut)
    "Saturation pressure of water at the water oulet temperature";
  parameter Modelica.SIunits.MassFraction X_wSatTWatOut=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=pSatTWatOut, p=MediumA.p_default, phi=1)
    "Mass fraction of water in saturated moist air at the water outlet temperature";
  parameter Modelica.SIunits.SpecificEnthalpy hSatTWatOut=
    Buildings.Media.Air.specificEnthalpy_pTX(
      p=MediumA.p_default, T=TWatOut, X={X_wSatTWatOut,1-X_wSatTWatOut})
    "Enthalpy of saturated moist air at the water oulet temperature";
initial equation
  isFulDry = if use_Q_flow_nominal then (X_wSatTWatIn >= X_wAirIn) else true;
  isFulWet = if use_Q_flow_nominal then (X_wSatTWatOut <= X_wAirIn) else true;
  assert(
    not use_Q_flow_nominal or
      hAirOut >= hSatTWatIn and hAirIn >= hSatTWatOut or
      hAirOut <= hSatTWatIn and hAirIn <= hSatTWatOut,
    "In " + getInstanceName() +
    ": The moist air enthalpy at the coil inlet or outlet is unrealistically low. " +
    "Check the rated conditions.");
  assert(
    isFulDry or isFulWet,
    "In " + getInstanceName() +
    ": The nominal conditions correspond to a partially-wet coil regime. " +
    "The modeling uncertainty under such conditions has not been assessed. " +
    "Rather specify nominal conditions in fully-dry or fully-wet regime.",
    level=AssertionLevel.warning);
  if use_Q_flow_nominal then
    if isFulDry then
      TAirOut = TAirIn + QTot_flow / mAir_flow / cpAir;
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        TWatIn,
        TWatOut,
        TAirIn,
        TAirOut) / TUnit * hUnit;
      QTot_flow=LMED*UASta;
      cpEff = 0;
      UA = UASta*cpUnit;
    else //fully wet
      // calculation of overall UAsta based on log mean enthalpy difference
      LMED=Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        hSatTWatIn/hUnit*TUnit,
        hSatTWatOut/hUnit*TUnit,
        hAirIn/hUnit*TUnit,
        hAirOut/hUnit*TUnit) / TUnit * hUnit;
      QTot_flow=LMED*UASta;
      cpEff= (hSatTWatOut-hSatTWatIn)/(TWatOut-TWatIn);
      UASta = (UAAir/cpAir)/(1 + (cpEff*UAAir)/(cpAir*UAWat));
      // Dummy value.
      TAirOut=MediumA.T_default;
    end if;
  else
    // Dummy values.
    TAirIn=MediumA.T_default;
    TAirOut=MediumA.T_default;
    X_wAirIn=MediumA.X_default[1];
    TWatIn=MediumA.T_default;
    TWatOut=MediumA.T_default;
    hAirIn=MediumA.h_default;
    hAirOut=MediumA.h_default;
    LMED=hUnit;
    -QTot_flow=LMED*UASta;
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
