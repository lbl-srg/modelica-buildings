within Buildings.Templates.Components.Valves;
model ThreeWayModulating "Three-way modulating valve"
  extends Buildings.Templates.Components.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.ThreeWayModulating);

  replaceable Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal={dpFixed_nominal, dpFixedByp_nominal},
      final energyDynamics=energyDynamics,
      final tau=tau,
      final use_inputFilter=use_inputFilter,
      final riseTime=riseTime,
      final init=init,
      final y_start=y_start,
      final portFlowDirection_1=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
        else Modelica.Fluid.Types.PortFlowDirection.Entering,
      final portFlowDirection_2=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
        else Modelica.Fluid.Types.PortFlowDirection.Leaving,
      final portFlowDirection_3=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
        else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Valve"
    annotation (
      __ctrlFlow(enable=false),
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(val.port_3, portByp_a)
    annotation (Line(points={{0,-10},{0,-100}}, color={0,127,255}));
  connect(bus.y, val.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(val.y_actual, bus.y_actual) annotation (Line(points={{5,7},{40,7},{40,
          96},{0,96},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  defaultComponentName="val",
  Documentation(info="<html>
<p>
This is a model for a three-way modulating valve.
</p>
<ul>
<li>
The valve position is modulated with a fractional position
signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to full bypass.
<code>y = 1</code> corresponds to zero bypass.
</li>
<li>
The actual valve position <code>y_actual</code> (real) is returned.<br/>
<code>y_actual = 0</code> corresponds to full bypass.
<code>y_actual = 1</code> corresponds to zero bypass.
</li>
</ul>
</html>"));
end ThreeWayModulating;
