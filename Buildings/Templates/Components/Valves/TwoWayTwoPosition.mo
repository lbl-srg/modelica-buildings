within Buildings.Templates.Components.Valves;
model TwoWayTwoPosition "Two-way two-position valve"
  extends Buildings.Templates.Components.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition);

  replaceable Buildings.Fluid.Actuators.Valves.TwoWayPolynomial val(
    c={0,1.101898284705380E-01, 2.217227395456580, -7.483401207660790, 1.277617623360130E+01, -6.618045307070130})
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
      redeclare final package Medium=Medium,
      final CvData = Buildings.Fluid.Types.CvTypes.OpPoint,
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpFixed_nominal)
    "Valve (butterfly valve characteristic)"
    annotation (
      __Linkage(enable=false),
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaOpe(
    t=0.99,
    h=0.5E-2)
    "Return true if open (open end switch contact)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-50})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold evaClo(t=0.01, h=0.5E-2)
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
  connect(port_a, val.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, port_b)
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
  annotation (
  defaultComponentName="val",
  Documentation(info="<html>
<p>
This is a model for a two-way two-position (isolation) valve.
</p>
<ul>
<li>
The valve position is commanded with a Boolean signal <code>y1</code>.<br/>
<code>y1 = false</code> corresponds to fully closed.
<code>y1 = true</code> corresponds to fully open.
</li>
<li>
The open end switch status <code>y1_actual</code> and
closed end switch status <code>y0_actual</code> (Booleans)
are returned.<br/>
<code>y1_actual = false</code> corresponds to fully closed.
<code>y1_actual = true</code> corresponds to fully open.
And the opposite for <code>y0_actual</code>.
</li>
</ul>
</html>"));
end TwoWayTwoPosition;
