within Buildings.DHC.Loads.Steam;
model BuildingTimeSeriesAtETS
  "Steam heating building interconnection with the district piping only
  and the load at the ETS provided as a time series."
  replaceable package MediumSte = Buildings.Media.Steam constrainedby
    Modelica.Media.Interfaces.PartialMedium
     "Steam medium";
  replaceable package MediumWat =
   Buildings.Media.Specialized.Water.TemperatureDependentDensity
   constrainedby Modelica.Media.Interfaces.PartialMedium
    "Water medium";

  constant Boolean allowFlowReversal = false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Set to false because the flow rate is prescribed."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean have_prv = false
    "Set to true if the building has a pressure reducing valve (PRV) station";
  // Nominal conditions
  parameter Modelica.Units.SI.Power Q_flow_nominal
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.AbsolutePressure pSte_nominal=MediumSte.p_default
    "Nominal pressure of steam entering the building"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.AbsolutePressure pLow_nominal=0.8*MediumSte.p_default
    "Nominal low pressure setpoint, downstream of PRV (if present)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.Temperature TSte_nominal=
     MediumSte.saturationTemperature(pSte_nominal)
     "Nominal temperature of steam entering the building"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.Temperature TLow_nominal=
     MediumSte.temperature(
       MediumSte.setState_phX(
         p=pLow_nominal,
         h=MediumSte.specificEnthalpy(MediumSte.setState_pTX(
            p=pSte_nominal,
            T=TSte_nominal,
            X=MediumSte.X_default)),
         X=MediumSte.X_default))
     "Nominal temperature of steam entering heat exchanger, if PRV present"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.SpecificEnthalpy dh_nominal=
    MediumSte.specificEnthalpy(MediumSte.setState_pTX(
        p=if have_prv then pLow_nominal else pSte_nominal,
        T=if have_prv then TLow_nominal else TSte_nominal,
        X=MediumSte.X_default)) -
      MediumWat.specificEnthalpy(MediumWat.setState_pTX(
        p=if have_prv then pLow_nominal else pSte_nominal,
        T=if have_prv then TLow_nominal else TSte_nominal,
        X=MediumWat.X_default))
    "Nominal change in enthalpy across the heat exchanger"
    annotation(Dialog(group = "Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dh_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.Units.SI.Volume V=1
    "Total volume of the steam side of the heat exchanger";

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter MediumSte.AbsolutePressure p_start=MediumSte.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumSte.Temperature T_start=MediumSte.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=0
    "Initial value of mass flow rate"
    annotation(Dialog(tab = "Initialization"));

  // Buildings.DHC.Loads.Heating load time series
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
  parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(tab = "Load Profile", group="Table data interpretation"));
  parameter Modelica.Units.SI.Time timeScale(
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

  // Advanced
  parameter Modelica.Units.SI.Density rho_a_default=
    MediumSte.density(MediumSte.setState_pTX(
      p=pSte_nominal,T=TSte_nominal,X=MediumSte.X_default))
    "Default steam density"
    annotation(Dialog(tab="Advanced",group="Nominal condition"));
  parameter Modelica.Units.SI.Density rho_b_default=
    MediumWat.density(MediumWat.setState_pTX(
      p=101325,T=273.15+90,X=MediumWat.X_default))
    "Default water density"
    annotation(Dialog(tab="Advanced",group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW")
    "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput EHea(
    final quantity="HeatFlow",
    final unit="J",
    displayUnit="kWh")
    "Total heating energy"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumSte)
    "Inlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumWat)
    "Outlet port"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea(
    final tableOnFile=tableOnFile,
    final table=QHeaLoa,
    final tableName=tableName,
    final fileName=fileName,
    final columns=columns,
    final smoothness=smoothness,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final timeScale=timeScale)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Continuous.Integrator IntEHea(y(unit="J"))
    "Integrator for heating energy of building"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCNR(
    redeclare final package Medium = MediumWat,
    final energyDynamics=energyDynamics,
    p_start=steTra.pAtm,
    T_start=steTra.TSat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    final m_flow_start=m_flow_start)
    "Condensate return pump"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation vol(
    redeclare final package MediumSte = MediumSte,
    redeclare final package MediumWat = MediumWat,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=if have_prv then pLow_nominal else pSte_nominal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final V=V)
    "Steam side of the heat exchanger, modeled as a steady state control volume"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-70}})));
  Buildings.DHC.Loads.Steam.BaseClasses.SteamTrap steTra(
    redeclare final package Medium = MediumWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T)
    "Steam trap"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hIn(
    redeclare final package Medium = MediumSte,
    final m_flow_nominal=m_flow_nominal)
    "Enthalpy in"
    annotation (Placement(transformation(extent={{0,10},{-20,-10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort hOut(
    redeclare final package Medium = MediumWat,
    final m_flow_nominal=m_flow_nominal)
    "Enthalpy out"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Add dh(final k2=-1)
    "Change in enthalpy with building-side fluid"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Math.Division m_flow "Mass flow"
    annotation (Placement(transformation(extent={{32,-34},{52,-14}})));
  Buildings.DHC.Loads.Steam.BaseClasses.ValveSelfActing prv(
    redeclare final package Medium = MediumSte,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final pb_nominal=pLow_nominal) if have_prv
    "Optional pressure reducing valve"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
equation
  connect(IntEHea.y, EHea) annotation (Line(points={{81,50},{96,50},{96,50},{
          110,50}}, color={0,0,127}));
  connect(QHea.y[1], Q_flow) annotation (Line(points={{-59,80},{110,80}},
                    color={0,0,127}));
  connect(IntEHea.u, Q_flow) annotation (Line(points={{58,50},{20,50},{20,80},{110,
          80}}, color={0,0,127}));
  connect(pumCNR.port_b, port_b)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  connect(steTra.port_b, pumCNR.port_a)
    annotation (Line(points={{40,-60},{50,-60}}, color={0,127,255}));
  connect(hIn.port_b, vol.port_a) annotation (Line(points={{-20,0},{-80,0},{-80,
          -60},{-60,-60}}, color={0,127,255}));
  connect(vol.port_b, hOut.port_a)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(hOut.port_b, steTra.port_a)
    annotation (Line(points={{0,-60},{20,-60}}, color={0,127,255}));
  connect(dh.y, m_flow.u2)
    annotation (Line(points={{21,-30},{30,-30}}, color={0,0,127}));
  connect(QHea.y[1], m_flow.u1) annotation (Line(points={{-59,80},{20,80},{20,-18},
          {30,-18}},      color={0,0,127}));
  connect(m_flow.y, pumCNR.m_flow_in)
    annotation (Line(points={{53,-24},{60,-24},{60,-48}}, color={0,0,127}));
  connect(hIn.h_out, dh.u1)
    annotation (Line(points={{-10,-11},{-10,-24},{-2,-24}}, color={0,0,127}));
  connect(hOut.h_out, dh.u2)
    annotation (Line(points={{-10,-49},{-10,-36},{-2,-36}}, color={0,0,127}));
  connect(port_a, prv.port_a) annotation (Line(points={{100,0},{70,0},{70,20},{60,
          20}}, color={0,127,255}));
  if have_prv then
    connect(prv.port_b, hIn.port_a)
     annotation (Line(points={{40,20},{30,20},{30,0},{0,0}}, color={0,127,255}));
  else
  connect(port_a, hIn.port_a)
    annotation (Line(points={{100,0},{0,0}}, color={0,127,255}));
  end if;

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
        textxColor={0,0,255},
        textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model is intended for existing steam district heating systems
where the heating load at the energy transfer station (ETS) is
availble as a time series data input. Thus, the building-side piping and equipement
is not included in this model, as depicted below.
</p>
<p>
<img src=\"modelica://Buildings/Resources/Images/DHC/Loads/Steam/BuildingTimeSeriesAtETS.png\" alt=\"steamBuilding\"/>.
</p>
<h4> Implementation</h4>
<p>
With the time series input, this model is configured such that the control
volume (representing the steam side of the heat exchanger) has steady state
energy and mass balances. The steam trap also has steady state balances by
design. Meanwhile, the condensate return pump allows either dynamic or steady
state balances. The mass flow rate at the pump is prescribed ideally such that
the heat flow rate input from the time series is rejected at the control volume
based on the physical laws.
</p>
<h4>References </h4>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Wangda Zuo. 2022.
&ldquo;A Fast and Accurate Modeling Approach for Water and Steam
Thermodynamics with Practical Applications in District Heating System Simulation,&rdquo;
<i>Energy</i>, 254(A), pp. 124227.
<a href=\"https://doi.org/10.1016/j.energy.2022.124227\">10.1016/j.energy.2022.124227</a>
</p>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Baptiste Ravache, Wangda Zuo 2022.
&ldquo;Towards Open-Source Modelica Models For Steam-Based District Heating Systems.&rdquo;
<i>Proc. of the 1st International Workshop On Open Source Modelling And Simulation Of
Energy Systems (OSMSES 2022)</i>, Aachen, German, April 4-5, 2022.
<a href=\"https://doi.org/10.1109/OSMSES54027.2022.9769121\">10.1109/OSMSES54027.2022.9769121</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 8, 2024, by Michael Wetter:<br/>
Removed connection to itself.
</li>
<li>
September 15, 2023, by Kathryn Hinkelman:<br/>
Added publication references.
</li>
<li>
March 28, 2022, by Kathryn Hinkelman:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesAtETS;
