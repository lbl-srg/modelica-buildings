within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Interfaces;
record Data "Data for cooling tower section"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.CoolingTowerSection
    typ "Type of cooling tower arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCooTow
    "Number of cooling towers (count one tower for each cell)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Buildings.Templates.Components.CoolingTower.Interfaces.Data cooTow[nCooTow](
    each m_flow_nominal = mTow_flow_nominal)
    "Cooling tower data"
    annotation (Dialog(group="Cooling towers"));
  parameter Buildings.Templates.Components.Data.Valve valCooTowInl[nCooTow](
    each final m_flow_nominal = mTow_flow_nominal)
    "Inlet isolation valve data"
    annotation (Dialog(group="Valves"));
  parameter Buildings.Templates.Components.Data.Valve valCooTowOut[nCooTow](
    each final m_flow_nominal = mTow_flow_nominal)
    "Inlet isolation valve data"
    annotation (Dialog(group="Valves"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Cooling tower section nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mTow_flow_nominal=
    m_flow_nominal/nCooTow "Single tower nominal mass flow rate";

end Data;
