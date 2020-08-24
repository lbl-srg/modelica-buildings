within Buildings.Applications.DHC.Examples.Cooling.BaseClasses;
model BuildingTimeSeriesCooling

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate, negative";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Boolean use_inputFilter=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));

  // ets parameters
  parameter Modelica.SIunits.Temperature TSetDisRet = 273.15+16
    "Minimum setpoint temperature for district return"
    annotation (Dialog(group="Energy transfer station"));

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of district cooling side"
    annotation (Dialog(group="Energy transfer station"));

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)=Q_flow_nominal/(cp*(7 - 16))
    "Nominal mass flow rate of building cooling side"
    annotation (Dialog(group="Energy transfer station"));

  parameter Modelica.SIunits.MassFlowRate mByp_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate through the bypass segment"
    annotation (Dialog(group="Energy transfer station"));

  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // table parameters
  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation (Dialog(group="Table data definition"));

  parameter Modelica.SIunits.Power QCooLoa[:, :]= [0, -20E3; 6, -30E3; 12, -50E3; 18, -30E3; 24, -20E3]
    "Cooling load table matrix, negative"
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

  parameter Integer columns[:]=2:size(QCooLoa, 2)
    "Columns of table to be interpolated"
    annotation (Dialog(group="Table data interpretation"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));

  parameter Modelica.SIunits.Time timeScale=3600
    "Time scale of first table column"
    annotation (Dialog(group="Table data interpretation"), Evaluate=true);

  // Diagnostics
  parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa") "Pressure difference"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput ECoo(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    tableOnFile=false,
    table=QCooLoa,
    tableName=tableName,
    fileName=fileName,
    columns=columns,
    smoothness=smoothness,
    timeScale=timeScale)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Applications.DHC.EnergyTransferStations.Cooling.CoolingDirectControlledReturn ets(
    redeclare package Medium = Medium,
    mDis_flow_nominal=mDis_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    mByp_flow_nominal=mByp_flow_nominal)
    "Energy transfer station"
    annotation (Placement(transformation(extent={{50,-20},{30,-40}})));

  Modelica.Blocks.Sources.Constant TSetDisRet_min(k=TSetDisRet)
    "Minimum setpoint temperature for district return"
    annotation (Placement(transformation(extent={{70,0},{50,20}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = Medium)
    "Pressure difference measurement"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-30})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare replaceable package Medium = Medium,
    energyDynamics=energyDynamics,
    m_flow_nominal=mBui_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=use_inputFilter,
    constantMassFlowRate=mBui_flow_nominal)
    "Building primary pump"
    annotation (Placement(transformation(extent={{10,-40},{-10,-20}})));
  Modelica.Blocks.Math.Gain m_flow(k=-1/(cp*(16 - 7)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=energyDynamics,
    m_flow_nominal=mBui_flow_nominal,
    V=mBui_flow_nominal*tau/rho_default,
    nPorts=2) "Building volume"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFlo "Heat flow"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Modelica.Blocks.Math.Gain heaGai(k=-1)
    "Multiplier for calculating heat gain of the volume"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

equation
  connect(ets.port_b2, senRelPre.port_b) annotation (Line(points={{50,-24},{50,-20},
          {70,-20}},                                                                           color={0,127,255}));
  connect(ets.port_a1, senRelPre.port_a) annotation (Line(points={{50,-36},{50,-40},
          {70,-40}},                                                                           color={0,127,255}));
  connect(ets.Q_flow, Q_flow) annotation (Line(points={{29,-45},{20,-45},{20,80},
          {110,80}}, color={0,0,127}));
  connect(senRelPre.p_rel, dp) annotation (Line(points={{79,-30},{90,-30},{90,40},
          {110,40}}, color={0,0,127}));
  connect(senRelPre.port_a, port_a) annotation (Line(points={{70,-40},{80,-40},{
          80,-60},{100,-60}}, color={0,127,255}));
  connect(senRelPre.port_b, port_b) annotation (Line(points={{70,-20},{80,-20},{
          80,0},{100,0}}, color={0,127,255}));
  connect(ets.Q, ECoo) annotation (Line(points={{29,-41},{24,-41},{24,60},{110,60}},
        color={0,0,127}));
  connect(ets.port_b1, pum.port_a) annotation (Line(points={{30,-36},{20,-36},{20,-30},{10,-30}},
                                                  color={0,127,255}));
  connect(pum.port_b, vol.ports[1]) annotation (Line(points={{-10,-30},{-16,-30},
          {-16,20},{-2,20}},  color={0,127,255}));
  connect(vol.ports[2], ets.port_a2) annotation (Line(points={{2,20},{16,20},{16,
          -24},{30,-24}}, color={0,127,255}));
  connect(heaFlo.port, vol.heatPort) annotation (Line(points={{-20,30},{-10,30}}, color={191,0,0}));
  connect(TSetDisRet_min.y, ets.TSetDisRet) annotation (Line(points={{49,10},{44,
          10},{44,-10},{60,-10},{60,-18},{52,-18}}, color={0,0,127}));
  connect(m_flow.y, pum.m_flow_in) annotation (Line(points={{-49,-10},{0,-10},{0,-18}}, color={0,0,127}));
  connect(heaGai.y, heaFlo.Q_flow) annotation (Line(points={{-49,30},{-40,30}}, color={0,0,127}));
  connect(QCoo.y[1], heaGai.u) annotation (Line(points={{-79,30},{-72,30}}, color={0,0,127}));
  connect(QCoo.y[1], m_flow.u) annotation (Line(points={{-79,30},{-76,30},{-76,-10},
          {-72,-10}}, color={0,0,127}));
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
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands);
end BuildingTimeSeriesCooling;
