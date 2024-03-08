within Buildings.Templates.Components.Data;
record Coil "Record for coil model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Dialog(group="Configuration", enable=false), Evaluate=true);
  parameter Buildings.Templates.Components.Types.Valve typVal
    "Type of valve"
    annotation (Dialog(group="Configuration", enable=false), Evaluate=true);
  parameter Boolean have_sou
    "Set to true for fluid ports on the source side"
    annotation (Dialog(group="Configuration"), Evaluate=true);

  /*
For evaporator coils this is also provided by the performance data record.
The coil model shall generate a warning in case the design value exceeds
the maximum value from the performance data record.
*/
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
      datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    else 1)
    "Air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Coil.None and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    final min=0,
    displayUnit="Pa",
    start=if typ==Buildings.Templates.Components.Types.Coil.None then 0 else
    100)
    "Air pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None));
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
      Q_flow_nominal / 4186 / 10 elseif
      typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
      -Q_flow_nominal / 4186 / 5 else
      0)
    "Liquid mass flow rate"
    annotation (
      Dialog(group="Nominal condition", enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpWat_nominal(
    final min=0,
    displayUnit="Pa",
    start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
    0.5e4 elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
    3e4 else
    0)
    "Liquid pressure drop across coil"
    annotation(Dialog(group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    displayUnit="Pa",
    start=if typVal==Buildings.Templates.Components.Types.Valve.None then 0
    else dpWat_nominal / 2)
    "Liquid pressure drop across fully open valve"
    annotation(Dialog(group="Nominal condition",
      enable=have_sou and typVal<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    start=if typ==Buildings.Templates.Components.Types.Coil.None then 0
    elseif typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
      datCoi.sta[datCoi.nSta].nomVal.Q_flow_nominal
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then -1E4
    else 1E4)
    "Coil capacity"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Coil.None and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
  /*
For evaporator coils this is also provided by the performance data record.
The coil model shall generate a warning in case the design value exceeds
the maximum value from the performance data record.
*/
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
       typ==Buildings.Templates.Components.Types.Coil.ElectricHeating then abs(cap_nominal)
    else -1 * abs(cap_nominal)
    "Nominal heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TWatEnt_nominal(
    final min=273.15,
    displayUnit="degC",
    start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then 50+273.15
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 7+273.15
    else 273.15)
    "Nominal entering liquid temperature"
    annotation (Dialog(
      group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal(
    final min=243.15,
    displayUnit="degC",
    start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 30+273.15
    else 273.15)
    "Nominal entering air temperature"
    annotation (Dialog(
      group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.MassFraction wAirEnt_nominal(
    final min=0,
    start=0.01)
    "Nominal entering air humidity ratio"
    annotation (Dialog(
      group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling));
  replaceable parameter
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Carrier_Centurion_50PG06 datCoi
    constrainedby
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    "Performance data record of evaporator coil"
    annotation(choicesAllMatching=true, Dialog(
      enable=typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
      typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing parameters for
the classes within
<a href=\"modelica://Buildings.Templates.Components.Coils\">
Buildings.Templates.Components.Coils</a>.
</p>
</html>"));
end Coil;
