within Buildings.Fluid.HeatExchangers.CoolingTowers.Data;
record DryCooler "Performance data record for a dry cooler"
  extends Modelica.Icons.Record;

  import cha =
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative, as heat is removed from the fluid)"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.Temperature TCooIn_nominal
    "Nominal cooling loop inlet temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.Temperature TCooOut_nominal
    "Nominal cooling loop outlet temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.Temperature TAirIn_nominal=273.15 + 35
    "Nominal outdoor (air inlet) drybulb temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Real ratCooAir_nominal(min=0, unit="1") = 1.2
    "Water-to-air mass flow rate ratio at design condition, used to compute air flow for UA_value"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter Real PFan_QCoo_nominal(min=0, max=0.1, unit="1") = 0.05
    "Ratio of fan power to provided cooling at full load"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.Power PFan_nominal=
    PFan_QCoo_nominal*abs(Q_flow_nominal)
    "Fan power at full speed";

  replaceable parameter cha.fan fanRelPow(
    r_V={0, 0.1,   0.3,   0.6,   1},
    r_P={0, 0.1^3, 0.3^3, 0.6^3, 1})
    constrainedby cha.fan
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{58,70},{78,90}})),
    Dialog(group="Fan"));

  annotation (
    defaultComponentName="datDryCoo",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data record for a dry cooler model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCooler;