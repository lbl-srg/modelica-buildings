within Buildings.Fluid.HeatExchangers.Examples;
model PlateHeatExchangerEffectivenessNTUPControl
  "Model that demonstrates use of a plate heat exchanger without condensation that uses the epsilon-NTU relation with feedback control"
  extends Modelica.Icons.Example;

 package Medium1 = Buildings.Media.Water "Medium model for water";
 package Medium2 = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.Temperature T_a1_nominal=60 + 273.15
    "Temperature at nominal conditions as port a1";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=50 + 273.15
    "Temperature at nominal conditions as port b1";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=20 + 273.15
    "Temperature at nominal conditions as port a2";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=40 + 273.15
    "Temperature at nominal conditions as port b2";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=0.01
    "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*(
      T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p(displayUnit="Pa") = 300000,
    T=303.15,
    nPorts=1) "Boundary condition" annotation (Placement(transformation(extent={{-52,10},
            {-32,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    use_T_in=false,
    p(displayUnit="Pa") = 305000,
    T=T_a2_nominal) "Boundary condition"
    annotation (Placement(transformation(extent={{140,10},
            {120,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    use_p_in=false,
    p=300000,
    T=293.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{140,50},{120,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 9000,
    nPorts=1,
    use_T_in=false,
    T=T_a1_nominal)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium1,
    l=0.005,
    m_flow_nominal=m1_flow_nominal,
    dpFixed_nominal=2000 + 3000,
    dpValve_nominal=6000) "Valve"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.Continuous.LimPID P(
    Ti=30,
    k=0.1,
    Td=1)
    "Controller"
    annotation (Placement(transformation(extent={{-24,80},{-4,100}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=5,
    period=3600,
    offset=273.15 + 22) "Temperature setpoint"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal(displayUnit="Pa") = 0,
    dp2_nominal(displayUnit="Pa") = 3000,
    use_Q_flow_nominal=false,
    eps_nominal=0.5)
    "Heat exchanger"
     annotation (Placement(transformation(extent={{60,16},{80,36}})));

equation
  connect(val.port_b, hex.port_a1) annotation (Line(points={{50,60},
          {52,60},{52,32},{60,32}},        color={0,127,255}));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-30,60},{30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a) annotation (Line(
      points={{60,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, P.u_s) annotation (Line(
      points={{-49,90},{-26,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, P.u_m) annotation (Line(
      points={{30,31},{30,40},{-14,40},{-14,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P.y, val.y) annotation (Line(
      points={{-3,90},{40,90},{40,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{80,32},{100,32},{100,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, sin_2.ports[1]) annotation (Line(
      points={{20,20},{-32,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/PlateHeatExchangerEffectivenessNTUPControl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</a>.
The valve on the water-side is regulated to track a setpoint temperature
for the water outlet.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2018 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlateHeatExchangerEffectivenessNTUPControl;
