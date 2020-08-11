within Buildings.Applications.DHC.Examples.FirstGeneration.BaseClasses;
model BuildingTimeSeriesCooling

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter Real QCooLoa[:, :]= [0, 1; 6, 1; 6, 0.25; 18, 0.25; 18, 0.375; 24, 0.375]
    "Time series cooling load, negative";

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate";

  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=QCooLoa,
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_a)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Fluid.MixingVolumes.MixingVolume           vol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_nominal=m_flow_nominal,
    V=V,
    T_start=TBuiSetPoi,
    nPorts=2)
          annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Interfaces.RealOutput dp "Pressure difference"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  EnergyTransferStations.CoolingDirectControlledReturn coo
    annotation (Placement(transformation(extent={{40,-20},{20,-40}})));
  Modelica.Blocks.Sources.Constant TSetDisRet_min(k=273.15 + 16)
    "Minimum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Fluid.Sensors.RelativePressure senRelPre annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-30})));
  Modelica.Blocks.Interfaces.RealOutput Q
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(points={{-30,10},{-20,10}}, color={191,0,0}));
  connect(QCoo.y[1], preHeaFlo.Q_flow)
    annotation (Line(points={{-59,10},{-50,10}}, color={0,0,127}));
  connect(coo.port_b2, senRelPre.port_b)
    annotation (Line(points={{40,-24},{40,-20},{70,-20}}, color={0,127,255}));
  connect(coo.port_a1, senRelPre.port_a)
    annotation (Line(points={{40,-36},{40,-40},{70,-40}}, color={0,127,255}));
  connect(coo.port_a2, vol.ports[1]) annotation (Line(points={{20,-24},{20,-20},
          {0,-20},{0,0},{-12,0}}, color={0,127,255}));
  connect(coo.port_b1, vol.ports[2]) annotation (Line(points={{20,-36},{20,-40},
          {-20,-40},{-20,0},{-8,0}}, color={0,127,255}));
  connect(coo.Q_flow, Q_flow) annotation (Line(points={{19,-45},{10,-45},{10,80},
          {110,80}}, color={0,0,127}));
  connect(TSetDisRet_min.y, coo.TSetDisRet) annotation (Line(points={{41,30},{52,
          30},{52,-18},{42,-18}}, color={0,0,127}));
  connect(senRelPre.p_rel, dp) annotation (Line(points={{79,-30},{90,-30},{90,40},
          {110,40}}, color={0,0,127}));
  connect(senRelPre.port_a, port_a) annotation (Line(points={{70,-40},{80,-40},{
          80,-60},{100,-60}}, color={0,127,255}));
  connect(senRelPre.port_b, port_b) annotation (Line(points={{70,-20},{80,-20},{
          80,0},{100,0}}, color={0,127,255}));
  connect(coo.Q, Q) annotation (Line(points={{19,-41},{14,-41},{14,60},{110,60}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          visible=not allowFlowReversal),
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-78,38},{80,38},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={28,108,200}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end BuildingTimeSeriesCooling;
