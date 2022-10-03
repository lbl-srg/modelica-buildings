within Buildings.Templates.Components.Data;
record PumpMultiple "Record for multiple pumps models"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(
    final min=0,
    start=1)
    "Number of pumps"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Default medium density"
    annotation(Dialog(enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPum](
    each final min=0)
    "Individual pump nominal mass flow rate"
    annotation (
    Dialog(group="Pump"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each final min=0)
    "Total pressure rise"
    annotation (Dialog(group="Pump",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  replaceable parameter Fluid.Movers.Data.Generic per[nPum]
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      pressure(
        V_flow={{0, 1, 2} * m_flow_nominal[i] / rho_default for i in 1:nPum},
        dp={{1.14, 1, 0.42} * dp_nominal[i] for i in 1:nPum}))
    "Performance data"
    annotation(Dialog(group="Pump",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

end PumpMultiple;
