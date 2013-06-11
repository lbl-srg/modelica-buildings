within Buildings.Rooms.Examples.FLeXLab.Cells.Examples;
model UF90X3AWithRadiantFloor
  "Example model showing the use of UF90X3A. This model uses a radiant slab model"
  import Buildings;
  extends Modelica.Icons.Example;

  parameter Integer nConExtWin = 1
    "Number of external constructions with windows";

  package Air = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Air model used in the example model";
  package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Water model used in the radiant slab loop";

  Buildings.Rooms.Examples.FLeXLab.Cells.UF90X3A UF90X3A(nConExtWin=nConExtWin,
      nPorts=2,
    redeclare package Medium = Air,
    linearizeRadiation=false)
              annotation (Placement(transformation(extent={{14,6},{54,46}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Modelica.Blocks.Routing.Multiplex3 mul "Combines intGai signal for roo model"
    annotation (Placement(transformation(extent={{-58,46},{-38,66}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-106,46},{-86,66}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
    "Position of the shade"
    annotation (Placement(transformation(extent={{-106,102},{-86,122}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    annotation (Placement(transformation(extent={{-52,102},{-32,122}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15],
    tableOnFile=true,
    tableName="airCon",
    fileName="/home/peter/FLeXLab/git-FLeXLab/modelica-buildings/Buildings/Rooms/Examples/FLeXLab/Cells/ExampleInputDataFiles/airCon.txt")
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-106,14},{-86,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU)"
    annotation (Placement(transformation(extent={{-46,10},{-26,30}})));
  Buildings.Fluid.Sources.Boundary_pT
                            airOut(nPorts=1, redeclare package Medium = Air)
    annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
                                                      sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    m_flow_nominal=0.063,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.229)
    annotation (Placement(transformation(extent={{16,-56},{36,-36}})));

  Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,293.15; 86400,
        0.06,293.15]) "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-104,-52},{-84,-32}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-22,-56},{-2,-36}})));
  Buildings.Fluid.Sources.Boundary_pT
                            watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-46})));
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

equation
  connect(weaDat.weaBus, UF90X3A.weaBus) annotation (Line(
      points={{40,130},{51.9,130},{51.9,43.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mul.y[1], UF90X3A.qGai_flow[1]) annotation (Line(
      points={{-37,55.3333},{0,55.3333},{0,34.6667},{12,34.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[2], UF90X3A.qGai_flow[2]) annotation (Line(
      points={{-37,56},{0,56},{0,36},{12,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[3], UF90X3A.qGai_flow[3]) annotation (Line(
      points={{-37,56.6667},{0,56.6667},{0,37.3333},{12,37.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPos.y[1],replicator. u) annotation (Line(
      points={{-85,112},{-54,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, UF90X3A.uSha) annotation (Line(
      points={{-31,112},{6,112},{6,42},{12,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-85,24},{-64,24},{-64,28},{-46,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-85,24},{-48,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], UF90X3A.ports[1]) annotation (Line(
      points={{-26,20},{-6,20},{-6,16},{17,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], UF90X3A.ports[2]) annotation (Line(
      points={{-28,-4},{-6,-4},{-6,16},{21,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.surf_b,preT. port)                  annotation (Line(
      points={{30,-56},{30,-84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn.ports[1],sla. port_a)    annotation (Line(
      points={{-2,-46},{16,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{36,-46},{74,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in) annotation (Line(
      points={{-83,-42},{-50,-42},{-50,-38},{-22,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in) annotation (Line(
      points={{-83,-42},{-24,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{30,-121},{30,-106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, UF90X3A.surf_surBou[1]) annotation (Line(
      points={{30,-36},{30,0},{30.2,0},{30.2,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intGai.y[1], mul.u1[1]) annotation (Line(
      points={{-85,56},{-76,56},{-76,63},{-60,63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[2], mul.u2[1]) annotation (Line(
      points={{-85,56},{-60,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[3], mul.u3[1]) annotation (Line(
      points={{-85,56},{-76,56},{-76,49},{-60,49}},
      color={0,0,127},
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
          <td>Mass flow rateM/td>
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
          </html>"));
end UF90X3AWithRadiantFloor;
