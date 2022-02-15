within Buildings.Fluid.Storage.Plant;
model ChillerAndTankWithRemoteCharging
  "(Draft) Model of a plant with a chiller and a tank where the tank can be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.ChillerAndTank;

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl pum2Con
    "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{-140,58},{-120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booOnOff
    "Plant status: true = online; false = offline" annotation (Placement(
        transformation(extent={{-202,28},{-180,50}}), iconTransformation(extent=
           {{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    "Flow direction: true = normal; false = reverse" annotation (Placement(
        transformation(extent={{-202,68},{-180,90}}),  iconTransformation(
          extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput set_mTan_flow
    "Tank mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-160,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m1_flow_nominal+m2_flow_nominal)
    "Valve in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m2_flow_nominal)
    "Valve in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{-120,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloDirPum2
    "Flow direction of secondary pump-valve group"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant conZero(k=0) "Constant y = 0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,70})));
equation
  connect(booFloDir, pum2Con.booFloDir) annotation (Line(points={{-191,79},{
          -172,79},{-172,65.7},{-142,65.7}}, color={255,0,255}));
  connect(pum2Con.booOnOff, booOnOff) annotation (Line(points={{-142,61.3},{-142,
          62},{-160,62},{-160,39},{-191,39}}, color={255,0,255}));
  connect(jun1.port_1, val2.port_a) annotation (Line(points={{-90,0},{-94,0},{-94,
          -20},{-120,-20}}, color={0,127,255}));
  connect(val2.port_b, port_a) annotation (Line(points={{-140,-20},{-164,-20},{-164,
          0},{-180,0}}, color={0,127,255}));
  connect(val1.port_b, jun1.port_1) annotation (Line(points={{-100,20},{-94,20},
          {-94,0},{-90,0}}, color={0,127,255}));
  connect(pum2Con.yVal2, val2.y) annotation (Line(points={{-127,56.9},{-127,-2},
          {-130,-2},{-130,-8}}, color={0,0,127}));
  connect(pum2Con.yVal1, val1.y) annotation (Line(points={{-123,56.9},{-110,56.9},
          {-110,32}}, color={0,0,127}));
  connect(pum2Con.um_mTan_flow, ideTan.m_flow) annotation (Line(points={{-141,76.7},
          {-142,76.7},{-142,78},{-170,78},{-170,-46},{-7,-46},{-7,-49}},
        color={0,0,127}));
  connect(pum2Con.us_mTan_flow, set_mTan_flow) annotation (Line(points={{-141,
          72.3},{-160,72.3},{-160,110}}, color={0,0,127}));
  connect(pum2.port_a, port_a) annotation (Line(points={{-160,20},{-164,20},{
          -164,0},{-180,0}}, color={0,127,255}));
  connect(pum2.port_b, val1.port_a)
    annotation (Line(points={{-140,20},{-120,20}}, color={0,127,255}));
  connect(pum2.y, pum2Con.yPum2) annotation (Line(points={{-150,32},{-150,50},{
          -131,50},{-131,56.9}}, color={0,0,127}));
  connect(swiFloDirPum2.u2, booFloDir) annotation (Line(points={{-50,82},{-50,88},
          {-174,88},{-174,79},{-191,79}}, color={255,0,255}));
  connect(swiFloDirPum2.u1, set_mPum1_flow) annotation (Line(points={{-42,82},{-42,
          96},{-50,96},{-50,110}}, color={0,0,127}));
  connect(pum1.m_flow_in, swiFloDirPum2.y)
    annotation (Line(points={{-50,52},{-50,58}}, color={0,0,127}));
  connect(conZero.y, swiFloDirPum2.u3) annotation (Line(points={{-90,81},{-90,86},
          {-58,86},{-58,82}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-80,-20},{-20,-20}},
          color={28,108,200},
          pattern=LinePattern.Dash), Polygon(
          points={{-80,-20},{-60,-14},{-60,-26},{-80,-20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{140,100}})));
end ChillerAndTankWithRemoteCharging;
