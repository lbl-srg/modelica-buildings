within Buildings.Applications.DHC.Loads.Examples;
model CouplingRC "Example illustrating the coupling of a RC building model to a fluid loop"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3
                                            weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.RCBuilding bui
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true)
              "Supply for heating water"          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,30})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium,
    nPorts=1,
    p=300000,
    T=couHea.T1_b_nominal)
              "Sink for heating water"
                                      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,30})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium,
    p=300000,
    T=couCoo.T1_b_nominal,
    nPorts=1) "Sink for chilled water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-90})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)             "Supply for chilled water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-90})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couHea(
    redeclare package Medium = Medium,
    flowRegime=bui.floRegHeaLoa,
    T1_a_nominal=318.15,
    T1_b_nominal=313.15,
    Q_flow_nominal=bui.Q_flowHea_nominal,
    T2_nominal=bui.THeaLoa_nominal,
    m_flow2_nominal=bui.m_flowHeaLoa_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nLoa=bui.nHeaLoa) annotation (Placement(transformation(extent={{0,40},{20,20}})));
  Modelica.Blocks.Sources.RealExpression m_flowHeaVal(y=couHea.m_flowReq)
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=couHea.T1_a_nominal)
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=couCoo.T1_a_nominal)
    annotation (Placement(transformation(extent={{-100,-106},{-80,-86}})));
  Modelica.Blocks.Sources.RealExpression m_flowCooVal(y=couCoo.m_flowReq)
    annotation (Placement(transformation(extent={{-100,-86},{-80,-66}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couCoo(
    redeclare package Medium = Medium,
    flowRegime=bui.floRegCooLoa,
    T1_a_nominal=280.15,
    T1_b_nominal=285.15,
    Q_flow_nominal=bui.Q_flowCoo_nominal,
    T2_nominal=bui.TCooLoa_nominal,
    m_flow2_nominal=bui.m_flowCooLoa_nominal,
    reverseAction=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nLoa=bui.nCooLoa) annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{90,-20},{50.1,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(supHea.ports[1], couHea.port_a)
  annotation (Line(points={{-22,30},{0,30}},                      color={0,127,255}));
  connect(couHea.port_b, sinHea.ports[1])
  annotation (Line(points={{20,30},{90,30}},                    color={0,127,255}));
  connect(supHea.m_flow_in, m_flowHeaVal.y)
    annotation (Line(points={{-44,38},{-66,38},{-66,44},{-79,44}}, color={0,0,127}));
  connect(THeaInlVal.y, supHea.T_in) annotation (Line(points={{-79,24},{-66,24},{-66,34},{-44,34}}, color={0,0,127}));
  connect(m_flowCooVal.y, supCoo.m_flow_in)
    annotation (Line(points={{-79,-76},{-68,-76},{-68,-82},{-42,-82}}, color={0,0,127}));
  connect(TCooInlVal.y, supCoo.T_in)
    annotation (Line(points={{-79,-96},{-68,-96},{-68,-86},{-42,-86}}, color={0,0,127}));
  connect(couHea.heaPorLoa, bui.heaPorHea) annotation (Line(points={{10,20},{10,-23},{40,-23}}, color={191,0,0}));
  connect(couCoo.port_b, sinCoo.ports[1]) annotation (Line(points={{20,-90},{90,-90}}, color={0,127,255}));
  connect(supCoo.ports[1], couCoo.port_a) annotation (Line(points={{-20,-90},{0,-90}}, color={0,127,255}));
  connect(couCoo.heaPorLoa, bui.heaPorCoo) annotation (Line(points={{10,-80},{10,-37},{40,-37}}, color={191,0,0}));
  connect(bui.Q_flowHeaReq, couHea.Q_flowReq)
    annotation (Line(points={{61,-24},{70,-24},{70,0},{-10,0},{-10,22},{-2,22}}, color={0,0,127}));
  connect(bui.Q_flowCooReq, couCoo.Q_flowReq)
    annotation (Line(points={{61,-36},{70,-36},{70,-60},{-12,-60},{-12,-82},{-2,-82}}, color={0,0,127}));
  connect(bui.fraLatCooReq, couCoo.fraLat)
    annotation (Line(points={{61,-31},{80,-31},{80,-120},{-14,-120},{-14,-94},{-2,-94}}, color={0,0,127}));
  connect(bui.m_flowCooLoa, couCoo.m_flow2)
    annotation (Line(points={{61,-33},{72,-33},{72,-114},{-10,-114},{-10,-98},{-2,-98}}, color={0,0,127}));
  connect(bui.m_flowHeaLoa, couHea.m_flow2)
    annotation (Line(points={{61,-27},{80,-27},{80,52},{-10,52},{-10,38},{-2,38}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified building model consisting in two heating loads and one cooling
  load as described in
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding</a>.
  </p>
  </html>"),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{140,80}})),
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingRC.mos"
        "Simulate and plot"));
end CouplingRC;
