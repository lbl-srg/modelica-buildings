within Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses;
record NominalValues "Data record of nominal values"
  extends Modelica.Icons.Record;

//-----------------------------Nominal conditions-----------------------------//
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal cooling capacity (negative number)"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COP_nominal "Nominal coefficient of performance"
    annotation (Dialog(group="Nominal condition"));
  parameter Real SHR_nominal "Nominal sensible heat ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure p_nominal=101325 "Atmospheric pressure"
    annotation(Dialog(tab="General",group="Nominal condition"));

//---------------------------------AHRI condition-----------------------------//
  parameter Modelica.SIunits.Temperature TIn_nominal=273.15+26.7
    "Dry-bulb temperature of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal/AHRI condition"));
  parameter Real phiIn_nominal=0.5
    "Relative humidity of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal/AHRI condition"));
annotation (defaultComponentName="nomVal",
              preferedView="info",
  Documentation(info="<html>
This is the base record of nominal values for DX cooling coil models. 
</html>",
revisions="<html>
<ul>
<li>
August 13, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end NominalValues;
