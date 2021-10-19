within Buildings.Templates.BaseClasses.Sensors;
model SpecificEnthalpy
  extends Buildings.Templates.Interfaces.Sensor(
    y(final unit="J/kg"),
    final isDifPreSen=false);

  Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal) if have_sen
    "Specific enthalpy sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  PassThroughFluid pas(redeclare final package Medium = Medium) if not have_sen
    "Pass through"
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end SpecificEnthalpy;
