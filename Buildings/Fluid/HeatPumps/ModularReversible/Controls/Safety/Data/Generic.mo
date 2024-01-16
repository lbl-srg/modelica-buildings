within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data;
record Generic "Generic record definition for safety control blocks"
  extends Modelica.Icons.Record;
  parameter Boolean use_minOnTime
    "=false to ignore minimum on-time constraint"
  annotation (Dialog(group="On/Off Control"), choices(checkBox=true));
  parameter Modelica.Units.SI.Time minOnTime
    "Mimimum on-time" annotation (Dialog(group=
          "On/Off Control", enable=use_minOnTime));
  parameter Boolean use_minOffTime
    "=false to ignore minimum off time"
    annotation (Dialog(group="On/Off Control"),
    choices(checkBox=true));
  parameter Modelica.Units.SI.Time minOffTime
    "Minimum off time" annotation (Dialog(group=
          "On/Off Control", enable=use_minOffTime));
  parameter Boolean use_maxCycRat
    "=false to ignore maximum cycle rate constraint"
    annotation (Dialog(group="On/Off Control"),
    choices(checkBox=true));
  parameter Integer maxCycRat "Maximum cycle rate"
    annotation (Dialog(group="On/Off Control",
    enable=use_maxCycRat));
  parameter Real ySetRed(unit="1")
    "Reduced relative compressor speed to allow longer on-time"
        annotation (
          Dialog(group="On/Off Control",
          enable=use_minOnTime));
  parameter Boolean onOffMea_start=true
    "Start value for the on-off signal of the device, true for on"
    annotation (
      Dialog(group="On/Off Control"),
      choices(checkBox=true));

  parameter Boolean use_opeEnv
    "=true to use a the operational envelope"
    annotation (
      Dialog(group="Operational Envelope"),
      choices(checkBox=true));
  parameter Modelica.Units.SI.Temperature tabUppHea[:,2]
    "Upper temperature boundary for heating with second column as useful temperature side"
    annotation (
      Dialog(group="Operational Envelope",
      enable=use_opeEnv));
  parameter Modelica.Units.SI.Temperature tabLowCoo[:,2]
    "Lower temperature boundary for cooling with second column as useful temperature side"
    annotation (
      Dialog(group="Operational Envelope",
      enable=use_opeEnv));
  parameter Modelica.Units.SI.TemperatureDifference dTHysOpeEnv=5
    "Hysteresis for operational envelopes of both upper and lower boundaries"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));

  parameter Boolean use_TUseSidOut=false
    "=true to use useful side outlet temperature for envelope, false for inlet"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));
  parameter Boolean use_TAmbSidOut=true
    "=true to use ambient side outlet temperature for envelope, false for inlet"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));
  parameter Boolean use_antFre
    "=true to enable antifreeze control"
    annotation (Dialog(group="Anti Freeze Control"), choices(checkBox=true));
  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre
    "Limit temperature for antifreeze control"
    annotation (Dialog(group="Anti Freeze Control", enable=use_antFre));
  parameter Modelica.Units.SI.TemperatureDifference dTHysAntFre
    "Hysteresis interval width for antifreeze control"
    annotation (Dialog(group="Anti Freeze Control", enable=use_antFre));
  parameter Boolean use_minFlowCtr
    "=false to disable minimum mass flow rate requirements"
    annotation (choices(checkBox=true), Dialog(group="Minimal Flow Rates"));
  parameter Real r_mEvaMinPer_flow
    "Percentage of mass flow rate in evaporator required to operate the device"
    annotation (Dialog(group="Minimal Flow Rates", enable=use_minFlowCtr));
  parameter Real r_mConMinPer_flow
    "Percentage of mass flow rate in condenser required to operate the device"
    annotation (Dialog(group="Minimal Flow Rates", enable=use_minFlowCtr));
    annotation (Icon(graphics, coordinateSystem(preserveAspectRatio=false)),
     Diagram(graphics, coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Base data definitions with parameters relevant
  to safety control of refrigerant machines.
</p>
<p>
  Typically, datasheets of manufacturers provide
  specific values for these assumptions. Some values are
  harder to get, e.g. the minimum and maximum for on-time or off time.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>
"));
end Generic;
