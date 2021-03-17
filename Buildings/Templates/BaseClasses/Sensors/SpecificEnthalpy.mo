within Buildings.Templates.BaseClasses.Sensors;
model SpecificEnthalpy
  extends Buildings.Templates.Interfaces.Sensor(final typ=Types.Sensor.HumidityRatio);

  Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    "Specific enthalpy sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough hRet if
    Modelica.Utilities.Strings.find(insNam, "hRet")<>0
    "Pass through to connect with specific control signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));

equation
  connect(port_a,senSpeEnt. port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senSpeEnt.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));

  connect(senSpeEnt.h_out, hRet.u)
    annotation (Line(points={{0,11},{0,38}}, color={0,0,127}));
  connect(hRet.y, busCon.inp.hRet) annotation (Line(points={{0,61},{0,80},{0,100.1},
          {0.1,100.1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end SpecificEnthalpy;
