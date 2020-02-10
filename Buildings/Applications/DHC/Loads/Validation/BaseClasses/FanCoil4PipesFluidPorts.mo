within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model FanCoil4PipesFluidPorts
  extends PartialFanCoil4Pipes(
    final have_TSen=true,
    final have_fluPor=true);
equation
  connect(hexHea.port_b2, port_bLoa)
    annotation (Line(points={{-80,0},{-200,0}}, color={0,127,255}));
  connect(port_aLoa, fan.port_a)
    annotation (Line(points={{200,0},{90,0}}, color={0,127,255}));
  connect(TSen, conCoo.u_m) annotation (Line(points={{-220,140},{-40,140},{-40,
          160},{0,160},{0,168}}, color={0,0,127}));
  connect(TSen, conHea.u_m) annotation (Line(points={{-220,140},{-40,140},{-40,
          200},{0,200},{0,208}}, color={0,0,127}));
end FanCoil4PipesFluidPorts;
