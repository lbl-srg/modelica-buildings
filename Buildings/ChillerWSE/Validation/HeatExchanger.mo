within Buildings.ChillerWSE.Validation;
model HeatExchanger
  "Model that demonstrates use of a waterside economizer with outlet temperature control"

  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Validation.BaseClasses.PartialPlantWithControl(
    sou1(nPorts=1),
    sou2(nPorts=1),
    T1_in(offset=273.15 + 4, startTime=1800));
  Buildings.ChillerWSE.HeatExchanger hx(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    eta=0.8,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    T_start=273.15 + 10,
    use_Controller=true) "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-8},{10,8}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    T_start=273.15 + 10) "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));

equation
  connect(TSet.y, hx.TSet) annotation (Line(points={{-79,70},{-44,70},{-24,70},
          {-24,4},{-12,4}}, color={0,0,127}));
  connect(sou1.ports[1], hx.port_a1) annotation (Line(points={{-42,26},{-20,26},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(hx.port_b1, res1.port_a) annotation (Line(points={{10,6},{20,6},{20,
          48},{40,48}}, color={0,127,255}));
  connect(res2.port_a, senTem.port_b)
    annotation (Line(points={{-52,-20},{-40,-20}}, color={0,127,255}));
  connect(senTem.port_a, hx.port_b2) annotation (Line(points={{-20,-20},{-14,-20},
          {-14,-6},{-10,-6}}, color={0,127,255}));
  connect(hx.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{20,-6},{
          20,-10},{60,-10}}, color={0,127,255}));
  annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Validation/HeatExchanger.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchanger;
