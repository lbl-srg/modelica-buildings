within Buildings.Fluid.Storage.Validation;
model StratifiedLoadingUnloading "Test model for stratified tank"
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
    m_flow=-0.028,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{78,-2},{58,18}})));

  Buildings.Fluid.Storage.StratifiedEnhanced tanEnh(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    VTan=0.1,
    nSeg=nSeg,
    show_T=true,
    m_flow_nominal=m_flow_nominal)
    "Tank"
    annotation (Placement(transformation(extent={{-30,-2},{-10,18}})));

  Buildings.Fluid.Sources.MassFlowSource_T sin_2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    m_flow=-0.028,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{78,-40},{58,-20}})));

  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    VTan=0.1,
    nSeg=nSeg,
    show_T=true,
    m_flow_nominal=m_flow_nominal)
    "Tank"
    annotation (Placement(transformation(extent={{-26,-40},{-6,-20}})));

  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=2*m_flow_nominal,
    offset=-m_flow_nominal,
    period=7200)
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Fluid.Sensors.EnthalpyFlowRate HIn_flow(
    redeclare package Medium =Medium,
    m_flow_nominal=m_flow_nominal)
    "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{-60,-38},{-44,-22}})));

  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow(
    redeclare package Medium =Medium, m_flow_nominal=m_flow_nominal)
    "Enthalpy flow rate"
   annotation (Placement(transformation(extent={{22,-38},{38,-22}})));

  Buildings.Fluid.Sensors.EnthalpyFlowRate HInEnh_flow(
    redeclare package Medium =
    Medium, m_flow_nominal=m_flow_nominal)
    "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-44,16}})));

  Buildings.Fluid.Sensors.EnthalpyFlowRate HOutEnh_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    "Enthalpy flow rate"
    annotation (Placement(transformation(extent={{2,0},{18,16}})));

  Modelica.Blocks.Math.Add add(
    k2=-1)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Modelica.Blocks.Continuous.Integrator dHTanEnh
    "Difference in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Modelica.Blocks.Math.Add add1(
  k2=-1)
  annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Modelica.Blocks.Continuous.Integrator dHTan
    "Difference in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

equation

  connect(sou_1.ports[1], HIn_flow.port_a)
    annotation (Line(points={{-80,-11},{-70,-11},{-70,-30},{-60,-30}},color={0,127,255},smooth=Smooth.None));

  connect(HIn_flow.port_b, tan.port_a)
    annotation (Line(points={{-44,-30},{-30,-30},{-30,-20},{-16,-20}},color={0,127,255},smooth=Smooth.None));

  connect(tan.port_b, HOut_flow.port_a)
    annotation (Line(points={{-16,-40},{4,-40},{4,-30},{22,-30}},color={0,127,255},smooth=Smooth.None));

  connect(HOut_flow.port_b, sin_2.ports[1])
    annotation (Line(points={{38,-30},{58,-30}},color={0,127,255},smooth=Smooth.None));

  connect(sou_1.ports[2], HInEnh_flow.port_a)
    annotation (Line(points={{-80,-9},{-76,-9},{-76,-6},{-72,-6},{-72,8},{-60,8}},color={0,127,255},smooth=Smooth.None));

  connect(HInEnh_flow.port_b, tanEnh.port_a)
    annotation (Line(points={{-44,8},{-32,8},{-32,18},{-20,18}},color={0,127,255},smooth=Smooth.None));

  connect(tanEnh.port_b, HOutEnh_flow.port_a)
    annotation (Line(points={{-20,-2},{-10,-2},{-10,8},{2,8}},color={0,127,255},smooth=Smooth.None));

  connect(HOutEnh_flow.port_b, sin_1.ports[1])
    annotation (Line(points={{18,8},{58,8}},color={0,127,255},smooth=Smooth.None));

  connect(HInEnh_flow.H_flow, add.u1)
    annotation (Line(points={{-52,16.8},{-52,56},{18,56}},color={0,0,127},smooth=Smooth.None));

  connect(HOutEnh_flow.H_flow, add.u2)
    annotation (Line(points={{10,16.8},{10,44},{18,44}},color={0,0,127},smooth=Smooth.None));

  connect(add.y, dHTanEnh.u)
    annotation (Line(points={{41,50},{58,50}},color={0,0,127},smooth=Smooth.None));

  connect(HIn_flow.H_flow, add1.u1)
    annotation (Line(points={{-52,-21.2},{-52,-14},{-34,-14},{-34,-64},{18,-64}},color={0,0,127},smooth=Smooth.None));

  connect(HOut_flow.H_flow, add1.u2)
    annotation (Line(points={{30,-21.2},{30,-16},{6,-16},{6,-76},{18,-76}},color={0,0,127},smooth=Smooth.None));

  connect(add1.y, dHTan.u)
    annotation (Line(points={{41,-70},{58,-70}},color={0,0,127},smooth=Smooth.None));

  connect(pulse.y, sin_1.m_flow_in)
    annotation (Line(points={{41,90},{92,90},{92,16},{80,16}},color={0,0,127},smooth=Smooth.None));

  connect(pulse.y, sin_2.m_flow_in)
    annotation (Line(points={{41,90},{90,90},{90,-22},{80,-22}},color={0,0,127},smooth=Smooth.None));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Validation/StratifiedLoadingUnloading.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This test model compares two tank models. The only difference between
the two tank models is that one uses the third order upwind discretization
scheme that reduces numerical diffusion that is induced when connecting
volumes in series.
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=14400));
end StratifiedLoadingUnloading;
