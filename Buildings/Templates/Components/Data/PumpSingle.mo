within Buildings.Templates.Components.Data;
record PumpSingle "Record for single pump model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    start=1,
    final min=0)
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    start=0,
    final min=0)
    "Total pressure rise"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=if typ<>Buildings.Templates.Components.Types.Pump.None then
      {0, 1, 2} * m_flow_nominal / rho_default else {0,0,0},
      dp=if typ<>Buildings.Templates.Components.Types.Pump.None then
      {1.14, 1, 0.42} * dp_nominal else {0,0,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation(Dialog(enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Default medium density"
    annotation(Dialog(enable=false));

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName="datPum", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the single pump model
<a href=\"modelica://Buildings.Templates.Components.Pumps.Single\">
Buildings.Templates.Components.Pumps.Single</a>.
</p>
<p>
A default flow characteristic is provided and can be overwritten as
described in the documentation of 
<a href=\"modelica://Buildings.Templates.Components.Data.PumpMultiple\">
Buildings.Templates.Components.Data.PumpMultiple</a>
in the more generic case of multiple units.
</p>
</html>"));
end PumpSingle;
