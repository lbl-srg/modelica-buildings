within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces;
record Data "Data for cooling tower groups"
  extends Modelica.Icons.Record;

  // Structure parameters

  constant Buildings.Templates.ChilledWaterPlant.Components.Types.CoolingTowerGroup typ
    "Type of cooling tower group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCooTow(final min=1)=2
    "Number of cooling towers (count one tower for each cell)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate mTot_flow_nominal
    "Cooling tower group nominal mass flow rate"
    annotation (Dialog(group="Cooling towers"));
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    mTot_flow_nominal/nCooTow
    "Individual tower nominal mass flow rate"
    annotation (Dialog(group="Cooling towers"));
  parameter Modelica.Units.SI.PressureDifference dpValInl_nominal
    "Nominal pressure difference of the valve"
    annotation (Dialog(group="Valves"));
  parameter Modelica.Units.SI.PressureDifference dpValOut_nominal
    "Nominal pressure difference of the valve"
    annotation (Dialog(group="Valves"));

end Data;
