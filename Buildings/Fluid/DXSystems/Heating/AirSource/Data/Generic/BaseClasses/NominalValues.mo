within Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.BaseClasses;
record NominalValues "Data record of nominal values"
  extends Modelica.Icons.Record;

//-----------------------------Nominal conditions-----------------------------//
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(final min=0)
    "Nominal capacity"
    annotation (Dialog(group="Nominal condition"));

  parameter Real COP_nominal(final unit="1") "Nominal coefficient of performance"
    annotation (Dialog(group="Nominal condition"));

  parameter Real SHR_nominal(final unit="1") "Nominal sensible heat ratio"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate at evaporators"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TEvaIn_nominal=292.55
    "Evaporator entering air wet-bulb temperature at rating condition"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TConIn_nominal=308.15
    "Condenser entering temperature at rating condition"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Real phiIn_nominal(final unit="1")=0.5
    "Relative humidity of entering air at nominal condition"
    annotation(Dialog(tab="General",group="Nominal"));

  parameter Modelica.Units.SI.Pressure p_nominal=101325
    "Atmospheric pressure"
    annotation (Dialog(tab="General", group="Nominal condition"));

  final parameter Modelica.Units.SI.Time tWet=0
    "Time until moisture drips from coil when a dry coil is switched on"
    annotation(HideResult=true);

  final parameter Real gamma(min=0) = 0
    "Ratio of evaporation heat transfer divided by latent heat transfer at nominal conditions"
   annotation(HideResult=true);

annotation (defaultComponentName="nomVal",
              preferredView="info",
  Documentation(info="<html>
<p>
This is the base record of nominal values for air source DX heating coil models.
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil\">
Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 16, 2023 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end NominalValues;
