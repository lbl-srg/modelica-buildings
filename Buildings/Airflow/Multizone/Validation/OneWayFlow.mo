within Buildings.Airflow.Multizone.Validation;
model OneWayFlow
  "Validation model to verify one way flow implementation"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Specialized.Air.PerfectGas;

  Modelica.Units.SI.PressureDifference dP = ela.dp "Pressure difference over the tested elements";
  Modelica.Units.SI.MassFlowRate[nTested] m_flow_data=
   {sen_ela.m_flow,
    sen_ori.m_flow,
    sen_pow_1dat.m_flow,
    sen_pow_2dat.m_flow,
    sen_pow_m_flow.m_flow,
    sen_pow_V_flow.m_flow,
    sen_tabDat_m_flow.m_flow,
    sen_tabDat_V_flow.m_flow}
    "Simulated mass flow of each flow element";
  Modelica.Units.SI.MassFlowRate[nTested] m_flow_testdata=contamData.y
    "Mass flow of each flow element of CONTAM simulation";

protected
  parameter Integer nTested=8 "Number of tested flow elements";

//Test Data
//Headers: ["dP","ELA_FlowRate","ORI_FlowRate","1DatPoint_FlowRate","2DatPoint_FlowRate","pow_m_flow_FlowRate","pow_V_flow_FlowRate","tabDat_m_flow","tabDat_V_flow_FlowRate"]
  parameter Real TestData[:,nTested+1]=[
      -50,-0.0838,-0.0658,-0.0672,-0.0609,-0.0707,-0.0851,-0.0871,-0.105;
      -40,-0.0725,-0.0589,-0.0601,-0.055,-0.0632,-0.0762,-0.0769,-0.0926;
      -25,-0.0534,-0.0466,-0.0475,-0.0443,-0.05,-0.0602,-0.0616,-0.0741;
      -10,-0.0294,-0.0294,-0.03,-0.029,-0.0316,-0.0381,-0.039,-0.0469;
      -5,-0.0188,-0.0208,-0.0212,-0.0211,-0.0224,-0.0269,-0.0275,-0.0332;
      -1,-0.00659,-0.00931,-0.0095,-0.01,-0.01,-0.012,-0.0123,-0.0148;
      0,0,0,0,0,0,0,0,0;
      1,0.00659,0.00931,0.0095,0.01,0.01,0.012,0.0123,0.0148;
      5,0.0188,0.0208,0.0212,0.0211,0.0224,0.0269,0.0261,0.0315;
      10,0.0294,0.0294,0.03,0.029,0.0316,0.0381,0.0261,0.0315;
      25,0.0534,0.0466,0.0475,0.0443,0.05,0.0602,0.0261,0.0315;
      40,0.0725,0.0589,0.0601,0.055,0.0632,0.0762,0.0261,0.0315;
      50,0.0838,0.0658,0.0672,0.0609,0.0707,0.0851,0.0261,0.0315]
      "Steady state CONTAM results with specific pressure difference for similar flow models";

  //Boundary conditions
  Fluid.Sources.Boundary_pT bouA(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=8) "Pressure boundary" annotation (Placement(transformation(extent={{-100,-28},{-80,-8}})));
  Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=8) "Pressure boundary" annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Blocks.Sources.Ramp ramp_min50_50pa(
    duration=500,
    height=100,
    offset=-50) "Block that generates a ramp signal from -50 to +50"
     annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Modelica.Blocks.Sources.Constant PAmb(k=101325)
  "Assumed ambient pressure" annotation (Placement(transformation(extent={{-180,18},
            {-160,38}})));
  Modelica.Blocks.Math.Sum sum(nin=2)
    "Sum" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,-10})));

  //Flow models
  EffectiveAirLeakageArea ela(
    redeclare package Medium = Medium,
    dpRat=10,
    CDRat=0.6,
    L=0.01)
    "EffectiveAirLeakageArea" annotation (Placement(transformation(extent={{-40,120},
            {-20,140}})));
  Orifice ori(
    redeclare package Medium = Medium,
    A=0.01,
    CD=0.6) "Orifice" annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Point_m_flow pow_1dat(
    dpMea_nominal(displayUnit="Pa") = 4,
    redeclare package Medium = Medium,
    mMea_flow_nominal=0.019) "Powerlaw_1Datapoint"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Points_m_flow pow_2dat(
    redeclare package Medium = Medium,
    mMea_flow_nominal={0.019, 0.029},
    dpMea_nominal = {4, 10}) "Powerlaw_2Datapoints"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Coefficient_m_flow pow_m_flow(
    redeclare package Medium = Medium,
    m=0.5,
    k=0.01) "Powerlaw_m_flow"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Coefficient_V_flow pow_V_flow(
    redeclare package Medium = Medium,
    m=0.5,
    C=0.01)
    "Powerlaw_V_flow" annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Table_m_flow tabDat_m_flow(
   redeclare package Medium = Medium,
   mMea_flow_nominal = {-0.08709, -0.06158, -0.03895, -0.02754, -0.02133, -0.01742, -0.01232, 0, 0.01232, 0.01742, 0.02133, 0.02613, 0.02614},
   dpMea_nominal =     {-50, -25, -10, -5, -3, -2, -1, 0, 1, 2, 3, 4.5, 50})
    "TableData_m_flow" annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Table_V_flow tabDat_V_flow(
    redeclare package Medium = Medium,
    VMea_flow_nominal = {-0.08709, -0.06158, -0.03895, -0.02754, -0.02133, -0.01742, -0.01232, 0, 0.01232, 0.01742, 0.02133, 0.02613, 0.02614},
    dpMea_nominal = {-50, -25, -10, -5, -3, -2, -1, 0, 1, 2, 3, 4.5, 50})
    "TableData_V_flow" annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));

  //Mass flow sensors
  Fluid.Sensors.MassFlowRate sen_ela(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Fluid.Sensors.MassFlowRate sen_ori(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Fluid.Sensors.MassFlowRate sen_pow_1dat(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Fluid.Sensors.MassFlowRate sen_pow_2dat(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Fluid.Sensors.MassFlowRate sen_pow_m_flow(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Fluid.Sensors.MassFlowRate sen_pow_V_flow(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Fluid.Sensors.MassFlowRate sen_tabDat_m_flow(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Fluid.Sensors.MassFlowRate sen_tabDat_V_flow(redeclare package Medium = Medium)
  "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-160},{20,-140}})));

  //Checking the data
  Modelica.Blocks.Tables.CombiTable1Dv contamData(
    table=TestData,
    columns=2:9,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2)
    "Table with CONTAM simulation results for comparison"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nTested)
    "Signal replicator"
     annotation (Placement(transformation(extent={{-120,
            160},{-100,180}})));


equation

  connect(ramp_min50_50pa.y, sum.u[1]) annotation (Line(points={{-159,-10},{-134,
          -10},{-134,-10.5}},                color={0,0,127}));
  connect(PAmb.y, sum.u[2]) annotation (Line(points={{-159,28},{-140,28},{-140,-10},
          {-134,-10},{-134,-9.5}}, color={0,0,127}));
  connect(sum.y, bouA.p_in) annotation (Line(points={{-111,-10},{-102,-10}},      color={0,0,127}));
  connect(PAmb.y, bouB.p_in) annotation (Line(points={{-159,28},{-140,28},{-140,
          150},{112,150},{112,-2},{102,-2}},                 color={0,0,127}));
  connect(ramp_min50_50pa.y, replicator.u) annotation (Line(points={{-159,-10},{
          -150,-10},{-150,170},{-122,170}},                  color={0,0,127}));
  connect(replicator.y, contamData.u)
    annotation (Line(points={{-99,170},{-82,170}}, color={0,0,127}));
  connect(bouA.ports[1],ela. port_a) annotation (Line(points={{-80,-19.75},{-62,
          -19.75},{-62,130},{-40,130}},
                              color={0,127,255}));
  connect(bouA.ports[2], ori.port_a) annotation (Line(points={{-80,-19.25},{-60,
          -19.25},{-60,90},{-40,90}},
                              color={0,127,255}));
  connect(bouA.ports[3], pow_1dat.port_a) annotation (Line(points={{-80,-18.75},
          {-58,-18.75},{-58,50},{-40,50}},
                                         color={0,127,255}));
  connect(bouA.ports[4], pow_2dat.port_a) annotation (Line(points={{-80,-18.25},
          {-56,-18.25},{-56,10},{-40,10}},
                                         color={0,127,255}));
  connect(bouA.ports[5], pow_m_flow.port_a) annotation (Line(points={{-80,-17.75},
          {-56,-17.75},{-56,-30},{-40,-30}},
                                      color={0,127,255}));
  connect(bouA.ports[6], pow_V_flow.port_a) annotation (Line(points={{-80,-17.25},
          {-58,-17.25},{-58,-70},{-40,-70}},
                                      color={0,127,255}));
  connect(bouA.ports[7],tabDat_m_flow. port_a) annotation (Line(points={{-80,-16.75},
          {-60,-16.75},{-60,-110},{-40,-110}},
                                      color={0,127,255}));
  connect(bouA.ports[8],tabDat_V_flow. port_a) annotation (Line(points={{-80,-16.25},
          {-62,-16.25},{-62,-150},{-40,-150}},
                                        color={0,127,255}));
  connect(ela.port_b,sen_ela. port_a)    annotation (Line(points={{-20,130},{0,130}},
                                              color={0,127,255}));
  connect(sen_ela.port_b, bouB.ports[1]) annotation (Line(points={{20,130},{60,130},
          {60,-11.75},{80,-11.75}},
                                color={0,127,255}));
  connect(ori.port_b,sen_ori. port_a)    annotation (Line(points={{-20,90},{0,90}},color={0,127,255}));
  connect(sen_ori.port_b, bouB.ports[2]) annotation (Line(points={{20,90},{58,90},
          {58,-11.25},{80,-11.25}},
                                color={0,127,255}));
  connect(pow_1dat.port_b,sen_pow_1dat. port_a) annotation (Line(points={{-20,50},{0,50}},color={0,127,255}));
  connect(sen_pow_1dat.port_b, bouB.ports[3]) annotation (Line(points={{20,50},
          {56,50},{56,-10.75},{80,-10.75}},
                                        color={0,127,255}));
  connect(pow_2dat.port_b,sen_pow_2dat. port_a) annotation (Line(points={{-20,10},{0,10}},color={0,127,255}));
  connect(sen_pow_2dat.port_b, bouB.ports[4]) annotation (Line(points={{20,10},
          {54,10},{54,-10.25},{80,-10.25}},
                                        color={0,127,255}));
  connect(pow_m_flow.port_b,sen_pow_m_flow. port_a) annotation (Line(points={{-20,-30},{0,-30}},color={0,127,255}));
  connect(sen_pow_m_flow.port_b, bouB.ports[5]) annotation (Line(points={{20,-30},
          {54,-30},{54,-9.75},{80,-9.75}},
                                         color={0,127,255}));
  connect(pow_V_flow.port_b,sen_pow_V_flow. port_a) annotation (Line(points={{-20,-70},{0,-70}},color={0,127,255}));
  connect(sen_pow_V_flow.port_b, bouB.ports[6]) annotation (Line(points={{20,-70},
          {56,-70},{56,-9.25},{80,-9.25}},
                                color={0,127,255}));
  connect(tabDat_m_flow.port_b,sen_tabDat_m_flow. port_a) annotation (Line(points={{-20,-110},{0,-110}},
                                                color={0,127,255}));
  connect(sen_tabDat_m_flow.port_b, bouB.ports[7]) annotation (Line(points={{20,-110},
          {58,-110},{58,-8.75},{80,-8.75}},
                                         color={0,127,255}));
  connect(tabDat_V_flow.port_b,sen_tabDat_V_flow. port_a) annotation (Line(points={{-20,-150},{0,-150}},  color={0,127,255}));
  connect(sen_tabDat_V_flow.port_b, bouB.ports[8]) annotation (Line(points={{20,-150},
          {60,-150},{60,-8.25},{80,-8.25}},
                                          color={0,127,255}));


  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{160,200}})),
    experiment(
      StopTime=500,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Validation/OneWayFlow.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, 2020, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>
"), Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end OneWayFlow;
