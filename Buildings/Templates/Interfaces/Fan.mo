within Buildings.Templates.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Fan typ "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Templates.Types.Location loc
    "Equipment location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter AHUs.Types.ReturnFanControlSensor typCtr=
    AHUs.Types.ReturnFanControlSensor.None
    "Sensor type used for return fan control"
    annotation (
      Evaluate=true,
      Dialog(
        group="Configuration",
        enable=loc==Templates.Types.Location.Return and typ<>Types.Fan.None));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if typ <> Types.Fan.None then (
      if loc == Templates.Types.Location.Supply then
        dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
      elseif loc == Templates.Types.Location.Return then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      elseif loc == Templates.Types.Location.Relief then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      else 0)
      else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition",
        enable=typ <> Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dp_nominal=
    if typ <> Types.Fan.None then (
      if loc == Templates.Types.Location.Supply then
        dat.getReal(varName=id + ".Mechanical.Supply fan.Total pressure rise.value")
      elseif loc == Templates.Types.Location.Return then
        dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
      elseif loc == Templates.Types.Location.Relief then
        dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
      else 0)
      else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Nominal condition", enable=typ <> Types.Fan.None));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Bus                                 busCon if typ <> Types.Fan.None
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fan;
