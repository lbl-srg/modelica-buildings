within Buildings.Templates.Components.Pumps.Interfaces;
record Data "Data for pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.Components.Types.Pump typPum
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum
    "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean is_none=
    typPum == Buildings.Templates.Components.Types.Pump.None;

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate mTot_flow_nominal
    "Pump group nominal mass flow rate"
    annotation (Dialog(group="Pump"));
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    mTot_flow_nominal/nPum
    "Individual pump nominal mass flow rate"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Total pressure rise"
    annotation (Dialog(group="Pump",
      enable=typPum <> Buildings.Templates.Components.Types.Pump.None));
  replaceable parameter Fluid.Movers.Data.Generic per(
    pressure(
      V_flow = m_flow_nominal/1000 .* {0,1,2},
      dp = dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation(Dialog(group="Pump", enable=not is_none));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal
    "Check valve pressure drop"
    annotation (Dialog(group="Valve", enable=not is_none));



end Data;
