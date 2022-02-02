within Buildings.Fluid.Storage.Plant;
model ChillerAndTankNoRemoteCharging
  "Model of a plant with a chiller and a tank where the tank cannot be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.ChillerAndTank;

  Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m_flow_nominal1 +
            m_flow_nominal2)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Controls.Continuous.LimPID conPIDPum2(
    Td=1,
    k=1,
    Ti=15)   "PI controller for the secondary pump"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-150,-30})));
  Modelica.Blocks.Math.Gain gain2(k=1/m_flow_nominal2) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,-30})));
  Modelica.Blocks.Sources.TimeTable setFloPum2(table=[0*3600,1; 0.25*3600,1; 0.25
        *3600,-1; 0.5*3600,-1; 0.5*3600,0; 0.75*3600,0; 0.75*3600,1; 1*3600,1])
    "Placeholder"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
equation
  connect(port_a, pum2.port_a)
    annotation (Line(points={{-180,0},{-140,0}}, color={0,127,255}));
  connect(pum2.port_b, jun1.port_1)
    annotation (Line(points={{-120,0},{-100,0}}, color={0,127,255}));
  connect(floSenTan.m_flow, gain2.u)
    annotation (Line(points={{-60,-49},{-60,-30},{-98,-30}}, color={0,0,127}));
  connect(gain2.y, conPIDPum2.u_m)
    annotation (Line(points={{-121,-30},{-138,-30}}, color={0,0,127}));
  connect(setFloPum2.y,conPIDPum2. u_s)
    annotation (Line(points={{-159,-70},{-150,-70},{-150,-42}},
                                                     color={0,0,127}));
  connect(conPIDPum2.y, pum2.y) annotation (Line(points={{-150,-19},{-150,18},{-130,
          18},{-130,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerAndTankNoRemoteCharging;
