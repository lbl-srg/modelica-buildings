within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block NominalCondition
  "Calculates inlet and outlet fluid parameters at nominal condition"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues per
    "Performance data"
    annotation (choicesAllMatching = true);
  final parameter Modelica.SIunits.MassFraction XIn_nominal( min=0, max=1.0, fixed=false)
    "Rated/Nominal mass fraction of air entering coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hIn_nominal(fixed=false)
    "Rated enthalpy of air entering cooling coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hOut_nominal(fixed=false)
    "Rated enthalpy of air exiting cooling coil";
  final parameter Modelica.SIunits.Temperature TOut_nominal(start=290, fixed=false)
    "Dry-bulb temperature of the air leaving the cooling coil at nominal condition";
  final parameter Modelica.SIunits.MassFraction XOut_nominal(start=0.005, min=0, max=1.0, fixed=false)
    "Rated/Nominal mass fraction of air leaving the coil";
  final parameter Real hfg=(2405900-2500500)/(40-0)*(per.TIn_nominal-273.16)+2500500;
  constant Real k = 0.621964713077499 "Ratio of molar masses; 
//    required to calculate water mass fraction from relative humidity";
protected
  parameter Modelica.SIunits.SpecificHeatCapacity Cp_nominal(fixed=false)
    "Specific heat of air at specified nominal condition";
  parameter Modelica.SIunits.AbsolutePressure psat_nominal(fixed=false)
    "Saturation pressure; required to calculate water mass fraction from relative humidity";
initial equation
//Following calculations are at AHRI/Nominal condition
//At AHRI condition TIn_nominal=80F and phiIn_nominal=0.5 (50%)
//---------------------------------------Nominal Inlet conditions------------------------------------------//
  psat_nominal =  Medium.saturationPressure(per.TIn_nominal);
//  XIn_nominal =  Medium.massFraction_pTphi(
//    p=per.p_nominal,
//    T=per.TIn_nominal,
//    phi=per.phiIn_nominal); //Not used; as this function is not availabel in all medium packages
  XIn_nominal=per.phiIn_nominal*k/(k*per.phiIn_nominal+per.p_nominal/psat_nominal-per.phiIn_nominal);
  hIn_nominal = Medium.h_pTX(
    p=per.p_nominal,
    T=per.TIn_nominal,
    X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})}));
//---------------------------------------Nominal Outlet conditions------------------------------------------//
  Cp_nominal=Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=per.p_nominal, T=per.TIn_nominal, X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})})));
  hOut_nominal = hIn_nominal + per.Q_flow_nominal / per.m_flow_nominal;
  TOut_nominal = per.TIn_nominal + (per.SHR_nominal * per.Q_flow_nominal)/(per.m_flow_nominal * Cp_nominal);
  (hOut_nominal- hIn_nominal)*(1-per.SHR_nominal)=(XOut_nominal-XIn_nominal)*hfg
 annotation(defaultComponentName="nomCon",
 Documentation(info="<html>
<p>
This block calculates inlet and outlet fluid parameters at the nominal condition.
These parameters are required to determine the apparatus dew point at the nominal condition. <br>
Calculations for fluid parameters at the nominal condition are not repeated at each time step. 
This block is further extended to determine the UA/Cp value of the coil. 
Once this value is determined it is used for further calculations.

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end NominalCondition;
