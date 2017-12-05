within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples;
model X3AWithRadiantFloor "Example model showing a use of X3A"
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.Air "Air model used in the example model";
  package Water = Buildings.Media.Water
    "Water model used in the radiant slab loop";

  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell X3A(
    nPorts=2,
    redeclare package Medium = Air,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
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
    columns=2:5) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
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
    annotation (Placement(transformation(extent={{-108,-136},{-88,-116}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon4A1(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-208,-132},{-188,-112}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A1(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-172,-136},{-152,-116}})));
  Buildings.Fluid.Sources.Boundary_pT watOut4A1(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,-126})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT
    "Temperature of the ground"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-170})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(
    table=[0,288.15; 86400,288.15], tableOnFile=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-198})));
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
    annotation (Placement(transformation(extent={{-196,-208},{-176,-188}})));
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe(dIn=0.015875, dOut=0.01905)
    annotation (Placement(transformation(extent={{-196,-186},{-176,-166}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT2[2]   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-114})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Electrical ele(
    redeclare package Medium = Air, nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of the electrical room"
    annotation (Placement(transformation(extent={{54,-80},{94,-40}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Closet
    clo(
    redeclare package Medium = Air,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of the closet"
    annotation (Placement(transformation(extent={{156,92},{196,132}})));
  Modelica.Blocks.Sources.CombiTimeTable TNei(
    table=[0,293.15,293.15; 86400,293.15,293.15], tableOnFile=false)
    "Temperature of the neighboring test cells (y[1] = X2B, y[2] = X3B)"
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
    "Inlet air conditions for the connected electrical room (y[1] = m_flow, y[4] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-58,-38})));

  Modelica.Blocks.Sources.CombiTimeTable airConClo(
    tableOnFile=true,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:5)
    "Inlet air conditions for the connected closet (y[1] = m_flow, y[4] = T)"
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
  Modelica.Blocks.Sources.CombiTimeTable watCon4A2(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-248,-96},{-228,-76}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A2(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-206,-100},{-186,-80}})));
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
    annotation (Placement(transformation(extent={{-152,-100},{-132,-80}})));

  Buildings.Fluid.Sources.Boundary_pT watOut4A2(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-112,-90})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A3(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-280,-58},{-260,-38}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A3(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-238,-62},{-218,-42}})));
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
    annotation (Placement(transformation(extent={{-192,-62},{-172,-42}})));

  Buildings.Fluid.Sources.Boundary_pT watOut4A3(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-152,-52})));
  Modelica.Blocks.Sources.CombiTimeTable watCon4A4(tableOnFile=false, table=[0,
        0.504,293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-300,-12},{-280,8}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn4A4(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-252,-16},{-232,4}})));
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
    annotation (Placement(transformation(extent={{-222,-16},{-202,4}})));

  Buildings.Fluid.Sources.Boundary_pT watOut4A4(nPorts=1, redeclare package
      Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-182,-6})));
