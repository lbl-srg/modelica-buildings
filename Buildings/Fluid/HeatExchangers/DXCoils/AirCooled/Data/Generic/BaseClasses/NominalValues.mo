within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses;
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
    "Nominal air mass flow rate at evaporators"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Temperature TEvaIn_nominal=273.15+19.4
    "Evaporator entering air wet-bulb temperature at rating condition"
      annotation(Dialog(tab="General",group="Nominal condition"));

  parameter Modelica.SIunits.Temperature TConIn_nominal=308.15
    "Condenser entering temperature at rating condition (wet bulb for evaporative cooled coils, dry bulb for air cooled)"
      annotation(Dialog(tab="General",group="Nominal condition"));

  parameter Real phiIn_nominal=0.5
    "Relative humidity of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal"));
  parameter Modelica.SIunits.Pressure p_nominal=101325 "Atmospheric pressure"
    annotation(Dialog(tab="General",group="Nominal condition"));

  parameter Modelica.SIunits.Time tWet = 1400
    "Time until moisture drips from coil when a dry coil is switched on"
     annotation(Dialog(tab="General",group="Re-evaporation data"));
  parameter Real gamma(min=0) = 1.5
    "Ratio of evaporation heat transfer divided by latent heat transfer at nominal conditions"
     annotation(Dialog(tab="General",group="Re-evaporation data"));

annotation (defaultComponentName="nomVal",
              preferredView="info",
  Documentation(info="<html>
<p>This is the base record of nominal values for air-cooled DX cooling coil models. </p>
<p>See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil</a>
for a description of the data. </p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Added parameters for evaporation model.
</li>
<li>
August 13, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end NominalValues;
