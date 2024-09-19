within Buildings.Fluid.Storage.HeatPumpWaterHeater.Data;
record WaterHeaterData "Heat pump water heater data"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Length hTan = 1.6 "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Volume VTan = 0.287691 "Tank volume";
  parameter Modelica.Units.SI.Length dIns = 0.05 "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns = 0.04
  "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.Length hTemSen = 1.0625
  "Height of temperature sensor in the tank from the bottom";
  parameter Integer nSeg = 5 "Number of volume segments" annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Length hSegBot = 0.08
  "Height of condenser/heat exchanger bottom from bottom";
  parameter Modelica.Units.SI.Length hSegTop = 0.86
  "Height of condenser/heat exchanger top from bottom";
  final parameter Modelica.Units.SI.Length hSeg = hTan / nSeg "Height of each node";
  final parameter Integer segBot = integer(nSeg - floor(hSegBot / hSeg))
  "Node number where the condenser/heat exchanger bottom is located";
  final parameter Integer segTop = integer(nSeg - floor(hSegTop / hSeg))
  "Node number where the condenser/heat exchanger top is located";
  final parameter Integer nSegCon = segBot - segTop + 1 "Number of each condenser/heat exchanger node";
  final parameter Integer segTemSen = integer(nSeg - floor(hTemSen / hSeg))
  "Node number where the temperature sensor is located";
  final parameter Real conHeaFraTop = (hSegTop - (nSeg - segTop)*hSeg)/hSeg
  "Heating fraction of condenser/heat exchanger top node";
  final parameter Real conHeaFraBot = ((nSeg + 1 - segBot)*hSeg - hSegBot)/hSeg
  "Heating fraction of condenser/heat exchanger bottom node";
  final parameter Real conHeaFra[nSegCon] = cat(1, {conHeaFraTop}, fill(1.0, nSegCon-2), {conHeaFraBot})
  "Heating fraction for each condenser/heat exchanger node";
  final parameter Real conHeaFraSca[nSegCon] = conHeaFra/sum(conHeaFra)
  "Scaled heating fraction for each condenser/heat exchanger node, sum up to 1";

annotation (preferredView="info",
defaultComponentName="datHPWH",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>This record declares the geometry and performance data for the heat pump water heater. For the wrapped configuration, the record calculates the scaled heating fraction for each condenser/heat exchanger node based on the geometry data.</p>
</html>",
revisions="<html>
<ul>

</ul>
</html>"));

end WaterHeaterData;
