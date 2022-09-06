within Buildings.Templates.Components.Data;
record CoolingTower "Record for cooling tower model"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.Components.Types.CoolingTower typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Cooling tower mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Real ratWatAir_nominal(final min=0, final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(
    displayUnit="K", final min=0)
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Fan"));

  final parameter Modelica.Units.SI.Temperature TWatOut_nominal(displayUnit="degC")=
    TWatIn_nominal - dT_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.TemperatureDifference dTApp_nominal(
    displayUnit="K", final min=0)=
    TWatOut_nominal - TAirInWB_nominal
    "Nominal approach temperature"
    annotation (Dialog(group="Nominal condition"));
end CoolingTower;
