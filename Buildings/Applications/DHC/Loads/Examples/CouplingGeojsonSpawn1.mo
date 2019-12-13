within Buildings.Applications.DHC.Loads.Examples;
model CouplingGeojsonSpawn1
  "Example illustrating the coupling of a multizone RC model to a fluid loop"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonSpawn1Z6 bui
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,30})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-90})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,10})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=bui.disFloHea.T_a1_nominal)
    annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req(y=bui.disFloHea.m_flow1Req)
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1)
    "Supply for chilled water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-70})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal1(y=bui.disFloCoo.T_a1_nominal)
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req1(y=bui.disFloCoo.m_flow1Req)
    annotation (Placement(transformation(extent={{-80,-66},{-60,-46}})));
equation
  connect(THeaInlVal.y,supHea. T_in) annotation (Line(points={{-59,4},{-40,4},{-40,
          14},{-22,14}},                                                                            color={0,0,127}));
  connect(m_flow1Req.y,supHea. m_flow_in)
    annotation (Line(points={{-59,24},{-40,24},{-40,18},{-22,18}}, color={0,0,127}));
  connect(THeaInlVal1.y,supCoo. T_in) annotation (Line(points={{-59,-76},{-40,-76},
          {-40,-66},{-22,-66}},                                                                    color={0,0,127}));
  connect(m_flow1Req1.y,supCoo. m_flow_in)
    annotation (Line(points={{-59,-56},{-40,-56},{-40,-62},{-22,-62}},
                                                                   color={0,0,127}));
  connect(supHea.ports[1], bui.ports_a1[1])
    annotation (Line(points={{0,10},{24,10},{24,-30},{40,-30}},
                                                              color={0,127,255}));
  connect(supCoo.ports[1], bui.ports_a1[2])
    annotation (Line(points={{0,-70},{24,-70},{24,-30},{40,-30}},
                                                              color={0,127,255}));
  connect(bui.ports_b1[1], sinHea.ports[1]) annotation (Line(points={{60,-30},{76,
          -30},{76,30},{90,30}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1]) annotation (Line(points={{60,-30},{76,
          -30},{76,-90},{90,-90}}, color={0,127,255}));
  annotation (
  experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
          extent={{-100,90},{140,58}},
          lineColor={28,108,200},
          fontSize=18,
          horizontalAlignment=TextAlignment.Left,
          textString="Model with multiple EnergyPlus thermal zones can only be simulated with:
- Dymola 2020x with:
Advanced.CompileWith64 = 2; Hidden.AvoidDoubleComputation=true
or
- JModelica.")}),
    __Dymola_Commands);
end CouplingGeojsonSpawn1;
