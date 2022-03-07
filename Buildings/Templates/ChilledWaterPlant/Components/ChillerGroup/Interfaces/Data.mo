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

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)=0
    "Condenser water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Chilled water side nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data chi[nChi](
    each m1_flow_nominal = m1_flow_nominal / nChi,
    each m2_flow_nominal = m2_flow_nominal / nChi)
    "Chiller data"
    annotation(Dialog(group = "Chiller"));

end Data;
