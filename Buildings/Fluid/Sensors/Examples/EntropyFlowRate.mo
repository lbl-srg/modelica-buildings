within Buildings.Fluid.Sensors.Examples;
model EntropyFlowRate "Test model for the entropy flow rate sensors"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Fluid.Sensors.EntropyFlowRate  senS_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=2) "Entropy flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    T=293.15) "Flow boundary condition"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    T=313.15) "Flow boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-10})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    offset=1,
    duration=60) "Input signal for mass flow rate"
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));

  Buildings.Fluid.Sensors.SpecificEntropyTwoPort  senS(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    tau=0)            "Specific entropy sensor"
                annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flow(
    redeclare package Medium = Medium) "Mass flow rate sensor"
                annotation (Placement(transformation(extent={{28,-20},{48,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu
    "Asserts the equality of the entropy flow rate computations"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Math.Product pro "Computes the enthalphy flow rate"
    annotation (Placement(transformation(extent={{0,54},{20,74}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-79,-2},{-62,-2}},
      color={0,0,127}));
  connect(sou.ports[1],senS_flow. port_a) annotation (Line(
      points={{-40,-10},{-30,-10}},
      color={0,127,255}));
  connect(senS_flow.port_b,senS. port_a) annotation (Line(
      points={{-10,-10},{-5.55112e-16,-10}},
      color={0,127,255}));
  connect(senS.port_b, senM_flow.port_a) annotation (Line(
      points={{20,-10},{28,-10}},
      color={0,127,255}));
  connect(senM_flow.port_b, sin.ports[1]) annotation (Line(
      points={{48,-10},{60,-10}},
      color={0,127,255}));
  connect(senM_flow.m_flow, pro.u2) annotation (Line(
      points={{38,1},{38,36},{-10,36},{-10,58},{-2,58}},
      color={0,0,127}));
  connect(pro.y, assEqu.u2) annotation (Line(
      points={{21,64},{38,64}},
      color={0,0,127}));
  connect(senS_flow.S_flow, assEqu.u1) annotation (Line(points={{-20,1},{-20,1},
          {-20,72},{-20,80},{30,80},{30,76},{38,76}}, color={0,0,127}));
  connect(senS.s, pro.u1) annotation (Line(points={{10,1},{10,26},{-16,26},{-16,
          70},{-2,70}}, color={0,0,127}));
    annotation (
experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/EntropyFlowRate.mos"
        "Simulate and plot"),    Documentation(info="<html>
<p>
This example tests the entropy flow rate sensor and the
specific entropy sensor.
The model compares the output of the entropy flow rate sensor with
the product of the output of the entropy and the mass flow rate sensor.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EntropyFlowRate;
