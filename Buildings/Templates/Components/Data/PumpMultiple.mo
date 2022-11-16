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
  annotation (
  defaultComponentName="datPum", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the multiple pump model
<a href=\"modelica://Buildings.Templates.Components.Pumps.Multiple\">
Buildings.Templates.Components.Pumps.Multiple</a>.
</p>
<p>
A default pump characteristic is provided, which goes through
the design operating point and spans over
<i>0</i> and twice the design flow rate at maximum speed.
This default characteristic is based on a least squares
polynomial fit of the characteristics from
<a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo\">
Buildings.Fluid.Movers.Data.Pumps.Wilo</a>.
Note that a default medium density is used to parameterize 
the pump characteristic. So models that use this record should
overwrite this default value with the density of the medium
in use, especially in the case of a water/glycol mix. 
</p>
</html>"));
end PumpMultiple;
