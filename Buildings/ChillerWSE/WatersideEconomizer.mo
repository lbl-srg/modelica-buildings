within Buildings.ChillerWSE;
model WatersideEconomizer "Parallel heat exchangers"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelPlant(
    final n=1);
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface;

  Buildings.ChillerWSE.HeatExchanger_T heaExc(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_startController=y_startController,
    final reverseAction=reverseAction,
    final reset=reset,
    final y_reset=y_reset) "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-12},{10,4}})));
equation
  connect(port_a1, heaExc.port_a1) annotation (Line(points={{-100,60},{-40,60},
            {-40,2},{-10,2}},
                            color={0,127,255}));
  connect(heaExc.port_a2, port_a2) annotation (Line(points={{10,-10},{40,-10},
            {40,-60},{100,-60}},
                              color={0,127,255}));
  connect(TSet, heaExc.TSet) annotation (Line(points={{-120,0},{-12,0}},
                       color={0,0,127}));
  connect(booToRea.y, val1.y) annotation (Line(points={{-59,40},{-26,40},{20,40},
          {20,32},{28,32}}, color={0,0,127}));

  connect(y_reset_in, heaExc.y_reset_in) annotation (Line(points={{-120,-50},{-80,
          -50},{-80,-9},{-12,-9}}, color={0,0,127}));
  connect(trigger, heaExc.trigger) annotation (Line(points={{-60,-100},{-60,-80},
          {-6,-80},{-6,-14}}, color={255,0,255}));
  connect(heaExc.port_b1, val1[1].port_a)
    annotation (Line(points={{10,2},{40,2},{40,22}}, color={0,127,255}));
  connect(val2[1].port_a, heaExc.port_b2) annotation (Line(points={{-40,-22},{-40,
          -22},{-40,-10},{-10,-10}}, color={0,127,255}));
end WatersideEconomizer;
