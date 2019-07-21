within Buildings.DistrictHeatingCooling.Loads.Examples;
model CouplingTimeSeries "Example illustrating the coupling of a time series building model to a fluid loop"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));
  Buildings.DistrictHeatingCooling.Loads.Examples.BaseClasses.TimeSeriesBuilding bui
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    T=couHea.T_a_nominal,
    nPorts=1,
    use_T_in=true)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,30})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium,
    nPorts=1,
    p=300000,
    T=couHea.T_b_nominal)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,30})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium,
    nPorts=1,
    p=300000,
    T=couCoo.T_b_nominal)
              "Sink for chilled water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-90})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    T=couCoo.T_a_nominal,
    nPorts=1,
    use_T_in=true)
    "Supply for chilled water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,-90})));
  Buildings.DistrictHeatingCooling.Loads.BaseClasses.HeatingOrCooling couHea(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TLoa_nominal=bui.THeaLoa_nominal,
    nLoa=bui.nHeaLoa,
    Q_flowLoa_nominal=bui.Q_flowHea_nominal,
    T_a_nominal=318.15,
    T_b_nominal=313.15) annotation (Placement(transformation(extent={{-20,40},{0,20}})));
  Buildings.DistrictHeatingCooling.Loads.BaseClasses.HeatingOrCooling couCoo(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reverseAction=true,
    TLoa_nominal=bui.TCooLoa_nominal,
    nLoa=bui.nCooLoa,
    T_a_nominal=280.15,
    T_b_nominal=285.15,
    Q_flowLoa_nominal=bui.Q_flowCoo_nominal) annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flowHeaVal(y=couHea.m_flowReq)
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=couHea.T_a_nominal)
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=couCoo.T_a_nominal)
    annotation (Placement(transformation(extent={{-100,-106},{-80,-86}})));
  Modelica.Blocks.Sources.RealExpression m_flowCooVal(y=couCoo.m_flowReq)
    annotation (Placement(transformation(extent={{-100,-86},{-80,-66}})));
equation
  connect(weaDat.weaBus, bui.weaBus) annotation (Line(
      points={{90,-20},{50.1,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(couCoo.port_b, sinCoo.ports[1]) annotation (Line(points={{0,-90},{90,-90}}, color={0,127,255}));
  connect(supCoo.ports[1], couCoo.port_a)
    annotation (Line(points={{-34,-90},{-20,-90}},                     color={0,127,255}));
  connect(couHea.port_b, sinHea.ports[1]) annotation (Line(points={{0,30},{90,30}}, color={0,127,255}));
  connect(supHea.ports[1], couHea.port_a) annotation (Line(points={{-38,30},{-20,30}}, color={0,127,255}));
  connect(bui.Q_flowHeaReq, couHea.Q_flowLoaReq)
    annotation (Line(points={{61,-27},{68,-27},{68,0},{-30,0},{-30,22},{-22,22}},   color={0,0,127}));
  connect(couHea.heaPorLoa, bui.heaPorHea) annotation (Line(points={{-10,20},{-10,-23},{40,-23}}, color={191,0,0}));
  connect(bui.heaPorCoo, couCoo.heaPorLoa) annotation (Line(points={{40,-37},{-10,-37},{-10,-80}}, color={191,0,0}));
  connect(bui.Q_flowCooReq, couCoo.Q_flowLoaReq)
    annotation (Line(points={{61,-33},{68,-33},{68,-60},{-30,-60},{-30,-82},{-22,-82}},   color={0,0,127}));
  connect(supHea.m_flow_in, m_flowHeaVal.y)
    annotation (Line(points={{-60,38},{-66,38},{-66,44},{-79,44}}, color={0,0,127}));
  connect(THeaInlVal.y, supHea.T_in) annotation (Line(points={{-79,24},{-66,24},{-66,34},{-60,34}}, color={0,0,127}));
  connect(m_flowCooVal.y, supCoo.m_flow_in)
    annotation (Line(points={{-79,-76},{-68,-76},{-68,-82},{-56,-82}}, color={0,0,127}));
  connect(TCooInlVal.y, supCoo.T_in)
    annotation (Line(points={{-79,-96},{-68,-96},{-68,-86},{-56,-86}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
   <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified building model consisting in two heating loads and one cooling
  load as described in
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.TimeSeriesBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.TimeSeriesBuilding</a>.
  </p>
  </html>"),
  Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{120,80}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/DistrictHeatingCooling/Loads/Examples/CouplingTimeSeries.mos"
        "Simulate and plot"));
end CouplingTimeSeries;
