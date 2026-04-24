within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses;
record BaseCoolingTower
  "Performance data record for dry and wet cooling towers"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative, as heat is removed from the fluid)"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.Temperature TCooIn_nominal
    "Nominal cooling loop inlet temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.Temperature TCooOut_nominal
    "Nominal cooling loop outlet temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    min=0,
    displayUnit= "Pa")
    "Pressure difference at design mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real ratCooAir_nominal(min=0, unit="1")
    "Coolant-to-air mass flow rate ratio at design condition, used to compute air flow rate for UA_value"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Real PFan_Q_flow_nominal(min=-0.1, max=0, unit="1") = -0.05
    "Ratio of fan power to provided cooling at full load (negative as Q_flow_nominal<0)";

  final parameter Modelica.Units.SI.Power PFan_nominal(min=0)=
    abs(PFan_Q_flow_nominal*Q_flow_nominal)
    "Fan power at full speed";

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan fanRelPow(
    r_V={0, 0.1,   0.3,   0.6,   1},
    r_P={0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)";

  parameter Real fraFreCon(
    min=0,
    max=1,
    final unit="1") = 0.125
    "Fraction of tower capacity in free convection regime";

  annotation (
    defaultComponentName="dat",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Basic performance data record for a dry and wet cooling towers
</p>
</html>", revisions="<html>
<ul>
<li>
April 22, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaseCoolingTower;
