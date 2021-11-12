within Buildings.Templates.Components.Fans.Interfaces;
partial model PartialFan
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Buildings.Templates.Components.Types.Fan typ "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Location loc
    "Equipment location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter AirHandlersFans.Types.ReturnFanControlSensor typCtr=
    Buildings.Templates.AirHandlersFans.Types.ReturnFanControlSensor.None
    "Sensor type used for return fan control" annotation (Evaluate=true,
      Dialog(group="Configuration",
        enable=loc == Buildings.Templates.Components.Types.Location.Return
           and typ <> Buildings.Templates.Components.Types.Fan.None));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if typ <>Buildings.Templates.Components.Types.Fan.None
                             then (
      if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                then
        dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
      else 0)
      else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition",
        enable=typ <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dp_nominal=
    if typ <>Buildings.Templates.Components.Types.Fan.None
                             then (
      if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                then
        dat.getReal(varName=id + ".Mechanical.Supply fan.Total pressure rise.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
      elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                    then
        dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
      else 0)
      else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Nominal condition", enable=typ <> Buildings.Templates.Components.Types.Fan.None));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Fan.None "Control bus"
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
end PartialFan;
