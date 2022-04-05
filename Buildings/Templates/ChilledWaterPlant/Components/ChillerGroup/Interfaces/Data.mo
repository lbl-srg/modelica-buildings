within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces;
record Data "Data for chiller groups"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup typ
    "Type of chiller group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers in group"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isAirCoo
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_series = typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerSeries
    "= true if chillers are connected in series";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data chi[nChi](
    each final isAirCoo=isAirCoo,
    each m1_flow_nominal = m1_flow_nominal / nChi,
    each m2_flow_nominal = m2_flow_nominal / nChi)
    "Chiller data"
    annotation(Dialog(group = "Chiller"));
  parameter Modelica.Units.SI.PressureDifference dpCHWValve_nominal=0
    "Nominal pressure drop of chiller valves on chilled water side"
    annotation(Dialog(group = "Nominal condition", enable=is_series));

end Data;
