within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
record NominalCondition
  "Calculates inlet and outlet fluid parameters at nominal condition"
  extends Modelica.Icons.Record;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues per
    "Performance data"
    annotation (choicesAllMatching = true);
  final parameter Modelica.SIunits.MassFraction XIn_nominal=
     Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=Medium.saturationPressure(per.TIn_nominal),
        p=per.p_nominal,
        phi=per.phiIn_nominal)
    "Rated/Nominal mass fraction of air entering coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hIn_nominal=
   Medium.h_pTX(
     p=per.p_nominal,
     T=per.TIn_nominal,
     X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})}))
    "Rated enthalpy of air entering cooling coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hOut_nominal=
    hIn_nominal + per.Q_flow_nominal / per.m_flow_nominal
    "Rated enthalpy of air exiting cooling coil";
  final parameter Modelica.SIunits.Temperature TOut_nominal=
    per.TIn_nominal + (per.SHR_nominal * per.Q_flow_nominal)/(per.m_flow_nominal * Cp_nominal)
    "Dry-bulb temperature of the air leaving the cooling coil at nominal condition";
  final parameter Modelica.SIunits.MassFraction XOut_nominal(start=0.005, min=0, max=1.0)=
     XIn_nominal + (hOut_nominal- hIn_nominal)*(1-per.SHR_nominal)/
     Medium.enthalpyOfCondensingGas(T=per.TIn_nominal)
    "Rated/Nominal mass fraction of air leaving the coil";
protected
  parameter Modelica.SIunits.SpecificHeatCapacity Cp_nominal=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=per.p_nominal, T=per.TIn_nominal, X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})})))
    "Specific heat of air at specified nominal condition";
 annotation(defaultComponentName="nomCon",
 Documentation(info="<html>
<p>
This block calculates inlet and outlet fluid parameters at the nominal condition.
These parameters are required to determine the apparatus dew point at the nominal condition. 
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2012 by Michael Wetter:<br>
Reimplemented class as a record. 
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end NominalCondition;
