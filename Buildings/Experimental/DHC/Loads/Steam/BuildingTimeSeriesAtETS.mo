within Buildings.Experimental.DHC.Loads.Steam;
model BuildingTimeSeriesAtETS
  "Steam heating building interconnection with the district piping only 
  (building side is not modeled) with the load at the ETS provided as a 
  time series."
  extends DES.Heating.Interfaces.PartialSteamWaterPhaseChange;

  // Nominal condition
  parameter Modelica.SIunits.Power Q_flow_nominal(start=1000)
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dhVapStd
    "Nominal mass flow rate";

  // Condensate subsystem
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput,
      tab = "Condensate Subsystem", group="Pump Controller"));

  // Heating load
  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation (Dialog(tab = "Load Profile", group="Table data definition"));
  parameter Real QHeaLoa[:, :] = fill(0.0, 0, 2)
    "Table matrix (time = first column; e.g., table=[0, 0; 1, 1; 2, 4])"
    annotation (Dialog(tab = "Load Profile", group="Table data definition",enable=not tableOnFile));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(tab = "Load Profile", group="Table data definition",enable=tableOnFile));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(
      tab = "Load Profile",
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Integer columns[:]=2:size(QHeaLoa, 2)
    "Columns of table to be interpolated"
    annotation (Dialog(tab = "Load Profile", group="Table data interpretation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(tab = "Load Profile", group="Table data interpretation"));
  parameter Modelica.SIunits.Time timeScale(
    min=Modelica.Constants.eps)=1 "Time scale of first table column"
    annotation (Dialog(tab = "Load Profile", group="Table data interpretation"), Evaluate=true);

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  MediumSte.ThermodynamicState sta_a=
      MediumSte.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";

  MediumWat.ThermodynamicState sta_b=
      MediumWat.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";

  parameter Modelica.SIunits.Density rho_a_default=
    MediumSte.density(MediumSte.setState_pTX(
      p=pSat,T=TSat,X=MediumSte.X_default))
    "Default steam density"
    annotation(Dialog(tab="Advanced",group="Nominal condition"));
  parameter Modelica.SIunits.Density rho_b_default=
    MediumWat.density(MediumWat.setState_pTX(
      p=101325,T=273.15+90,X=MediumWat.X_default))
    "Default water density"
    annotation(Dialog(tab="Advanced",group="Nominal condition"));

  Modelica.Blocks.Sources.CombiTimeTable QHea(
    tableOnFile=tableOnFile,
    table=QHeaLoa,
    tableName=tableName,
    fileName=fileName,
    columns=columns,
    smoothness=smoothness,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=timeScale)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumSte)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumWat)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Continuous.Integrator IntEHea(y(unit="J"))
    "Integrator for heating energy of building"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Interfaces.RealOutput EHea(
    final quantity="HeatFlow",
    final unit="J",
    displayUnit="kWh") "Total heating energy" annotation (Placement(
        transformation(extent={{100,40},{120,60}}), iconTransformation(extent={
            {100,40},{120,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCNR(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    m_flow_start=0.8*m_flow_nominal)
    "Condensate return pump"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  CentralPlants.BaseClasses.MixingVolumeCondensation
                                       vol(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=pSat,
    T_start=TSat,
    pSat=pSat,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    V=V)
    "Volume"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-70}})));
  DES.Heating.Loads.BaseClasses.SteamTrap steTra(
    redeclare package Medium = MediumWat,
    final m_flow_nominal=m_flow_nominal,
    show_T=show_T) "Steam trap"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  parameter Modelica.SIunits.Volume V=1 "Total volume";
  Buildings.Fluid.Sensors.SpecificEntropy s_a(redeclare package Medium =
        MediumSte) "Specific enthlapy at port a"
    annotation (Placement(transformation(extent={{90,-10},{70,-30}})));
  Buildings.Fluid.Sensors.SpecificEntropy s_b(redeclare package Medium =
        MediumWat) "Specific enthlapy at port b"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-90}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hIn(redeclare package Medium =
        MediumSte, m_flow_nominal=m_flow_nominal) "Enthalpy in"
    annotation (Placement(transformation(extent={{0,10},{-20,-10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hOut(redeclare package Medium =
        MediumWat, m_flow_nominal=m_flow_nominal) "Enthalpy out"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Add dh(k2=-1)
    "Change in enthalpy with building-side fluid"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Math.Division m_flow "Mass flow"
    annotation (Placement(transformation(extent={{32,-34},{52,-14}})));
equation
  connect(Q_flow, Q_flow) annotation (Line(points={{110,80},{107,80},{107,80},{
          110,80}}, color={0,0,127}));
  connect(IntEHea.y, EHea) annotation (Line(points={{81,50},{96,50},{96,50},{
          110,50}}, color={0,0,127}));
  connect(QHea.y[1], Q_flow) annotation (Line(points={{-59,70},{20,70},{20,80},{
          110,80}}, color={0,0,127}));
  connect(IntEHea.u, Q_flow) annotation (Line(points={{58,50},{20,50},{20,80},{110,
          80}}, color={0,0,127}));
  connect(pumCNR.port_b, port_b)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  connect(steTra.port_b, pumCNR.port_a)
    annotation (Line(points={{40,-60},{50,-60}}, color={0,127,255}));
  connect(s_b.port, vol.port_b) annotation (Line(points={{-30,-70},{-30,-60},{
          -40,-60}}, color={0,127,255}));
  connect(port_a, hIn.port_a)
    annotation (Line(points={{100,0},{0,0}}, color={0,127,255}));
  connect(hIn.port_b, vol.port_a) annotation (Line(points={{-20,0},{-80,0},{-80,
          -60},{-60,-60}}, color={0,127,255}));
  connect(s_a.port, hIn.port_a)
    annotation (Line(points={{80,-10},{80,0},{0,0}}, color={0,127,255}));
  connect(vol.port_b, hOut.port_a)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(hOut.port_b, steTra.port_a)
    annotation (Line(points={{0,-60},{20,-60}}, color={0,127,255}));
  connect(dh.y, m_flow.u2)
    annotation (Line(points={{21,-30},{30,-30}}, color={0,0,127}));
  connect(QHea.y[1], m_flow.u1) annotation (Line(points={{-59,70},{20,70},{20,
          -18},{30,-18}}, color={0,0,127}));
  connect(m_flow.y, pumCNR.m_flow_in)
    annotation (Line(points={{53,-24},{60,-24},{60,-48}}, color={0,0,127}));
  connect(hIn.h_out, dh.u1)
    annotation (Line(points={{-10,-11},{-10,-24},{-2,-24}}, color={0,0,127}));
  connect(hOut.h_out, dh.u2)
    annotation (Line(points={{-10,-49},{-10,-36},{-2,-36}}, color={0,0,127}));
  annotation (
    defaultComponentName="bui",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
A building-side model with district-side piping only and a PRV.
</p>
</html>"));
end BuildingTimeSeriesAtETS;
