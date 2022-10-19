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
    each start=1,
    each final min=0)
    "Individual pump nominal mass flow rate"
    annotation (
    Dialog(group="Pump"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each start=0,
    each final min=0)
    "Total pressure rise"
    annotation (Dialog(group="Pump",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  // To avoid missing support for zero-sized record in case of nPum=0 we use max(nPum, 1).
  replaceable parameter Fluid.Movers.Data.Generic per[max(nPum, 1)]
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      pressure(
        V_flow=if typ<>Buildings.Templates.Components.Types.Pump.None then
        {{0, 1, 2} * m_flow_nominal[i] / rho_default for i in 1:nPum}
        else [0],
        dp=if typ<>Buildings.Templates.Components.Types.Pump.None then
        {{1.14, 1, 0.42} * dp_nominal[i] for i in 1:nPum}
        else [0]))
    "Performance data"
    annotation(Dialog(group="Pump",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

end PumpMultiple;
