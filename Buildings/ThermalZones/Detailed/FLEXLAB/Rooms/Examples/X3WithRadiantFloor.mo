within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples;
model X3WithRadiantFloor
  "Example model of test cells X3A and X3B connected to form test bed X3"
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.Air "Air model used in the example model";
  package Water = Buildings.Media.Water
    "Water model used in the radiant slab loop";

  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell X3B(redeclare
      package                                                                      Medium = Air,
      nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Test cell X3B"
    annotation (Placement(transformation(extent={{82,24},{122,64}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet BClo(redeclare
      package                                                                     Medium = Air,
      nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Closet in test cell X3B"
    annotation (Placement(transformation(extent={{68,124},{108,164}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Electrical BEle(redeclare
      package                                                                         Medium =
        Air, nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Electrical room in test cell X3B"
    annotation (Placement(transformation(extent={{244,124},{284,164}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCellFullBed  X3A(redeclare
      package
      Medium = Air, nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Test cell X3A"
    annotation (Placement(transformation(extent={{-76,24},{-36,64}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.ClosetFullBed  AClo(redeclare
      package
      Medium = Air, nPorts=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Closet in test cell X3A"
    annotation (Placement(transformation(extent={{-86,124},{-46,164}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Electrical AEle(redeclare
      package                                                                         Medium =
        Air, nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Electrical room in test cell X3A"
    annotation (Placement(transformation(extent={{-212,124},{-172,164}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
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
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
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
        origin={-154,134})));
  Modelica.Blocks.Sources.CombiTimeTable airConCloB(
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
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
        origin={-18,134})));
  Modelica.Blocks.Sources.CombiTimeTable airConA(
    table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
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
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
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
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
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

  Buildings.HeatTransfer.Sources.PrescribedTemperature preT
    "Temperature of the ground"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-254})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(
    table=[0,288.15; 86400,288.15], tableOnFile=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-290})));
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
    annotation (Placement(transformation(extent={{-266,-280},{-246,-260}})));
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe(dIn=0.015875, dOut=0.01905)
    annotation (Placement(transformation(extent={{-266,-258},{-246,-238}})));

  Modelica.Blocks.Sources.CombiTimeTable TNei(    tableOnFile=false, table=[0,293.15;
        86400,293.15]) "Temperature of the neighboring test cells (y[1] = X2B)"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-274,-42})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT2      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
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
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:5)
    "Inlet air conditions for the connected electrical room in test cell X3B (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={176,218})));

  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4A1(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*3.09,
    length=32.92,
    disPip=sla4A1.A/sla4A1.length,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the north side of cell X3A. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-74,-220},{-54,-200}})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A1(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-182,-216},{-162,-196}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A1(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-126,-220},{-106,-200}})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A2(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-222,-180},{-202,-160}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A2(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-180,-184},{-160,-164}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4A2(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*1.51,
    disPip=sla4A2.A/sla4A2.length,
    length=45.11,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the north-central section of cell X3A. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-126,-184},{-106,-164}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4A2(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-86,-174})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A3(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-254,-142},{-234,-122}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A3(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-212,-146},{-192,-126}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4A3(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*0.91,
    disPip=sla4A3.A/sla4A3.length,
    length=42.98,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the south-central section of cell X3A. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-166,-146},{-146,-126}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4A3(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-126,-136})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A4(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-274,-96},{-254,-76}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A4(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-226,-100},{-206,-80}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla4A4(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    pipe=pipe,
    layers=slaCon,
    m_flow_nominal=0.504,
    A=6.645*3.65,
    disPip=sla4A4.A/sla4A4.length,
    length=50.9,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    stateAtSurface_b=false)
    "Radiant slab serving the south section of cell X3A. Name is taken from drawing M3.02"
    annotation (Placement(transformation(extent={{-196,-100},{-176,-80}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4A4(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-156,-90})));
  Buildings.Fluid.Sources.Boundary_pT watOut4A1(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-18,-210})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B1(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{186,-216},{166,-196}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B1(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{138,-220},{118,-200}})));
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
    annotation (Placement(transformation(extent={{60,-220},{40,-200}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B1(          redeclare package
      Medium = Water, nPorts=1) "Water outlet"
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={20,-210})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B2(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{214,-180},{194,-160}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B2(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{168,-184},{148,-164}})));
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
    annotation (Placement(transformation(extent={{106,-184},{86,-164}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B2(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={66,-174})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B3(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{226,-140},{206,-120}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B3(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{182,-144},{162,-124}})));
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
    annotation (Placement(transformation(extent={{150,-144},{130,-124}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B3(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-134})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4B4(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{272,-96},{252,-76}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4B4(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{228,-100},{208,-80}})));
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
    annotation (Placement(transformation(extent={{198,-100},{178,-80}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4B4(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={156,-90})));
equation
  connect(X3B.surf_conBou[2], BClo.surf_surBou[1]) annotation (Line(
      points={{108,28},{108,18},{126,18},{126,98},{84.2,98},{84.2,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[3], BClo.surf_surBou[2]) annotation (Line(
      points={{108,28},{108,18},{126,18},{126,98},{84.2,98},{84.2,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[4], BEle.surf_surBou[1]) annotation (Line(
      points={{108,28},{108,18},{126,18},{126,98},{260.2,98},{260.2,130}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(BClo.surf_conBou[1], BEle.surf_surBou[2]) annotation (Line(
      points={{94,128},{94,116},{260.2,116},{260.2,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3A.surf_surBou[5], X3B.surf_conBou[1]) annotation (Line(
      points={{-59.8,30},{-59.8,-12},{108,-12},{108,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(AClo.surf_surBou[3], BClo.surf_conBou[2]) annotation (Line(
      points={{-69.8,130},{-69.8,116},{94,116},{94,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3A.surf_conBou[2], AClo.surf_surBou[1]) annotation (Line(
      points={{-50,28},{-50,24},{-30,24},{-30,100},{-69.8,100},{-69.8,130}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(X3A.surf_conBou[3], AClo.surf_surBou[2]) annotation (Line(
      points={{-50,28},{-50,24},{-30,24},{-30,100},{-69.8,100},{-69.8,130}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(AEle.surf_surBou[2], AClo.surf_conBou[1]) annotation (Line(
      points={{-195.8,130},{-195.8,122},{-60,122},{-60,128}},
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
      points={{-50,28},{-50,24},{-30,24},{-30,100},{-195.8,100},{-195.8,130}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intGaiCloB.y, BClo.qGai_flow) annotation (Line(
      points={{-9,250},{50,250},{50,152},{66.4,152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiCloA.y, AClo.qGai_flow) annotation (Line(
      points={{-129,250},{-100,250},{-100,152},{-87.6,152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEleA.y, AEle.qGai_flow) annotation (Line(
      points={{-269,250},{-230,250},{-230,152},{-213.6,152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEleB.y, BEle.qGai_flow) annotation (Line(
      points={{153,250},{226,250},{226,152},{242.4,152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPosA.y, X3A.uSha) annotation (Line(
      points={{-149,78},{-86,78},{-86,62},{-77.6,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPosB.y, X3B.uSha) annotation (Line(
      points={{11,90},{72,90},{72,62},{80.4,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiA.y, X3A.qGai_flow) annotation (Line(
      points={{-149,44},{-100,44},{-100,52},{-77.6,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiB.y, X3B.qGai_flow) annotation (Line(
      points={{11,62},{46,62},{46,52},{80.4,52}},
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
      points={{-8,134},{32,134},{32,132},{73,132}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInCloB.ports[1], BClo.ports[2]) annotation (Line(
      points={{14,162},{14,136},{73,136}},
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
      points={{-114,4},{-80,4},{-80,32},{-71,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOutA.ports[1], X3A.ports[2]) annotation (Line(
      points={{-112,-22},{-80,-22},{-80,36},{-71,36}},
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
      points={{46,28},{80,28},{80,32},{87,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOutB.ports[1], X3B.ports[2]) annotation (Line(
      points={{48,2},{80,2},{80,36},{87,36}},
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
      points={{-276,134},{-242,134},{-242,132},{-207,132}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInEleA.ports[1], AEle.ports[2]) annotation (Line(
      points={{-260,154},{-260,136},{-207,136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{0,-279},{0,-266}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TNei.y[1], preT2.T) annotation (Line(
      points={{-263,-42},{-252,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT2.port, X3A.surf_conBou[1]) annotation (Line(
      points={{-230,-42},{-60,-42},{-60,14},{-50,14},{-50,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, BClo.surf_conBou[3]) annotation (Line(
      points={{0,-244},{0,14},{-20,14},{-20,114},{94,114},{94,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, BEle.surf_conBou[1]) annotation (Line(
      points={{1.11022e-15,-244},{0,-244},{0,14},{-20,14},{-20,114},{270,114},{
          270,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, AEle.surf_conBou[1]) annotation (Line(
      points={{0,-244},{0,14},{-20,14},{-20,114},{-186,114},{-186,128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, AClo.surf_conBou[2]) annotation (Line(
      points={{0,-244},{0,14},{-20,14},{-20,114},{-60,114},{-60,128}},
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
      points={{152,134},{200,134},{200,132},{249,132}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airInEleB.ports[1], BEle.ports[2]) annotation (Line(
      points={{168,154},{168,136},{249,136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn4A1.ports[1],sla4A1. port_a)
                                         annotation (Line(
      points={{-106,-210},{-74,-210}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4A1.y[1],watIn4A1. m_flow_in)
                                        annotation (Line(
      points={{-161,-206},{-144,-206},{-144,-202},{-126,-202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A1.y[2],watIn4A1. T_in)
                                   annotation (Line(
      points={{-161,-206},{-128,-206}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A2.y[1],watIn4A2. m_flow_in) annotation (Line(
      points={{-201,-170},{-190,-170},{-190,-166},{-180,-166}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A2.y[2],watIn4A2. T_in) annotation (Line(
      points={{-201,-170},{-182,-170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A2.ports[1],sla4A2. port_a) annotation (Line(
      points={{-160,-174},{-126,-174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A2.port_b,watOut4A2. ports[1]) annotation (Line(
      points={{-106,-174},{-96,-174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4A3.y[1],watIn4A3. m_flow_in) annotation (Line(
      points={{-233,-132},{-222,-132},{-222,-128},{-212,-128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A3.y[2],watIn4A3. T_in) annotation (Line(
      points={{-233,-132},{-214,-132}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A3.ports[1],sla4A3. port_a) annotation (Line(
      points={{-192,-136},{-166,-136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A3.port_b,watOut4A3. ports[1]) annotation (Line(
      points={{-146,-136},{-136,-136}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4A4.y[1],watIn4A4. m_flow_in) annotation (Line(
      points={{-253,-86},{-240,-86},{-240,-82},{-226,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A4.y[2],watIn4A4. T_in) annotation (Line(
      points={{-253,-86},{-228,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A4.ports[1],sla4A4. port_a) annotation (Line(
      points={{-206,-90},{-196,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A4.port_b,watOut4A4. ports[1]) annotation (Line(
      points={{-176,-90},{-166,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A1.port_b,watOut4A1. ports[1])
                                          annotation (Line(
      points={{-54,-210},{-28,-210}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preT.port, sla4A1.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{-60,-230},{-60,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4A1.surf_a, X3A.surf_surBou[1]) annotation (Line(
      points={{-60,-200},{-60,-172},{-59.8,-172},{-59.8,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4A2.surf_a, X3A.surf_surBou[2]) annotation (Line(
      points={{-112,-164},{-112,-152},{-59.8,-152},{-59.8,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4A2.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{-92,-230},{-92,-190},{-112,-190},{-112,-184}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(preT.port, sla4A3.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{-92,-230},{-92,-190},{-152,-190},{-152,-146}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(sla4A3.surf_a, X3A.surf_surBou[3]) annotation (Line(
      points={{-152,-126},{-152,-112},{-59.8,-112},{-59.8,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4A4.surf_a, X3A.surf_surBou[4]) annotation (Line(
      points={{-182,-80},{-182,-68},{-59.8,-68},{-59.8,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4A4.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{-92,-230},{-92,-190},{-152,-190},{-152,-154},{
          -182,-154},{-182,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn4B1.ports[1],sla4B1. port_a)
                                         annotation (Line(
      points={{118,-210},{60,-210}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B1.port_b, watOut4B1.ports[1]) annotation (Line(
      points={{40,-210},{30,-210}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4B1.y[2], watIn4B1.T_in) annotation (Line(
      points={{165,-206},{140,-206}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B1.y[1], watIn4B1.m_flow_in) annotation (Line(
      points={{165,-206},{150,-206},{150,-202},{138,-202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port, sla4B1.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{46,-230},{46,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B1.surf_a, X3B.surf_surBou[1]) annotation (Line(
      points={{46,-200},{46,-26},{98.2,-26},{98.2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B2.port_b, watOut4B2.ports[1]) annotation (Line(
      points={{86,-174},{76,-174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn4B2.ports[1], sla4B2.port_a) annotation (Line(
      points={{148,-174},{106,-174}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4B2.y[2], watIn4B2.T_in) annotation (Line(
      points={{193,-170},{170,-170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B2.y[1], watIn4B2.m_flow_in) annotation (Line(
      points={{193,-170},{180,-170},{180,-166},{168,-166}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port, sla4B2.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{92,-230},{92,-184}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B2.surf_a, X3B.surf_surBou[2]) annotation (Line(
      points={{92,-164},{92,-26},{98.2,-26},{98.2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watOut4B3.ports[1], sla4B3.port_b) annotation (Line(
      points={{120,-134},{130,-134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B3.port_a, watIn4B3.ports[1]) annotation (Line(
      points={{150,-134},{162,-134}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4B3.y[2], watIn4B3.T_in) annotation (Line(
      points={{205,-130},{184,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B3.y[1], watIn4B3.m_flow_in) annotation (Line(
      points={{205,-130},{194,-130},{194,-126},{182,-126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port, sla4B3.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{92,-230},{92,-192},{136,-192},{136,-144}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B3.surf_a, X3B.surf_surBou[3]) annotation (Line(
      points={{136,-124},{136,-26},{98.2,-26},{98.2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watOut4B4.ports[1], sla4B4.port_b) annotation (Line(
      points={{166,-90},{178,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4B4.port_a, watIn4B4.ports[1]) annotation (Line(
      points={{198,-90},{208,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4B4.y[2], watIn4B4.T_in) annotation (Line(
      points={{251,-86},{230,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4B4.y[1], watIn4B4.m_flow_in) annotation (Line(
      points={{251,-86},{240,-86},{240,-82},{228,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port, sla4B4.surf_b) annotation (Line(
      points={{0,-244},{0,-230},{92,-230},{92,-192},{136,-192},{136,-152},{154,
          -152},{154,-110},{184,-110},{184,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4B4.surf_a, X3B.surf_surBou[4]) annotation (Line(
      points={{184,-80},{184,-26},{98.2,-26},{98.2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -300},{300,300}})),           __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3WithRadiantFloor.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=864000),
        Documentation(info="<html>
<p>
This example models demonstrates how the <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A\">
Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A</a> and <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B\">
Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B</a> test cell models can be combined to form a simulation of test
bed X3. The example is primarily a combination of
<a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a> and
<a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor\">
Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor</a>. The example
<a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a> contains detailed
documentation on these models. Some small changes were necessary to create the model of the test
bed correctly. These changes are:
</p>
<ul>
<li>To make the connection between X3A and X3B possible two of the models from the X3A example were
replaced with models designed for connection to X3B.</li>
<li>Connections between the two test cells do not exist in either of the other two examples.
</li>
<li>The data reader models in this example function in the same manner as in the
other two examples, but their names had to be changed to avoid using the same name
for multiple models in this example. Their names now contain a suffix describing the test
cell they're connected to. For example, <code>airConA</code> is connected to test cell X3A and
<code>shaPosB</code> is connected to test cell X3B.</li>
<li>TNei now only contains a temperature for test cell X2B. A temperature input for X3B
is not needed because that test cell is now included in the model.</li>
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
        <li>Sep 19, 2013 by Peter Grant:<br/>
        First implementation.</li>
        </ul>
        </html>"));
end X3WithRadiantFloor;
