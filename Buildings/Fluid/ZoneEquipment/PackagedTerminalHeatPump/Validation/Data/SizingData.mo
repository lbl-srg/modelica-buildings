within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data;
record SizingData "Sizing calculations and values for component parameters"

  extends Modelica.Icons.Record;

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

// protected

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
      <p>
      Sizing data record based on EnergyPlus example file available in the Buildings library
      (modelica-buildings/Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.idf).
      The calculations for the UA values are derived from the EnergyPlus 
      Engineering Reference document.
      <br>
      The record is currently being used as an example for the UA calculations 
      required to translate the EnergyPlus cooling coil parameters to the Modelica 
      parameters. The exposed parameters for the cooling coil are the inputs used 
      for the EnergyPlus component and <code>UACooCoiTot_nominal</code> is the parameter
      being used on the Modelica component.
      <br>
      A correction factor <code>UACorrectionFactor</code> is currently being used
      to make the cooling coil outlet temperature and energy consumption match 
      with the reference value form Modelica.
      </p>
      </html>",   revisions="<html>
      <ul>
      <li>
      September 06, 2022, by Karthik Devaprasad:
      <br/>
      Initial version
      </li>
      </ul>
      </html>"));

end SizingData;
