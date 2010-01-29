within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachine
  import Buildings;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}}), graphics),
    Commands(file="ControlledFlowMachine.mos" "run"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
All flow models have the same mass flow rate and pressure difference.
</html>"));
  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Modelica.Blocks.Sources.Ramp y(
    duration=1,
    offset=1,
    height=-0.6) annotation (Placement(transformation(extent={{-100,70},{-80,90}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=8,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15) annotation (Placement(transformation(extent={{-100,8},{-80,28}},
          rotation=0)));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat1(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Fluid.Sensors.RelativePressure relPre(redeclare package Medium = 
        Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={4,32})));
  Buildings.Fluid.Movers.FlowMachine_y fan1(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    redeclare function efficiencyCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.constantEfficiency (
          eta_nominal=0.8),
    V=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-6,50},{14,70}})));
  FixedResistances.FixedResistanceDpM dp1(
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=600,
    redeclare package Medium = Medium) "Pressure drop" 
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  FixedResistances.FixedResistanceDpM dp2(
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=600,
    redeclare package Medium = Medium) "Pressure drop" 
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat2(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{-46,-30},{-26,-10}})));
  FixedResistances.FixedResistanceDpM dp3(
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=600,
    redeclare package Medium = Medium) "Pressure drop" 
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat3(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));
  FlowMachine_dp fan3(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    redeclare function efficiencyCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.constantEfficiency (
          eta_nominal=0.8),
    m_flow_nominal=6000/3600*1.2,
    V=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  FlowMachine_m_flow fan2(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    redeclare function efficiencyCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.constantEfficiency (
          eta_nominal=0.8),
    m_flow_nominal=6000/3600*1.2,
    V=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-6,-30},{14,-10}})));
  FixedResistances.FixedResistanceDpM dp4(
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=600,
    redeclare package Medium = Medium) "Pressure drop" 
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat4(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  FlowMachine_Nrpm fan4(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    redeclare function efficiencyCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.constantEfficiency (
          eta_nominal=0.8),
    V=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-6,100},{14,120}})));
  Modelica.Blocks.Math.Gain gain(k=1500) "Converts y to nominal rpm" 
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(startTime=0.01)
    "Asserts the equality of the input signals" 
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(startTime=0.01)
    "Asserts the equality of the input signals" 
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu2(startTime=0.01)
    "Asserts the equality of the input signals" 
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
equation

  annotation (Diagram);
  connect(y.y, fan1.y_in) annotation (Line(
      points={{-79,80},{4,80},{4,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp2.port_b, sou.ports[1]) annotation (Line(
      points={{60,-20},{80,-20},{80,-40},{-72,-40},{-72,21.5},{-80,21.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_a, relPre.port_b) annotation (Line(
      points={{-6,60},{-6,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, relPre.port_a) annotation (Line(
      points={{14,60},{14,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp3.port_b, sou.ports[2]) annotation (Line(
      points={{60,-60},{80,-60},{80,-78},{-78,-78},{-78,20.5},{-80,20.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(relPre.p_rel, fan3.dp_set) annotation (Line(
      points={{4,23},{4,8},{-16,8},{-16,-38},{9,-38},{9,-51.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloRat1.port_b, fan1.port_a) annotation (Line(
      points={{-30,40},{-14,40},{-14,60},{-6,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat1.port_a, sou.ports[3]) annotation (Line(
      points={{-50,40},{-66,40},{-66,19.5},{-80,19.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, dp1.port_a) annotation (Line(
      points={{14,60},{40,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, dp2.port_a) annotation (Line(
      points={{14,-20},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_b, dp3.port_a) annotation (Line(
      points={{14,-60},{40,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_a, masFloRat3.port_b) annotation (Line(
      points={{-6,-60},{-26,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_a, masFloRat2.port_b) annotation (Line(
      points={{-6,-20},{-26,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat2.port_a, sou.ports[4]) annotation (Line(
      points={{-46,-20},{-68,-20},{-68,18.5},{-80,18.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat3.port_a, sou.ports[5]) annotation (Line(
      points={{-46,-60},{-70,-60},{-70,17.5},{-80,17.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat1.m_flow, fan2.m_flow_set) annotation (Line(
      points={{-40,51},{-40,60},{-20,60},{-20,2},{-1,2},{-1,-11.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp1.port_b, sou.ports[6]) annotation (Line(
      points={{60,60},{80,60},{80,14},{-80,14},{-80,16.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat4.port_a, sou.ports[7]) annotation (Line(
      points={{-40,110},{-66,110},{-66,15.5},{-80,15.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat4.port_b, fan4.port_a) annotation (Line(
      points={{-20,110},{-6,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan4.port_b, dp4.port_a) annotation (Line(
      points={{14,110},{40,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp4.port_b, sou.ports[8]) annotation (Line(
      points={{60,110},{80,110},{80,14.5},{-80,14.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, fan4.N_in) annotation (Line(
      points={{-39,140},{4,140},{4,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, y.y) annotation (Line(
      points={{-62,140},{-70,140},{-70,80},{-79,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu.u1, masFloRat4.m_flow) annotation (Line(
      points={{118,136},{-30,136},{-30,121}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloRat1.m_flow, assEqu.u2) annotation (Line(
      points={{-40,51},{-40,86},{100,86},{100,124},{118,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu1.u1, masFloRat1.m_flow) annotation (Line(
      points={{118,76},{100,76},{100,86},{-40,86},{-40,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu1.u2, masFloRat2.m_flow) annotation (Line(
      points={{118,64},{100,64},{100,-2},{-36,-2},{-36,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu2.u1, masFloRat2.m_flow) annotation (Line(
      points={{118,-4},{100,-4},{100,-2},{-36,-2},{-36,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEqu2.u2, masFloRat3.m_flow) annotation (Line(
      points={{118,-16},{100,-16},{100,-44},{-36,-44},{-36,-49}},
      color={0,0,127},
      smooth=Smooth.None));
end ControlledFlowMachine;
