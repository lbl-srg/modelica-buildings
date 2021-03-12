within Buildings.Templates.AHUs.BaseClasses.Fans;
model SingleVariable "Single fan - Variable speed"
  extends Interfaces.Fan(
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

  Modelica.Blocks.Routing.RealPassThrough speSup if braStr=="Supply"
    "Supply fan speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Modelica.Blocks.Routing.RealPassThrough speRet if braStr=="Return"
    "Return fan speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comSup if braStr=="Supply"
    "Supply fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comRet if braStr=="Return"
    "Return fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,70})));
  Buildings.Controls.OBC.CDL.Continuous.Product conSup if braStr=="Supply"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,40})));
  Buildings.Controls.OBC.CDL.Continuous.Product conRet if braStr=="Return"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,40})));
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
        rotation=180,
        origin={-30,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough staRet if
                                                    braStr=="Return"
    "Return fan status" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={30,-80})));
equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(comSup.y, conSup.u2) annotation (Line(points={{-46,58},{-46,52}},
                     color={0,0,127}));
  connect(speSup.y, conSup.u1) annotation (Line(points={{-20,59},{-20,54},{-34,
          54},{-34,52}},
                     color={0,0,127}));
  connect(ahuBus.ahuO.ySpeFanSup, speSup.u) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,82}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.yFanSup, comSup.u) annotation (Line(
      points={{0.1,100.1},{-46,100.1},{-46,82}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.ySpeFanRet, speRet.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,82}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.yFanRet, comRet.u) annotation (Line(
      points={{0.1,100.1},{46,100.1},{46,82}},
      color={255,204,51},
      thickness=0.5));
  connect(conSup.y, fan.y) annotation (Line(points={{-40,28},{-40,20},{0,20},{0,
          12}}, color={0,0,127}));
  connect(speRet.y, conRet.u2) annotation (Line(points={{20,59},{20,54},{34,54},
          {34,52}}, color={0,0,127}));
  connect(comRet.y, conRet.u1) annotation (Line(points={{46,58},{46,52}},
                    color={0,0,127}));
  connect(conRet.y, fan.y)
    annotation (Line(points={{40,28},{40,20},{0,20},{0,12}}, color={0,0,127}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,
          -16},{0,-16},{0,-18}}, color={0,0,127}));
  connect(evaSta.y, staRet.u)
    annotation (Line(points={{0,-42},{0,-80},{18,-80}}, color={255,0,255}));
  connect(evaSta.y, staSup.u)
    annotation (Line(points={{0,-42},{0,-80},{-18,-80}}, color={255,0,255}));
  connect(staSup.y, ahuBus.ahuI.staFanSup) annotation (Line(points={{-41,-80},{
          -60,-80},{-60,96},{0,96},{0,98},{0.1,98},{0.1,100.1}}, color={255,0,
          255}));
  connect(staRet.y, ahuBus.ahuI.staFanRet) annotation (Line(points={{41,-80},{
          60,-80},{60,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariable;
