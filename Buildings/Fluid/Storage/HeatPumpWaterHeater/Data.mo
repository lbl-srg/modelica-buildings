within Buildings.Fluid.Storage.HeatPumpWaterHeater;
package Data "Sizing data used for example models"
  extends Modelica.Icons.MaterialPropertiesPackage;
  record FanData "Fan data for the validation model"
    extends Buildings.Fluid.Movers.Data.Generic(
      power(V_flow={0,0.0189917,0.0379834,0.0569751,0.0759668,0.0949585,
      0.1139502,0.1329419,0.1519336,0.1709253,0.189917}, P={0.869,1.301,1.693,
      2.121,2.659,3.383,4.366,5.685,7.412,9.624,12.395}),
     pressure(V_flow={0.0189917,0.0379834,0.0569751,0.0759668,0.0949585,
      0.1139502,0.1329419,0.1519336,0.1709253,0.189917}, dp={6500,1625,722.2222222,
      406.25,260,180.5555556,132.6530612,101.5625,80.24691358,65}),
      motorCooledByFluid=true);
    annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="per",
  Documentation(info="<html>
<p>
Fan performance data record based on EnergyPlus example file available in the 
Buildings library
(modelica-buildings/Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.idf).
<br>
The volume flowrate values are derived by splitting the nominal flowrate from the 
EnergyPlus sizing report into ten datapoints. The power values are calculated for 
each flowrate datapoint with the power curve coefficients from EnergyPlus. 
</p>
</html>",     revisions="<html>
<ul>
<li>
September 06, 2022, by Karthik Devaprasad:
<br/>
Initial version
</li>
</ul>
</html>"));
  end FanData;

  record WaterTankData
    "Performance record for a water tank"
    extends Modelica.Icons.Record;
    parameter Modelica.Units.SI.Length hTan = 1.6 "Height of tank (without insulation)";
    parameter Modelica.Units.SI.Volume VTan = 0.287691 "Tank volume";
    parameter Modelica.Units.SI.Length dIns = 0.05 "Thickness of insulation";
    parameter Modelica.Units.SI.ThermalConductivity kIns = 0.04 "Specific heat conductivity of insulation";
    parameter Modelica.Units.SI.Length hTemSen = 1.0625 "Height of temperature sensor in the tank from the bottom";
    parameter Integer nSeg = 12 "Number of volume segments" annotation(Dialog(group="System parameters"));
    parameter Modelica.Units.SI.Length hSegBot = 0.08
    "Height of condenser bottom from bottom";
    parameter Modelica.Units.SI.Length hSegTop = 0.86
    "Height of condenser top from bottom";

    final parameter Modelica.Units.SI.Length hSeg = hTan / nSeg "Height of each node";
    final parameter Integer segBot = integer(nSeg - floor(hSegBot / hSeg)) "Node number where the condenser bottom is located";
    final parameter Integer segTop = integer(nSeg - floor(hSegTop / hSeg)) "Node number where the condenser top is located";
    final parameter Integer nSegCon = segBot - segTop + 1 "Number of each condenser node";
    final parameter Integer segTemSen = integer(nSeg - floor(hTemSen / hSeg)) "Node number where the temperature sensor is located";

    final parameter Real conHeaFraTop = (hSegTop - (nSeg - segTop)*hSeg)/hSeg "Heating fraction of condenser top node";
    final parameter Real conHeaFraBot = ((nSeg + 1 - segBot)*hSeg - hSegBot)/hSeg "Heating fraction of condenser bottom node";

    final parameter Real conHeaFra[nSegCon] = cat(1, {conHeaFraTop}, fill(1.0, nSegCon-2), {conHeaFraBot}) "Heating fraction for each condenser node";
    final parameter Real conHeaFraSca[nSegCon] = conHeaFra/sum(conHeaFra) "Scaled heating fraction for each condenser node, sum up to 1";

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


  end WaterTankData;
end Data;
