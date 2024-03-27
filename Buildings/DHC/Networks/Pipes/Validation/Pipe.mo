within Buildings.DHC.Networks.Pipes.Validation;
model Pipe "Validates the PipeAutosize model initialization"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Real dp1_length_nominal(final unit="Pa/m") = 1000 "Pressure drop per unit length 1";
  parameter Real dp2_length_nominal(final unit="Pa/m") = 0.1 "Pressure drop per unit length 2";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal = 0.01 "Nominal mass flow rate 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal = 1000 "Nominal mass flow rate 2";
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare final package Medium = Medium,
   nPorts=4) "Sink for water flow" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
  Buildings.DHC.Networks.Pipes.PipeStandard pipSta1(
    redeclare final package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dh=0.00548,
    length=100) "Pipe 1 with standard hydraulic diameter"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souSta1(
    redeclare final package Medium = Medium,
    m_flow=m1_flow_nominal,
    nPorts=1) "Source of water flow for standard pipe 1"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAut2(
    redeclare final package Medium = Medium,
    m_flow=m2_flow_nominal,
    nPorts=1) "Source of water flow for autosized pipe 2"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.DHC.Networks.Pipes.PipeAutosize pipAut2(
    redeclare final package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    dp_length_nominal=dp2_length_nominal,
    length=100) "Pipe 2 with autosized hydraulic diameter"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Fluid.Sources.MassFlowSource_T souAut1(
    redeclare final package Medium = Medium,
    m_flow=m1_flow_nominal,
    nPorts=1) "Source of water flow for autosized pipe 1"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Pipes.PipeAutosize pipAut1(
    redeclare final package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_length_nominal=dp1_length_nominal,
    length=100) "Pipe 1 with autosized hydraulic diameter"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Pipes.PipeStandard pipSta2(
    redeclare final package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    dh=2.943,
    length=100) "Pipe 2 with standard hydraulic diameter"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Fluid.Sources.MassFlowSource_T souSta2(
    redeclare final package Medium = Medium,
    m_flow=m2_flow_nominal,
    nPorts=1) "Source of water flow for standard pipe 2"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(souSta1.ports[1], pipSta1.port_a)
    annotation (Line(points={{-40,-20},{-10,-20}}, color={0,127,255}));
  connect(souAut2.ports[1], pipAut2.port_a)
    annotation (Line(points={{-40,20},{-10,20}}, color={0,127,255}));
  connect(souAut1.ports[1], pipAut1.port_a)
    annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
  connect(souSta2.ports[1], pipSta2.port_a)
    annotation (Line(points={{-40,-60},{-10,-60}}, color={0,127,255}));
  connect(pipAut1.port_b, sin.ports[1])
    annotation (Line(points={{10,60},{40,60},{40,1.5}}, color={0,127,255}));
  connect(pipAut2.port_b, sin.ports[2]) annotation (Line(points={{10,20},{20,20},
          {20,0.5},{40,0.5}}, color={0,127,255}));
  connect(pipSta1.port_b, sin.ports[3]) annotation (Line(points={{10,-20},{20,-20},
          {20,-0.5},{40,-0.5}}, color={0,127,255}));
  connect(pipSta2.port_b, sin.ports[4])
    annotation (Line(points={{10,-60},{40,-60},{40,-1.5}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Validation model for <a href=\"modelica://Buildings.DHC.Networks.Pipes.PipeAutosize\">
Buildings.DHC.Networks.Combined.BaseClasses.PipeAutosize</a>
for range of flow rates and pressure drops per unit length.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2023, by Ettore Zanetti:<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
November 18, 2022 by David Blum:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2510\">issue 2510</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Networks/Pipes/Validation/Pipe.mos"
        "Simulate and plot"),
experiment(
      StopTime=1,
      Tolerance=1e-06));
end Pipe;
