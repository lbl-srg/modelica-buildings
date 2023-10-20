within Buildings.Templates.Components.Valves;
model ThreeWayTwoPosition "Three-way two-position valve"
  extends Buildings.Templates.Components.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition);

  replaceable Buildings.Fluid.Actuators.Valves.ThreeWayLinear val
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
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold evaOpe(t=0.99, h=0.5E-2)
    "Return true if open (open end switch contact)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-50})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold evaClo(t=0.01, h=0.5E-2)
    "Return true if closed (closed end switch contact)"
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Signal conversion"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
equation
  connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(val.y_actual, evaOpe.u)
    annotation (Line(points={{5,7},{20,7},{20,-38}}, color={0,0,127}));
  connect(val.y_actual, evaClo.u) annotation (Line(points={{5,7},{20,7},{20,-20},
          {-20,-20},{-20,-38}}, color={0,0,127}));
  connect(evaOpe.y, bus.y1_actual) annotation (Line(points={{20,-62},{20,-80},{60,
          -80},{60,96},{0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(evaClo.y, bus.y0_actual) annotation (Line(points={{-20,-62},{-20,-80},
          {-60,-80},{-60,96},{0,96},{0,100}},color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToRea.u, bus.y1) annotation (Line(points={{2.22045e-15,62},{2.22045e-15,
          81},{0,81},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToRea.y, val.y) annotation (Line(points={{-2.22045e-15,38},{-2.22045e-15,
          25},{0,25},{0,12}}, color={0,0,127}));
  connect(val.port_3, portByp_a)
    annotation (Line(points={{0,-10},{0,-100}}, color={0,127,255}));
  annotation (
  defaultComponentName="val",
  Documentation(info="<html>
<p>
This is a model for a three-way two-position (directional) valve.
</p>
<ul>
<li>
The valve position is commanded with a Boolean signal <code>y1</code>.<br/>
<code>y1 = false</code> corresponds to full bypass.
<code>y1 = true</code> corresponds to zero bypass.
</li>
<li>
The open end switch status <code>y1_actual</code> and
closed end switch status <code>y0_actual</code> (Booleans)
are returned.<br/>
<code>y1_actual = false</code> corresponds to full bypass.
<code>y1_actual = true</code> corresponds to zero bypass.
And the opposite for <code>y0_actual</code>.
</li>
</ul>
</html>"));
end ThreeWayTwoPosition;
