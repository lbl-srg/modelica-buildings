within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record Generic_epsNTU
  "Generic data record for a CDU that uses the epsilon-NTU method to compute the thermal performance"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration =
   Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
   "Heat exchanger configuration"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative as it is for cooling)"
    annotation (Dialog(group="Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature TPla_a_nominal=TRac_a_nominal-6
    "Nominal temperature at port a1 (from cooling plant)" annotation (Dialog(group=
          "Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature TRac_a_nominal
    "Nominal temperature at port a2 (from rack)" annotation (Dialog(group=
          "Nominal thermal performance"));

  // Design mass flow rates
  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal(min=0)
    "Nominal mass flow rate on cooling plant side" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mRac_flow_nominal(min=0)
    "Nominal mass flow rate on rack side" annotation (Dialog(group="Nominal condition"));

  // Flow resistances
  parameter Modelica.Units.SI.PressureDifference dpHexPla_nominal(
    min=0,
    displayUnit="Pa") "Heat exchanger design pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance", group="Medium 1"));
  parameter Modelica.Units.SI.PressureDifference dpHexRac_nominal(
    min=0,
    displayUnit="Pa") = dpHexPla_nominal "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(tab="Flow resistance", group="Medium 2"));

  // Volume fractions
  type Glycol = enumeration(EthyleneGlycol, PropyleneGlycol)
    "Type of glycol solution";
  parameter Glycol glyPla "Type of glycol solution for which performance data are specified"
    annotation(Dialog(group="Plant-side medium for performance data"));
  parameter Real phiGlyPla
    "Glycol volume fraction for which performance data are specified"
    annotation(Dialog(group="Plant-side medium for performance data"));
  final parameter Modelica.Units.SI.MassFraction XGlyPla =
    if glyPla == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyPla,
        T=TPla_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyPla,
        T=TPla_a_nominal)
    "Glycol mass fraction for which performance data are specified"
    annotation(Dialog(group="Plant-side medium for performance data"));

  parameter Glycol glyRac "Type of glycol solution for which performance data are specified"
    annotation(Dialog(group="Rack-side medium for performance data"));
  parameter Real phiGlyRac(
    min=0,
    final unit="1")
    "Glycol volume fraction for which performance data are specified"
    annotation(Dialog(group="Rack-side medium for performance data"));
  final parameter Modelica.Units.SI.MassFraction XGlyRac =
    if glyRac == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyRac,
        T=TRac_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyRac,
        T=TRac_a_nominal)
    "Glycol mass fraction for which performance data are specified"
    annotation(Dialog(group="Rack-side medium for performance data"));

  // Plant-side fluid propertiesf
  final parameter Modelica.Units.SI.DynamicViscosity etaPla_default =
    if glyPla == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.dynamicViscosity_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    "Dynamic viscosity for plant-side performance data";
  final parameter Modelica.Units.SI.ThermalConductivity kPla_default =
    if glyPla == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.thermalConductivity_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.thermalConductivity_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    "Thermal conductivity for plant-side performance data";
  final parameter Modelica.Units.SI.PrandtlNumber PrPla_default =
    if glyPla == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.prandtlNumber_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.prandtlNumber_TX_a(
        X_a=XGlyPla,
        T=TPla_a_nominal)
    "Prandtl number for plant-side performance data";

  // Rack-side fluid properties
  final parameter Modelica.Units.SI.DynamicViscosity etaRac_default =
    if glyRac == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.dynamicViscosity_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    "Dynamic viscosity for rack-side performance data";
  final parameter Modelica.Units.SI.ThermalConductivity kRac_default =
    if glyRac == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.thermalConductivity_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.thermalConductivity_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    "Thermal conductivity for rack-side performance data";
  final parameter Modelica.Units.SI.PrandtlNumber PrRac_default =
    if glyRac == Glycol.EthyleneGlycol then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.prandtlNumber_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.prandtlNumber_TX_a(
        X_a=XGlyRac,
        T=TRac_a_nominal)
    "Prandtl number for rack-side performance data";


  // Valve
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa") = dpHexPla_nominal
    "Nominal pressure drop of fully open valve on chiller plant side"
    annotation (Dialog(group="Valve"));

  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to fully open or close actuator"
    annotation (Dialog(tab="Dynamics", group="Valve"));

  // Pump
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    displayUnit="Pa")
    "Nominal pressure head of pump for configuration of pressure curve, after subtracting dpHexRac_nominal. I.e., this is the head for resistances external to the CDU"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Time needed to change motor speed between zero and full speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));

  parameter Real r_nominal(min=0)=
      (kPla_default * (mPla_flow_nominal/etaPla_default)^nPla * PrPla_default^(1/3)) /
      (kRac_default * (mRac_flow_nominal/etaRac_default)^nRac * PrRac_default^(1/3))
    "Ratio between convective heat transfer coefficients at nominal conditions, r_nominal = hAPla_nominal/hARac_nominal"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  parameter Real nPla(min=0, max=1)=0.8
    "Exponent for convective heat transfer coefficient, h~m_flow^n"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));
  parameter Real nRac(min=0, max=1)=nPla
   "Exponent for convective heat transfer coefficient, h~m_flow^n"
   annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

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
