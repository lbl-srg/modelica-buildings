within Buildings.Fluid.HeatExchangers.Examples;
model DryCoilCounterFlowPControl
  "Model that demonstrates use of a heat exchanger without condensation and with feedback control"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Air;

  parameter Modelica.SIunits.Temperature T_a1_nominal=5 + 273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal=10 + 273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal=30 + 273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal=15 + 273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=0.1
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200/
      1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=303.15) annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true,
    p(displayUnit="Pa") = 101325 + 300) annotation (Placement(transformation(
          extent={{140,10},{120,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_p_in=false,
    p=300000,
    T=293.15) annotation (Placement(transformation(extent={{140,50},{120,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_T_in=true,
    p=300000 + 12000)
                   annotation (Placement(transformation(extent={{-40,50},{-20,
            70}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    dp_nominal=3000,
    m_flow_nominal=m1_flow_nominal)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(redeclare package Medium =
               Medium2, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{20,10},{0,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=6000) "Valve model"           annotation (Placement(
        transformation(extent={{30,50},{50,70}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,288.15; 600,288.15; 600,
        298.15; 1200,298.15; 1800,283.15; 2400,283.15; 2400,288.15])
    "Setpoint temperature" annotation (Placement(transformation(extent={{-40,90},
            {-20,110}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal(displayUnit="Pa") = 3000,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal - T_b1_nominal)/
       Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                             annotation (Placement(transformation(extent={{60,
            16},{80,36}})));
  Modelica.Blocks.Sources.Constant const(k=0.8)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-40},{170,-20}})));
  Modelica.Blocks.Sources.Constant const1(k=T_a2_nominal)
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Buildings.Controls.Continuous.LimPID con(
    Td=1,
    reverseActing=false,
    yMin=0,
    k=0.1,
    Ti=60) "Controller"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Sources.Ramp TWat(
    height=30,
    offset=T_a1_nominal,
    startTime=300,
    duration=2000) "Water temperature, raised to high value at t=3000 s"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
equation
  connect(hex.port_b1, res_1.port_a) annotation (Line(points={{80,32},{86,32},{
          86,60},{90,60}}, color={0,127,255}));
  connect(val.port_b, hex.port_a1) annotation (Line(points={{50,60},{54,60},{54,
          32},{60,32}}, color={0,127,255}));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-20,60},{30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{120,60},{110,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-60,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, res_2.port_a) annotation (Line(
      points={{-5.55112e-16,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-30},{186,-30},{186,16},{142,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-36},{148,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-30},{148,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,24},{142,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, con.u_s)    annotation (Line(
      points={{-19,100},{-2,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, con.u_m)    annotation (Line(
      points={{10,31},{10,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWat.y, sou_1.T_in) annotation (Line(
      points={{-59,64},{-42,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, val.y)    annotation (Line(
      points={{21,100},{40,100},{40,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.port_a, hex.port_b2) annotation (Line(
      points={{20,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryCoilCounterFlowPControl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a>.
The valve on the water-side is regulated to track a setpoint temperature
for the air outlet.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valve as
this parameter no longer has a default value.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCoilCounterFlowPControl;
