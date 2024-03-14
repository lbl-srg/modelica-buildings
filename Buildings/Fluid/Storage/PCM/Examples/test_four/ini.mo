within Buildings.Fluid.Storage.PCM.Examples.test_four;
model ini
  extends Interfaces.PartialFourPortInterface;
  Medium1.ThermodynamicState sta = Medium1.setState_phX(p=port_a1.p, h=port_a1.h_outflow, X=port_a1.Xi_outflow);
  Real TT;
  Real TTT;
  Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
equation
  //TT = Medium1.temperature(state_a1);
//  TT = Medium1.cp_const;

TT = Medium1.prandtlNumber(state=
                    Medium1.setState_phX(p=port_a1.p, h=port_a1.h_outflow, X=port_a1.Xi_outflow));

TTT = Medium1.specificHeatCapacityCp(state=sta);


  connect(port_a1, senTem.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(senTem.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_b2, senTem1.port_b)
    annotation (Line(points={{-100,-60},{-10,-60}}, color={0,127,255}));
  connect(senTem1.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end ini;
