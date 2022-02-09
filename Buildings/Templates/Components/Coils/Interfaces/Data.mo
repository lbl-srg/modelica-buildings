within Buildings.Templates.Components.Coils.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typVal
    "Type of valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatExchanger typHex
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=0)
    "Air mass flow rate"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None));
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
    final min=0,
    start=0,
    displayUnit="Pa")
    "Air pressure drop"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None));
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(
    final min=0,
    start=0)
    "Liquid mass flow rate"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpWat_nominal(
    final min=0,
    start=0,
    displayUnit="Pa")
    "Liquid pressure drop"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=have_sou));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    start=0,
    displayUnit="Pa")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=have_sou and typVal<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    "Nominal heat flow rate"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typ<>Buildings.Templates.Components.Types.Coil.None));
end Data;
