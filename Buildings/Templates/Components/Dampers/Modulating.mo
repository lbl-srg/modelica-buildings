within Buildings.Templates.Components.Dampers;
model Modulating "Modulating damper"
  extends Buildings.Templates.Components.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.Modulating,
    typBla=Buildings.Templates.Components.Types.DamperBlades.Parallel);

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
equation
  connect(port_a, dam.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,0},
          {-10,0}}, color={0,127,255}));
  connect(dam.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(dam.y_actual, bus.y_actual) annotation (Line(points={{5,7},{40,7},{40,
          96},{0,96},{0,100}}, color={0,0,127}));
  connect(bus.y, dam.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This is a model for a modulating damper.
</p>
<ul>
<li>
The damper opening is modulated with a fractional opening
signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to fully closed.
<code>y = 1</code> corresponds to fully open.
</li>
<li>
The actual damper position <code>y_actual</code> (real) is returned.<br/>
<code>y_actual = 0</code> corresponds to fully closed.
<code>y_actual = 1</code> corresponds to fully open.
</li>
</ul>
</html>"));
end Modulating;
