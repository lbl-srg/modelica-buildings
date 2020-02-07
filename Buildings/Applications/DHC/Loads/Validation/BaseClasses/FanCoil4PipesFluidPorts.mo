within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model FanCoil4PipesFluidPorts
  extends PartialFanCoil4Pipes(
    final have_fluPor=true);
equation
  connect(senTem.port_a, port_aLoa) annotation (Line(points={{130,0},{164,0},{
          164,0},{200,0}}, color={0,127,255}));
  connect(hexHea.port_b2, port_bLoa)
    annotation (Line(points={{-80,0},{-200,0}}, color={0,127,255}));
end FanCoil4PipesFluidPorts;
