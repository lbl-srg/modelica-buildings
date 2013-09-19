within Buildings.Rooms.FLEXLAB.Rooms.Examples;
model X3BConnectedToX3AWithRadiantFloor
  "Example model showing a simulation of test cell X3B connected to test cell X3A (both have radiant floors)"
  import Buildings;
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Air model used in the example model";
  package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Water model used in the radiant slab loop";

  Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell X3B(redeclare package Medium = Air,
      nPorts=2) "Test cell X3B"
    annotation (Placement(transformation(extent={{82,24},{122,64}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Closet BClo(redeclare package Medium = Air,
      nPorts=2) "Closet in test cell X3B"
    annotation (Placement(transformation(extent={{68,124},{108,164}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Electrical BEle(redeclare package Medium =
        Air, nPorts=2) "Electrical room in test cell X3B"
    annotation (Placement(transformation(extent={{244,124},{284,164}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3A.TestCellNoCelDiv X3A(redeclare package
      Medium = Air, nPorts=2) "Test cell X3A"
    annotation (Placement(transformation(extent={{-76,24},{-36,64}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3A.ClosetNoCelDiv AClo(redeclare package
      Medium = Air, nPorts=1) "Closet in test cell X3A"
    annotation (Placement(transformation(extent={{-86,124},{-46,164}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3A.Electrical AEle(redeclare package Medium =
        Air, nPorts=2) "Electrical room in test cell X3A"
    annotation (Placement(transformation(extent={{-212,124},{-172,164}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{280,-300},{300,-280}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-240,260},{-220,280}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiCloB(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow for the closet in test cell X3B"
    annotation (Placement(transformation(extent={{-30,240},{-10,260}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiCloA(
    table=[0,0,0,0; 86400,0,0,0], tableOnFile=false)
    "Internal gain heat flow for the closet in test cell X3A"
    annotation (Placement(transformation(extent={{-150,240},{-130,260}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiEleA(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow for the electrical room in test cell X3A"
    annotation (Placement(transformation(extent={{-290,240},{-270,260}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiEleB(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow for the electrical room in test cell X3B"
    annotation (Placement(transformation(extent={{132,240},{152,260}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPosA(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade in test cell X3A"
    annotation (Placement(transformation(extent={{-170,68},{-150,88}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPosB(
                                                table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade in test cell X3B"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiA(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow in test cell X3A (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-170,34},{-150,54}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiB(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow in test cell X3B (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Modelica.Blocks.Sources.CombiTimeTable airConCloA(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected closet of test cell X3A (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-126,222})));

  Buildings.Fluid.Sources.MassFlowSource_T airInCloA(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for the closet of test cell X3A"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-122,172})));
  Buildings.Fluid.Sources.Boundary_pT airOutCloA(redeclare package Medium = Air,
      nPorts=1) "Air outlet from the closet in test cell X3A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-154,134})));
  Modelica.Blocks.Sources.CombiTimeTable airConCloB(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected closet of test cell X3B (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,220})));

  Buildings.Fluid.Sources.MassFlowSource_T airInCloB(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for the closet of test cell X3B"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={14,172})));
  Buildings.Fluid.Sources.Boundary_pT airOutCloB(redeclare package Medium = Air,
      nPorts=1) "Air outlet from the closet in test cell X3B"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,134})));
  Modelica.Blocks.Sources.CombiTimeTable airConA(
    table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for test cell X3A (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-170,-2},{-150,18}})));

  Buildings.Fluid.Sources.MassFlowSource_T airInA(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{-134,-6},{-114,14}})));
  Buildings.Fluid.Sources.Boundary_pT airOutA(nPorts=1, redeclare package
      Medium = Air) "Air outlet for X3A"
    annotation (Placement(transformation(extent={{-132,-32},{-112,-12}})));
  Modelica.Blocks.Sources.CombiTimeTable airConB(
    table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for test cell X3B (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));

  Buildings.Fluid.Sources.MassFlowSource_T airInB(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for X3B"
    annotation (Placement(transformation(extent={{26,18},{46,38}})));
  Buildings.Fluid.Sources.Boundary_pT airOutB(nPorts=1, redeclare package
      Medium = Air) "Air outlet for X3B"
    annotation (Placement(transformation(extent={{28,-8},{48,12}})));
  Modelica.Blocks.Sources.CombiTimeTable airConEleA(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected electrical room in test cell X3A (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-252,218})));

  Buildings.Fluid.Sources.MassFlowSource_T airInEleA(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1)
    "Inlet air conditions (from AHU) for the electrical room in test cell X3A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-260,164})));
  Buildings.Fluid.Sources.Boundary_pT airOutEleA(redeclare package Medium = Air,
      nPorts=1) "Air outlet from the electrical room in test cell X3A"
    annotation (Placement(transformation(extent={{-296,124},{-276,144}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab slaA(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229,
    m_flow_nominal=0.504) "Model of a radiant slab attached to test cell X3A"
    annotation (Placement(transformation(extent={{-92,-84},{-72,-64}})));

  Modelica.Blocks.Sources.CombiTimeTable watConA(tableOnFile=false, table=[0,0.504,
        293.15; 86400,0.504,293.15])
    "Inlet water conditions in test cell X3A (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Fluid.Sources.MassFlowSource_T watInA(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant) in the radiant slab serving X3A"
    annotation (Placement(transformation(extent={{-138,-84},{-118,-64}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT
    "Temperature of the ground"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-112})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(
    table=[0,288.15; 86400,288.15], tableOnFile=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-140})));
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    slaCon(nLay=3, material={
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1524,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.127,
        k=0.036,
        c=1200,
        d=40),
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)}) "Construction of the slab"
    annotation (Placement(transformation(extent={{-180,-144},{-160,-124}})));
  Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe(dOut=0.015875, dIn=0.01905)
    annotation (Placement(transformation(extent={{-180,-122},{-160,-102}})));
  Buildings.Fluid.Sources.Boundary_pT watOutA(nPorts=1, redeclare package
      Medium = Water) "Water outlet in test cell X3A"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-20,-74})));
  Buildings.Fluid.Sources.Boundary_pT watOutB(nPorts=1, redeclare package
      Medium = Water) "Water outlet in test cell X3B"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={154,-74})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab slaB(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229,
    m_flow_nominal=0.504) "Radiant slab connected to test cell X3B"
    annotation (Placement(transformation(extent={{102,-84},{122,-64}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon(
                                              tableOnFile=false, table=[0,0.504,
        293.15; 86400,0.504,293.15])
    "Inlet water conditions for radiant slab connected to X3B (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{14,-80},{34,-60}})));
  Buildings.Fluid.Sources.MassFlowSource_T watInB(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions for radiant slab connected to X3B (from central plant)"
    annotation (Placement(transformation(extent={{56,-84},{76,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable TNei(    tableOnFile=false, table=[0,293.15;
        86400,293.15]) "Temperature of the neighboring test cells (y[1] = X2B)"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-274,-42})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT2      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-240,-42})));
  Buildings.Fluid.Sources.Boundary_pT airOutEleB(redeclare package Medium = Air,
      nPorts=1) "Air outlet from the electrical room in test cell X3B"
    annotation (Placement(transformation(extent={{132,124},{152,144}})));
  Buildings.Fluid.Sources.MassFlowSource_T airInEleB(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1)
    "Inlet air conditions (from AHU) for the electrical room in test cell X3B"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={168,164})));
  Modelica.Blocks.Sources.CombiTimeTable airConEleB(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected electrical room in test cell X3B (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={176,218})));

equation
  connect(X3B.surf_conBou[2], BClo.surf_surBou[1]) annotation (Line(
      points={{108,27.75},{108,18},{126,18},{126,98},{84.2,98},{84.2,129.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[3], BClo.surf_surBou[2]) annotation (Line(
      points={{108,28.25},{108,18},{126,18},{126,98},{84.2,98},{84.2,130.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[4], BEle.surf_surBou[1]) annotation (Line(
      points={{108,28.75},{108,18},{126,18},{126,98},{260.2,98},{260.2,129.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(BClo.surf_conBou[1], BEle.surf_surBou[2]) annotation (Line(
      points={{94,127.333},{94,116},{260.2,116},{260.2,130.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3A.surf_surBou[2], X3B.surf_conBou[1]) annotation (Line(
      points={{-59.8,30.5},{-59.8,-12},{108,-12},{108,27.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(AClo.surf_surBou[3], BClo.surf_conBou[2]) annotation (Line(
      points={{-69.8,130.667},{-69.8,116},{94,116},{94,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3A.surf_conBou[2], AClo.surf_surBou[1]) annotation (Line(
      points={{-50,27.75},{-50,24},{-30,24},{-30,100},{-69.8,100},{-69.8,
          129.333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(X3A.surf_conBou[3], AClo.surf_surBou[2]) annotation (Line(
      points={{-50,28.25},{-50,24},{-30,24},{-30,100},{-69.8,100},{-69.8,130}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(AEle.surf_surBou[2], AClo.surf_conBou[1]) annotation (Line(
      points={{-195.8,130.5},{-195.8,122},{-60,122},{-60,127.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, AEle.weaBus) annotation (Line(
      points={{-220,270},{-174.1,270},{-174.1,161.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, AClo.weaBus) annotation (Line(
      points={{-220,270},{-48.1,270},{-48.1,161.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, X3A.weaBus) annotation (Line(
      points={{-220,270},{-38.1,270},{-38.1,61.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, BClo.weaBus) annotation (Line(
      points={{-220,270},{105.9,270},{105.9,161.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, X3B.weaBus) annotation (Line(
      points={{-220,270},{119.9,270},{119.9,61.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, BEle.weaBus) annotation (Line(
      points={{-220,270},{281.9,270},{281.9,161.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(X3A.surf_conBou[4], AEle.surf_surBou[1]) annotation (Line(
      points={{-50,28.75},{-50,24},{-30,24},{-30,100},{-195.8,100},{-195.8,129.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intGaiCloB.y, BClo.qGai_flow) annotation (Line(
      points={{-9,250},{50,250},{50,154},{60,154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiCloA.y, AClo.qGai_flow) annotation (Line(
      points={{-129,250},{-100,250},{-100,154},{-94,154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEleA.y, AEle.qGai_flow) annotation (Line(
      points={{-269,250},{-230,250},{-230,154},{-220,154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEleB.y, BEle.qGai_flow) annotation (Line(
      points={{153,250},{226,250},{226,154},{236,154}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPosA.y, X3A.uSha) annotation (Line(
      points={{-149,78},{-86,78},{-86,60},{-78,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPosB.y, X3B.uSha) annotation (Line(
      points={{11,90},{72,90},{72,60},{80,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiA.y, X3A.qGai_flow) annotation (Line(
      points={{-149,44},{-100,44},{-100,54},{-84,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiB.y, X3B.qGai_flow) annotation (Line(
      points={{11,62},{46,62},{46,54},{74,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutCloA.ports[1], AClo.ports[1]) annotation (Line(
      points={{-144,134},{-81,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInCloA.ports[1], AClo.ports[1]) annotation (Line(
      points={{-122,162},{-122,134},{-81,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airConCloA.y[2], airInCloA.m_flow_in) annotation (Line(
      points={{-126,211},{-126,198},{-130,198},{-130,182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConCloA.y[4], airInCloA.T_in) annotation (Line(
      points={{-126,211},{-126,184}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConCloB.y[2], airInCloB.m_flow_in) annotation (Line(
      points={{10,209},{10,200},{6,200},{6,182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConCloB.y[4], airInCloB.T_in) annotation (Line(
      points={{10,209},{10,184}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutCloB.ports[1], BClo.ports[1]) annotation (Line(
      points={{-8,134},{71,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInCloB.ports[1], BClo.ports[2]) annotation (Line(
      points={{14,162},{14,134},{75,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airConA.y[1], airInA.m_flow_in)
                                        annotation (Line(
      points={{-149,8},{-142,8},{-142,12},{-134,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConA.y[4], airInA.T_in)
                                   annotation (Line(
      points={{-149,8},{-136,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airInA.ports[1], X3A.ports[1]) annotation (Line(
      points={{-114,4},{-80,4},{-80,34},{-73,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOutA.ports[1], X3A.ports[2]) annotation (Line(
      points={{-112,-22},{-80,-22},{-80,34},{-69,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airConB.y[1], airInB.m_flow_in)
                                        annotation (Line(
      points={{11,32},{18,32},{18,36},{26,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConB.y[4], airInB.T_in)
                                   annotation (Line(
      points={{11,32},{24,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airInB.ports[1], X3B.ports[1]) annotation (Line(
      points={{46,28},{80,28},{80,34},{85,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOutB.ports[1], X3B.ports[2]) annotation (Line(
      points={{48,2},{80,2},{80,34},{89,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airConEleA.y[3], airInEleA.m_flow_in)
                                              annotation (Line(
      points={{-252,207},{-252,174}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConEleA.y[4], airInEleA.T_in) annotation (Line(
      points={{-252,207},{-252,194},{-256,194},{-256,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutEleA.ports[1], AEle.ports[1]) annotation (Line(
      points={{-276,134},{-209,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInEleA.ports[1], AEle.ports[2]) annotation (Line(
      points={{-260,154},{-260,134},{-205,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(slaA.surf_b, preT.port)                 annotation (Line(
      points={{-78,-84},{-78,-102},{1.33227e-15,-102}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watInA.ports[1], slaA.port_a)  annotation (Line(
      points={{-118,-74},{-92,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watConA.y[1], watInA.m_flow_in)
                                        annotation (Line(
      points={{-159,-70},{-148,-70},{-148,-66},{-138,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watConA.y[2], watInA.T_in)
                                   annotation (Line(
      points={{-159,-70},{-140,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{0,-129},{0,-124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(slaA.port_b, watOutA.ports[1]) annotation (Line(
      points={{-72,-74},{-30,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(slaA.surf_a, X3A.surf_surBou[1]) annotation (Line(
      points={{-78,-64},{-78,-42},{-59.8,-42},{-59.8,29.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watInB.ports[1], slaB.port_a)  annotation (Line(
      points={{76,-74},{102,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1], watInB.m_flow_in)
                                        annotation (Line(
      points={{35,-70},{46,-70},{46,-66},{56,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2], watInB.T_in)
                                   annotation (Line(
      points={{35,-70},{54,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(slaB.surf_a, X3B.surf_surBou[1]) annotation (Line(
      points={{116,-64},{116,-34},{98.2,-34},{98.2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(slaB.port_b, watOutB.ports[1]) annotation (Line(
      points={{122,-74},{144,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preT.port, slaB.surf_b) annotation (Line(
      points={{1.11022e-15,-102},{116,-102},{116,-84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TNei.y[1], preT2.T) annotation (Line(
      points={{-263,-42},{-252,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT2.port, X3A.surf_conBou[1]) annotation (Line(
      points={{-230,-42},{-60,-42},{-60,14},{-50,14},{-50,27.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, BClo.surf_conBou[3]) annotation (Line(
      points={{0,-102},{0,12},{-20,12},{-20,112},{94,112},{94,128.667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, BEle.surf_conBou[1]) annotation (Line(
      points={{1.11022e-15,-102},{0,-102},{0,12},{-20,12},{-20,112},{270,112},{270,
          128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, AEle.surf_conBou[1]) annotation (Line(
      points={{0,-102},{0,12},{-20,12},{-20,112},{-186,112},{-186,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, AClo.surf_conBou[3]) annotation (Line(
      points={{0,-102},{0,12},{-20,12},{-20,112},{-60,112},{-60,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airConEleB.y[4], airInEleB.T_in) annotation (Line(
      points={{176,207},{176,194},{172,194},{172,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConEleB.y[3], airInEleB.m_flow_in)
                                              annotation (Line(
      points={{176,207},{176,174}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutEleB.ports[1], BEle.ports[1]) annotation (Line(
      points={{152,134},{247,134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInEleB.ports[1], BEle.ports[2]) annotation (Line(
      points={{168,154},{168,134},{251,134}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -300},{300,300}}), graphics), Commands(file="Resources/Scripts/Dymola/Rooms/FLEXLAB/Rooms/Examples/X3BConnectedToX3AWithRadiantFloor.mos"
        "Simulate and Plot"));
end X3BConnectedToX3AWithRadiantFloor;
