within Buildings.Templates.BaseClasses.Sensors;
model HumidityRatio
  extends Buildings.Templates.Interfaces.Sensor(
    final typ=Types.Sensor.HumidityRatio);

  Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    "Mass fraction sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.Psychrometrics.ToDryAir toDryAir
    "Conversion into kg/kg dry air"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Modelica.Blocks.Routing.RealPassThrough xSup if
    Modelica.Utilities.Strings.find(insNam, "xSup")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,70})));

equation
  connect(port_a, senMasFra.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senMasFra.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senMasFra.X, toDryAir.XiTotalAir)
    annotation (Line(points={{0,11},{0,19}}, color={0,0,127}));

  connect(toDryAir.XiDry, xSup.u) annotation (Line(points={{6.66134e-16,41},{0,
          41},{0,44},{-8.88178e-16,44},{-8.88178e-16,58}},
                                  color={0,0,127}));
  connect(xSup.y,busCon.inp.xSup)  annotation (Line(points={{0,81},{0,90},{0,
          100.1},{0.1,100.1}},
                        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end HumidityRatio;
