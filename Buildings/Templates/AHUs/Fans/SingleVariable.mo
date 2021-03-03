within Buildings.Experimental.Templates.AHUs.Fans;
model SingleVariable "Single fan - Variable speed"
  extends Interfaces.Fan(
    final typ=Types.Fan.SingleVariable);

  replaceable Fluid.Movers.SpeedControlled_y fan(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium =MediumAir,
      final inputType=Buildings.Fluid.Types.InputType.Continuous,
      final per=dat.per)
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Routing.RealPassThrough    conSup if fun==Types.FanFunction.Supply
    "Pass through block used to used to connect the right control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Modelica.Blocks.Routing.RealPassThrough    conRet if fun==Types.FanFunction.Return
    "Pass through block used to used to connect the right control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(ahuBus.ahuO.yFanSup, conSup.u) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO.yFanRet, conRet.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(conSup.y, fan.y) annotation (Line(points={{-20,59},{-20,40},{0,40},{0,
          12}}, color={0,0,127}));
  connect(conRet.y, fan.y)
    annotation (Line(points={{20,59},{20,40},{0,40},{0,12}}, color={0,0,127}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariable;
