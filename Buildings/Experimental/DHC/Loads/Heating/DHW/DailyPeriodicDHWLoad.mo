within Buildings.Experimental.DHC.Loads.Heating.DHW;
model DailyPeriodicDHWLoad "A model for a daily periodic domestic water draw"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal "Nominal doemstic hot water flow rate";

  Modelica.Fluid.Interfaces.FluidPort_a port_tw(redeclare package Medium = Medium) "Port for tempered water supply"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Fluid.Sources.MassFlowSource_T sinDhw(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for domestic hot water supply"
    annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
  Modelica.Blocks.Math.Gain gaiDhw(k=-mDhw_flow_nominal) "Gain for multiplying domestic hot water schedule"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Modelica.Blocks.Sources.CombiTimeTable schDhw(
    tableOnFile=false,
    table=[0,0.1; 3600*1,1e-5; 3600*2,1e-5; 3600*3,1e-5; 3600*4,1e-5; 3600*5,0.3;
        3600*6,0.9; 3600*7,1; 3600*8,1; 3600*9,0.8; 3600*10,0.8; 3600*11,0.6; 3600
        *12,0.5; 3600*13,0.5; 3600*14,0.4; 3600*15,0.5; 3600*16,0.6; 3600*17,0.7;
        3600*18,0.9; 3600*19,0.8; 3600*20,0.8; 3600*21,0.6; 3600*22,0.5; 3600*23,
        0.3; 3600*24,0.1],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Domestic hot water fraction schedule"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Continuous.Integrator watCon(k=-1) "Integrated hot water consumption"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput mDhw "Total hot water consumption"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
equation
  connect(gaiDhw.y,sinDhw. m_flow_in) annotation (Line(points={{39,20},{-20,20},
          {-20,8},{-44,8}},      color={0,0,127}));
  connect(watCon.u,gaiDhw. y) annotation (Line(points={{38,-80},{20,-80},{20,20},
          {39,20}},       color={0,0,127}));
  connect(watCon.y, mDhw)
    annotation (Line(points={{61,-80},{110,-80}}, color={0,0,127}));
  connect(sinDhw.ports[1], port_tw)
    annotation (Line(points={{-66,0},{-100,0}}, color={0,127,255}));
  connect(schDhw.y[1], gaiDhw.u)
    annotation (Line(points={{79,20},{62,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-7.728,38.2054},{-25.772,18.1027},{-25.772,-24.6152},{0,
              -57.2823},{25.772,-24.6152},{25.772,18.1027},{7.728,38.2054},{0,
              53.2823},{-7.728,38.2054}},
          lineColor={28,108,200},
          lineThickness=0.5,
          smooth=Smooth.Bezier,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=1),
      Text(
          extent={{-147,143},{153,103}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DailyPeriodicDHWLoad;
