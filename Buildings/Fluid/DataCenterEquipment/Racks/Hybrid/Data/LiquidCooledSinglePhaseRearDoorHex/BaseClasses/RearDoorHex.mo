within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHex.BaseClasses;
record RearDoorHex "Data record for rear door heat exchanger"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Design air mass flow rate for heat exchanger and fan parameterization"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal
    "Design coolant flow rate for heat exchanger parameterization"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.SpecificHeatCapacity cpCoo_flow_nominal=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity for rear door heat exchanger coolant fluid";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Cooling capacity at design condition (negative number)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Power PFan_nominal=0.04*Q_flow_nominal
    "Fan power at full speed"
    annotation (Dialog(group="Fan power"));

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan fanRelPow(
    r_V={0, 0.1,   0.3,   0.6,   1},
    r_P={0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (
    Placement(transformation(extent={{40,60},{60,80}})),
    Dialog(group="Fan"));

  parameter Modelica.Units.SI.Temperature TAirIn_nominal
    "Air inlet nominal temperature (air entering rear door heat exchanger)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TCooIn_nominal
    "Rear door coolant inlet nominal temperature"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpCoo_nominal(
    min=0,
    displayUnit="Pa") = 10000
    "Coolant-side pressure drop at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    min=0,
    displayUnit="Pa") = 200
    "Air-side pressure drop at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));

  final parameter Real eps_nominal(min=0, max=1, final unit="1")=
    -Q_flow_nominal/(
      min(mAir_flow_nominal*Buildings.Utilities.Psychrometrics.Constants.cpAir,
          mCoo_flow_nominal*cpCoo_flow_nominal)*
      (TAirIn_nominal - TCooIn_nominal))
    "Heat exchanger effectiveness";

  final parameter Modelica.Units.SI.TemperatureDifference dTAir_nominal=
    -Q_flow_nominal/(mAir_flow_nominal*Buildings.Utilities.Psychrometrics.Constants.cpAir)
    "Air temperature difference across rear door heat exchanger";

  final parameter Modelica.Units.SI.TemperatureDifference dTCoo_nominal=
    Q_flow_nominal/(mCoo_flow_nominal*cpCoo_flow_nominal)
    "Rear door coolant temperature difference";

annotation (
  defaultComponentName="reaDooHex",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for a rear door heat exchanger used in hybrid IT racks.
</p>
<p>
The rear door heat exchanger is placed at the air outlet of the rack.
It removes heat from the warm exhaust air using a liquid coolant.
The heat exchanger effectiveness <code>eps_nominal</code> is computed from
the design heat duty, the inlet temperatures, and the minimum capacity flow rate.
</p>
<p>
The parameter <code>cpCoo_flow_nominal</code> is the specific heat capacity
of the coolant at nominal conditions, which defaults to water.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RearDoorHex;
