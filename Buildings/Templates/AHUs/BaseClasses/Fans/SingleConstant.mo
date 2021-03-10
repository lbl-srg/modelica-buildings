within Buildings.Templates.AHUs.BaseClasses.Fans;
model SingleConstant "Single fan - Constant speed"
  extends Interfaces.Fan(
    final typ=Types.Fan.SingleConstant);
  extends Data.SingleConstant
    annotation (IconMap(primitivesVisible=false));

  replaceable Fluid.Movers.SpeedControlled_y fan(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium =MediumAir,
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
  Modelica.Blocks.Routing.BooleanPassThrough comSup if braStr=="Supply"
    "Supply fan start/stop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,70})));
  Modelica.Blocks.Routing.BooleanPassThrough comRet if braStr=="Return"
    "Return fan start/stop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
        0.5E-2) if                                               braStr=="Supply"
    "Evaluate fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Blocks.Routing.BooleanPassThrough staSup if
                                                    braStr=="Supply"
    "Supply fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-70})));
  Modelica.Blocks.Routing.BooleanPassThrough staRet if
                                                    braStr=="Return"
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
  connect(ahuBus.ahuO.yFanSup,comSup. u) annotation (Line(
      points={{0.1,100.1},{-60,100.1},{-60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(comSup.y, booToRea.u) annotation (Line(points={{-60,59},{-60,50},{0,
          50},{0,42}},
                   color={255,0,255}));
  connect(ahuBus.ahuO.yFanRet,comRet. u) annotation (Line(
      points={{0.1,100.1},{60,100.1},{60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(comRet.y, booToRea.u) annotation (Line(points={{60,59},{60,50},{0,50},
          {0,42},{2.22045e-15,42}}, color={255,0,255}));
  connect(evaSta.y, staRet.u) annotation (Line(points={{0,-42},{0,-50},{20,-50},
          {20,-58}}, color={255,0,255}));
  connect(evaSta.y, staSup.u) annotation (Line(points={{0,-42},{0,-50},{-20,-50},
          {-20,-58}}, color={255,0,255}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
          -16},{0,-16},{0,-18}}, color={0,0,127}));
  connect(staSup.y, ahuBus.ahuI.staFanSup) annotation (Line(points={{-20,-81},{
          -20,-90},{-40,-90},{-40,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
  connect(staRet.y, ahuBus.ahuI.staFanRet) annotation (Line(points={{20,-81},{
          20,-90},{40,-90},{40,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConstant;
