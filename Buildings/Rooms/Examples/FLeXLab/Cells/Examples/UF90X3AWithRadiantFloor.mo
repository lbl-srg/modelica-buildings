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
              annotation (Placement(transformation(extent={{-20,6},{20,46}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-14,76},{6,96}})));
  Modelica.Blocks.Routing.Multiplex3 mul "Combines intGai signal for roo model"
    annotation (Placement(transformation(extent={{-64,40},{-44,60}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,0,0; 86400,0,0,0])
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
    "Position of the shade"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    annotation (Placement(transformation(extent={{-68,70},{-48,90}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15])
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-98,14},{-78,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air,
    nPorts=1) "Inlet air conditions (from AHU)"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Fluid.Sources.Boundary_pT
                            airOut(nPorts=1, redeclare package Medium = Air)
    annotation (Placement(transformation(extent={{-50,-14},{-30,6}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
                                                      sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    redeclare package Medium = Water,
    m_flow_nominal=0.063,
    A=60.97,
    pipe=pipe,
    layers=slaCon,
    disPip=0.2)
    annotation (Placement(transformation(extent={{-18,-38},{2,-18}})));

  //fixme - Currently disPip = 0.2m. Don't know actual measurement of disPip, change when more detailed information available

  Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,303.15; 86400,0.06,
        303.15]) "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-48,-44},{-28,-24}})));
  Buildings.Fluid.Sources.Boundary_pT
                            watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-28})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature
                                             preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-56})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(table=[0,288.15; 86400,288.15])
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-86})));
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
    annotation (Placement(transformation(extent={{-100,-94},{-80,-74}})));
  Buildings.Fluid.Data.Pipes.PEX_RADTEST
                               pipe
    annotation (Placement(transformation(extent={{-100,-72},{-80,-52}})));

equation
  connect(weaDat.weaBus, UF90X3A.weaBus) annotation (Line(
      points={{6,86},{17.9,86},{17.9,43.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mul.y[1], UF90X3A.qGai_flow[1]) annotation (Line(
      points={{-43,49.3333},{-34,49.3333},{-34,34.6667},{-22,34.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[2], UF90X3A.qGai_flow[2]) annotation (Line(
      points={{-43,50},{-34,50},{-34,36},{-22,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y[3], UF90X3A.qGai_flow[3]) annotation (Line(
      points={{-43,50.6667},{-34,50.6667},{-34,37.3333},{-22,37.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[1], mul.u1[1]) annotation (Line(
      points={{-79,50},{-72,50},{-72,57},{-66,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[2], mul.u2[1]) annotation (Line(
      points={{-79,50},{-66,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[3], mul.u3[1]) annotation (Line(
      points={{-79,50},{-72,50},{-72,43},{-66,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPos.y[1],replicator. u) annotation (Line(
      points={{-79,80},{-70,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, UF90X3A.uSha) annotation (Line(
      points={{-47,80},{-28,80},{-28,42},{-22,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-77,24},{-68,24},{-68,28},{-50,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-77,24},{-52,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], UF90X3A.ports[1]) annotation (Line(
      points={{-30,20},{-22,20},{-22,16},{-17,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], UF90X3A.ports[2]) annotation (Line(
      points={{-30,-4},{-22,-4},{-22,16},{-13,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.surf_b,preT. port)                  annotation (Line(
      points={{-4,-38},{-4,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(watIn.ports[1],sla. port_a)    annotation (Line(
      points={{-28,-34},{-20,-34},{-20,-28},{-18,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{2,-28},{40,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in) annotation (Line(
      points={{-79,-30},{-64,-30},{-64,-26},{-48,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in) annotation (Line(
      points={{-79,-30},{-50,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGro.y[1],preT. T) annotation (Line(
      points={{-4,-75},{-4,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, UF90X3A.surf_surBou[1]) annotation (Line(
      points={{-4,-18},{-4,0},{-3.8,0},{-3.8,12}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end UF90X3AWithRadiantFloor;
