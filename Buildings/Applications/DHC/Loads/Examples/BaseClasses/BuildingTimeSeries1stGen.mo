within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries1stGen

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b (outlet)";

  parameter Real timSer_norHeaLoa[:, :]= [0, 1; 6, 1; 6, 0.25; 18, 0.25; 18, 0.375; 24, 0.375]
    "Normalized time series heating load";

  parameter Real QPea_flow_real= 200E3
    "Peak heat flow rate (real data type)";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    Medium_a.dewEnthalpy(Medium_a.setSat_p(pSte_nominal)) -
    Medium_a.bubbleEnthalpy(Medium_a.setSat_p(pSte_nominal))
    "Nominal change in enthalpy";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    QPea_flow_real/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)";

  Modelica.Blocks.Sources.CombiTimeTable QHea(
    table=timSer_norHeaLoa/QPea_flow_real,
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Applications.DHC.EnergyTransferStations.Heating1stGenIdeal ets(
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=200E3,
    pSte_nominal=pSte_nominal)
                          "Energy transfer station"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_a)
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=QPea_flow_real,
    duration(displayUnit="h") = 10800,
    startTime(displayUnit="h") = 21600)
    annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
equation
  connect(port_a, ets.port_a) annotation (Line(points={{100,40},{-40,40},{-40,0},
          {-10,0}}, color={0,127,255}));
  connect(ets.port_b, port_b) annotation (Line(points={{10,0},{60,0},{60,-40},{100,
          -40}}, color={0,127,255}));
  connect(ramp.y, Q_flow) annotation (Line(points={{-31,70},{36,70},{36,80},{
          110,80}}, color={0,0,127}));
  connect(ramp.y, ets.Q_flow) annotation (Line(points={{-31,70},{-22,70},{-22,6},
          {-12,6}}, color={0,0,127}));
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
          fillColor={255,0,0}),
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
end BuildingTimeSeries1stGen;
