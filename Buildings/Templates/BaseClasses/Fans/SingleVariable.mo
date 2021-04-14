within Buildings.Templates.BaseClasses.Fans;
model SingleVariable "Single fan - Variable speed"
  extends Buildings.Templates.Interfaces.Fan(
    final typ=Types.Fan.SingleVariable);

  replaceable Fluid.Movers.SpeedControlled_y fan(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium =Medium,
      final inputType=Buildings.Fluid.Types.InputType.Continuous,
      final per=per)
    "Fan"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Routing.RealPassThrough ySpeFanSup if
                                                    locStr=="Supply"
    "Supply fan speed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Modelica.Blocks.Routing.RealPassThrough ySpeFanRet if
                                                    locStr=="Return"
    "Return fan speed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yFanSup if
                                                                 locStr=="Supply"
    "Supply fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yFanRet if
                                                                 locStr=="Return"
    "Return fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,70})));
  Buildings.Controls.OBC.CDL.Continuous.Product conSup if locStr=="Supply"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,40})));
  Buildings.Controls.OBC.CDL.Continuous.Product conRet if locStr=="Return"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,40})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
        0.5E-2)
    "Evaluate fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanSup_actual if
                                                    locStr=="Supply"
    "Supply fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanRet_actual if
                                                    locStr=="Return"
    "Return fan status" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={30,-80})));
equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(yFanSup.y, conSup.u2)
    annotation (Line(points={{-46,58},{-46,52}}, color={0,0,127}));
  connect(ySpeFanSup.y, conSup.u1) annotation (Line(points={{-20,59},{-20,54},{-34,
          54},{-34,52}}, color={0,0,127}));
  connect(conSup.y, fan.y) annotation (Line(points={{-40,28},{-40,20},{0,20},{0,
          12}}, color={0,0,127}));
  connect(ySpeFanRet.y, conRet.u2) annotation (Line(points={{20,59},{20,54},{34,
          54},{34,52}}, color={0,0,127}));
  connect(yFanRet.y, conRet.u1)
    annotation (Line(points={{46,58},{46,52}}, color={0,0,127}));
  connect(conRet.y, fan.y)
    annotation (Line(points={{40,28},{40,20},{0,20},{0,12}}, color={0,0,127}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
          -16},{0,-16},{0,-18}}, color={0,0,127}));
  connect(evaSta.y, yFanRet_actual.u)
    annotation (Line(points={{0,-42},{0,-80},{18,-80}}, color={255,0,255}));
  connect(evaSta.y, yFanSup_actual.u)
    annotation (Line(points={{0,-42},{0,-80},{-18,-80}}, color={255,0,255}));
  connect(busCon.out.ySpeFanRet, ySpeFanRet.u) annotation (Line(
      points={{0.1,100.1},{2,100.1},{2,86},{20,86},{20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.ySpeFanSup, ySpeFanSup.u) annotation (Line(
      points={{0.1,100.1},{0.1,100},{-2,100},{-2,86},{-20,86},{-20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yFanSup, yFanSup.u) annotation (Line(
      points={{0.1,100.1},{-4,100.1},{-4,90},{-46,90},{-46,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yFanRet, yFanRet.u) annotation (Line(
      points={{0.1,100.1},{0.1,100},{4,100},{4,90},{46,90},{46,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yFanRet_actual.y, busCon.inp.yFanRet_actual) annotation (Line(points={
          {41,-80},{60,-80},{60,96},{6,96},{6,100.1},{0.1,100.1}}, color={255,0,
          255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yFanSup_actual.y, busCon.inp.yFanSup_actual) annotation (Line(points={
          {-41,-80},{-60,-80},{-60,96},{0,96},{0,98},{0.1,98},{0.1,100.1}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariable;
