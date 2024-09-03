within Buildings.Templates.Components.Sensors;
model Temperature "Temperature sensor"
  extends Buildings.Templates.Components.Interfaces.PartialSensor(
    y(final unit="K", displayUnit="degC"),
    final isDifPreSen=false);

  parameter Buildings.Templates.Components.Types.SensorTemperature typ=
    Buildings.Templates.Components.Types.SensorTemperature.Standard
    "Type of temperature sensor"
    annotation(Dialog(enable=false));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal) if have_sen
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas(redeclare final
      package Medium = Medium) if not have_sen "Pass through"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation

  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_a, pas.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
          {-10,-40}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{10,-40},{80,-40},{80,0},
          {100,0}}, color={0,127,255}));
  connect(senTem.T, y)
    annotation (Line(points={{0,11},{0,11},{0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        visible=have_sen and typ<>Buildings.Templates.Components.Types.SensorTemperature.InWell,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
      Bitmap(
        extent=if text_flip then {{40,160},{-40,240}} else {{-40,160},{40,240}},
        rotation=text_rotation,
        visible=have_sen and typ==Buildings.Templates.Components.Types.SensorTemperature.InWell,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
      Bitmap(extent={{-100,-160},{100,40}},
        visible=have_sen and typ==Buildings.Templates.Components.Types.SensorTemperature.Averaging,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeAveraging.svg"),
      Bitmap(extent={{-100,-40},{100,160}},
        visible=have_sen and typ==Buildings.Templates.Components.Types.SensorTemperature.InWell,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg"),
      Bitmap(extent={{-100,-160},{100,40}},
        visible=have_sen and typ==Buildings.Templates.Components.Types.SensorTemperature.Standard,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a dry bulb temperature sensor that can be
enabled or disabled with the Boolean parameter <code>have_sen</code>.
If disabled, the control input variable <code>y</code> is removed
and the model is a direct fluid pass-through.
</p>
</html>"));
end Temperature;
