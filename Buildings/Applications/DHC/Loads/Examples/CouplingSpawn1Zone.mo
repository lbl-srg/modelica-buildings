within Buildings.Applications.DHC.Loads.Examples;
model CouplingSpawn1Zone "Example illustrating the coupling of a multizone RC model to a fluid loop"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.SpawnBuilding1Zone bui
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,30})));
  Buildings.Fluid.Sources.Boundary_pT   sinHea(
    redeclare package Medium = Medium,
    p=300000,
    T=couHea.T1_b_nominal,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,30})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium,
    p=300000,
    T=couCoo.T1_b_nominal,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-90})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)
   "Supply for chilled water"
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-90})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=couHea.T1_a_nominal)
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=couCoo.T1_a_nominal)
    annotation (Placement(transformation(extent={{-100,-106},{-80,-86}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couHea(
    redeclare package Medium = Medium,
    nLoa=bui.nHeaLoa,
    flowRegime=bui.floRegHeaLoa,
    T1_a_nominal=318.15,
    T1_b_nominal=313.15,
    Q_flow_nominal=bui.Q_flowHea_nominal,
    T2_nominal=bui.THeaLoa_nominal,
    m_flow2_nominal=bui.m_flowHeaLoa_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,40},{20,20}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couCoo(
    redeclare package Medium = Medium,
    nLoa=bui.nCooLoa,
    flowRegime=bui.floRegCooLoa,
    T1_a_nominal=280.15,
    T1_b_nominal=285.15,
    Q_flow_nominal=bui.Q_flowCoo_nominal,
    T2_nominal=bui.TCooLoa_nominal,
    m_flow2_nominal=bui.m_flowCooLoa_nominal,
    reverseAction=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
equation
  connect(THeaInlVal.y, supHea.T_in) annotation (Line(points={{-79,24},{-66,24},{-66,34},{-44,34}}, color={0,0,127}));
  connect(TCooInlVal.y, supCoo.T_in)
    annotation (Line(points={{-79,-96},{-68,-96},{-68,-86},{-42,-86}}, color={0,0,127}));
  connect(supHea.ports[1], couHea.port_a) annotation (Line(points={{-22,30},{0,30}}, color={0,127,255}));
  connect(couHea.port_b, sinHea.ports[1]) annotation (Line(points={{20,30},{90,30}}, color={0,127,255}));
  connect(bui.yHea, couHea.yHeaCoo)
    annotation (Line(points={{61,-24},{80,-24},{80,0},{-10,0},{-10,22},{-2,22}}, color={0,0,127}));
  connect(supCoo.ports[1], couCoo.port_a) annotation (Line(points={{-20,-90},{0,-90}}, color={0,127,255}));
  connect(couCoo.port_b, sinCoo.ports[1]) annotation (Line(points={{20,-90},{90,-90}}, color={0,127,255}));
  connect(bui.yCoo, couCoo.yHeaCoo)
    annotation (Line(points={{61,-36},{80,-36},{80,-60},{-10,-60},{-10,-82},{-2,-82}}, color={0,0,127}));
  connect(bui.m_flowHeaLoa, couHea.m_flow2)
    annotation (Line(points={{61,-27},{82,-27},{82,52},{-10,52},{-10,38},{-2,38}}, color={0,0,127}));
  connect(bui.m_flowCooLoa, couCoo.m_flow2)
    annotation (Line(points={{61,-33},{82,-33},{82,-114},{-10,-114},{-10,-98},{-2,-98}}, color={0,0,127}));
  connect(bui.fraLatCooReq, couCoo.fraLat)
    annotation (Line(points={{61,-31},{84,-31},{84,-118},{-12,-118},{-12,-94},{-2,-94}}, color={0,0,127}));
  connect(couCoo.m_flow1Req, supCoo.m_flow_in)
    annotation (Line(points={{22,-95},{28,-95},{28,-64},{-60,-64},{-60,-82},{-42,-82}}, color={0,0,127}));
  connect(couHea.m_flow1Req, supHea.m_flow_in)
    annotation (Line(points={{22,35},{26,35},{26,60},{-60,60},{-60,38},{-44,38}}, color={0,0,127}));
  connect(couHea.heaPorLoa, bui.heaPorHea)
    annotation (Line(points={{20,25},{20,24.5},{34,24.5},{34,-23},{40,-23}}, color={191,0,0}));
  connect(couCoo.heaPorLoa, bui.heaPorCoo)
    annotation (Line(points={{20,-85},{34,-85},{34,-37},{40,-37}}, color={191,0,0}));
  annotation (
  experiment(
      StopTime=800000,
      Tolerance=1e-06),
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified multizone RC model resulting
  from the translation of a GeoJSON model specified within Urbanopt UI, see
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding</a>.
  </p>
  </html>"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{140,80}}), graphics={Text(
          extent={{-98,90},{-38,50}},
          lineColor={28,108,200},
          fontSize=18,
          horizontalAlignment=TextAlignment.Left,
          textString="Model with one EnergyPlus thermal zone can only be simulated with:
- dymola-2020-x86_64 (with Advanced.CompileWith64 = 2) or
- JModelica.")}),
    __Dymola_Commands);
end CouplingSpawn1Zone;
