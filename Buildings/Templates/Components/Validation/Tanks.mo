within Buildings.Templates.Components.Validation;
model Tanks "Validation model for tank components"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Liquid medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Volume V=
    60 * m_flow_nominal / Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Tank volume";
  Fluid.Sources.MassFlowSource_T sou(
    redeclare final package Medium = Medium,
    final m_flow=m_flow_nominal,
    T=303.15,
    nPorts=1)
    "Fluid source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Templates.Components.Tanks.Buffer tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    show_T=true,
    final V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Tank"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.Boundary_pT sin(redeclare final package Medium = Medium, nPorts=2)
          "Fluid sink" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,0})));
  Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal) "Volume flow rate"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Utilities.Math.IntegratorWithReset intFlo
    "Volume flow rate integrated over time"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Fluid.Sources.MassFlowSource_T sou1(
    redeclare final package Medium = Medium,
    final m_flow=m_flow_nominal,
    T=303.15,
    nPorts=1)
    "Fluid source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-60})));
  Buildings.Templates.Components.Tanks.Buffer noTan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    show_T=true,
    have_tan=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "No tank – Direct fluid pass through"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
equation
  connect(senVolFlo.port_b, tan.port_a)
    annotation (Line(points={{-30,0},{0,0}},   color={0,127,255}));
  connect(senVolFlo.V_flow, intFlo.u)
    annotation (Line(points={{-40,11},{-40,60},{-22,60}}, color={0,0,127}));
  connect(tan.port_b, sin.ports[1])
    annotation (Line(points={{20,0},{40,0},{40,-1},{60,-1}},
                                             color={0,127,255}));
  connect(sou.ports[1], senVolFlo.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(sou1.ports[1], noTan.port_a)
    annotation (Line(points={{-70,-60},{0,-60}}, color={0,127,255}));
  connect(noTan.port_b, sin.ports[2]) annotation (Line(points={{20,-60},{40,-60},
          {40,1},{60,1}}, color={0,127,255}));
annotation(
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Tanks.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=500),
    Documentation(info="<html>
<p> 
This model validates the models within 
<a href=\"modelica://Buildings.Templates.Components.Tanks\">
Buildings.Templates.Components.Tanks</a>.
</p>
</html>"));
end Tanks;
