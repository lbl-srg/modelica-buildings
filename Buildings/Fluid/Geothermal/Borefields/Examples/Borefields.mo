within Buildings.Fluid.Geothermal.Borefields.Examples;
model Borefields
  "Example model with several borefield configurations operating simultaneously"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Time tLoaAgg=300
    "Time resolution of load aggregation";

  parameter Modelica.Units.SI.Temperature TGro=283.15 "Ground temperature";
  Buildings.Fluid.Geothermal.Borefields.TwoUTubes borFie2UTubPar(
    redeclare package Medium = Medium,
    borFieDat=borFie2UTubParDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a 2-U-tube connected in parallel borehole configuration"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubParDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-92,-10},{
            -72,10}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2UTubParIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubParDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-10},{70,
            10}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2UTubParOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubParDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield with 2-UTube in parallel configuration"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{70,-100},{90,-80}})));

  Buildings.Fluid.Geothermal.Borefields.TwoUTubes borFie2UTubSer(
    redeclare package Medium = Medium,
    borFieDat=borFie2UTubSerDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a 2-U-tube connected in serie borehole configuration"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubSerDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-92,50},{
            -72,70}},
                  rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2UTubSerIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubSerDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,50},{70,
            70}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2UTubSerOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFie2UTubSerDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{42,50},{62,70}})));
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFie2UTubParDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel))
    "Data from the borefield with 2-UTube in parallel borehole configuration"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-92,-70},{
            -72,-50}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-70},{70,
            -50}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFie2UTubSerDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries))
    "Data from the borefield with 2-UTube in serie borehole configuration"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));

equation
  connect(sou1.ports[1], T2UTubParIn.port_a)
    annotation (Line(points={{-72,0},{-60,0}}, color={0,127,255}));
  connect(T2UTubParIn.port_b, borFie2UTubPar.port_a)
    annotation (Line(points={{-40,0},{-10,0}},         color={0,127,255}));
  connect(T2UTubParOut.port_a, borFie2UTubPar.port_b)
    annotation (Line(points={{40,0},{10,0}}, color={0,127,255}));
  connect(T2UTubParOut.port_b, sin1.ports[1])
    annotation (Line(points={{60,0},{70,0}},        color={0,127,255}));
  connect(sou2.ports[1], T2UTubSerIn.port_a)
    annotation (Line(points={{-72,60},{-58,60}}, color={0,127,255}));
  connect(T2UTubSerIn.port_b, borFie2UTubSer.port_a)
    annotation (Line(points={{-38,60},{-10,60}},          color={0,127,255}));
  connect(T2UTubSerOut.port_a, borFie2UTubSer.port_b)
    annotation (Line(points={{42,60},{10,60}}, color={0,127,255}));
  connect(T2UTubSerOut.port_b,sin2. ports[1])
    annotation (Line(points={{62,60},{70,60}},         color={0,127,255}));
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-72,-60},{-60,-60}}, color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-40,-60},{-10,-60}}, color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{10,-60},{40,-60}},          color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{60,-60},{70,-60}},          color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/Borefields.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows three different borefields, each with a different configuration
(single U-tube, double U-tube in parallel, and double U-tube in series) and compares
the thermal behaviour of the circulating fluid in each case.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=36000,Tolerance=1e-6));
end Borefields;
