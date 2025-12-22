within Buildings.Applications.DataCenters.LiquidCooled.Cabinets.Data;
record Generic_R_m_flow
  "Generic data record for thermal resistance as a function of mass flow rate"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow[:](each min=0)
    "Volume flow rate at user-selected points";
  parameter Modelica.Units.SI.ThermalResistance R[size(V_flow, 1)](
    each min=0) "Case-to-inlet thermal resistance";
  parameter Integer n(min=1) = 1
    "Order of desired polynomial that fits the data points (V_flow, R*V_flow)";
  annotation (
  defaultComponentName="datRes",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for the case-to-inlet thermal resistance of a cold plate.
Note that this resistance is relative to the inlet fluid temperature,
which is the convention used in the Open Compute Project report by
Chen et al. (2023). Thus, it is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
</p>
<p>
R = (T<sub>case</sub> - T<sub>inlet</sub>) &frasl; Q&#775;
</p>
where
<i>T<sub>case</sub></i> is the case temperature,
<i>T<sub>inlet</sub></i> is the coolant inlet temperature and
<i>Q&#775;</i> is the heat emitted by the cold plate.
The case temperature is the external surface temperature
of the component's packaging, typically the top-center point where a 
thermal interface material or heat sink is attached.
</p>
<p>
It turns out that the product <i>R V&#775;</i> as a function of
the volume flow rate <i>V&#775;</i> is close to linear.
Therefore, the model that computes the case temperature
<a href=\"Buildings.Applications.DataCenters.LiquidCooled.Cabinets.BaseClasses.CaseTemperature\">
Buildings.Applications.DataCenters.LiquidCooled.Cabinets.BaseClasses.CaseTemperature</a>
makes a data fit using <i>R V&#775;</i> versus <i>V&#775;</i>.
The parameter <code>n</code> determines the order of this polynomial,
which is by default set to <code>n=1</code>.
</p>
<h4>References</h4>
<p>
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>"));
end Generic_R_m_flow;
