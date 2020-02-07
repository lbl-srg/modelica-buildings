within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model FanCoil4PipesFluidPorts
  extends PartialFanCoil4Pipes(
    final have_fluPor=true);
equation
  connect(senTem.port_a, port_aLoa) annotation (Line(points={{130,0},{164,0},{
          164,0},{200,0}}, color={0,127,255}));
  connect(hexHea.port_b2, port_bLoa)
    annotation (Line(points={{-80,0},{-200,0}}, color={0,127,255}));
  connect(TSetHea, conHea.u_s)
    annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
  connect(TSetCoo, conCoo.u_s)
    annotation (Line(points={{-220,180},{-12,180}}, color={0,0,127}));
  connect(senTem.T, conCoo.u_m) annotation (Line(points={{120,11},{120,40},{0,
          40},{0,168}}, color={0,0,127}));
  connect(senTem.T, conHea.u_m) annotation (Line(points={{120,11},{120,40},{0,
          40},{0,140},{-20,140},{-20,200},{0,200},{0,208}}, color={0,0,127}));
end FanCoil4PipesFluidPorts;