equation
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-175,64},{-168,64},{-168,68},{-160,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[4],airIn. T_in) annotation (Line(
      points={{-175,64},{-162,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], X3A.ports[1]) annotation (Line(
      points={{-140,60},{-132,60},{-132,46},{-105,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], X3A.ports[2]) annotation (Line(
      points={{-138,34},{-132,34},{-132,50},{-105,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A1.surf_b, preT.port)               annotation (Line(
      points={{-94,-136},{-94,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn4A1.ports[1], sla4A1.port_a)
                                         annotation (Line(
      points={{-152,-126},{-108,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A1.port_b, watOut4A1.ports[1])
                                          annotation (Line(
      points={{-88,-126},{-70,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon4A1.y[1], watIn4A1.m_flow_in)
                                        annotation (Line(
      points={{-187,-122},{-180,-122},{-180,-118},{-172,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A1.y[2], watIn4A1.T_in)
                                   annotation (Line(
      points={{-187,-122},{-174,-122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{-94,-187},{-94,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, X3A.weaBus) annotation (Line(
      points={{-100,180},{-72.1,180},{-72.1,75.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaPos.y, X3A.uSha) annotation (Line(
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
  connect(ele.surf_surBou[1], X3A.surf_conBou[5])    annotation (Line(
      points={{70.2,-74},{70,-74},{70,-88},{-84,-88},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(clo.surf_surBou[1], X3A.surf_conBou[3]) annotation (Line(
      points={{172.2,98},{172,98},{172,-88},{-84,-88},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(clo.surf_surBou[2], X3A.surf_conBou[4]) annotation (Line(
      points={{172.2,98},{172,98},{172,-88},{-84,-88},{-84,42}},
      color={191,0,0},
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
  connect(preT2[1].port, X3A.surf_conBou[1])   annotation (Line(
      points={{54,-114},{-84,-114},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT2[2].port, X3A.surf_conBou[2])   annotation (Line(
      points={{54,-114},{-84,-114},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airInClo.ports[1],clo. ports[1]) annotation (Line(
      points={{60,116},{110,116},{110,100},{161,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TNei.y, preT2.T)   annotation (Line(
      points={{89,-114},{76,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT2[2].port, clo.surf_conBou[2])   annotation (Line(
      points={{54,-114},{36,-114},{36,-96},{182,-96},{182,96}},
      color={191,0,0},
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
  connect(intGai.y, X3A.qGai_flow) annotation (Line(
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
      points={{-94,-160},{-94,-142},{182,-142},{182,96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ele.surf_conBou[1], preT.port)    annotation (Line(
      points={{80,-76},{80,-92},{-16,-92},{-16,-142},{-94,-142},{-94,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4A1.surf_a, X3A.surf_surBou[1]) annotation (Line(
      points={{-94,-116},{-94,44},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watCon4A2.y[1], watIn4A2.m_flow_in) annotation (Line(
      points={{-227,-86},{-216,-86},{-216,-82},{-206,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A2.y[2], watIn4A2.T_in) annotation (Line(
      points={{-227,-86},{-208,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A2.ports[1], sla4A2.port_a) annotation (Line(
      points={{-186,-90},{-152,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A2.port_b, watOut4A2.ports[1]) annotation (Line(
      points={{-132,-90},{-122,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A2.surf_a, X3A.surf_surBou[2]) annotation (Line(
      points={{-138,-80},{-138,-48},{-93.8,-48},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4A2.surf_b) annotation (Line(
      points={{-94,-160},{-138,-160},{-138,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watCon4A3.y[1], watIn4A3.m_flow_in) annotation (Line(
      points={{-259,-48},{-248,-48},{-248,-44},{-238,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A3.y[2], watIn4A3.T_in) annotation (Line(
      points={{-259,-48},{-240,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A3.ports[1], sla4A3.port_a) annotation (Line(
      points={{-218,-52},{-192,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A3.port_b, watOut4A3.ports[1]) annotation (Line(
      points={{-172,-52},{-162,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A3.surf_a, X3A.surf_surBou[3]) annotation (Line(
      points={{-178,-42},{-178,-24},{-93.8,-24},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT.port, sla4A3.surf_b) annotation (Line(
      points={{-94,-160},{-138,-160},{-138,-106},{-178,-106},{-178,-62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watCon4A4.y[1], watIn4A4.m_flow_in) annotation (Line(
      points={{-279,-2},{-266,-2},{-266,2},{-252,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon4A4.y[2], watIn4A4.T_in) annotation (Line(
      points={{-279,-2},{-254,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watIn4A4.ports[1], sla4A4.port_a) annotation (Line(
      points={{-232,-6},{-222,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla4A4.port_b, watOut4A4.ports[1]) annotation (Line(
      points={{-202,-6},{-192,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preT.port, sla4A4.surf_b) annotation (Line(
      points={{-94,-160},{-138,-160},{-138,-106},{-178,-106},{-178,-72},{-208,
          -72},{-208,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla4A4.surf_a, X3A.surf_surBou[4]) annotation (Line(
      points={{-208,4},{-208,14},{-93.8,14},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -210},{200,200}})),
          Documentation(info = "<html>
          <p>
          This model demonstrates one potential simulation using the models available in
          <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A</a>. This example simulates test cell
          X3A when it is conditioned with a radiant slab. This example model includes
          heat transfer between the test cell, the outdoor environment, the radiant slab
          conditioning the test cell, the connected electrical room and closet, and the
          neighboring test cells.
          </p>
          <p>
          The connections between the test cell and the external models are described in the following table.
          Only models not included in the X3A package are included. For documentation describing the connections
          between X3A models see <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A\">
          Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A</a>.
          </p>
          <table border =\"1\" summary = \"Summary of connections between test cell and other models\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>X3A port</th>
          </tr>
          <tr>
          <td>weaDat</td>
          <td>Outdoor weather</td>
          <td>weaDat.weaBus</td>
          <td>X3A.weaBus</td>
          </tr>
          <tr>
          <td>TNei</td>
          <td>Neighboring test cells (X2B and X3B)</td>
          <td>X2B: X3A.preTem2.port[1]<br/>
          X3B: X3A.preTem2.port[2]</td>
          <td>X2B: X3A.surf_conBou[1]<br/>
          X3B: X3A.surf_conBou[2]</td>
          </tr>
          <tr>
          <td>sla4A1</td>
          <td>Radiant slab serving the north portion of X3A</td>
          <td>sla4A1.surf_a</td>
          <td>X3A.surf_surBou[1]</td>
          </tr>
          <tr>
          <td>sla4A2</td>
          <td>Radiant slab serving the north-central portion of X3A</td>
          <td>sla4A2.surf_a</td>
          <td>X3A.surf_surBou[2]</td>
          </tr>
          <tr>
          <td>sla4A3</td>
          <td>Radiant slab serving the south-central portion of X3A</td>
          <td>sla4A3.surf_a</td>
          <td>X3A.surf_surBou[3]</td>
          </tr>
          <tr>
          <td>sla4A4</td>
          <td>Radiant slab serving the south portion of X3A</td>
          <td>sla4A4.surf_a</td>
          <td>X3A.surf_surBou[4]</td>
          </tr>
          <tr>
          <td>shaPos</td>
          <td>Table describing the position of the window shade</td>
          <td>shaPos.y[1]</td>
          <td>X3A.uSha</td>
          </tr>
          <tr>
          <td>intGai</td>
          <td>Table specifying the internal gains in the space</td>
          <td>intGai[1,2,3]</td>
          <td>X3A.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airIn</td>
          <td>Prescribed airflow describing service air from the AHU</td>
          <td>airIn.ports[1]</td>
          <td>X3A.ports[1]</td>
          </tr>
          <tr>
          <td>airOut</td>
          <td>Outlet for ventilation air flow</td>
          <td>airOut.ports[1]</td>
          <td>X3A.ports[1]</td>
          </tr>
          </table>
          <p>
          The connections between the closet and external models are described in the following table.
          Only connections to models not included in the X3A package are described.
          </p>
          <table border=\"1\" summary = \"Summary of connections to the closet model\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>clo port</th>
          </tr>
          <tr>
          <td>intGaiClo</td>
          <td>Table specifying the internal gains in the closet</td>
          <td>intGaiClo[1,2,3]</td>
          <td>clo.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airInClo</td>
          <td>Prescribed airflow describing service air from the AHU</td>
          <td>airInClo.ports[1]</td>
          <td>clo.ports[1]</td>
          </tr>
          <tr>
          <td>airOutClo</td>
          <td>Outlet for ventilation air flow</td>
          <td>airOutClo.ports[1]</td>
          <td>clo.ports[1]</td>
          </tr>
          <tr>
          <td>preT</td>
          <td>Prescribed temperature describing the ground temperature</td>
          <td>preT.port</td>
          <td>clo.surf_conBou[3]</td>
          </tr>
          </table>
          <p>
          The connections between the electrical room and external models are described in the following
          table. Only connections to models not included in the X3A package are described.
          </p>
          <table border=\"1\" summary = \"Summary of connections to the electrical room model\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>ele port</th>
          </tr>
          <tr>
          <td>intGaiEle</td>
          <td>Table specifying the internal gains in the electrical room</td>
          <td>intGaiEle[1,2,3]</td>
          <td>ele.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airInEle</td>
          <td>Prescribed airflow describing service air from the AHU</td>
          <td>airInEle.ports[1]</td>
          <td>ele.ports[1]</td>
          </tr>
          <tr>
          <td>airOutEle</td>
          <td>Outlet for ventilation air flow</td>
          <td>airOutEle.ports[1]</td>
          <td>ele.ports[1]</td>
          </tr>
          <tr>
          <td>preT</td>
          <td>Prescribed temperature describing the ground temperature</td>
          <td>preT.port</td>
          <td>ele.surf_conBou[1]</td>
          </tr>
          </table>
          <p>
          The radiant slab is modeled using an instance of
          <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
          Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>. All of the inputs
          used to define the radiant slab are taken from the architectural drawings. The following
          table describes the connections between models used in the radiant slab. The connection
          to X3A is not included because it was previously described.
          </p>
          <table border=\"1\" summary = \"Summary of connections to the radiant slab model\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>Radiant slab port</th>
          </tr>
          <tr>
          <td>watIn</td>
          <td>Inlet for service fluid flow. Currently connects to a prescribed flow described
          in a table</td>
          <td>watIn.ports[1]</td>
          <td>sla.port_a</td>
          </tr>
          <tr>
          <td>preT</td>
          <td>Ground temperature beneath the radiant slab construction. Currently connects to
          a prescribed temperature defined in a table</td>
          <td>preT.port</td>
          <td>sla.surf_b</td>
          </tr>
          <tr>
          <td>watOut</td>
          <td>Outlet for service fluid flow</td>
          <td>watOut.ports[1]</td>
          <td>sla.port_b</td>
          </tr>
          </table>
          <p>
          The model only simulates the space conditions, the effects of the radiant slab, and the
          heat transfer between the rooms. The air handling unit, chilled water plant, shade control,
          internal gains, and ground temperature are all modeled by reading data from tables.
          Currently the ventilation air is read from an external data file, via the model
          <code>airCon</code>, while the others use tables described in the data reader model. The table
          below shows the name of data input files in the model, what physical phenomena the data file
          describes, the physical quantity of each data file output, and the source of the data.
          </p>
          <table border =\"1\" summary = \"Description of data table models\">
          <tr>
          <th>Model name</th>
          <th>Quantity described</th>
          <th>Data source</th>
          <th>y[1] significance</th>
          <th>y[2] significance</th>
          <th>y[3] significance</th>
          <th>y[4] significance</th>
          </tr>
          <tr>
          <td>shaPos</td>
          <td>Position of the shade</td>
          <td>Table in model</td>
          <td>Position of the shade</td>
          </tr>
          <tr>
          <td>intGai</td>
          <td>Internal gains</td>
          <td>Table in model</td>
          <td>Radiant heat</td>
          <td>Convective heat</td>
          <td>Latent heat</td>
          <td></td>
          </tr>
          <tr>
          <td>airCon</td>
          <td>Ventilation air from air handling unit</td>
          <td>External text file</td>
          <td>Mass flow rate</td>
          <td></td>
          <td></td>
          <td>Temperature</td>
          <td></td>
          </tr>
          <tr>
          <td>watCon</td>
          <td>Conditioning water from central plant</td>
          <td>Table in model</td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          <td></td>
          </tr>
          <tr>
          <td>TGro</td>
          <td>Ground temperature</td>
          <td>Table in model</td>
          <td>Temperature</td>
          <td></td>
          <td></td>
          </tr>
          <tr>
          <td>intGaiClo</td>
          <td>Internal gains for the closet</td>
          <td>Table in model</td>
          <td>Radiant heat</td>
          <td>Convective heat</td>
          <td>Latent heat</td>
          </tr>
          <tr>
          <td>intGaiEle</td>
          <td>Internal gains for the electrical room</td>
          <td>Table in model</td>
          <td>Radiant heat</td>
          <td>Convective heat</td>
          <td>Latent heat</td>
          </tr>
          <tr>
          <td>airConEle</td>
          <td>Ventilation air from AHU in the electrical room</td>
          <td>External text file</td>
          <td></td>
          <td></td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          </tr>
          <tr>
          <td>airConClo</td>
          <td>Ventilation air from AHU in closet</td>
          <td>External text file</td>
          <td></td>
          <td>Mass flow rate</td>
          <td></td>
          <td>Temperature</td>
          </tr>
          <tr>
          <td>TNei</td>
          <td>Temperature of the neighboring cells</td>
          <td>Table in model</td>
          <td>X2B</td>
          <td>X3B</td>
          </tr>
          </table>
          <p>
          In the above table blank entries either show that there is no data to describe, or that the data
          is describing a quantity for a separate model. Two examples are:
          <ul>
          <li>The table for shaPos only contains data for shade position. Because it only has a y[1] value
          the remaining columns in the table are left blank.</li>
          <li> airCon, airConClo, and airConEle all share an external data file. They all use the same
          temperature data, located in y[4] of the external data file. The three room models use different
          air mass flow rates. airCon uses the flow rate from y[1] in the data file, airConClo uses the
          flow rate from y[2], and airConEle uses the flow rate from y[3]. Thus, the other entries
          for each row in the table are left blank because the data is innapropriate for that particular
          model.</li>
          </ul>
          <p>
          The ventilation air flow rates used during occupied hours in this example were calculated using
          the assumption of 4 air changes per hour (ACH). It is assumed that there is
          no ventilation flow during unoccupied hours.
          </p>
          </html>",
          revisions="<html>
          <ul>
          <li>
          January 09, 2017, by Thierry S. Nouidui:<br/>
          Fixed wrong <code>port</code> index.
          </li>
          <li>
          December 07, 2016, by Thierry S. Nouidui:<br/>
          Changed example to place a state at the surface.
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
          <li>Sep 16, 2013 by Peter Grant:<br/>
          Added connections to include floor models in Closet and Electrical.</li>
          <li>Jun 10, 2013 by Peter Grant:<br/>
          First implementation.</li>
          </ul>
          </html>"),
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.mos"
        "Simulate and plot"),
     experiment(Tolerance=1e-6, StopTime=864000));
end X3AWithRadiantFloor;
