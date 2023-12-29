within Buildings.Fluid.Storage.HeatPumpWaterHeater.Examples.Data;
record HeatPumpWaterHeaterData
  "Performance record for a heat pump water heater"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Length hTan = 1.6 "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Volume VTan "Tank volume";
  parameter Modelica.Units.SI.Length dIns "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns "Specific heat conductivity of insulation";
  parameter Integer nSeg = 12 "Number of volume segments" annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Length hSegBot = 0.08
  "Height of condenser bottom from bottom";
  parameter Modelica.Units.SI.Length hSegTop = 0.86
  "Height of condenser top from bottom";

  final parameter Modelica.Units.SI.Length hSeg = hTan / nSeg "Height of each node";

  final parameter Integer segBot = integer(nSeg - floor(hSegBot / hSeg)) "Node number where the condenser bottom is located";
  final parameter Integer segTop = integer(nSeg - floor(hSegTop / hSeg)) "Node number where the condenser top is located";
  final parameter Integer nSegCon = segBot - segTop + 1 "Number of each condenser node";



annotation (preferredView="info",
defaultComponentName="datHPWH",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>This record declares the performance data for the heat pump water heater model. The performance data are structured as follows: </p>
</html>",
revisions="<html>
<ul>

</ul>
</html>"));
end HeatPumpWaterHeaterData;
