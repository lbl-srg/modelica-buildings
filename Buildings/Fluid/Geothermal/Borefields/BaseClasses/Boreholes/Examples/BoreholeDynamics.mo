within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples;
model BoreholeDynamics "Example model for different borehole models and dynamics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Temperature T_start=273.15 + 22
    "Initial soil temperature";

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube
    borHolOneUTubDyn(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal,
    dp_nominal=borFieUTubDat.conDat.dp_nominal,
    nSeg=nSeg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TGro_start = {T_start for i in 1:nSeg},
    TFlu_start={Medium.T_default for i in 1:nSeg})
    "Borehole with U-Tub configuration and grout dynamics"
    annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,60})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-68,50},{
            -48,70}},
                  rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,50},{60,70}},
                  rotation=0)));
  parameter
    Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieUTubDat "Borefield parameters with UTube borehole configuration"
    annotation (Placement(transformation(extent={{90,40},{110,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal,
    redeclare package Medium = Medium,
    tau=0)
    "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBor1UTubDyn(
    m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal,
    redeclare package Medium = Medium,
    tau=0)
    "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol1(m=nSeg)
   "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,90})));
  Modelica.Blocks.Sources.Constant TGroUn(k=T_start)
    "Undisturbed ground temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,90})));
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHolOneUTubSteSta(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDatSteSta,
    m_flow_nominal=borFieUTubDatSteSta.conDat.mBor_flow_nominal,
    dp_nominal=borFieUTubDatSteSta.conDat.dp_nominal,
    nSeg=nSeg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    TGro_start = {T_start for i in 1:nSeg},
    TFlu_start={Medium.T_default for i in 1:nSeg})
    "Borehole with U-Tub configuration and steady state grout"
    annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-68,-10},{
            -48,10}},
                  rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-10},{60,10}},
                  rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorIn1(
    m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal,
    redeclare package Medium = Medium,
    tau=0) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBor1UTubSteSta(
    m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal,
    redeclare package Medium = Medium,
    tau=0) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol2(m=nSeg)
    "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,30})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.TwoUTube borHol2UTubDyn(
    redeclare package Medium = Medium,
    dp_nominal=borFie2UTubDat.conDat.dp_nominal,
    m_flow_nominal=borFie2UTubDat.conDat.mBor_flow_nominal,
    borFieDat=borFie2UTubDat,
    nSeg=nSeg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TGro_start = {T_start for i in 1:nSeg},
    TFlu_start={Medium.T_default for i in 1:nSeg})
    "Borehole with 2U-Tub configuration and grout dynamics" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,-60})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-68,-70},{
            -48,-50}},
                   rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-70},{60,-50}},
                  rotation=0)));
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFie2UTubDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
      borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel))
    "Borefield parameters with UTube borehole configuration"
    annotation (Placement(transformation(extent={{90,-80},{110,-60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorIn2(redeclare package Medium =
        Medium, m_flow_nominal=borFie2UTubDat.conDat.mBor_flow_nominal,
    tau=0)
    "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBor2UTubDyn(redeclare package Medium =
        Medium, m_flow_nominal=borFie2UTubDat.conDat.mBor_flow_nominal,
    tau=0)
    "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol3(m=nSeg)
    "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,-30})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.TwoUTube borHol2UTubSteSta(
    redeclare package Medium = Medium,
    dp_nominal=borFie2UTubDatSteSta.conDat.dp_nominal,
    m_flow_nominal=borFie2UTubDatSteSta.conDat.mBor_flow_nominal,
    borFieDat=borFie2UTubDatSteSta,
    nSeg=nSeg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    TGro_start = {T_start for i in 1:nSeg},
    TFlu_start={Medium.T_default for i in 1:nSeg})
    "Borehole with 2U-Tub configuration and steady states grout" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,-120})));
  Buildings.Fluid.Sources.MassFlowSource_T sou3(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-68,-130},
            {-48,-110}},rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin3(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-130},{60,
            -110}},
                  rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorIn3(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubDat.conDat.mBor_flow_nominal,
    tau=0)
    "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBor2UTubSteSta(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubDat.conDat.mBor_flow_nominal,
    tau=0)
    "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol4(m=nSeg)
                                    "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,-90})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature2
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature3
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDatSteSta(filDat=
        Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
        steadyState=true))
    "Borefield parameters with UTube borehole configuration and steady-state filling"
    annotation (Placement(transformation(extent={{90,0},{110,20}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFie2UTubDatSteSta(
    filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
        steadyState=true),
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel))
    "Borefield parameters with UTube borehole configuration and steady-state filling"
    annotation (Placement(transformation(extent={{90,-120},{110,-100}})));
equation
  connect(sou.ports[1],TBorIn. port_a)
    annotation (Line(points={{-48,60},{-40,60}},
                                               color={0,127,255}));
  connect(TBorIn.port_b, borHolOneUTubDyn.port_a)
    annotation (Line(points={{-20,60},{-14,60}}, color={0,127,255}));
  connect(borHolOneUTubDyn.port_b, TBor1UTubDyn.port_a)
    annotation (Line(points={{14,60},{14,60},{20,60}}, color={0,127,255}));
  connect(TBor1UTubDyn.port_b, sin.ports[1])
    annotation (Line(points={{40,60},{60,60}}, color={0,127,255}));
  connect(therCol1.port_a, borHolOneUTubDyn.port_wall)
    annotation (Line(points={{-26,90},{0,90},{0,74}}, color={191,0,0}));
  connect(sou1.ports[1], TBorIn1.port_a)
    annotation (Line(points={{-48,0},{-40,0}}, color={0,127,255}));
  connect(TBorIn1.port_b, borHolOneUTubSteSta.port_a)
    annotation (Line(points={{-20,0},{-14,0}}, color={0,127,255}));
  connect(borHolOneUTubSteSta.port_b, TBor1UTubSteSta.port_a)
    annotation (Line(points={{14,0},{14,0},{20,0}}, color={0,127,255}));
  connect(TBor1UTubSteSta.port_b, sin1.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(therCol2.port_a, borHolOneUTubSteSta.port_wall)
    annotation (Line(points={{-26,30},{0,30},{0,14}}, color={191,0,0}));
  connect(sou2.ports[1], TBorIn2.port_a)
    annotation (Line(points={{-48,-60},{-40,-60}}, color={0,127,255}));
  connect(TBorIn2.port_b, borHol2UTubDyn.port_a)
    annotation (Line(points={{-20,-60},{-14,-60}}, color={0,127,255}));
  connect(borHol2UTubDyn.port_b, TBor2UTubDyn.port_a)
    annotation (Line(points={{14,-60},{14,-60},{20,-60}}, color={0,127,255}));
  connect(TBor2UTubDyn.port_b, sin2.ports[1])
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(therCol3.port_a, borHol2UTubDyn.port_wall)
    annotation (Line(points={{-26,-30},{0,-30},{0,-46}}, color={191,0,0}));
  connect(sou3.ports[1], TBorIn3.port_a)
    annotation (Line(points={{-48,-120},{-40,-120}}, color={0,127,255}));
  connect(TBorIn3.port_b, borHol2UTubSteSta.port_a)
    annotation (Line(points={{-20,-120},{-14,-120}}, color={0,127,255}));
  connect(borHol2UTubSteSta.port_b, TBor2UTubSteSta.port_a) annotation (Line(
        points={{14,-120},{14,-120},{20,-120}}, color={0,127,255}));
  connect(TBor2UTubSteSta.port_b, sin3.ports[1])
    annotation (Line(points={{40,-120},{60,-120}}, color={0,127,255}));
  connect(therCol4.port_a, borHol2UTubSteSta.port_wall)
    annotation (Line(points={{-26,-90},{0,-90},{0,-106}}, color={191,0,0}));
  connect(TGroUn.y, prescribedTemperature.T)
    annotation (Line(points={{-87,90},{-72,90}}, color={0,0,127}));
  connect(therCol1.port_b, prescribedTemperature.port)
    annotation (Line(points={{-46,90},{-50,90}}, color={191,0,0}));
  connect(therCol2.port_b, prescribedTemperature1.port)
    annotation (Line(points={{-46,30},{-50,30}}, color={191,0,0}));
  connect(TGroUn.y, prescribedTemperature1.T) annotation (Line(points={{-87,90},
          {-80,90},{-80,30},{-72,30}}, color={0,0,127}));
  connect(therCol3.port_b, prescribedTemperature2.port)
    annotation (Line(points={{-46,-30},{-50,-30}}, color={191,0,0}));
  connect(prescribedTemperature2.T, prescribedTemperature1.T) annotation (Line(
        points={{-72,-30},{-80,-30},{-80,30},{-72,30}}, color={0,0,127}));
  connect(therCol4.port_b, prescribedTemperature3.port)
    annotation (Line(points={{-46,-90},{-50,-90}}, color={191,0,0}));
  connect(prescribedTemperature3.T, prescribedTemperature1.T) annotation (Line(
        points={{-72,-90},{-80,-90},{-80,30},{-72,30}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=15000),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{120,120}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/Examples/BoreholeDynamics.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
<p>
This example illustrates different borehole models using different mass
and energy dynamics.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2024, by Michael Wetter:<br/>
Updated model due to removal of parameter <code>dynFil</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
</li>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Removed ground heat transfer models so the example focuses on the boreholes.
</li>
<li>
February, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoreholeDynamics;
