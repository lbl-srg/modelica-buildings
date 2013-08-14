within Buildings.Rooms.FLEXLAB.Rooms.Examples;
model UF90X3AWithRadiantFloor "Example model showing a use of UF90X3A"
  import Buildings;
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Air model used in the example model";
  package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Water model used in the radiant slab loop";

  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A
                                                 UF90X3A(
      nPorts=2,
    redeclare package Medium = Air,
    linearizeRadiation=false)
              annotation (Placement(transformation(extent={{-110,38},{-70,78}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-196,92},{-176,112}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
    "Position of the shade"
    annotation (Placement(transformation(extent={{-196,124},{-176,144}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName="Resources/Data/Rooms.FLEXLAB/Rooms/Examples/UF90X3AWithRadiantFloor.txt")
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-196,54},{-176,74}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU) for UF90X3A"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Fluid.Sources.Boundary_pT
                            airOut(nPorts=1, redeclare package Medium = Air)
    "Air outlet for UF90X3A"
    annotation (Placement(transformation(extent={{-158,24},{-138,44}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
                                                      sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    m_flow_nominal=0.063,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229)
    annotation (Placement(transformation(extent={{-108,-132},{-88,-112}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,293.15; 86400,
        0.06,293.15]) "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-196,-128},{-176,-108}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-154,-132},{-134,-112}})));
  Buildings.Fluid.Sources.Boundary_pT
                            watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={16,-122})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
                                             preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-154})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(table=[0,288.15; 86400,288.15])
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
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.127,
        k=0.036,
        c=1200,
        d=40),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)}) "Construction of the slab"
    annotation (Placement(transformation(extent={{-196,-196},{-176,-176}})));
  Buildings.Fluid.Data.Pipes.PEX_RADTEST
                               pipe
    annotation (Placement(transformation(extent={{-196,-174},{-176,-154}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem2[2] annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-108})));
  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3AElectrical
                           eleRoo(
    redeclare package Medium = Air,
    nPorts=2) "Model of the electrical room"
    annotation (Placement(transformation(extent={{54,-80},{94,-40}})));
  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3ACloset
                           clo(
    redeclare package Medium = Air,
    nPorts=2) "Model of the closet"
    annotation (Placement(transformation(extent={{156,92},{196,132}})));
  Modelica.Blocks.Sources.CombiTimeTable TNei(table=[0,293.15,293.15; 86400,
        293.15,293.15])
    "Temperature of the neighboring test cells (y[1] = UF90X2B, y[2] = UF90X3B)"
    annotation (Placement(transformation(extent={{110,-118},{90,-98}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiEle(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow for the electrical room"
    annotation (Placement(transformation(extent={{-68,-16},{-48,4}})));
  Modelica.Blocks.Sources.CombiTimeTable airConEle(table=[0,0.1,293.15; 86400,0.1,
        293.15], tableOnFile=false)
    "Inlet air conditions for the connected electrical room (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,-38})));
  Modelica.Blocks.Sources.CombiTimeTable airConClo(table=[0,0.1,293.15; 86400,0.1,
        293.15], tableOnFile=false)
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
  Buildings.Fluid.Sources.Boundary_pT airOutClo(          redeclare package
      Medium = Air, nPorts=1) "Air outlet from the closet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,80})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiClo(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow for the closet"
    annotation (Placement(transformation(extent={{-12,132},{8,152}})));
equation
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-175,64},{-168,64},{-168,68},{-160,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-175,64},{-162,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], UF90X3A.ports[1]) annotation (Line(
      points={{-140,60},{-132,60},{-132,48},{-107,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], UF90X3A.ports[2]) annotation (Line(
      points={{-138,34},{-132,34},{-132,48},{-103,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.surf_b,preT. port)                  annotation (Line(
      points={{-94,-132},{-94,-144}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn.ports[1],sla. port_a)    annotation (Line(
      points={{-134,-122},{-108,-122}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{-88,-122},{6,-122}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in) annotation (Line(
      points={{-175,-118},{-164,-118},{-164,-114},{-154,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in) annotation (Line(
      points={{-175,-118},{-156,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{-94,-175},{-94,-166}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, UF90X3A.surf_surBou[1]) annotation (Line(
      points={{-94,-112},{-94,0},{-93.8,0},{-93.8,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, UF90X3A.weaBus) annotation (Line(
      points={{-100,180},{-72.1,180},{-72.1,75.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaPos.y, UF90X3A.uSha) annotation (Line(
      points={{-175,134},{-118,134},{-118,74},{-112,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, eleRoo.weaBus) annotation (Line(
      points={{-100,180},{91.9,180},{91.9,-42.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, clo.weaBus) annotation (Line(
      points={{-100,180},{193.9,180},{193.9,129.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eleRoo.surf_surBou[1], UF90X3A.surf_conBou[5]) annotation (Line(
      points={{70.2,-74.5},{70,-74.5},{70,-82},{-84,-82},{-84,42.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(clo.surf_surBou[1], UF90X3A.surf_conBou[3]) annotation (Line(
      points={{172.2,97.5},{172,97.5},{172,-86},{-84,-86},{-84,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(clo.surf_surBou[1], UF90X3A.surf_conBou[4]) annotation (Line(
      points={{172.2,97.5},{172,97.5},{172,-86},{-84,-86},{-84,42.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airConEle.y[2], airInEle.T_in) annotation (Line(
      points={{-47,-38},{-18,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airInEle.ports[1], eleRoo.ports[1]) annotation (Line(
      points={{4,-42},{12,-42},{12,-70},{57,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(eleRoo.ports[2], airOutEle.ports[1]) annotation (Line(
      points={{61,-70},{2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(eleRoo.surf_surBou[2], clo.surf_conBou[1]) annotation (Line(
      points={{70.2,-73.5},{70,-73.5},{70,-82},{182,-82},{182,95.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preTem2[1].port, UF90X3A.surf_conBou[1]) annotation (Line(
      points={{40,-108},{-84,-108},{-84,41.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preTem2[2].port, UF90X3A.surf_conBou[2]) annotation (Line(
      points={{40,-108},{-84,-108},{-84,41.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airInClo.ports[1], clo.ports[1]) annotation (Line(
      points={{60,116},{110,116},{110,102},{159,102}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TNei.y, preTem2.T) annotation (Line(
      points={{89,-108},{62,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem2[2].port, clo.surf_conBou[2]) annotation (Line(
      points={{40,-108},{36,-108},{36,-90},{182,-90},{182,96.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(airConClo.y[2], airInClo.T_in) annotation (Line(
      points={{9,112},{38,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConEle.y[1], airInEle.m_flow_in) annotation (Line(
      points={{-47,-38},{-36,-38},{-36,-34},{-16,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airConClo.y[1], airInClo.m_flow_in) annotation (Line(
      points={{9,112},{20,112},{20,108},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airOutClo.ports[1], clo.ports[2]) annotation (Line(
      points={{60,80},{110,80},{110,102},{163,102}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intGai.y, UF90X3A.qGai_flow) annotation (Line(
      points={{-175,102},{-140,102},{-140,68},{-118,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiEle.y, eleRoo.qGai_flow) annotation (Line(
      points={{-47,-6},{20,-6},{20,-50},{46,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGaiClo.y, clo.qGai_flow) annotation (Line(
      points={{9,142},{120,142},{120,122},{148,122}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics),
          Documentation(info = "<html>
          <p>
          This model demonstrates one potential use of
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A\">
          Buildings.Rooms.Examples.FLEXLAB.Rooms.UF90X3A.UF90X3A</a>. This examples
          simulates the test cell when it is conditioned with a radiant slab.
          </p>
          <p>
          This example model of <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A\">
          Buildings.Rooms.FLEXLAB.UF90X3A.UF90X3A</a> includes heat transfer between the test cell,
          the outdoor environment, the radiant slab conditioning the test cell, the connected electrical room
          and closet, and the neighboring test cells. The following image is a drawing of test cell UF90X3A.
          It shows how the different rooms in this example are connected, as well as providing the names used
          in this example for each of the rooms.
          </p>        
          <p align=\"center\">
          <img src=\"modelica://Buildings/Resources/Images/Rooms.FLEXLAB/Rooms/Examples/UF90X3AWithRadiantFloor.png\"border=\"1\" alt=\"Room locations and names in UF90X3AWithRadiantFloor\"/>
          </p>                    
          <p>
          The connections between the test cell and the external models are described in the following table.
          </p>
          <table border =\"1\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>UF90X3A port</th>
          </tr>
          <tr>
          <td>weaDat</td>
          <td>Outdoor weather</td>
          <td>weaDat.weaBus</td>
          <td>UF90X3A.weaBus</td>
          </tr>          
          <tr>
          <td>TNei</td>
          <td>Neighboring test cells</td>
          <td>UF90X2B: UF90X3A.preTem2.port[1]; UF90X3B: UF90X3A.preTem2.port[2]</td>
          <td>UF90X2B: UF90X3A.surf_conBou[1]; UF90X3B: UF90X3A.surf_conBou[2]</td>
          </tr>          
          <tr>
          <td>clo</td>
          <td>Closet</td>
          <td>Door: clo.surf_surBou[2]; Wall: clo.surf_surBou[1]</td>
          <td>Door: UF90X3A.surf_conBou[4]; Wall: UF90X3A.surf_conBou[3]</td>
          </tr>          
          <tr>
          <td>eleRoo</td>
          <td>Electrical room</td>
          <td>eleRoo.surf_surBou[1]</td>
          <td>UF90X3A.surf_conBou[5]</td>
          </tr>
          <tr>
          <td>sla</td>
          <td>Radiant slab</td>
          <td>sla.surf_a</td>
          <td>UF90X3A.surf_surBou[1]</td>
          </tr>
          <tr>
          <td>shaPos</td>
          <td>Table describing the position of the window shade</td>
          <td>shaPos.y[1]</td>
          <td>UF90X3A.uSha</td>
          </tr>
          <tr>
          <td>intGai</td>
          <td>Table specifying the internal gains in the space</td>
          <td>intGai[1,2,3]</td>
          <td>UF90X3A.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airIn</td>
          <td>Prescribed airflow describing service air from the AHU</td>
          <td>airIn.ports[1]</td>
          <td>UF90X3A.ports[1]</td>
          </tr>
          <tr>
          <td>airOut</td>
          <td>Outlet for ventilation air flow</td>
          <td>airOut.ports[1]</td>
          <td>UF90X3A.ports[1]</td>
          </tr>
          </table>  
          <p>
          The radiant slab is modeled using an instance of 
          <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
          Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>. All of the inputs
          used to define the radiant slab are taken from the architectural drawings. The following
          table describes the connections between models used in the radiant slab. Being previously
          described, the connection to UF90X3A is not included.
          </p>
          <table border \"1\">
          <tr>
          <th>Physical significance of connector</th>
          <th>Radiant slab port</th>
          <th>External model port</th>
          </tr>
          <tr>
          <td>Inlet for service fluid flow. Currently connects to a prescribed flow described
          in a table</td>
          <td>sla.port_a</td>
          <td>watIn.ports[1]</td>
          </tr>
          <tr>
          <td>Ground temperature beneath the radiant slab construction. Currently connects to
          a prescribed temperature defined in a table</td>
          <td>sla.surf_b</td>
          <td>preT.port</td>
          </tr>
          <tr>
          <td>Outlet for service fluid flow</td>
          <td>sla.port_b</td>
          <td>watOut.ports[1]</td>
          </tr>
          </table>
          <p>
          The electrical room connected to test cell UF90X3A is modeled using
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3AElectrical\">
          Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3AElectrical</a>. The necessary 
          connections are described in the following table. Connections previously described
          are not included here.
          </p>
          <table border=\"1\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>eleRoo port</th>
          </tr>
          <tr>
          <td>intGaiEle</td>
          <td>Table specifying internal gains in the space</td>
          <td>intGaiEle[1,2,3]</td>
          <td>eleRoo.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airInEle</td>
          <td>Prescribed airflow describing service from AHU</td>
          <td>airIn.ports[1]</td>
          <td>eleRoo.ports[1]</td>
          </tr>
          <tr>
          <td>airOut</td>
          <td>Outlet for ventilation air flow</td>
          <td>airOut.ports[1]</td>
          <td>eleRoo.ports[2]</td>
          </tr>
          <tr>
          <td>clo</td>
          <td>Heat transfer through the wall shared by the closet and the electrical room</td>
          <td>clo.surf_conBou[1]</td>
          <td>eleRoo.surf_surBou[2]</td>
          </tr>
          </table>
          <p>
          The close connected to the UF90X3A test cell is modeled using an instance of 
          <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.UF90X3ACloset\">
          Buildings.Rooms.FLEXLAB.Rooms.UF90X3ACloset</a>. The connections
          necessary to accurately include the space in the simulation are described
          in the following table. Prevsiouly mentioned connections are not included.
          </p>
          <table border =\"1\">
          <tr>
          <th>External model name</th>
          <th>External model significance</th>
          <th>External model port</th>
          <th>clo port</th>
          </tr>
          <tr>
          <td>intGaiClo</td>
          <td>Internal gains for the closet</td>
          <td>intGaiClo.y[1,2,3]</td>
          <td>clo.qGai_flow[1,2,3]</td>
          </tr>
          <tr>
          <td>airInClo</td>
          <td>Prescribed airflow describing service air coming from the AHU</td>
          <td>airInClo.ports[1]</td>
          <td>clo.ports[1]</td>
          </tr>
          <tr>
          <td>airOutClo</td>
          <td>Outlet for ventilation air</td>
          <td>airOutClo.ports[1]</td>
          <td>clo.ports[2]</td>
          </tr>
          <tr>
          <td>preTem2</td>
          <td>Prescribed temperature representing the closet in UF90X3B. Data is 
          read from the table in TNei</td>
          <td>preTem2[2].port</td>
          <td>clo.surf_conBou[2]</td>
          </tr>
          </table>
          <p>
          The model only simulates the space conditions, the effects of the radiant slab, and the 
          heat transfer between the rooms. The air handling unit, chilled water plant, shade control, 
          internal gains, and ground temperature are all modeled by reading data from tables. 
          Currently the ventilation air is read from an external data file, via the model 
          <code>airCon</code>, while the others use tables described in the data reader model. The table
          below shows the name of data input files in the model, what physical phonemona the data file 
          describes, the physical signifacance of each data file output, and the source of the data.
          </p>
          <table border =\"1\">
          <tr>
          <th>Model name</th>
          <th>Quantity described</th>
          <th>Data source</th>          
          <th>y[1] significane</th>
          <th>y[2] significance</th>
          <th>y[3] significance</th>
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
          </tr>
          <tr>
          <td>airCon</td>
          <td>Ventilation air from air handling unit</td>
          <td>External text file</td>          
          <td>Mass flow rate</td>
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
          <td>Closet radiant heat</td>
          <td>Closet convective heat</td>
          <td>Closet latent heat</td>
          </tr>
          <tr>
          <td>intGaiEle</td>
          <td>Internal gains for the closet</td>
          <td>Table in model</td>
          <td>Electrical radiant heat</td>
          <td>Electrical convective heat</td>
          <td>Electrical latent heat</td>
          </tr>
          <tr>
          <td>airConEle</td>
          <td>Ventilation air from AHU in the electrical room</td>
          <td>Table in model</td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          </tr>
          <tr>
          <td>airConClo</td>
          <td>Ventilation air from AHU in closet</td>
          <td>Table in model</td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          </tr>
          <tr>
          <td>TNei</td>
          <td>Temperature of the neighboring cells</td>
          <td>Table in model</td>
          <td>UF90X2B</td>
          <td>UF90X3B</td>
          </tr>
          </table>
          </html>",
          revisions = "<html>
          <ul>
          <li>Jun 10, 2013 by Peter Grant:<br>
          First implementation.</li>
          </ul>
          </html>"),
    Commands(file="Resources/Scripts/Dymola/Rooms/Examples/FLEXLAB/Rooms/Examples/UF90X3AWithRadiantFloor.mos"
        "Simulate and Plot"));
end UF90X3AWithRadiantFloor;
