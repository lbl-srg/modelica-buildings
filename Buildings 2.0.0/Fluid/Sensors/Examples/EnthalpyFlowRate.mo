within Buildings.Fluid.Sensors.Examples;
model EnthalpyFlowRate "Test model for the enthalpy flow rate sensors"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Fluid.Sensors.EnthalpyFlowRate senH_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=2) "Enthalpy flow rate sensor"
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
    duration=60)
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));

  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senH(
    redeclare package Medium = Medium,
    m_flow_nominal=2) "Specific enthalpy sensor"
                annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flow(
    redeclare package Medium = Medium) "Mass flow rate sensor"
                annotation (Placement(transformation(extent={{28,-20},{48,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu
    "Asserts the equality of the enthalpy flow rate computations"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Math.Product pro "Computes the enthalphy flow rate"
    annotation (Placement(transformation(extent={{0,54},{20,74}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-79,-2},{-60,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], senH_flow.port_a) annotation (Line(
      points={{-40,-10},{-30,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.port_b, senH.port_a) annotation (Line(
      points={{-10,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH.port_b, senM_flow.port_a) annotation (Line(
      points={{20,-10},{28,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flow.port_b, sin.ports[1]) annotation (Line(
      points={{48,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.H_flow, assEqu.u1) annotation (Line(
      points={{-20,1},{-20,82},{28,82},{28,76},{38,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senH.h_out, pro.u1) annotation (Line(
      points={{10,1},{10,28},{-14,28},{-14,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flow.m_flow, pro.u2) annotation (Line(
      points={{38,1},{38,36},{-10,36},{-10,58},{-2,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.y, assEqu.u2) annotation (Line(
      points={{21,64},{38,64}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (
experiment(StopTime=60.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/EnthalpyFlowRate.mos"
        "Simulate and plot"),    Documentation(info="<html>
<p>
This example tests the enthalpy flow rate sensor and the
specific enthalpy sensor.
The model compares the output of the enthalpy flow rate sensor with
the product of the output of the enthalpy and the mass flow rate sensor.
</p>
</html>", revisions="<html>
<ul>
<li>
August 31, 2013, by Michael Wetter:<br/>
Change <code>tau=0</code> to <code>tau=1</code> for sensors.
Changed source model to use temperature instead of specific enthalpy
as a parameter.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnthalpyFlowRate;
