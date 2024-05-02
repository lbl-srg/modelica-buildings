within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialParallelDXCoiInterface
  "Partial model for parallel DX coils"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.Units.SI.PressureDifference dpDamper_nominal=5
    "Pressure drop at mAir_flow_nominal for damper";

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal=5
    "Pressure drop at mAir_flow_nominal for duct and resistances other than the dampers in series";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=2.0
    "Nominal mass flow rate";

  Buildings.Fluid.FixedResistances.Junction splRetOut(
    redeclare package Medium = Medium,
    tau=15,
    m_flow_nominal=mAir_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    linearized=true)
    "Flow splitter"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, rotation=0, origin={-70,0})));

  Buildings.Fluid.FixedResistances.Junction splRetOut1(
    redeclare package Medium = Medium,
    tau=15,
    m_flow_nominal=mAir_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    linearized=true)
    "Flow splitter"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, rotation=0, origin={70,0})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent damPreInd1(
    redeclare package Medium = Medium,
    m_flow_nominal=mAir_flow_nominal,
    dpDamper_nominal=dpDamper_nominal,
    dpFixed_nominal=dpFixed_nominal)
    "Damper for controlling airflow bypassing DX coils"
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final max=1,
    final unit="1")
    "Damper position"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

equation
  connect(splRetOut1.port_2, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));

  connect(splRetOut.port_1, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));

  connect(splRetOut1.port_3, damPreInd1.port_b)
    annotation (Line(points={{70,10},{70,42},{10,42}}, color={0,127,255}));

  connect(splRetOut.port_3, damPreInd1.port_a)
    annotation (Line(points={{-70,10},{-70,42},{-10,42}}, color={0,127,255}));

  connect(damPreInd1.y, uDam) annotation (Line(points={{0,54},{0,66},{-80,66},{-80,
          40},{-110,40}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Text(
          extent={{-134,68},{-80,50}},
          textColor={0,0,127},
          textString="uDam")}),
  defaultComponentName="ParDXCoiInt", Documentation(revisions="<html>
  <ul>
  <li>
  February 15, 2024, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>", info="<html>
  This model implements the interface for the parallel DX coils.
  </html>"));
end PartialParallelDXCoiInterface;
