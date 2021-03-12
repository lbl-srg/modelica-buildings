within Buildings.Templates.AHUs.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if typ<>Types.Fan.None then
      dat.getReal(varName=id + "." + braStr + " air mass flow rate")
    else 0
    "Mass flow rate"
    annotation (
      Dialog(group="Nominal condition", enable=typ<>Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dp_nominal=
    if typ<>Types.Fan.None then
      dat.getReal(varName=id + "." + braStr + " fan.Total pressure rise")
    else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Nominal condition", enable=typ<>Types.Fan.None));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ<>Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  final parameter String braStr=
    if Modelica.Utilities.Strings.find(insNam, "fanSup")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "fanRe")<>0 then "Return/relief"
    else "Undefined"
    "String used to identify the fan location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter String insNam = getInstanceName()
    "Instance name"
    annotation (Evaluate=true);
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Templates.BaseClasses.AhuBus ahuBus if typ<>Types.Fan.None
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),    iconTransformation(extent={{-10,-10},{10,10}},
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
