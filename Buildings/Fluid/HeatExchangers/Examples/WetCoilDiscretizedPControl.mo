within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilDiscretizedPControl
  "Model that demonstrates use of a finite volume model of a heat exchanger with condensation and feedback control"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Air;

  parameter Modelica.SIunits.Temperature T_a1_nominal = 5+273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = 10+273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 30+273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal = 10+273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 5
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
    "Nominal mass flow rate medium 2";

 Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p=101325,
    T=303.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-26},
            {-38,-6}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    use_T_in=true,
    p(displayUnit="Pa") = 101525,
    T=293.15)             annotation (Placement(transformation(extent={{160,8},
            {140,28}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{160,40},
            {140,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_T_in=true,
    p=300000 + 7000,
    T=278.15)             annotation (Placement(transformation(extent={{-24,38},
            {-4,58}})));
    Modelica.Blocks.Sources.Ramp PSin(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000)
                 annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{40,-26},{20,-6}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    use_inputFilter=false,
    dpFixed_nominal=2000,
    dpValve_nominal=5000)
    annotation (Placement(transformation(extent={{18,38},{38,58}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,293.15; 600,293.15; 600,
        288.15; 1200,288.15; 1800,288.15; 2400,295.15; 2400,295.15])
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Fluid.HeatExchangers.WetCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    nPipPar=1,
    nPipSeg=3,
    nReg=4,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal)/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    dp2_nominal(displayUnit="Pa") = 200,
    dp1_nominal(displayUnit="Pa") = 0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                         annotation (Placement(transformation(extent={{60,16},{
            80,36}})));
  Modelica.Blocks.Sources.Step TSou_2(
    startTime=3000,
    offset=T_a2_nominal,
    height=-3)
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Modelica.Blocks.Sources.Step TSou_1(
    startTime=3000,
    height=10,
    offset=T_a1_nominal)
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
  Buildings.Controls.Continuous.LimPID con(
    k=1,
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Td=60,
    reverseActing=false) "Controller"  annotation (Placement(transformation(
          extent={{-40,120},{-20,140}})));
  Buildings.Fluid.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
equation
  connect(PSin.y, sin_1.p_in)   annotation (Line(points={{161,90},{180,90},{180,
          58},{162,58}}, color={0,0,127}));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{140,18},{140,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a)      annotation (Line(
      points={{60,20},{48,20},{48,-16},{40,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val.port_b, hex.port_a1) annotation (Line(
      points={{38,48},{42,48},{42,32},{60,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-4,48},{18,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSou_2.y, sou_2.T_in) annotation (Line(
      points={{161,-30},{178,-30},{178,22},{162,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSou_1.y, sou_1.T_in) annotation (Line(
      points={{-39,52},{-26,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, con.u_s)
    annotation (Line(
      points={{-59,130},{-42,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, con.u_m)
    annotation (Line(
      points={{30,-5},{30,8},{10,8},{10,100},{-30,100},{-30,118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, mot.u)
    annotation (Line(
      points={{-19,130},{-2,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mot.y, val.y) annotation (Line(
      points={{21,130},{28,130},{28,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sin_2.ports[1], temSen.port_b) annotation (Line(
      points={{-38,-16},{20,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{80,32},{112,32},{112,50},{140,50}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {200,200}}),       graphics),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilDiscretizedPControl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>.
The valve on the water-side is regulated to track a setpoint temperature
for the air outlet.
</p>
<p>
Note that between the controller output and the valve is a model of a motor
that has hysteresis. The events generated by the motor model can lead to a
significantly higher computing time. In most applications, this level
of modeling detail is not justified.
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
July 3, 2014, by Michael Wetter:<br/>
Changed pressure sink to mass flow rate sink to avoid an overdetermined
by consistent set of initial conditions.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valve as
this parameter no longer has a default value.
</li>
<li>
August 13, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilDiscretizedPControl;
