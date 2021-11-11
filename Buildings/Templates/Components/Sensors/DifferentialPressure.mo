within Buildings.Templates.Components.Sensors;
model DifferentialPressure
  extends Buildings.Templates.Components.Sensors.Interfaces.PartialSensor(
    y(final unit="Pa", displayUnit="Pa"),
    final isDifPreSen=true);

  parameter Buildings.Templates.Components.Types.SensorDifferentialPressure typ=
    Buildings.Templates.Components.Types.SensorDifferentialPressure.Static
    "Type of differential pressure sensor"
    annotation(Dialog(enable=false), Evaluate=true);

  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium) if have_sen
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
equation
  connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{-50,-40}}, color={0,127,255}));
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.port_b, port_bRef)
    annotation (Line(points={{-30,-40},{0,-40},{0,-100}}, color={0,127,255}));
  connect(senRelPre.p_rel, y) annotation (Line(points={{-40,-31},{-40,80},{0,80},
          {0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent={{-74,-192},{74,6}},
        visible=typ==Buildings.Templates.Components.Types.SensorDifferentialPressure.Static,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureStatic.svg"),
      Bitmap(
        extent={{-74,-200},{86,2}},
        visible=typ==Buildings.Templates.Components.Types.SensorDifferentialPressure.External,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureExternal.svg"),
      Bitmap(
        extent={{-84,-192},{62,10}},
        visible=typ==Buildings.Templates.Components.Types.SensorDifferentialPressure.Total,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureTotal.svg"),
      Bitmap(
            extent={{-30,-200},{30,-140}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
      Bitmap(
        extent={{-122,-174},{122,122}},
        visible=typ==Buildings.Templates.Components.Types.SensorDifferentialPressure.StaticLong,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureStaticLong.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DifferentialPressure;
