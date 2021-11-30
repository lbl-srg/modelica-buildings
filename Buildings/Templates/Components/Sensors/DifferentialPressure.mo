within Buildings.Templates.Components.Sensors;
model DifferentialPressure "Differential pressure sensor"
  extends Buildings.Templates.Components.Sensors.Interfaces.PartialSensor(
    y(final unit="Pa", displayUnit="Pa"),
    final isDifPreSen=true);

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium) if have_sen
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
equation
  connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-10,0}},
                           color={0,127,255}));
  connect(senRelPre.p_rel, y) annotation (Line(points={{0,9},{0,120}},
                    color={0,0,127}));
  connect(senRelPre.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent=if text_flip then {{40,-40},{-40,40}} else {{-40,-40},{40,40}},
        visible=have_sen,
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DifferentialPressure;
