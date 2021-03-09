within Buildings.Templates.AHUs.Fans.Data;
record SingleVariable
  extends Buildings.Templates.AHUs.Interfaces.Data.Fan;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    dat.getReal(varName=id + "." + braStr + " air mass flow rate")
    "Mass flow rate"
    annotation (
      Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal=
    dat.getReal(varName=id + "." + braStr + " fan.Total pressure rise")
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
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
end SingleVariable;
