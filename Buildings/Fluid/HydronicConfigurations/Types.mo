within Buildings.Fluid.HydronicConfigurations;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Control = enumeration(
      ChangeOver
    "Change-over",
      Cooling
    "Cooling",
      Heating
    "Heating",
      None
    "No built-in controls")
    "Enumeration to specify the type of valve controls" annotation (
      Documentation(info="<html>
<p>
Enumeration that defines the type of valve controls.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>ChangeOver</td>
    <td>Change-over</td></tr>
<tr><td>Cooling</td>
    <td>Cooling</td></tr>
<tr><td>Heating</td>
    <td>Heating</td></tr>
<tr><td>None</td>
    <td>No built-in controls</td></tr>
</table>
</html>"));
  type ControlVariable = enumeration(
      ReturnTemperature
    "Consumer circuit return temperature",
      SupplyTemperature
    "Consumer circuit supply temperature")
    "Enumeration to specify the controlled variable"
    annotation (Documentation(info=
         "<html>
<p>
Enumeration that defines the controlled variable in case of built-in valve controls.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>ReturnTemperature</td>
    <td>Consumer circuit return temperature</td></tr>
<tr><td>SupplyTemperature</td>
    <td>Consumer circuit supply temperature</td></tr>
</table>
</html>"));
  type Pump = enumeration(
      None
      "No pump",
      NoVariableInput
      "Constant input signal",
      VariableInput
      "Variable input signal")
    "Enumeration to specify the type of pump"
    annotation (Documentation(info="<html>
<p>
Enumeration that defines the type of pump.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>None</td>
    <td>No pump</td></tr>
<tr><td>NoVariableInput</td>
<td>No variable input signal (constant set point equal to design value)</td></tr>
<tr><td>VariableInput</td>
<td>Variable input signal</td></tr>
</table>
</html>"));
  type PumpModel = enumeration(
      Head
      "Pump with ideally controlled head as input",
      MassFlowRate
      "Pump with ideally controlled mass flow rate as input",
      SpeedFractional
      "Pump with ideally controlled normalized speed as input",
      SpeedRotational
      "Pump with ideally controlled rotational speed as input")
    "Enumeration to specify the type of pump model" annotation (Documentation(
        info="<html>
<p>
Enumeration that defines the type of pump model.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>Head</td>
    <td>Pump with ideally controlled head as input</td></tr>
<tr><td>MassFlowRate</td>
    <td>Pump with ideally controlled mass flow rate as input</td></tr>
<tr><td>SpeedFractional</td>
    <td>Pump with ideally controlled normalized speed as input</td></tr>
<tr><td>SpeedRotational</td>
    <td>Pump with ideally controlled rotational speed as input</td></tr>
</table>
</html>"));
  type Valve = enumeration(
      None
    "No valve",
      ThreeWay
    "Three-way valve",
      TwoWay
    "Two-way valve")
    "Enumeration to specify the type of control valve" annotation (
      Documentation(info="<html>
<p>
Enumeration that defines the type of valve.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>None</td>
    <td>No valve</td></tr>
<tr><td>ThreeWay</td>
    <td>Three-way valve</td></tr>
<tr><td>TwoWay</td>
    <td>Two-way valve</td></tr>
</table>
</html>"));
  type ValveCharacteristic = enumeration(
      EqualPercentage
      "Equal percentage - Equal percentage and linear for three-way valves",
      Linear
      "Linear",
      PressureIndependent
      "Pressure independent (mass flow rate only dependent of input signal)",
      Table
      "Table-specified")
    "Enumeration to specify the control valve characteristic" annotation (
      Documentation(info="<html>
<p>
Enumeration that defines the valve characteristic.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>EqualPercentage</td>
    <td>Equal percentage - Equal percentage and linear for three-way valves</td></tr>
<tr><td>Linear</td>
    <td>Linear</td></tr>
<tr><td>PressureIndependent</td>
    <td>Pressure independent (mass flow rate only dependent of input signal)</td></tr>
<tr><td>Table</td>
    <td>Table-specified</td></tr>
</table>
</html>"));
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
