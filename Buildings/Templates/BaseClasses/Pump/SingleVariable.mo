within Buildings.Templates.BaseClasses.Pump;
model SingleVariable
  extends Buildings.Templates.Interfaces.Pump(final typ=Types.Pump.SingleVariable);

  replaceable Fluid.Movers.SpeedControlled_y pum(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare final package Medium =Medium,
      final inputType=Buildings.Fluid.Types.InputType.Continuous,
      final per=per) "Pump"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPum
    if loc == Templates.Types.Location.Supply "Pump start/stop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,30})));
  Buildings.Controls.OBC.CDL.Continuous.Product con
    if loc == Templates.Types.Location.Supply "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,30})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
        0.5E-2)
    "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
equation
  connect(port_a,pum. port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(yPum.y, con.u2) annotation (Line(points={{-58,30},{-50,30},{-50,24},{
          -42,24}}, color={0,0,127}));
  connect(con.y, pum.y)
    annotation (Line(points={{-18,30},{0,30},{0,12}}, color={0,0,127}));
  connect(pum.y_actual,evaSta. u) annotation (Line(points={{11,7},{30,7},{30,30},
          {38,30}},              color={0,0,127}));
  connect(busCon.out.ySpePum, con.u1) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-50,80},{-50,36},{-42,36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yPum, yPum.u) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-90,80},{-90,30},{-82,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(evaSta.y, busCon.inp.yPum_actual) annotation (Line(points={{62,30},{
          80,30},{80,80},{0.1,80},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariable;
