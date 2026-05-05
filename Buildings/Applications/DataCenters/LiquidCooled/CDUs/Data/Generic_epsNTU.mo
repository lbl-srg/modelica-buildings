within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data;
record Generic_epsNTU
  "Generic data record for a CDU that uses the epsilon-NTU method to compute the thermal performance"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative as it is for cooling)"
    annotation (Dialog(group="Nominal thermal performance"));
  parameter Modelica.Units.SI.TemperatureDifference TApp_nominal(min=0)
    "Approach temperature on IT loop size (to cooling minus from rack)"
    annotation (Dialog(group="Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature TRacOut_nominal
    "Outlet temperature to IT rack loop"
    annotation (Dialog(group="Nominal thermal performance"));
  final parameter Modelica.Units.SI.Temperature TPlaIn_nominal=
    TRacOut_nominal - TApp_nominal
    "Inlet temperature from cooling plant loop";
  final parameter Modelica.Units.SI.Temperature TPlaOut_nominal=
    TPlaIn_nominal - Q_flow_nominal/CPla_flow_nominal
    "Outlet temperature to cooling plant loop";
  final parameter Modelica.Units.SI.Temperature TRacIn_nominal=
    TRacOut_nominal - Q_flow_nominal/CRac_flow_nominal "Inlet temperature from IT rack loop";

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
  parameter Real deltaMPla=0.1
    "Fraction of nominal flow rate where flow transitions to laminar on cooling plant side"
    annotation(Dialog(tab="Flow resistance", group="Medium 1"));
  parameter Modelica.Units.SI.PressureDifference dpHexRac_nominal(
    min=0,
    displayUnit="Pa") = dpHexPla_nominal "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaMRac=0.1
    "Fraction of nominal flow rate where flow transitions to laminar on rack side"
    annotation(Dialog(tab="Flow resistance", group="Medium 2"));

  // Volume fractions
  parameter Types.Media medPla=Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water
    "Media for which performance data are specified"
    annotation (Dialog(group="Plant-side medium for performance data"));
  parameter Real phiGlyPla = 0
    "Glycol volume fraction for which performance data are specified"
    annotation(Dialog(group="Plant-side medium for performance data"));
  final parameter Modelica.Units.SI.MassFraction XGlyPla =
    if medPla ==Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water
    then
      0
    elseif medPla ==Buildings.Applications.DataCenters.LiquidCooled.Types.Media.EthyleneGlycol
    then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyPla,
        T=TRacOut_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyPla,
        T=TRacOut_nominal)
    "Glycol mass fraction for which performance data are specified"
    annotation(Dialog(group="Plant-side medium for performance data"));

  parameter Types.Media medRac
    "Type of glycol solution for which performance data are specified"
    annotation (Dialog(group="Rack-side medium for performance data"));
  parameter Real phiGlyRac(
    min=0,
    final unit="1")
    "Glycol volume fraction for which performance data are specified"
    annotation(Dialog(group="Rack-side medium for performance data"));
  final parameter Modelica.Units.SI.MassFraction XGlyRac =
    if medRac ==Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water
    then
      0
    elseif medRac ==Buildings.Applications.DataCenters.LiquidCooled.Types.Media.EthyleneGlycol
    then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyRac,
        T=TRacOut_nominal)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=phiGlyRac,
        T=TRacOut_nominal)
    "Glycol mass fraction for which performance data are specified"
    annotation(Dialog(group="Rack-side medium for performance data"));

  // Plant-side fluid properties
  final parameter Modelica.Units.SI.DynamicViscosity etaPla_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.dynamicViscosity_TX_a(
      medium=medPla, X_a=XGlyPla, T=TRacOut_nominal)
    "Dynamic viscosity for plant-side performance data";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpPla_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.specificHeatCapacityCp_TX_a(
      medium=medPla, X_a=XGlyPla, T=TRacOut_nominal)
    "Specific heat capacity at constant pressure for plant-side performance data";
  final parameter Modelica.Units.SI.ThermalConductivity kPla_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.thermalConductivity_TX_a(
      medium=medPla, X_a=XGlyPla, T=TRacOut_nominal)
    "Thermal conductivity for plant-side performance data";
  final parameter Modelica.Units.SI.PrandtlNumber PrPla_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.prandtlNumber_TX_a(
      medium=medPla, X_a=XGlyPla, T=TRacOut_nominal)
    "Prandtl number for plant-side performance data";

  // Rack-side fluid properties
  final parameter Modelica.Units.SI.DynamicViscosity etaRac_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.dynamicViscosity_TX_a(
      medium=medRac, X_a=XGlyRac, T=TRacOut_nominal)
    "Dynamic viscosity for rack-side performance data";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpRac_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.specificHeatCapacityCp_TX_a(
      medium=medRac, X_a=XGlyRac, T=TRacOut_nominal)
    "Specific heat capacity at constant pressure for rack-side performance data";
  final parameter Modelica.Units.SI.ThermalConductivity kRac_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.thermalConductivity_TX_a(
      medium=medRac, X_a=XGlyRac, T=TRacOut_nominal)
    "Thermal conductivity for rack-side performance data";
  final parameter Modelica.Units.SI.PrandtlNumber PrRac_default =
    Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses.prandtlNumber_TX_a(
      medium=medRac, X_a=XGlyRac, T=TRacOut_nominal)
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

  final parameter Modelica.Units.SI.ThermalConductance CPla_flow_nominal=
    mPla_flow_nominal * cpPla_default
    "Capacity flow rate at nominal conditions on cooling plant side";
  final parameter Modelica.Units.SI.ThermalConductance CRac_flow_nominal=
    mRac_flow_nominal * cpRac_default
    "Capacity flow rate at nominal conditions on rack side";

  final parameter Modelica.Units.SI.TemperatureDifference dTPla_nominal(min=0)=
    -Q_flow_nominal / CPla_flow_nominal
    "Fluid temperature difference at nominal conditions on cooling plant side";
  final parameter Modelica.Units.SI.TemperatureDifference dTRac_nominal(max=0)=
    Q_flow_nominal / CRac_flow_nominal
    "Fluid temperature difference at nominal conditions on rack side";

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for a CDU that models the heat transfer using the epsilon-NTU method.
</p>
<p>
This is the base record that is used to characterize the performance data of CDU.
The data record is structured as follows.
</p>
    <h4>Required Parameters</h4>
    <p>These parameters have no default values and must be provided by the user.</p>
    <table>
        <thead>
            <tr>
                <th>Parameter</th>
                <th>Description</th>
                <th>Type / Unit</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>Q_flow_nominal</code></td>
                <td>Nominal heat flow rate (negative as it is for cooling).</td>
                <td><code>[W]</code></td>
            </tr>
            <tr>
                <td><code>TApp_nominal</code></td>
                <td>Approach temperature on IT loop size (to cooling minus from rack).</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>TRacOut_nominal</code></td>
                <td>Outlet temperature to IT rack loop.</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>mPla_flow_nominal</code></td>
                <td>Nominal mass flow rate on cooling plant side.</td>
                <td><code>[kg/s]</code></td>
            </tr>
            <tr>
                <td><code>mRac_flow_nominal</code></td>
                <td>Nominal mass flow rate on rack side.</td>
                <td><code>[kg/s]</code></td>
            </tr>
            <tr>
                <td><code>dpHexPla_nominal</code></td>
                <td>Heat exchanger design pressure drop (plant side).</td>
                <td><code>[Pa]</code></td>
            </tr>
            <tr>
                <td><code>medRac</code></td>
                <td>Type of glycol solution for which rack-side performance data are specified.</td>
                <td><code>Types.Media</code></td>
            </tr>
            <tr>
                <td><code>phiGlyRac</code></td>
                <td>Glycol volume fraction for which rack-side performance data are specified.</td>
                <td><code>[1]</code></td>
            </tr>
            <tr>
                <td><code>dpPum_nominal</code></td>
                <td>Nominal pressure head of pump for configuration of pressure curve, after subtracting <code>dpHexRac_nominal</code>
                   (head for resistances external to the CDU).</td>
                <td><code>[Pa]</code></td>
            </tr>
        </tbody>
    </table>

    <h4>Defaulted Parameters (Overridable)</h4>
    <p>These parameters are pre-configured with default values or initial equations, but may be overridden by the user.
    </p>
    <table>
        <thead>
            <tr>
                <th>Parameter</th>
                <th>Description</th>
                <th>Type / Unit</th>
                <th>Default Value / Equation</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>deltaMPla</code></td>
                <td>Fraction of nominal flow rate where flow transitions to laminar on cooling plant side.</td>
                <td><code>[1]</code></td>
                <td><code>0.1</code></td>
            </tr>
            <tr>
                <td><code>dpHexRac_nominal</code></td>
                <td>Heat exchanger design pressure drop (rack side).</td>
                <td><code>[Pa]</code></td>
                <td><code>dpHexPla_nominal</code></td>
            </tr>
            <tr>
                <td><code>deltaMRac</code></td>
                <td>Fraction of nominal flow rate where flow transitions to laminar on rack side.</td>
                <td><code>[1]</code></td>
                <td><code>0.1</code></td>
            </tr>
            <tr>
                <td><code>medPla</code></td>
                <td>Media for which performance data are specified (plant side).</td>
                <td><code>Types.Media</code></td>
            </tr>
            <tr>
                <td><code>phiGlyPla</code></td>
                <td>Glycol volume fraction for which performance data are specified (plant side).</td>
                <td><code>[1]</code></td>
                <td><code>0</code></td>
            </tr>
            <tr>
                <td><code>dpValve_nominal</code></td>
                <td>Nominal pressure drop of fully open valve on chiller plant side.</td>
                <td><code>[Pa]</code></td>
                <td><code>dpHexPla_nominal</code></td>
            </tr>
            <tr>
                <td><code>strokeTime</code></td>
                <td>Time needed to fully open or close actuator.</td>
                <td><code>[s]</code></td>
                <td><code>120</code></td>
            </tr>
            <tr>
                <td><code>riseTime</code></td>
                <td>Time needed to change motor speed between zero and full speed.</td>
                <td><code>[s]</code></td>
                <td><code>30</code></td>
            </tr>
            <tr>
                <td><code>r_nominal</code></td>
                <td>Ratio between convective heat transfer coefficients at nominal conditions (hAPla_nominal/hARac_nominal).</td>
                <td><code>[1]</code></td>
                <td><code>(kPla_default * (mPla_flow_nominal/etaPla_default)^nPla * PrPla_default^(1/3)) / (kRac_default * (mRac_flow_nominal/etaRac_default)^nRac * PrRac_default^(1/3))</code></td>
            </tr>
            <tr>
                <td><code>nPla</code></td>
                <td>Exponent for convective heat transfer coefficient (<i>h~m_flow<sup>n</sup></i>) on plant side.</td>
                <td><code>[1]</code></td>
                <td><code>0.8</code></td>
            </tr>
            <tr>
                <td><code>nRac</code></td>
                <td>Exponent for convective heat transfer coefficient (<i>h~m_flow<sup>n</sup></i>) on rack side.</td>
                <td><code>[1]</code></td>
                <td><code>nPla</code></td>
            </tr>
        </tbody>
    </table>

    <h4>Derived Parameters</h4>
    <p>These parameters are calculated by the model based on the above parameters and cannot be changed by the user.
    </p>
    <table>
        <thead>
            <tr>
                <th>Parameter</th>
                <th>Description</th>
                <th>Type / Unit</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>TPlaIn_nominal</code></td>
                <td>Inlet temperature from cooling plant loop.</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>TPlaOut_nominal</code></td>
                <td>Outlet temperature to cooling plant loop.</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>TRacIn_nominal</code></td>
                <td>Inlet temperature from IT rack loop.</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>XGlyPla</code></td>
                <td>Glycol mass fraction for performance data (plant side).</td>
                <td><code>[1]</code></td>
            </tr>
            <tr>
                <td><code>XGlyRac</code></td>
                <td>Glycol mass fraction for performance data (rack side).</td>
                <td><code>[1]</code></td>
            </tr>
            <tr>
                <td><code>etaPla_default</code></td>
                <td>Dynamic viscosity for plant-side performance data.</td>
                <td><code>[Pa.s]</code></td>
            </tr>
            <tr>
                <td><code>cpPla_default</code></td>
                <td>Specific heat capacity at constant pressure for plant-side performance data.</td>
                <td><code>[J/(kg.K)]</code></td>
            </tr>
            <tr>
                <td><code>kPla_default</code></td>
                <td>Thermal conductivity for plant-side performance data.</td>
                <td><code>[W/(m.K)]</code></td>
            </tr>
            <tr>
                <td><code>PrPla_default</code></td>
                <td>Prandtl number for plant-side performance data.</td>
                <td><code>[1]</code></td>
            </tr>
            <tr>
                <td><code>etaRac_default</code></td>
                <td>Dynamic viscosity for rack-side performance data.</td>
                <td><code>[Pa.s]</code></td>
            </tr>
            <tr>
                <td><code>cpRac_default</code></td>
                <td>Specific heat capacity at constant pressure for rack-side performance data.</td>
                <td><code>[J/(kg.K)]</code></td>
            </tr>
            <tr>
                <td><code>kRac_default</code></td>
                <td>Thermal conductivity for rack-side performance data.</td>
                <td><code>[W/(m.K)]</code></td>
            </tr>
            <tr>
                <td><code>PrRac_default</code></td>
                <td>Prandtl number for rack-side performance data.</td>
                <td><code>[1]</code></td>
            </tr>
            <tr>
                <td><code>CPla_flow_nominal</code></td>
                <td>Capacity flow rate at nominal conditions on cooling plant side.</td>
                <td><code>[W/K]</code></td>
            </tr>
            <tr>
                <td><code>CRac_flow_nominal</code></td>
                <td>Capacity flow rate at nominal conditions on rack side.</td>
                <td><code>[W/K]</code></td>
            </tr>
            <tr>
                <td><code>dTPla_nominal</code></td>
                <td>Fluid temperature difference at nominal conditions on cooling plant side.</td>
                <td><code>[K]</code></td>
            </tr>
            <tr>
                <td><code>dTRac_nominal</code></td>
                <td>Fluid temperature difference at nominal conditions on rack side.</td>
                <td><code>[K]</code></td>
            </tr>
        </tbody>
    </table>

</html>", revisions="<html>
<ul>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic_epsNTU;
