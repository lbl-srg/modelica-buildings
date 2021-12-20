within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model UACp "Calculates UA/Cp of the coil"
  extends Modelica.Blocks.Icons.Block;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  replaceable package Medium = Buildings.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues per
     constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues
     "Performance data" annotation (choicesAllMatching=true);

  final parameter Modelica.SIunits.MassFraction XEvaIn_nominal=
     Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=Medium.saturationPressure(per.TEvaIn_nominal),
        p=per.p_nominal,
        phi=per.phiIn_nominal)
    "Rated/Nominal mass fraction of air entering coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hEvaIn_nominal=
   Medium.specificEnthalpy_pTX(
     p=per.p_nominal,
     T=per.TEvaIn_nominal,
     X=cat(1,{XEvaIn_nominal}, {1-sum({XEvaIn_nominal})}))
    "Rated enthalpy of air entering cooling coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hOut_nominal=
    hEvaIn_nominal + per.Q_flow_nominal / per.m_flow_nominal
    "Rated enthalpy of air exiting cooling coil";
  final parameter Modelica.SIunits.Temperature TOut_nominal=
    per.TEvaIn_nominal + (per.SHR_nominal * per.Q_flow_nominal)/(per.m_flow_nominal * Cp_nominal)
    "Dry-bulb temperature of the air leaving the cooling coil at nominal condition";
  final parameter Modelica.SIunits.MassFraction XEvaOut_nominal(start=0.005, min=0, max=1.0)=
     XEvaIn_nominal + (hOut_nominal- hEvaIn_nominal)*(1-per.SHR_nominal)/
     Medium.enthalpyOfCondensingGas(T=per.TEvaIn_nominal)
    "Rated/Nominal mass fraction of air leaving the coil";
  final parameter Modelica.SIunits.SpecificHeatCapacity Cp_nominal=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=per.p_nominal, T=per.TEvaIn_nominal, X=cat(1,{XEvaIn_nominal}, {1-sum({XEvaIn_nominal})})))
    "Specific heat of air at specified nominal condition"
    annotation(HideResult=true);

  final parameter Modelica.SIunits.MassFraction XADP_nominal(
    start=0.008,
    min=0,
    max=1.0,
    fixed=false)
    "Rated/Nominal mass fraction of air at coil apparatus dew point";
  final parameter Modelica.SIunits.Temperature TADP_nominal(
    start=273.15+10,
    fixed=false) "Coil apparatus dew point temperature";
  final parameter Modelica.SIunits.SpecificEnthalpy hADP_nominal(
    fixed=false)
    "Enthalpy of air at coil apparatus dew point (at rated condition)";
  final parameter Real bypass_nominal(
    start=0.25,
    min=0,
    max=1.0,
    fixed=false) "Bypass factor for nominal condition";
  final parameter Real UAcp(
    min=0,
    unit="kg/s",
    fixed=false) "UA/Cp of coil";

protected
  constant Real phiADP_nominal = 1.0 "Realtive humidity at ADP";
  final parameter Modelica.SIunits.AbsolutePressure psat_ADP_nominal(
    start=1250,
    fixed=false) "Saturation pressure";

initial equation
//------------------------Apparatus Dew Point (ADP) calculations---------------------//
  //Solve Eq. 1 , 2 and 3 for air properties (XADP_nominal and TADP_nominal)
  //of saturated air at coil apparatus dew point
//---------------------------------------Eq.1---------------------------------------//
  (XEvaIn_nominal - XEvaOut_nominal)*(per.TEvaIn_nominal - TADP_nominal)
     =(XEvaIn_nominal  - XADP_nominal)*(per.TEvaIn_nominal - TOut_nominal);
//---------------------------------------Eq.2---------------------------------------//
  if homotopyInitialization then
    psat_ADP_nominal=homotopy(
      actual=Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TADP_nominal),
      simplified=1252.393+83.933*(TADP_nominal-283.15));
  else // do not use homotopy
    psat_ADP_nominal=Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TADP_nominal);
  end if;
  //  Taylor series
  //  psat_ADP_nominal=1252.393+83.933*(TADP_nominal-283.15);
  //  Non-linear equation
  //  psat_ADP_nominal =  Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TADP_nominal);
//---------------------------------------Eq.3---------------------------------------//
  if homotopyInitialization then
    XADP_nominal=homotopy(
      actual=Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=psat_ADP_nominal,
        p=per.p_nominal,
        phi=phiADP_nominal),
      simplified=0.007572544+6.19495*(10^(-6))*(psat_ADP_nominal-1228));

  else // do not use homotopy
    XADP_nominal=Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=psat_ADP_nominal,
        p=per.p_nominal,
        phi=phiADP_nominal);
  end if;
//-----------------------------------uACp calculations-----------------------------//
  hADP_nominal = Medium.specificEnthalpy_pTX(
              p=per.p_nominal,
              T=TADP_nominal,
              X=cat(1,{XADP_nominal}, {1-sum({XADP_nominal})}));
  bypass_nominal=Buildings.Utilities.Math.Functions.smoothLimit(
              x=(hOut_nominal-hADP_nominal)/(hEvaIn_nominal-hADP_nominal),
              l=1e-3,
              u=0.999,
              deltaX=1e-4);
  UAcp = -per.m_flow_nominal * Modelica.Math.log(bypass_nominal);

  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

 annotation(defaultComponentName="uacp",
    Documentation(info="<html>
<p>
This model calculates the <i>UA/c<sub>p</sub></i> value and the bypass factor
of the coil from the nominal inlet and outlet
air properties.
</p>
<p>
For a heat exchanger where one medium changes phase, the <i>NTU-&epsilon;</i> relation
is
<p align=\"center\" style=\"font-style:italic;\">
  &epsilon; = 1 - exp(-NTU) = 1-exp(-UA &frasl; c<sub>p</sub> &frasl; m&#775;).
</p>
<p>
Since the bypass factor <i>b</i> is defined as <i>b=1-&epsilon;</i>,
one can write
</p>
<p align=\"center\" style=\"font-style:italic;\">
  b = exp(-UA &frasl; c<sub>p</sub> &frasl; m&#775;)
</p>
<p>
and, hence,
<p align=\"center\" style=\"font-style:italic;\">
 UA &frasl; c<sub>p</sub> = - m&#775; log(b).
</p>
</html>",
revisions="<html>
<ul>
<li>
November 11, 2020, by Michael Wetter:<br/>
Refactored to integrate directly a base class that was used only once in the library.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2229\">#2229</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
September 21, 2012 by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end UACp;
