within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples;
model X3BWithRadiantFloor "Example model showing a use of X3B"
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.Air "Air model used in the example model";
  package Water = Buildings.Media.Water
    "Water model used in the radiant slab loop";

  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell X3B(
    nPorts=2,
    redeclare package Medium = Air,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    datConBou(stateAtSurface_a = {false, true, true, true}))
              annotation (Placement(transformation(extent={{-110,38},{-70,78}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,0,0; 86400,0,0,0],
      tableOnFile=false)
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-196,92},{-176,112}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{-196,124},{-176,144}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:5) "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-196,54},{-176,74}})));
  Buildings.Fluid.Sources.MassFlowSource_T airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Fluid.Sources.Boundary_pT
    airOut(nPorts=1, redeclare package Medium = Air) "Air outlet for X3A"
    annotation (Placement(transformation(extent={{-158,24},{-138,44}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preT
    "Temperature of the ground"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-158})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(
    table=[0,288.15; 86400,288.15], tableOnFile=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-186})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
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
    annotation (Placement(transformation(extent={{-196,-196},{-176,-176}})));
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe(dIn=0.015875, dOut=0.01905)
    annotation (Placement(transformation(extent={{-196,-174},{-176,-154}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT2      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-114})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Electrical ele(
    redeclare package Medium = Air,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of the electrical room"
    annotation (Placement(transformation(extent={{54,-80},{94,-40}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet
    clo(
    redeclare package Medium = Air,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    datConBou(stateAtSurface_a = {true, false, false}))
    "Model of the closet"
    annotation (Placement(transformation(extent={{156,92},{196,132}})));
  Modelica.Blocks.Sources.CombiTimeTable TNei(
    tableOnFile=false,
    table=[0,293.15; 86400,293.15])
    "Temperature of the neighboring test cell (y[1] = X3A)"
    annotation (Placement(transformation(extent={{110,-124},{90,-104}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiEle(
    table=[0,0,0,0; 86400,0,0,0], tableOnFile=false)
    "Internal gain heat flow for the electrical room"
    annotation (Placement(transformation(extent={{-68,-16},{-48,4}})));
  Modelica.Blocks.Sources.CombiTimeTable airConEle(
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:5)
    "Inlet air conditions for the connected electrical room (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-58,-38})));

  Modelica.Blocks.Sources.CombiTimeTable airConClo(
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:5)
    "Inlet air conditions for the connected closet (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-2,112})));

  Buildings.Fluid.Sources.MassFlowSource_T airInEle(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for the electrical room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-6,-42})));
  Buildings.Fluid.Sources.Boundary_pT airOutEle(nPorts=1, redeclare package
      Medium = Air) "Air outlet from the electrical room"
    annotation (Placement(transformation(extent={{-18,-80},{2,-60}})));
  Buildings.Fluid.Sources.MassFlowSource_T airInClo(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for the closet"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,116})));
  Buildings.Fluid.Sources.Boundary_pT airOutClo(
    redeclare package Medium = Air, nPorts=1) "Air outlet from the closet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={50,80})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiClo(
    table=[0,0,0,0; 86400,0,0,0], tableOnFile=false)
    "Internal gain heat flow for the closet"
    annotation (Placement(transformation(extent={{-12,132},{8,152}})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B2(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-248,-96},{-228,-76}})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B3(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-280,-58},{-260,-38}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B3(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-238,-62},{-218,-42}})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B4(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-300,-12},{-280,8}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B4(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-252,-16},{-232,4}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4B4(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*3.65,
    disPip=sla4B4.A/sla4B4.length,
    length=48.77,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the south section of cell X3B. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-222,-16},{-202,4}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B4(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-182,-6})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4B3(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*0.91,
    disPip=sla4B3.A/sla4B3.length,
    length=37.49,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the south-central section of cell X3B. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-192,-62},{-172,-42}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B3(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-152,-52})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B2(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-206,-100},{-186,-80}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4B2(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*1.51,
    length=45.11,
    disPip=sla4B2.A/sla4B2.length,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the north-central section of cell X3B. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-152,-100},{-132,-80}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B2(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-112,-90})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B1(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-208,-132},{-188,-112}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B1(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-172,-136},{-152,-116}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4B1(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*3.09,
    disPip=sla4B1.A/sla4B1.length,
    length=38.71,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the north side of cell X3B. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-108,-136},{-88,-116}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B1(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,-126})));
equation
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-175,64},{-168,64},{-168,68},{-160,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[4],airIn. T_in) annotation (Line(
      points={{-175,64},{-162,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1],X3B. ports[1]) annotation (Line(
      points={{-140,60},{-132,60},{-132,46},{-105,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1],X3B. ports[2]) annotation (Line(
      points={{-138,34},{-132,34},{-132,50},{-105,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{-94,-175},{-94,-170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,X3B. weaBus) annotation (Line(
      points={{-100,180},{-72.1,180},{-72.1,75.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaPos.y,X3B. uSha) annotation (Line(
      points={{-175,134},{-118,134},{-118,76},{-111.6,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, ele.weaBus)    annotation (Line(
      points={{-100,180},{91.9,180},{91.9,-42.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus,clo. weaBus) annotation (Line(
      points={{-100,180},{193.9,180},{193.9,129.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(airConEle.y[4], airInEle.T_in) annotation (Line(
      points={{-47,-38},{-18,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airInEle.ports[1], ele.ports[1])    annotation (Line(
      points={{4,-42},{12,-42},{12,-72},{59,-72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele.ports[2], airOutEle.ports[1])    annotation (Line(
      points={{59,-68},{30,-68},{30,-70},{2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele.surf_surBou[2], clo.surf_conBou[1])    annotation (Line(
      points={{70.2,-74},{70,-74},{70,-88},{182,-88},{182,96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airInClo.ports[1],clo. ports[1]) annotation (Line(
      points={{60,116},{110,116},{110,100},{161,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airConClo.y[4], airInClo.T_in) annotation (Line(
      points={{9,112},{38,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConEle.y[3], airInEle.m_flow_in) annotation (Line(
      points={{-47,-38},{-36,-38},{-36,-34},{-16,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConClo.y[2], airInClo.m_flow_in) annotation (Line(
      points={{9,112},{20,112},{20,108},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutClo.ports[1],clo. ports[2]) annotation (Line(
      points={{60,80},{110,80},{110,104},{161,104}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intGai.y,X3B. qGai_flow) annotation (Line(
      points={{-175,102},{-140,102},{-140,66},{-111.6,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEle.y, ele.qGai_flow)    annotation (Line(
      points={{-47,-6},{20,-6},{20,-52},{52.4,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiClo.y,clo. qGai_flow) annotation (Line(
      points={{9,142},{120,142},{120,120},{154.4,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port,clo.surf_conBou[3]) annotation (Line(
      points={{-94,-148},{-94,-142},{182,-142},{182,96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ele.surf_conBou[1], preT.port)    annotation (Line(
      points={{80,-76},{80,-92},{-16,-92},{-16,-142},{-94,-142},{-94,-148}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[2], clo.surf_surBou[1]) annotation (Line(
      points={{-84,42},{-84,14},{172.2,14},{172.2,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[3], clo.surf_surBou[2]) annotation (Line(
      points={{-84,42},{-84,14},{172.2,14},{172.2,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[4], ele.surf_surBou[1]) annotation (Line(
      points={{-84,42},{-84,-88},{70.2,-88},{70.2,-74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TNei.y[1], preT2.T)   annotation (Line(
      points={{89,-114},{76,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT2.port, X3B.surf_conBou[1])   annotation (Line(
      points={{54,-114},{-84,-114},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT2.port, clo.surf_conBou[2])   annotation (Line(
      points={{54,-114},{40,-114},{40,-96},{182,-96},{182,96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watCon4B2.y[1],watIn4B2. m_flow_in) annotation (Line(
      points={{-227,-86},{-216,-86},{-216,-82},{-206,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B2.y[2],watIn4B2. T_in) annotation (Line(
      points={{-227,-86},{-208,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B3.y[1],watIn4B3. m_flow_in) annotation (Line(
      points={{-259,-48},{-248,-48},{-248,-44},{-238,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B3.y[2],watIn4B3. T_in) annotation (Line(
      points={{-259,-48},{-240,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B4.y[1],watIn4B4. m_flow_in) annotation (Line(
      points={{-279,-2},{-266,-2},{-266,2},{-252,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B4.y[2],watIn4B4. T_in) annotation (Line(
      points={{-279,-2},{-254,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4B4.ports[1],sla4B4. port_a) annotation (Line(
      points={{-232,-6},{-222,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn4B3.ports[1],sla4B3. port_a) annotation (Line(
      points={{-218,-52},{-192,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B4.port_b,watOut4B4. ports[1]) annotation (Line(
      points={{-202,-6},{-192,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B3.port_b,watOut4B3. ports[1]) annotation (Line(
      points={{-172,-52},{-162,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn4B2.ports[1],sla4B2. port_a) annotation (Line(
      points={{-186,-90},{-152,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B2.port_b,watOut4B2. ports[1]) annotation (Line(
      points={{-132,-90},{-122,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4B1.y[2],watIn4B1. T_in)
                                   annotation (Line(
      points={{-187,-122},{-174,-122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4B1.ports[1],sla4B1. port_a)
                                         annotation (Line(
      points={{-152,-126},{-108,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B1.port_b,watOut4B1. ports[1])
                                          annotation (Line(
      points={{-88,-126},{-70,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preT.port, sla4B1.surf_b) annotation (Line(
      points={{-94,-148},{-94,-136}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4B2.surf_b) annotation (Line(
      points={{-94,-148},{-94,-142},{-138,-142},{-138,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4B3.surf_b) annotation (Line(
      points={{-94,-148},{-94,-142},{-138,-142},{-138,-104},{-178,-104},{-178,
          -62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4B4.surf_b) annotation (Line(
      points={{-94,-148},{-94,-142},{-138,-142},{-138,-104},{-178,-104},{-178,
          -70},{-208,-70},{-208,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B1.surf_a, X3B.surf_surBou[1]) annotation (Line(
      points={{-94,-116},{-94,44},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B2.surf_a, X3B.surf_surBou[2]) annotation (Line(
      points={{-138,-80},{-138,-60},{-93.8,-60},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B3.surf_a, X3B.surf_surBou[3]) annotation (Line(
      points={{-178,-42},{-178,-30},{-93.8,-30},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B4.surf_a, X3B.surf_surBou[4]) annotation (Line(
      points={{-208,4},{-208,14},{-93.8,14},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watCon4B1.y[1], watIn4B1.m_flow_in) annotation (Line(
      points={{-187,-122},{-182,-122},{-182,-118},{-172,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -220},{200,200}}), graphics),
          Documentation(info = "<html>
          <p>
          This model demonstrates one potential simulation using the models available in
          <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B</a>. This model is nearly identical to
          <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>. For a description
          of most of the connections and reasons behind them see that documentation. The changes
          to make this example model are:
          </p>
          <ul>
          <li>The room models were changed from X3A models to X3B models.</li>
          <li><a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell</a> has one external wall (modeled in datConExt)
          which was a dividing wall (modeled in datConBou) in
          <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell</a>. Because of this, a few construction indexes
          changed. Connections were made according to the table in
          <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B</a>.</li>
          </ul>
          </html>",
          revisions="<html>
          <ul>
          <li>
          December 07, 2016, by Thierry S. Nouidui:<br/>
          Changed example to place a state at the surface.
          </li>
          <li>
          August 23, 2016, by Thierry S. Nouidui:<br/>
          Corrected the syntax of the weather data file name entry.
          </li>
          <li>
          April 21, 2016, by Michael Wetter:<br/>
          Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
          <code>Modelica.Utilities.Files.loadResource</code>.
          </li>
          <li>
          December 22, 2014 by Michael Wetter:<br/>
          Removed <code>Modelica.Fluid.System</code>
          to address issue
          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
          </li>
          <li>September 2, 2014, by Michael Wetter:<br/>
          Corrected wrong pipe diameter.
          </li>
          <li>June 30, 2014, by Michael Wetter:<br/>
          Specified equations to be used to compute the initial conditions.</li>
          <li>October 11, 2013, by Michael Wetter:<br/>
          Added missing <code>parameter</code> keyword in the declaration of the data record.</li>
          <li>Sep 18, 2013 by Peter Grant:<br/>
          First implementation.</li>
          </ul>
          </html>"),
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3BWithRadiantFloor.mos"
        "Simulate and plot"),
     experiment(Tolerance=1e-6, StopTime=864000));
end X3BWithRadiantFloor;
