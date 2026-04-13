within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record Generic_epsNTU
  "Generic data record for a CDU that uses the epsilon-NTU method to compute the thermal performance"
  extends Modelica.Icons.Record;

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 (chiller loop)"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 (rack loop)"
      annotation (choices(
        choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium2 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
            "Propylene glycol water, 40% mass fraction")));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration =
   Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
   "Heat exchanger configuration"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative as it is for cooling)"
    annotation (Dialog(group="Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal=T_a2_nominal-6
    "Nominal temperature at port a1 (from chiller)" annotation (Dialog(group=
          "Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal
    "Nominal temperature at port a2 (from rack)" annotation (Dialog(group=
          "Nominal thermal performance"));

  // Design mass flow rates
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  // Flow resistances
  parameter Modelica.Units.SI.PressureDifference dpHex1_nominal(
    min=0,
    displayUnit="Pa") "Heat exchanger design pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance", group="Medium 1"));
  parameter Modelica.Units.SI.PressureDifference dpHex2_nominal(
    min=0,
    displayUnit="Pa") = dpHex1_nominal "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance", group="Medium 2"));

  final parameter Medium1.DynamicViscosity eta1_default = Medium1.dynamicViscosity(
    Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default[1:Medium1.nXi])) "Dynamic viscosity";
  final parameter Medium1.ThermalConductivity k1_default = Medium1.thermalConductivity(
    Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default[1:Medium1.nXi])) "Thermal conductivity";
  final parameter Medium1.PrandtlNumber Pr1_default = Medium1.prandtlNumber(
    Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default[1:Medium1.nXi])) "Prandtl number";
  final parameter Medium2.DynamicViscosity eta2_default = Medium2.dynamicViscosity(
    Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default[1:Medium2.nXi])) "Dynamic viscosity";
  final parameter Medium2.ThermalConductivity k2_default = Medium2.thermalConductivity(
    Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default[1:Medium2.nXi])) "Thermal conductivity";
  final parameter Medium2.PrandtlNumber Pr2_default = Medium2.prandtlNumber(
    Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default[1:Medium2.nXi])) "Prandtl number";

  // Valve
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa") = dpHex1_nominal
    "Nominal pressure drop of fully open valve"
    annotation (Dialog(group="Valve"));

  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to fully open or close actuator"
    annotation (Dialog(tab="Dynamics", group="Valve"));

  // Pump
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    displayUnit="Pa")
    "Nominal pressure head of pump for configuration of pressure curve, after subtracting dpHex2_nominal. I.e., this is the head for resistances external to the CDU"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Time needed to change motor speed between zero and full speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));

  parameter Real r_nominal(min=0)=
      (k1_default * (m1_flow_nominal/eta1_default)^n1 * Pr1_default^(1/3)) /
      (k2_default * (m2_flow_nominal/eta2_default)^n2 * Pr2_default^(1/3))
    "Ratio between convective heat transfer coefficients at nominal conditions, r_nominal = hA1_nominal/hA2_nominal"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  parameter Real n1(min=0, max=1)=0.8
    "Exponent for convective heat transfer coefficient, h1~m1_flow^n1"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));
  parameter Real n2(min=0, max=1)=n1
   "Exponent for convective heat transfer coefficient, h2~m2_flow^n2"
   annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));
//  final parameter Medium1.ThermodynamicState sta1_default=Medium1.setState_pTX(
//      T=Medium1.T_default,
//      p=Medium1.p_default,
//      X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
//  final parameter Medium2.ThermodynamicState sta2_default=Medium2.setState_pTX(
//      T=Medium2.T_default,
//      p=Medium2.p_default,
//      X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for a CDU that models the heat transfer using the epsilon-NTU method.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic_epsNTU;
