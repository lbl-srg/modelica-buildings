within Buildings.Fluid.Storage.Plant;
model ChillerAndTankWithRemoteCharging
  "(Draft) Model of a plant with a chiller and a tank where the tank can be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.ChillerAndTank;

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl pum2Con
    "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{-140,58},{-120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput onOffLin
    "Plant online/offline signal, true = online, false = offline" annotation (
      Placement(transformation(extent={{-220,30},{-180,70}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    "Flow direction, true = normal, false = reverse" annotation (Placement(
        transformation(extent={{-220,70},{-180,110}}), iconTransformation(
          extent={{-140,50},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput set_mTan_flow
    "Tank mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-150,120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,110})));

  Buildings.Fluid.Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium,
    per(pressure(
          dp=dp_nominal*{2,1.2,0},
          V_flow=(m1_flow_nominal+m2_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal)
    "Secondary pump"
    annotation (Placement(transformation(
        extent={{-160,10},{-140,30}},
        rotation=0)));
  Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m1_flow_nominal+m2_flow_nominal)
    "Valve in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m2_flow_nominal) "Valve in parallel to the pump (reverse direction)"
    annotation (Placement(transformation(extent={{-120,-30},{-140,-10}})));
equation
  connect(booFloDir, pum2Con.booFloDir) annotation (Line(points={{-200,90},{-160,
          90},{-160,65.7},{-142,65.7}},      color={255,0,255}));
  connect(pum2Con.onOffLin, onOffLin) annotation (Line(points={{-142,61.3},{-142,
          50},{-200,50}},      color={255,0,255}));
  connect(jun1.port_1, val2.port_a) annotation (Line(points={{-90,0},{-94,0},{-94,
          -20},{-120,-20}}, color={0,127,255}));
  connect(val2.port_b, port_a) annotation (Line(points={{-140,-20},{-164,-20},{-164,
          0},{-180,0}}, color={0,127,255}));
  connect(val1.port_b, jun1.port_1) annotation (Line(points={{-100,20},{-94,20},
          {-94,0},{-90,0}}, color={0,127,255}));
  connect(val1.port_a, pum2.port_b)
    annotation (Line(points={{-120,20},{-140,20}}, color={0,127,255}));
  connect(pum2.port_a, port_a) annotation (Line(points={{-160,20},{-164,20},{-164,
          0},{-180,0}}, color={0,127,255}));
  connect(pum2Con.yPum2, pum2.y) annotation (Line(points={{-131,56.9},{-131,38},
          {-150,38},{-150,32}}, color={0,0,127}));
  connect(pum2Con.yVal2, val2.y) annotation (Line(points={{-127,56.9},{-127,-2},
          {-130,-2},{-130,-8}}, color={0,0,127}));
  connect(pum2Con.yVal1, val1.y) annotation (Line(points={{-123,56.9},{-110,56.9},
          {-110,32}}, color={0,0,127}));
  connect(pum2Con.um_mTan_flow, ideTan.m_flow) annotation (Line(points={{-141,
          76.7},{-142,76.7},{-142,78},{-170,78},{-170,-42},{-7,-42},{-7,-49}},
        color={0,0,127}));
  connect(pum2Con.us_mTan_flow, set_mTan_flow) annotation (Line(points={{-141,
          72.3},{-150,72.3},{-150,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -100},{140,100}}), graphics={Line(
          points={{-80,-20},{-20,-20}},
          color={28,108,200},
          pattern=LinePattern.Dash), Polygon(
          points={{-80,-20},{-60,-14},{-60,-26},{-80,-20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{140,
            100}})));
end ChillerAndTankWithRemoteCharging;
