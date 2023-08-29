within Buildings.Templates.Components.Dampers;
model TwoPosition "Two-position damper"
  extends Buildings.Templates.Components.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.TwoPosition,
    typBla=Buildings.Templates.Components.Types.DamperBlades.Opposed);

  Buildings.Fluid.Actuators.Dampers.Exponential dam(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dp_nominal,
    final dpFixed_nominal=dat.dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Signal conversion"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaOpe(t=0.99, h=0.5E-2)
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
equation
  connect(port_a, dam.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,0},
          {-10,0}}, color={0,127,255}));
  connect(dam.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(dam.y_actual,evaOpe. u) annotation (Line(points={{5,7},{20,7},{20,-38}},
                                                        color={0,0,127}));
  connect(booToRea.y, dam.y)
    annotation (Line(points={{-2.22045e-15,38},{0,12}}, color={0,0,127}));
  connect(evaOpe.y, bus.y1_actual) annotation (Line(points={{20,-62},{20,-80},{60,
          -80},{60,96},{0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(dam.y_actual, evaClo.u) annotation (Line(points={{5,7},{20,7},{20,-20},
          {-20,-20},{-20,-38}}, color={0,0,127}));
  connect(evaClo.y, bus.y0_actual) annotation (Line(points={{-20,-62},{-20,-80},{
          -60,-80},{-60,96},{0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y1, booToRea.u) annotation (Line(
      points={{0,100},{0,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This is a model for a two-position damper.
</p>
<ul>
<li>
The damper is commanded open with a Boolean signal <code>y1</code>.<br/>
<code>y1 = 0</code> corresponds to fully closed.
<code>y1 = 1</code> corresponds to fully open.
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
end TwoPosition;
