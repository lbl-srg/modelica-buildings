within Buildings.Utilities.IO.SignalExchange;
model Read "Block that allows a signal to be read as an FMU output"
  extends Modelica.Blocks.Routing.RealPassThrough;

  parameter String description "Description of the signal being read";

  parameter SignalTypes.SignalsForKPIs KPIs = SignalTypes.SignalsForKPIs.None
    "Tag with the type of signal for the calculation of the KPIs";

  parameter String zone = "1" if (
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RadiativeZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.OperativeZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RelativeHumidity or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.CO2Concentration)
    "Zone designation, required if KPIs is AirZoneTemperature, 
    RadiativeZoneTemperature, OperativeZoneTemperature, RelativeHumidity, 
    or CO2Concentration"
  annotation(Dialog(enable=(
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RadiativeZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.OperativeZoneTemperature or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RelativeHumidity or
    KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.CO2Concentration)));

  final parameter Boolean boptestRead = true
    "Parameter that is used by tools to search for read block in models";

  annotation (Documentation(info="<html>
<p>
This block enables the reading of a signal and its meta-data by an external
program without the need to explicitly propogate the signal to a top-level model.
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and read signals as measurements by test
controllers. It is used in combination with a dedicated parser to perform
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
This block is also used by BOPTEST to specify if the signal is needed
for calculation of specific key performance indicators (KPI).
</p>
<p>
The block output <code>y</code> is equal to the input <code>u</code> so that
the block can be used in line with connections.  However, input signal will
also be directed to an external program as an output.
</p>
<p>
It is important to add a brief description of the signal using the
<code>description</code> parameter, assign a <code>unit</code> to the output 
variable <code>y</code>, assign a type if needed for KPI
calculation using the <code>KPIs</code> parameter, and assign a zone 
designation using the <code>zone</code> parameter if the KPI calculation is
specific to a particular zone (for multi-zone models). See documentation for 
the parameter <code>zone</code> for more details.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2022 by David Blum:<br/>
Made parameter <code>boptestRead</code> unprotected.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1585\">#1585</a>.
</li>
<li>
February 23, 2020 by David Blum:<br/>
Added zone designation for KPI calculation by parameter <code>zone</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1257\">#1257</a>.
</li>
<li>
January 9, 2020 by David Blum:<br/>
Updated documentation to prompt user to add unit to output.  
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1276\">#1276</a>.
</li>
<li>
July 17, 2019 by Michael Wetter:<br/>
Changed parameter name from <code>Description</code> to <code>description</code>.
</li>
<li>
April 11, 2019 by Javier Arroyo:<br/>
Enumeration type KPI tags added.
</li>
<li>
December 17, 2018 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1059\">#1059</a>.
</li>
</ul>
</html>"), Icon(graphics={
        Line(points={{22,60},{70,60}},  color={0,0,127}),
        Line(points={{-38,0},{22,60}}, color={0,0,127}),
        Line(points={{-100,0},{-38,0}}, color={0,0,127}),
        Line(points={{-38,0},{100,0}}, color={0,0,127}),
        Ellipse(
          extent={{-40,2},{-36,-2}},
          lineColor={28,108,200},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,70},{66,60},{36,50},{36,70}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={78,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={74,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={70,60},
          rotation=90),
        Text(
          extent={{-50,-24},{54,-72}},
          textColor={153,153,153},
          textString=DynamicSelect("", if (
            (KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature) or
            (KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RadiativeZoneTemperature) or
            (KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.OperativeZoneTemperature) or
            (KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RelativeHumidity) or
            (KPIs==Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.CO2Concentration)) then "zone" else ""))}));
end Read;
