within Buildings.Rooms.Examples.FLEXLAB.Cells.Examples;
model UF90X3AWithRadiantFloor
  "Example model showing the use of UF90X3A. This model uses a radiant slab model"
  import Buildings;
  extends Modelica.Icons.Example;

  package Air = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Air model used in the example model";
  package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Water model used in the radiant slab loop";

  Buildings.Rooms.Examples.FLEXLAB.Cells.UF90X3A UF90X3A(
      nPorts=2,
    redeclare package Medium = Air,
    linearizeRadiation=false)
              annotation (Placement(transformation(extent={{14,38},{54,78}})));
  Modelica.Blocks.Routing.Multiplex3 mul "Combines intGai signal for roo model"
    annotation (Placement(transformation(extent={{-58,92},{-38,112}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-106,92},{-86,112}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
    "Position of the shade"
    annotation (Placement(transformation(extent={{-106,124},{-86,144}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName="/home/peter/FLeXLab/git-FLeXLab/modelica-buildings/Buildings/Rooms/Examples/FLeXLab/Cells/ExampleInputDataFiles/airCon.txt")
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-106,54},{-86,74}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU)"
    annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
  Buildings.Fluid.Sources.Boundary_pT
                            airOut(nPorts=1, redeclare package Medium = Air)
    annotation (Placement(transformation(extent={{-66,24},{-46,44}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
                                                      sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    m_flow_nominal=0.063,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229)
    annotation (Placement(transformation(extent={{16,-66},{36,-46}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,293.15; 86400,
        0.06,293.15]) "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-104,-62},{-84,-42}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-22,-66},{-2,-46}})));
  Buildings.Fluid.Sources.Boundary_pT
                            watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-56})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
                                             preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-94})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(table=[0,288.15; 86400,288.15])
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-132})));
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
    annotation (Placement(transformation(extent={{-102,-142},{-82,-122}})));
  Buildings.Fluid.Data.Pipes.PEX_RADTEST
                               pipe
    annotation (Placement(transformation(extent={{-102,-120},{-82,-100}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{28,116},{48,136}})));
  Modelica.Blocks.Sources.Constant TNei[2](k=273.15 + 20)
    "Temperature of the neighboring test cells" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,36})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem[2] annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,36})));
  Modelica.Blocks.Sources.Constant TClo[2](k=273.15 + 20)
    "Temperature of the closet"                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,4})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1[2] annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,4})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem2    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-28})));
  Modelica.Blocks.Sources.Constant TElec(k=273.15 + 30)
    "Temperature of the electrical room"        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,-28})));
equation
  connect(mul.y[1], UF90X3A.qGai_flow[1]) annotation (Line(
      points={{-37,101.333},{-18,101.333},{-18,66.6667},{6,66.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[2], UF90X3A.qGai_flow[2]) annotation (Line(
      points={{-37,102},{-16,102},{-16,68},{6,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[3], UF90X3A.qGai_flow[3]) annotation (Line(
      points={{-37,102.667},{-14,102.667},{-14,69.3333},{6,69.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-85,64},{-78,64},{-78,68},{-68,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-85,64},{-70,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], UF90X3A.ports[1]) annotation (Line(
      points={{-48,60},{-26,60},{-26,48},{17,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], UF90X3A.ports[2]) annotation (Line(
      points={{-46,34},{-26,34},{-26,48},{21,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.surf_b,preT. port)                  annotation (Line(
      points={{30,-66},{30,-84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn.ports[1],sla. port_a)    annotation (Line(
      points={{-2,-56},{16,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{36,-56},{74,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in) annotation (Line(
      points={{-83,-52},{-52,-52},{-52,-48},{-22,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in) annotation (Line(
      points={{-83,-52},{-24,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{30,-121},{30,-106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, UF90X3A.surf_surBou[1]) annotation (Line(
      points={{30,-46},{30,0},{30.2,0},{30.2,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intGai.y[1], mul.u1[1]) annotation (Line(
      points={{-85,102},{-76,102},{-76,109},{-60,109}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[2], mul.u2[1]) annotation (Line(
      points={{-85,102},{-60,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[3], mul.u3[1]) annotation (Line(
      points={{-85,102},{-76,102},{-76,95},{-60,95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, UF90X3A.weaBus) annotation (Line(
      points={{48,126},{51.9,126},{51.9,75.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaPos.y, UF90X3A.uSha) annotation (Line(
      points={{-85,134},{4,134},{4,74},{12,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem.port, UF90X3A.surf_conBou[1:2]) annotation (Line(
      points={{70,36},{40,36},{40,41.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TNei.y, preTem.T) annotation (Line(
      points={{109,36},{92,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TClo.y, preTem1.T) annotation (Line(
      points={{109,4},{92,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem1[1].port, UF90X3A.surf_conBou[3]) annotation (Line(
      points={{70,4},{40,4},{40,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TElec.y, preTem2.T) annotation (Line(
      points={{109,-28},{92,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem2.port, UF90X3A.surf_conBou[5]) annotation (Line(
      points={{70,-28},{40,-28},{40,42.8}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -150},{150,150}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-150,-150},{150,150}})),
          Documentation(info = "<html>
          <p>
          This model demonstrates one potential use of
          <a href=\"modelica:Buildings.Rooms.Examples.FLeXLab.Cells.Examples.UF90X3AWithRadiantFloor\">
          Buildings.Rooms.Examples.FLeXLab.Cells.Examples.UF90X3AWithRadiantFloor</a>. This examples
          simulates the test cell when it is conditioned with a radiant slab.
          </p>
          <p>
          The model only simulates the space conditions, and the effects of the radiant slab. The
          air handling unit, chilled water plant, shade control, internal gains, and ground temperature
          are all modeled by reading data from tables. Currently the ventilation air is read-in from an
          external data file, via the model <code>airCon</code>, while the others use tables described
          in the data reader model. The tabls below shows the name of data input files in the model, what
          physical phonemona the data file describes, the physical signifacance of each data file output,
          and the source of the data.
          </p>
          <p>
          <table border =\"1\">
          <tr>
          <th>Model name</th>
          <th>Quantity described</th>
          <th>y[1] significane</th>
          <th>y[2] significance</th>
          <th>y[3] significance</th>
          <th>Data source</th>
          </tr>
          <tr>
          <td>shaPos</td>
          <td>Position of the shade</td>
          <td>Position of the shade</td>
          <td></td>
          <td></td>
          <td>Table in model</td>
          </tr>
          <tr>
          <td>intGai</td>
          <td>Internal gains</td>
          <td>Radiant heat</td>
          <td>Convective heat</td>
          <td>Latent heat</td>
          <td>Table in model</td>
          </tr>
          <tr>
          <td>airCon</td>
          <td>Ventilation air from air handling unit</td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          <td></td>
          <td>External text file</td>
          </tr>
          <tr>
          <td>watCon</td>
          <td>Conditioning water from central plant</td>
          <td>Mass flow rate</td>
          <td>Temperature</td>
          <td></td>
          <td>Table in model</td>
          </tr>
          <tr>
          <td>TGro</td>
          <td>Ground temperature</td>
          <td>Temperature</td>
          <td></td>
          <td></td>
          <td>Table in model</td>
          </table>
          </p>
          </html>",
          revisions = "<html>
          <ul>
          <li>Jun 10, 2013 by Peter Grant:<br>
          First implementation.</li>
          </ul>
          </html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Rooms/Examples/FLeXLab/Cells/Examples/UF90X3AWithRadiantFloor.mos"
        "Simulate and Plot"));
end UF90X3AWithRadiantFloor;
