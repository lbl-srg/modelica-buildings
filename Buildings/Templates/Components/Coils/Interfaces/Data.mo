within Buildings.Templates.Components.Coils.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typVal
    "Type of valve"
    annotation (Dialog(group="Configuration"));
  parameter Boolean have_sou
    "Set to true for fluid ports on the source side"
    annotation (Dialog(group="Configuration"));

  // For evaporator coils this is provided by the performance data record.
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=0) = if typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
     typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
     datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    else 1
    "Air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Coil.None and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    final min=0,
    displayUnit="Pa")=
    if typ==Buildings.Templates.Components.Types.Coil.None then 0 else
    150
    "Air pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None));
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(
    final min=0,
    start=0)=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
     Q_flow_nominal / 4186 / 10 elseif
     typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
     -Q_flow_nominal / 4186 / 5 else
     0
    "Liquid mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpWat_nominal(
    final min=0,
    start=0,
    displayUnit="Pa")=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
    0.5e4 elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
    3e4 else
    0
    "Liquid pressure drop across coil"
    annotation(Dialog(group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    start=0,
    displayUnit="Pa")=if typVal==Buildings.Templates.Components.Types.Valve.None then 0
    else dpWat_nominal / 2
    "Liquid pressure drop across fully open valve"
    annotation(Dialog(group="Nominal condition",
      enable=have_sou and typVal<>Buildings.Templates.Components.Types.Valve.None));
  // For evaporator coils this is provided by the performance data record.
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(final min=0)=
    if typ==Buildings.Templates.Components.Types.Coil.None then 0
    elseif typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
     typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
     abs(datCoi.sta[datCoi.nSta].nomVal.Q_flow_nominal)
    else 1e4
    "Coil capacity"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Coil.None and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
      typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
       typ==Buildings.Templates.Components.Types.Coil.ElectricHeating then cap_nominal
    else -1 * cap_nominal
    "Nominal heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TWatEnt_nominal=
    if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then 50+273.15
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 7+273.15
    else 273.15
    "Nominal entering liquid temperature"
    annotation (Dialog(
      group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=
    if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then 0+273.15
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 30+273.15
    else 273.15
    "Nominal entering air temperature"
    annotation (Dialog(
      group="Nominal condition",
      enable=have_sou));
  parameter Modelica.Units.SI.MassFraction wAirEnt_nominal=0.012
    "Nominal entering air humidity ratio"
    annotation (Dialog(
      group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling));
  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.SingleSpeed.Carrier_Centurion_50PG06 datCoi
    constrainedby Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    "Performance record"
    annotation(choicesAllMatching=true, Dialog(
      enable=typ==Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage or
      typ==Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed));
end Data;
