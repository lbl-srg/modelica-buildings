within Buildings.Templates.Components.Fans;
model SingleVariable "Single fan - Variable speed"
  extends Buildings.Templates.Components.Fans.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.SingleVariable);

  Buildings.Fluid.Movers.SpeedControlled_y fan(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare final package Medium =Medium,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final per=per)
    "Fan"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));

  Buildings.Controls.OBC.CDL.Continuous.Product sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
    t=1E-2,
    h=0.5E-2)
    "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
          -20},{2.22045e-15,-20},{2.22045e-15,-38}}, color={0,0,127}));
  connect(bus.y, sigSta.u) annotation (Line(
      points={{0,100},{0,90},{-20,90},{-20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(evaSta.y, bus.y_actual) annotation (Line(points={{0,-62},{0,-80},{60,
          -80},{60,100},{0,100}},           color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigCon.y, fan.y)
    annotation (Line(points={{-2.22045e-15,18},{0,12}}, color={0,0,127}));
  connect(bus.ySpe, sigCon.u1) annotation (Line(
      points={{0,100},{0,90},{20,90},{20,50},{6,50},{6,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigSta.y, sigCon.u2) annotation (Line(points={{-20,58},{-20,50},{-6,50},
          {-6,42}}, color={0,0,127}));
  connect(fan.port_b, V_flow.port_a)
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
    Icon(
      coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
        extent={{-92,-88},{92,92}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
    Bitmap(
        visible=have_senFlo,
        extent={{-52,-10},{24,10}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/AirflowSensor.svg"),
    Line(
      visible=have_senFlo,
          points={{-180,0},{-52,0}},
          color={0,0,0},
          thickness=1)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariable;
