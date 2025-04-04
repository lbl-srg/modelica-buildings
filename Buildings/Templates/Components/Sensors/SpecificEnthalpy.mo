within Buildings.Templates.Components.Sensors;
model SpecificEnthalpy "Specific enthalpy sensor"
  extends Buildings.Templates.Components.Interfaces.PartialSensor(
    y(final unit="J/kg"),
    final isDifPreSen=false);

  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal) if have_sen
    "Specific enthalpy sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Templates.Components.Routing.PassThroughFluid pas(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal) if not have_sen "Pass through"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(port_a,senSpeEnt. port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senSpeEnt.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));

  connect(port_a, pas.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
          {-10,-40}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{10,-40},{80,-40},{80,0},
          {100,0}}, color={0,127,255}));
  connect(senSpeEnt.h_out, y)
    annotation (Line(points={{0,11},{0,11},{0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        visible=have_sen,
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/SpecificEnthalpy.svg"),
      Bitmap(
        extent={{-20,-160},{20,40}},
        visible=have_sen,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a specific enthalpy sensor that can be
enabled or disabled with the Boolean parameter <code>have_sen</code>.
If disabled, the control input variable <code>y</code> is removed
and the model is a direct fluid pass-through.
</p>
</html>"));
end SpecificEnthalpy;
