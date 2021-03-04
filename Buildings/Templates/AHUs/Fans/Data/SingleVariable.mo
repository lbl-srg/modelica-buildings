within Buildings.Templates.AHUs.Fans.Data;
record SingleVariable
  extends Modelica.Icons.Record;
  parameter Types.FanFunction fun
    "Equipment function"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter String id=""
    "System identifier";
  outer parameter ExternData.JSONFile dat
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if fun==Types.FanFunction.Supply then
    dat.getReal(varName=id + ".Supply air mass flow rate")
    else
    dat.getReal(varName=id + ".Return air mass flow rate")
    "Mass flow rate"
    annotation (
      Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal=
    if fun==Types.FanFunction.Supply then
    dat.getReal(varName=id + ".Supply fan.Total pressure rise")
    else
    dat.getReal(varName=id + ".Return fan.Total pressure rise")
    "Total pressure rise"
    annotation (
      Dialog(group="Nominal condition"));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-82,-86},{-62,-66}})));
end SingleVariable;
