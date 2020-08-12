within Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses;
model BuildingTimeSeriesHeating

  replaceable package Medium_a =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_b (outlet)";

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    Medium_a.enthalpyOfVaporization_sat(Medium_a.saturationState_p(pSte_nominal))
    "Nominal change in enthalpy";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  // Table parameters
  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation (Dialog(group="Table data definition"));
  parameter Real QHeaLoa[:, :] = fill(0.0, 0, 2)
    "Table matrix (time = first column; e.g., table=[0, 0; 1, 1; 2, 4])"
    annotation (Dialog(group="Table data definition",enable=not tableOnFile));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(group="Table data definition",enable=tableOnFile));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]=2:size(QHeaLoa, 2)
    "Columns of table to be interpolated"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.SIunits.Time timeScale(
    min=Modelica.Constants.eps)=1 "Time scale of first table column"
    annotation (Dialog(group="Table data interpretation"), Evaluate=true);

  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Medium_a.ThermodynamicState sta_a=
      Medium_a.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";

  Medium_b.ThermodynamicState sta_b=
      Medium_b.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";

  Modelica.Blocks.Sources.CombiTimeTable QHea(
    tableOnFile=tableOnFile,
    table=QHeaLoa,
    tableName=tableName,
    fileName=fileName,
    columns=columns,
    smoothness=smoothness,
    timeScale=timeScale)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Applications.DHC.EnergyTransferStations.Heating.Generation1.Heating1stGenIdeal ets(
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte_nominal)
                          "Energy transfer station"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium_a)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium_b)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Sources.Ramp ram(duration=120)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Product pro
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Continuous.Integrator IntEHea(y(unit="J"))
    "Integrator for heating energy of building"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Interfaces.RealOutput EHea(
    final quantity="HeatFlow",
    final unit="J",
    displayUnit="kWh") "Total heating energy" annotation (Placement(
        transformation(extent={{100,40},{120,60}}), iconTransformation(extent={
            {100,40},{120,60}})));
equation
  connect(port_a, ets.port_a) annotation (Line(points={{100,-60},{0,-60},{0,0},
          {40,0}},  color={0,127,255}));
  connect(ets.port_b, port_b) annotation (Line(points={{60,0},{100,0}},
                 color={0,127,255}));
  connect(QHea.y[1], pro.u1) annotation (Line(points={{-59,70},{-50,70},{-50,56},
          {-42,56}}, color={0,0,127}));
  connect(ram.y, pro.u2) annotation (Line(points={{-59,30},{-50,30},{-50,44},{
          -42,44}}, color={0,0,127}));
  connect(pro.y, Q_flow) annotation (Line(points={{-19,50},{0,50},{0,80},{110,
          80}}, color={0,0,127}));
  connect(pro.y, ets.Q_flow)
    annotation (Line(points={{-19,50},{0,50},{0,6},{38,6}}, color={0,0,127}));
  connect(pro.y, IntEHea.u)
    annotation (Line(points={{-19,50},{58,50}}, color={0,0,127}));
  connect(Q_flow, Q_flow) annotation (Line(points={{110,80},{107,80},{107,80},{
          110,80}}, color={0,0,127}));
  connect(IntEHea.y, EHea) annotation (Line(points={{81,50},{96,50},{96,50},{
          110,50}}, color={0,0,127}));
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
end BuildingTimeSeriesHeating;
