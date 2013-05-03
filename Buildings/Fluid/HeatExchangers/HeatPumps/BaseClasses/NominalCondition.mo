within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
record NominalCondition
  "Calculates inlet and outlet fluid parameters at nominal condition"
  extends Modelica.Icons.Record;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
//   replaceable parameter
//     Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingNominalValues
//                                                                                                 cooNomVal
//     "Performance data"
//     annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Temperature TIn_nominal
    "Entering air dry-bulb temperature at rating condition";

  parameter Modelica.SIunits.Pressure p_nominal "Inlet air nominal pressure";

  parameter Real phiIn_nominal
    "Relative humidity of entering air at nominal condition";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Nominal cooling capacity (negative number)";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate";

  parameter Real SHR_nominal "Nominal sensible heat ratio";

  final parameter Modelica.SIunits.MassFraction XIn_nominal=
     Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=Medium.saturationPressure(TIn_nominal),
        p=p_nominal,
        phi=phiIn_nominal) "Rated/Nominal mass fraction of air entering coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hIn_nominal=
   Medium.h_pTX(
     p=p_nominal,
     T=TIn_nominal,
     X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})}))
    "Rated enthalpy of air entering cooling coil";
  final parameter Modelica.SIunits.SpecificEnthalpy hOut_nominal=
    hIn_nominal + Q_flow_nominal / m_flow_nominal
    "Rated enthalpy of air exiting cooling coil";
  final parameter Modelica.SIunits.Temperature TOut_nominal=
    TIn_nominal + (SHR_nominal * Q_flow_nominal)/(m_flow_nominal * Cp_nominal)
    "Dry-bulb temperature of the air leaving the cooling coil at nominal condition";
  final parameter Modelica.SIunits.MassFraction XOut_nominal(start=0.005, min=0, max=1.0)=
     XIn_nominal + (hOut_nominal- hIn_nominal)*(1-SHR_nominal)/
     Medium.enthalpyOfCondensingGas(T=TIn_nominal)
    "Rated/Nominal mass fraction of air leaving the coil";
protected
  parameter Modelica.SIunits.SpecificHeatCapacity Cp_nominal=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=p_nominal, T=TIn_nominal, X=cat(1,{XIn_nominal}, {1-sum({XIn_nominal})})))
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
