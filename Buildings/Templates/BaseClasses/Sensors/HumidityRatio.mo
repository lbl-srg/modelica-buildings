within Buildings.Templates.BaseClasses.Sensors;
model HumidityRatio
  extends Buildings.Templates.Interfaces.Sensor(
    final isDifPreSen=false);

  Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal) if have_sen
    "Mass fraction sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.Psychrometrics.ToDryAir toDryAir if have_sen
    "Conversion into kg/kg dry air"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));

  PassThroughFluid pas(redeclare final package Medium = Medium) if not have_sen
    "Pass through"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(port_a, senMasFra.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senMasFra.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senMasFra.X, toDryAir.XiTotalAir)
    annotation (Line(points={{0,11},{0,19}}, color={0,0,127}));

  connect(toDryAir.XiDry, busCon.x) annotation (Line(points={{7.21645e-16,41},{0,
          100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, pas.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
          {-10,-40}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{10,-40},{80,-40},{80,0},
          {100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end HumidityRatio;
