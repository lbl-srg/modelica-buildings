within Buildings.Templates.Components.Data;
record PumpSingle "Record for single pump model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    start=1,
    final min=0)
    "Individual pump nominal mass flow rate"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    start=0,
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

  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Default medium density"
    annotation(Dialog(enable=false));

  annotation (
  defaultComponentName="datPum", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the single pump model
<a href=\"modelica://Buildings.Templates.Components.Pumps.Single\">
Buildings.Templates.Components.Pumps.Single</a>.
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
end PumpSingle;
