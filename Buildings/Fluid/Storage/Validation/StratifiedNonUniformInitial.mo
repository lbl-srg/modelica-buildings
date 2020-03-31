within Buildings.Fluid.Storage.Validation;
model StratifiedNonUniformInitial
  "Test model for stratified tank with non-uniform initial temperature"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  constant Integer nSeg = 7 "Number of segments in tank";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1*1000/3600/4;

  Buildings.Fluid.Sources.Boundary_pT sou_1(
    p=300000 + 5000,
    T=273.15 + 40,
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=2)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T sin_1(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    m_flow=-m_flow_nominal,
    nPorts=1)
    "Mass flow source" annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Buildings.Fluid.Storage.Stratified heaTan(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    VTan=0.1,
    nSeg=nSeg,
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    TFlu_start={313.15,312.15,311.15,310.15,309.15,308.15,307.15})
    "Tank that will be heated up"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sin_2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Mass flow source" annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Buildings.Fluid.Storage.Stratified cooTan(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    VTan=0.1,
    nSeg=nSeg,
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    TFlu_start={313.15,312.15,311.15,310.15,309.15,308.15,307.15})
    "Tank that will be cooled down"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Buildings.Fluid.Sensors.EnthalpyFlowRate HIn_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{-58,-58},{-42,-42}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{2,-58},{18,-42}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HInEnh_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{-60,12},{-44,28}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOutEnh_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{2,12},{18,28}})));
  Modelica.Blocks.Math.Add add(k2=-1) "Adder for enthalpy difference"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Continuous.Integrator dHTanEnh
    "Difference in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Math.Add add1(k2=-1) "Adder for enthalpy difference"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Continuous.Integrator dHTan
    "Difference in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

equation
  connect(HIn_flow.port_b, cooTan.port_a) annotation (Line(
      points={{-42,-50},{-30,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooTan.port_b, HOut_flow.port_a) annotation (Line(
      points={{-10,-50},{2,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HOut_flow.port_b, sin_2.ports[1]) annotation (Line(
      points={{18,-50},{60,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HOutEnh_flow.port_b, sin_1.ports[1]) annotation (Line(
      points={{18,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HInEnh_flow.H_flow, add.u1) annotation (Line(
      points={{-52,28.8},{-52,56},{18,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HOutEnh_flow.H_flow, add.u2) annotation (Line(
      points={{10,28.8},{10,44},{18,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, dHTanEnh.u) annotation (Line(
      points={{41,50},{58,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HIn_flow.H_flow, add1.u1) annotation (Line(
      points={{-50,-41.2},{-50,-14},{18,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HOut_flow.H_flow, add1.u2) annotation (Line(
      points={{10,-41.2},{10,-26},{18,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, dHTan.u) annotation (Line(
      points={{41,-20},{58,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HInEnh_flow.port_b, heaTan.port_a)
    annotation (Line(points={{-44,20},{-30,20}}, color={0,127,255}));
  connect(heaTan.port_b, HOutEnh_flow.port_a)
    annotation (Line(points={{-10,20},{2,20}}, color={0,127,255}));
  connect(sou_1.ports[1], HInEnh_flow.port_a) annotation (Line(points={{-80,-8},
          {-70,-8},{-70,20},{-60,20}}, color={0,127,255}));
  connect(sou_1.ports[2], HIn_flow.port_a) annotation (Line(points={{-80,-12},{-70,
          -12},{-70,-50},{-58,-50}}, color={0,127,255}));

annotation (experiment(Tolerance=1e-6, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Validation/StratifiedNonUniformInitial.mos"
        "Simulate and plot"),
Documentation(info="<html>
This test model validates
<a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a> by specifying a non-uniform initial 
temperature. 
</html>", revisions="<html>
<ul>
<li>
November 13, 2019 by Jianjun Hu:<br/>
Changed the uniform initial tank temperature to be non-uniform.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1246\">#1246</a>.
</li>
</ul>
</html>"));
end StratifiedNonUniformInitial;
