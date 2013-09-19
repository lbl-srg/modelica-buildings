within Buildings.Rooms.FLEXLAB.Rooms.Examples;
model X3BWithRadiantFloor "Example model showing a use of X3B"
  import Buildings;
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Air model used in the example model";
  package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Water model used in the radiant slab loop";

  Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell X3B(
    nPorts=2,
    redeclare package Medium = Air,
    linearizeRadiation=false)
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
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
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
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    sla(
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229,
    m_flow_nominal=0.504)
    annotation (Placement(transformation(extent={{-108,-136},{-88,-116}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon(
                                              tableOnFile=false, table=[0,0.504,
        293.15; 86400,0.504,293.15])
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-196,-132},{-176,-112}})));
  Buildings.Fluid.Sources.MassFlowSource_T watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-154,-136},{-134,-116}})));
  Buildings.Fluid.Sources.Boundary_pT watOut(
    nPorts=1, redeclare package Medium = Water) "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={16,-126})));
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
    annotation (Placement(transformation(extent={{-196,-196},{-176,-176}})));
  Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe(dOut=0.015875, dIn=0.01905)
    annotation (Placement(transformation(extent={{-196,-174},{-176,-154}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preT2      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-114})));
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Electrical ele(redeclare package Medium =
        Air, nPorts=2) "Model of the electrical room"
    annotation (Placement(transformation(extent={{54,-80},{94,-40}})));
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Closet
    clo(
    redeclare package Medium = Air,
    nPorts=2) "Model of the closet"
    annotation (Placement(transformation(extent={{156,92},{196,132}})));
  Modelica.Blocks.Sources.CombiTimeTable TNei(    tableOnFile=false, table=[0,293.15;
        86400,293.15]) "Temperature of the neighboring test cell (y[1] = X3A)"
    annotation (Placement(transformation(extent={{110,-124},{90,-104}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiEle(
    table=[0,0,0,0; 86400,0,0,0], tableOnFile=false)
    "Internal gain heat flow for the electrical room"
    annotation (Placement(transformation(extent={{-68,-16},{-48,4}})));
  Modelica.Blocks.Sources.CombiTimeTable airConEle(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected electrical room (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,-38})));

  Modelica.Blocks.Sources.CombiTimeTable airConClo(
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt",
    columns=2:5)
    "Inlet air conditions for the connected closet (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-2,112})));

  Buildings.Fluid.Sources.MassFlowSource_T airInEle(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for the electrical room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
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
        rotation=0,
        origin={50,80})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiClo(
    table=[0,0,0,0; 86400,0,0,0], tableOnFile=false)
    "Internal gain heat flow for the closet"
    annotation (Placement(transformation(extent={{-12,132},{8,152}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
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
      points={{-140,60},{-132,60},{-132,48},{-107,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1],X3B. ports[2]) annotation (Line(
      points={{-138,34},{-132,34},{-132,48},{-103,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.surf_b,preT. port)                  annotation (Line(
      points={{-94,-136},{-94,-148}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn.ports[1],sla. port_a)    annotation (Line(
      points={{-134,-126},{-108,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{-88,-126},{6,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in) annotation (Line(
      points={{-175,-122},{-164,-122},{-164,-118},{-154,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in) annotation (Line(
      points={{-175,-122},{-156,-122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{-94,-175},{-94,-170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a,X3B. surf_surBou[1]) annotation (Line(
      points={{-94,-116},{-94,0},{-93.8,0},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus,X3B. weaBus) annotation (Line(
      points={{-100,180},{-72.1,180},{-72.1,75.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaPos.y,X3B. uSha) annotation (Line(
      points={{-175,134},{-118,134},{-118,74},{-112,74}},
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
      points={{4,-42},{12,-42},{12,-70},{57,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele.ports[2], airOutEle.ports[1])    annotation (Line(
      points={{61,-70},{2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele.surf_surBou[2], clo.surf_conBou[1])    annotation (Line(
      points={{70.2,-73.5},{70,-73.5},{70,-88},{182,-88},{182,95.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airInClo.ports[1],clo. ports[1]) annotation (Line(
      points={{60,116},{110,116},{110,102},{159,102}},
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
      points={{60,80},{110,80},{110,102},{163,102}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intGai.y,X3B. qGai_flow) annotation (Line(
      points={{-175,102},{-140,102},{-140,68},{-118,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEle.y, ele.qGai_flow)    annotation (Line(
      points={{-47,-6},{20,-6},{20,-50},{46,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiClo.y,clo. qGai_flow) annotation (Line(
      points={{9,142},{120,142},{120,122},{148,122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT.port,clo. surf_conBou[3]) annotation (Line(
      points={{-94,-148},{-94,-142},{182,-142},{182,96.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ele.surf_conBou[1], preT.port)    annotation (Line(
      points={{80,-76},{80,-92},{-16,-92},{-16,-142},{-94,-142},{-94,-148}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[2], clo.surf_surBou[1]) annotation (Line(
      points={{-84,41.75},{-84,14},{172.2,14},{172.2,97.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[3], clo.surf_surBou[2]) annotation (Line(
      points={{-84,42.25},{-84,14},{172.2,14},{172.2,98.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(X3B.surf_conBou[4], ele.surf_surBou[1]) annotation (Line(
      points={{-84,42.75},{-84,-88},{70.2,-88},{70.2,-74.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TNei.y[1], preT2.T)   annotation (Line(
      points={{89,-114},{76,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preT2.port, X3B.surf_conBou[1])   annotation (Line(
      points={{54,-114},{-84,-114},{-84,41.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preT2.port, clo.surf_conBou[2])   annotation (Line(
      points={{54,-114},{40,-114},{40,-96},{182,-96},{182,96}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics),
          Documentation(info = "<html>
          <p>
          This model demonstrates one potential simulation using the models available in
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B\">
          Buildings.Rooms.FLEXLAB.Rooms.X3B</a>. This model is nearly identical to
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
          Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>. For a description
          of most of the connections and reasons behind them see that example. The changes
          to make this example model are:
          </p>
          <ul>
          <li>The room models were changed from X3A models to X3B models.</li>
          <li><a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell\">
          Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell</a> has one external wall which was a dividing 
          wall in <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3A\">
          Buildings.Rooms.FLEXLAB.Rooms.X3A</a>. Because of this, a few construction indexes
          changed. Connections were made according to the list in 
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B\">
          Buildings.Rooms.FLEXLAB.Rooms.X3B</a>.</li>
          </ul>
          </html>",
          revisions = "<html>
          <ul>
          <li>Sep 18, 2013 by Peter Grant:<br/>
          First implementation.</li>
          </ul>
          </html>"),
     __Dymola_Commands(file="Resources/Scripts/Dymola/Rooms/FLEXLAB/Rooms/Examples/X3BWithRadiantFloor.mos"
        "Simulate and Plot"));
end X3BWithRadiantFloor;
