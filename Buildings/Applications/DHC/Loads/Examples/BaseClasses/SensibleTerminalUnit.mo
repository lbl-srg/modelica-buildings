within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model SensibleTerminalUnit
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit;
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT(
    k=1,
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PID controller for minimum temperature"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Modelica.Blocks.Sources.RealExpression m_flow2(y=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,44})));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare each final package Medium = Medium2,
    m_flow_nominal=m_flow2_nominal,
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=dp2_nominal) annotation (Placement(transformation(extent={{80,10},{60,30}})));
equation
  connect(gaiNom.u, conPIDMinT.y) annotation (Line(points={{58,200},{42,200}}, color={0,0,127}));
  connect(THexInl.T, conPIDMinT.u_m) annotation (Line(points={{30,31},{30,188},{30,188}}, color={0,0,127}));
  connect(uSet, conPIDMinT.u_s) annotation (Line(points={{-120,200},{18,200}}, color={0,0,127}));
  connect(port_a2, fan.port_a) annotation (Line(points={{100,80},{90,80},{90,20},{80,20}},
                                                                             color={0,127,255}));
  connect(fan.port_b, THexInl.port_a) annotation (Line(points={{60,20},{40,20}},                   color={0,127,255}));
  connect(m_flow2.y, fan.m_flow_in) annotation (Line(points={{61,44},{70,44},{70,32}},    color={0,0,127}));
  connect(hex.port_b2, port_b2) annotation (Line(points={{-10,12},{-60,12},{-60,80},{-100,80}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-160},{100,240}})));
end SensibleTerminalUnit;
