within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces;
record Data "Data for cooling tower groups"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.CoolingTowerGroup typ
    "Type of cooling tower group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCooTow
    "Number of cooling towers (count one tower for each cell)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Buildings.Templates.Components.CoolingTower.Interfaces.Data cooTow[nCooTow](
    each m_flow_nominal = m_flow_nominal / nCooTow)
    "Cooling tower data"
    annotation (Dialog(group="Cooling towers"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValInl_nominal[nCooTow]
    "Nominal pressure difference of the valve"
    annotation (Dialog(group="Valves"));
  parameter Modelica.Units.SI.PressureDifference dpValOut_nominal[nCooTow]
    "Nominal pressure difference of the valve"
    annotation (Dialog(group="Valves"));

end Data;
