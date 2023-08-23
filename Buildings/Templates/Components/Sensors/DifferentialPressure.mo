within Buildings.Templates.Components.Sensors;
model DifferentialPressure "Differential pressure sensor"
  extends Buildings.Templates.Components.Interfaces.PartialSensor(
    y(final unit="Pa", displayUnit="Pa"),
    final m_flow_nominal=0,
    final isDifPreSen=true);

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium) if have_sen
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
equation
  connect(port_a, senRelPre.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senRelPre.p_rel, y)
    annotation (Line(points={{0,9},{0,120}}, color={0,0,127}));
  connect(senRelPre.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent=if text_flip then {{40,-40},{-40,40}} else {{-40,-40},{40,40}},
        visible=have_sen,
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
      Bitmap(
        extent=if text_flip then {{-30,-70},{-110,10}} else {{-110,-70},{-30,10}},
        visible=have_sen,
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureHigh.svg"),
      Bitmap(
        extent=if text_flip then {{110,-70},{30,10}} else {{30,-70},{110,10}},
        visible=have_sen,
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureLow.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a differential pressure sensor that can be
enabled or disabled with the Boolean parameter <code>have_sen</code>.
If disabled, the control input variable <code>y</code> is removed
and the model simply consists of two fluid ports that are not connected
to each other and for which the following equations are used.
So the model must still be provided with pressure conditions
at each port.
</p>
<code>
// Zero flow equations<br/>
port_(a|b).m_flow = 0;<br/>
// No contribution of specific quantities<br/>
port_(a|b).h_outflow = 0;<br/>
port_(a|b).Xi_outflow = zeros(Medium.nXi);<br/>
port_(a|b).C_outflow  = zeros(Medium.nC);
</code>
</html>"));
end DifferentialPressure;
