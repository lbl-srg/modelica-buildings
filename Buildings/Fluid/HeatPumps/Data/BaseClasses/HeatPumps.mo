within Buildings.Fluid.HeatPumps.Data.BaseClasses;
partial record HeatPumps
  "Base record for calibrated heat pump models"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor"
    annotation (Dialog(group="Compressor"));

  parameter Modelica.Units.SI.Power PLos(min=0)
    "Constant part of the compressor power losses"
    annotation (Dialog(group="Compressor"));

  parameter Modelica.Units.SI.TemperatureDifference dTSup(min=0)
    "Superheating at compressor suction" annotation (Dialog(group="Evaporator"));

  parameter Modelica.Units.SI.ThermalConductance UACon
    "Thermal conductance of condenser between water and refrigerant"
    annotation (Dialog(group="Condenser"));

  parameter Modelica.Units.SI.ThermalConductance UAEva
    "Thermal conductance of evaporator between water and refrigerant"
    annotation (Dialog(group="Evaporator"));

  annotation (
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for heat pump models.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          textColor={0,0,255},
          textString="etaEle"),
        Text(
          extent={{-95,-9},{-48,-48}},
          textColor={0,0,255},
          textString="PLos"),
        Text(
          extent={{-95,-49},{-12,-104}},
          textColor={0,0,255},
          textString="dTSup")}));
end HeatPumps;
