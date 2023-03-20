within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses;
record NominalValues "Data record of nominal values"
  extends Modelica.Icons.Record;

//-----------------------------Nominal conditions-----------------------------//
  parameter Boolean activate_CooCoi = true "= false, if DX coil is in the heating operation";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal capacity (negative number for the DX cooling coil, and positive number for the DX heating coil)"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COP_nominal "Nominal coefficient of performance"
    annotation (Dialog(group="Nominal condition"));
  parameter Real SHR_nominal "Nominal sensible heat ratio"
      annotation (Dialog(group="Nominal condition", enable = activate_CooCoi));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate at evaporators"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TEvaIn_nominal=273.15 + 19.4
    "Evaporator entering air wet-bulb temperature at rating condition"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TConIn_nominal=308.15
    "Condenser entering temperature at rating condition (wet bulb for evaporative cooled coils, dry bulb for air cooled)"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Real phiIn_nominal=0.5
    "Relative humidity of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal"));
  parameter Modelica.Units.SI.Pressure p_nominal=101325 "Atmospheric pressure"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.Units.SI.Time tWet=1400
    "Time until moisture drips from coil when a dry coil is switched on"
    annotation (Dialog(tab="General", group="Re-evaporation data", enable = activate_CooCoi));
  parameter Real gamma(min=0) = 1.5
    "Ratio of evaporation heat transfer divided by latent heat transfer at nominal conditions"
     annotation(Dialog(tab="General",group="Re-evaporation data", enable = activate_CooCoi));


annotation (defaultComponentName="nomVal",
              preferredView="info",
  Documentation(info="<html>
<p>This is the base record of nominal values for air source DX cooling coil models. </p>
<p>See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil</a>
for a description of the data. </p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Added Boolean conditional for cooling mode operation. Added conditional enable to parameters for SHR_nominal, tWet and gamma.
</li>
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
