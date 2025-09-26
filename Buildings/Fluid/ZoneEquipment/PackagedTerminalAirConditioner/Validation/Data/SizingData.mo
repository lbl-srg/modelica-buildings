within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Validation.Data;
record SizingData "Sizing calculations and values for component parameters"

  extends Modelica.Icons.Record;
  // fixme: I don't think this data record is used in any model.

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal = 1.225 * 0.56578
    "Nominal supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal = 1.225 * 0.02832
    "Nominal outdoor air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Pressure pAir = 101325
    "Assumed pressure of air"
    annotation (Dialog(group="Assumed values"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirIn_nominal = 273.15 + 24.46
    "Nominal cooling coil inlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirIn_nominal(
    final unit="1",
    displayUnit="1") = 0.009379
    "Inlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermodynamicTemperature TCooCoiAirOut_nominal = 273.15 + 14
    "Nominal cooling coil outlet air temperature"
    annotation (Dialog(group="Cooling coil parameters"));

  parameter Real humRatAirOut_nominal(
    final unit="1",
    displayUnit="1") = 0.009
    "Outlet air humidity ratio"
    annotation (Dialog(group="Cooling coil parameters"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
      <p>
      Sizing data record based on EnergyPlus example file available in the Buildings library
      (modelica-buildings/Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/1ZonePTAC.idf).
      </p>
      </html>",   revisions="<html>
      <ul>
      <li>
      April 10, 2023, by Xing Lu:
      <br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end SizingData;
