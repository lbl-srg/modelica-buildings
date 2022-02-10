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
  Modelica.Blocks.Interfaces.RealInput yPum2 "Secondary pump speed input"
    annotation (Placement(transformation(extent={{-204,58},{-180,82}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow "Mass flow rate" annotation (
     Dialog(group="Time varying output signal"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-110}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-110})));
equation
  connect(port_a, pum2.port_a)
    annotation (Line(points={{-180,0},{-140,0}}, color={0,127,255}));
  connect(pum2.port_b, jun1.port_1)
    annotation (Line(points={{-120,0},{-90,0}},  color={0,127,255}));
  connect(ideTan.m_flow, m_flow) annotation (Line(points={{-7,-49},{-7,-46},{
          -40,-46},{-40,-110}}, color={0,0,127}));
  connect(pum2.y, yPum2)
    annotation (Line(points={{-130,12},{-130,70},{-192,70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})));
end ChillerAndTankNoRemoteCharging;
