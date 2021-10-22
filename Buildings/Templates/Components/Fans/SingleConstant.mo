within Buildings.Templates.Components.Fans;
model SingleConstant "Single fan - Constant speed"
  extends Buildings.Templates.Components.Interfaces.Fan(final typ=Buildings.Templates.Components.Types.Fan.SingleConstant);

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

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanSup
    if loc == Buildings.Templates.Components.Types.Location.Supply
    "Supply fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,70})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanRet if loc == Buildings.Templates.Components.Types.Location.Return
     or loc == Buildings.Templates.Components.Types.Location.Relief
    "Return fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
    t=1E-2,
    h=0.5E-2)
    "Evaluate fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanSup_actual
    if loc == Buildings.Templates.Components.Types.Location.Supply
    "Supply fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-70})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanRet_actual if loc == Buildings.Templates.Components.Types.Location.Return
     or loc == Buildings.Templates.Components.Types.Location.Relief
    "Return fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-70})));
equation
  connect(booToRea.y, fan.y)
    annotation (Line(points={{0,18},{0,12}}, color={0,0,127}));
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(yFanSup.y, booToRea.u) annotation (Line(points={{-60,59},{-60,50},{0,
          50},{0,42}}, color={255,0,255}));
  connect(yFanRet.y, booToRea.u) annotation (Line(points={{60,59},{60,50},{0,50},
          {0,42},{2.22045e-15,42}}, color={255,0,255}));
  connect(evaSta.y, yFanRet_actual.u) annotation (Line(points={{0,-42},{0,-50},
          {20,-50},{20,-58}}, color={255,0,255}));
  connect(evaSta.y, yFanSup_actual.u) annotation (Line(points={{0,-42},{0,-50},
          {-20,-50},{-20,-58}}, color={255,0,255}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
          -16},{0,-16},{0,-18}}, color={0,0,127}));
  connect(yFanRet_actual.y, busCon.inp.yFanRet_actual) annotation (Line(points=
          {{20,-81},{20,-90},{40,-90},{40,80},{0.1,80},{0.1,100.1}}, color={255,
          0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yFanSup_actual.y, busCon.inp.yFanSup_actual) annotation (Line(points=
          {{-20,-81},{-20,-90},{-40,-90},{-40,80},{0.1,80},{0.1,100.1}}, color=
          {255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yFanSup, yFanSup.u) annotation (Line(
      points={{0.1,100.1},{-2,100.1},{-2,90},{-60,90},{-60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yFanRet, yFanRet.u) annotation (Line(
      points={{0.1,100.1},{2,100.1},{2,90},{60,90},{60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
     Icon(graphics={Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")},
     coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConstant;
