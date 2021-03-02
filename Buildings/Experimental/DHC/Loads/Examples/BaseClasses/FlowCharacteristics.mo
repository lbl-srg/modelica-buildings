within Buildings.Experimental.DHC.Loads.Examples.BaseClasses;
block FlowCharacteristics
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Design heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Real fra_m_flow_min = 0.1
    "Minimum flow rate (ratio to nominal)";
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(
    final unit="kg/s")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow(
    final unit="W")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140, -20},{-100,20}})));
equation
  m_flow = max(Q_flow / Q_flow_nominal, fra_m_flow_min*m_flow_nominal);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FlowCharacteristics;
