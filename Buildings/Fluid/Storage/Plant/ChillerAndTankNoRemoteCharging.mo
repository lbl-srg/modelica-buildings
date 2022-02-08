within Buildings.Fluid.Storage.Plant;
model ChillerAndTankNoRemoteCharging
  "(Draft) Model of a plant with a chiller and a tank where the tank cannot be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.ChillerAndTank;

  Buildings.Fluid.Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium,
    per(pressure(
          dp=dp_nominal*{2,1.2,0},
          V_flow=(m1_flow_nominal+m2_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Buildings.Controls.Continuous.LimPID conPIDPum2(
    Td=1,
    k=1,
    Ti=15)   "PI controller for the secondary pump"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-150,70})));
  Modelica.Blocks.Math.Gain gain2(k=1/m2_flow_nominal) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-150,30})));
  Modelica.Blocks.Interfaces.RealInput usMasFloPum2
    "Secondary pump mass flow rate setpoint" annotation (Placement(
        transformation(extent={{-204,58},{-180,82}}), iconTransformation(extent={{-120,50},
            {-100,70}})));
equation
  connect(port_a, pum2.port_a)
    annotation (Line(points={{-180,0},{-140,0}}, color={0,127,255}));
  connect(pum2.port_b, jun1.port_1)
    annotation (Line(points={{-120,0},{-90,0}},  color={0,127,255}));
  connect(gain2.y, conPIDPum2.u_m)
    annotation (Line(points={{-150,41},{-150,58}},   color={0,0,127}));
  connect(conPIDPum2.y, pum2.y) annotation (Line(points={{-139,70},{-130,70},{
          -130,12}},      color={0,0,127}));
  connect(usMasFloPum2, conPIDPum2.u_s)
    annotation (Line(points={{-192,70},{-162,70}}, color={0,0,127}));
  connect(ideTan.m_flow, gain2.u) annotation (Line(points={{-7,-49},{-8,-49},{-8,
          -40},{-150,-40},{-150,18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})));
end ChillerAndTankNoRemoteCharging;
