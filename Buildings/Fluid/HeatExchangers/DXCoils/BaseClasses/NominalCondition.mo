within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
record NominalCondition
  "Calculates inlet and outlet fluid parameters at nominal condition"
  extends Modelica.Icons.Record;
  replaceable package Medium =
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
  parameter Modelica.SIunits.SpecificHeatCapacity Cp_nominal=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=per.p_nominal, T=per.TEvaIn_nominal, X=cat(1,{XEvaIn_nominal}, {1-sum({XEvaIn_nominal})})))
    "Specific heat of air at specified nominal condition"
    annotation(HideResult=true);
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
February 17, 2017 by Yangyang Fu:<br/>
Changed parameter <code>per</code> to replaceable and added constrained type for redeclaration in water-cooled DX coils.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Changed protected parameter <code>Cp_nominal</code> to public, and
hidded its result. The use of a protected parameter is not valid Modelica
syntax.
</li>
<li>
September 20, 2012 by Michael Wetter:<br/>
Reimplemented class as a record.
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end NominalCondition;
