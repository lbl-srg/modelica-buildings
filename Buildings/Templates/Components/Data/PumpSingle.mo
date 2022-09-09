within Buildings.Templates.Components.Data;
record PumpSingle "Record for single pump model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0)
    "Individual pump nominal mass flow rate"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0)
    "Total pressure rise"
    annotation (Dialog(group="Pump",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  replaceable parameter Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * m_flow_nominal / rho_default,
        dp={1.14, 1, 0.42} * dp_nominal))
    "Performance data"
    annotation(Dialog(group="Pump",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Modelica.Units.SI.Density rho_default=1000
    "Default medium density"
    annotation(Dialog(enable=false));
end PumpSingle;
