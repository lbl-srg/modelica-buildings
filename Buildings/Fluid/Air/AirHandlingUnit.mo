within Buildings.Fluid.Air;
model AirHandlingUnit
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Air.BaseClasses.EssentialParameter;


  HeatExchangers.WetCoilCounterFlow cooCoi
    annotation (Placement(transformation(extent={{12,-12},{32,8}})));
  replaceable Movers.SpeedControlled_y fan
  constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Sensors.TemperatureTwoPort senTem
    annotation (Placement(transformation(extent={{-68,-70},{-88,-50}})));
  replaceable Actuators.Valves.TwoWayEqualPercentage watVal
  constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv
     annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,30})));

  MassExchangers.Humidifier_u hum annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,-34})));
  Modelica.Blocks.Interfaces.RealInput uHum "Control input for humidifier"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput uVal
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput uFan "Input for the fan"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
equation
  connect(port_a1, cooCoi.port_a1) annotation (Line(points={{-100,60},{-60,60},{
          -20,60},{-20,4},{12,4}},  color={0,127,255}));
  connect(cooCoi.port_a2, port_a2) annotation (Line(points={{32,-8},{32,-8},{60,
          -8},{60,-60},{100,-60}}, color={0,127,255}));
  connect(fan.port_b, senTem.port_a) annotation (Line(points={{-40,-60},{-40,-60},
          {-68,-60}}, color={0,127,255}));
  connect(senTem.port_b, port_b2) annotation (Line(points={{-88,-60},{-90,-60},{
          -100,-60}}, color={0,127,255}));
  connect(cooCoi.port_b1, watVal.port_a)
    annotation (Line(points={{32,4},{60,4},{60,20}}, color={0,127,255}));
  connect(watVal.port_b, port_b1) annotation (Line(points={{60,40},{60,40},{60,60},
          {100,60}}, color={0,127,255}));
  connect(cooCoi.port_b2, hum.port_a)
    annotation (Line(points={{12,-8},{1.77636e-15,-8},{1.77636e-15,-24}},
                                                           color={0,127,255}));
  connect(hum.port_b, fan.port_a) annotation (Line(points={{-1.77636e-15,-44},{-1.77636e-15,
          -60},{-20,-60}},
                     color={0,127,255}));
  connect(hum.u, uHum) annotation (Line(points={{-6,-22},{-6,-22},{-6,0},{-120,0}},
        color={0,0,127}));
  connect(watVal.y, uVal)
    annotation (Line(points={{48,30},{-120,30}}, color={0,0,127}));
  connect(fan.y, uFan) annotation (Line(points={{-29.8,-48},{-29.8,-30},{-120,-30}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirHandlingUnit;
