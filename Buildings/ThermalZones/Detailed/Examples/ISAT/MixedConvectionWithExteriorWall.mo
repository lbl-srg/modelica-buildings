within Buildings.ThermalZones.Detailed.Examples.ISAT;
model MixedConvectionWithExteriorWall
  "Tutorial for the mixed convection case"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air (
        T_default=283.15) "Medium model";
  parameter Integer nConExtWin=0 "Number of constructions with a window";
  parameter Integer nConBou=0
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou=5
    "Number of surface that are connected to the room air volume";
  parameter Integer nConExt=1
    "Number of exterior constructions without a window";
  parameter Integer nConPar=0 "Number of partition constructions";
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBul=293.15)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.ThermalZones.Detailed.ISAT roo(
    redeclare package Medium = MediumA,
    surBou(
     name={"West Wall","North Wall","South Wall","Ceiling","Floor"},
     A={0.9,1,1,1,1},
     til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
     each absIR=1e-5,
     each absSol=1e-5,
     each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
    datConExt(
     name={"East Wall"},
     A={0.9},
     layers={matLayExt},
     til={Buildings.Types.Tilt.Wall},
     boundaryCondition={Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature}),
    AFlo = 1*1,
    hRoo = 1,
    linearizeRadiation = false,
    useCFD = true,
    nSou=0,
    sensorName = {"Zone air temperature","East wall heat flux"},
    cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/MixedConvectionWithExteriorWall/input.ffd",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts=2,
    portName={"Inlet","Outlet"},
    samplePeriod=200,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) "Room model"
  annotation (Placement(transformation(extent={{80,-38},{120,2}})));
  HeatTransfer.Sources.FixedTemperature TOthWal[nSurBou](each T=283.15)
    "Temperature for other walls"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},origin={150,-50})));
  Fluid.Sources.MassFlowSource_T bouIn(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=0.1,
    T=283.15)
    "Mass flow boundary condition"
    annotation (Placement(transformation(extent={{40,-54},{60,-34}})));
  Buildings.Fluid.Sources.Boundary_pT bouOut(
    nPorts=1,
    redeclare package Medium = MediumA)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{40,-84},{60,-64}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Brick120 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1]) annotation (Line(
      points={{-19,30},{10,30},{10,-3},{18,-3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-19,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1]) annotation (Line(
      points={{-19,-50},{8,-50},{8,-17},{18,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y,roo. qGai_flow) annotation (Line(
      points={{41,-10},{78.4,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,roo. weaBus) annotation (Line(
      points={{160,90},{176,90},{176,-0.1},{117.9,-0.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  for i in 1:(nSurBou) loop
    connect(TOthWal[i].port, roo.surf_surBou[i]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;
  connect(bouIn.ports[1], roo.ports[1]) annotation (Line(
      points={{60,-44},{74,-44},{74,-26},{84,-26},{84,-26},{84,-26},{84,-29},{85,
          -29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouOut.ports[1], roo.ports[2]) annotation (Line(
      points={{60,-74},{74,-74},{74,-27},{85,-27}},
      color={0,127,255},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p>
The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>
with the ISAT program by simulating ventilation with mixed convection in an
empty room with an exterior wall.
The schematic can be found in
<a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.ISAT.Tutorial.MixedConvection\">
Buildings.ThermalZones.Detailed.Examples.ISAT.Tutorial.MixedConvection</a>.
This case is to demenstrate a case with weather conditions involved by adding
an exterior wall. Also, this case adopts a pretraining feature that trains the
isat model before the start of the simulation, which can be adapted duringh
the simulation when needed.
</p>
<h4>Case Description</h4>
<p>
There are one input and two outputs in the ISAT model for this case. The input
is (1) interior surface temperature of east wall (exterior wall). The outputs
are (1) Zone air temperature, (2) East wall heat flux.
</p>
<h4>Guide for Setting Pretraining</h4>
<p>
This section describes how to set up pretraining for isat.
</p>
<ol>
<li>Define the settings for the ISAT model:
<p>In the <span style=\"font-family: Courier New;\">set.isat</span> file,
the parameters for the ISAT model can be defined:</p>
<p>/********************************************************************************</p>
<p>| Section 1: General settings of isat</p>
<p>********************************************************************************/</p>
<p>isat.useBinarySelectedPoint 1 /*If use binary pre-training*/</p>
<p>isat.read_existing 1 /*1: read existing database; 0: train from scratch*/</p>
<p>isat.write_existing 0 /*1: write ffd results to database; 0: do not write*/</p>
<p>/********************************************************************************</p>
<p>| Section 2: Input settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/*inpu.xBoundary_upper: inpu upper boundary for genereating gird in Binary pretraining*/</p>
<p>inpu.xBoundary_upper 40</p>
<p>/*inpu.xBoundary_lower: inpu lower boundary for genereating gird in Binary pretraining*/</p>
<p>inpu.xBoundary_lower -30</p>
<p>/*inpu.divide: define coarse/fine gird in Binary pretraining*/</p>
<p>inpu.divide 128</p>
<p>/********************************************************************************</p>
<p>| Section 3: Output settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/*outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen,
temp_rack, heat_wall1, heat_wall2, heat_wall3, heat_wall4, heat_wall5, heat_wall6*/</p>
<p>outp.outp_name temp_roo</p>
<p>outp.outp_name heat_wall1</p>
<p>/*outp.outp_Boundary_upper: output upper boundary for error control,
when outputs have different order of magnitudes*/</p>
<p>outp.outp_Boundary_upper 284.15</p>
<p>outp.outp_Boundary_upper 12.0</p>
<p>/*outp.outp_Boundary_lower: output lower boundary for error control,
when outputs have different order of magnitudes*/</p>
<p>outp.outp_Boundary_lower 281.15</p>
<p>outp.outp_Boundary_lower -10.0</p>
</li>
<li>Note: this guide is for pretraining of isat with one input.
If the case has more than one inputs, the syntax of setting is:
<p>/*inpu.xBoundary_upper: inpu upper boundary for genereating gird in Binary pretraining*/</p>
<p>inpu.xBoundary_upper 40 /*upper boundary for the first input*/</p>
<p>inpu.xBoundary_upper 40 /*upper boundary for the second input*/</p>
<p>inpu.xBoundary_upper 40 /*upper boundary for the third input*/</p>
<p>/*inpu.xBoundary_lower: inpu lower boundary for genereating gird in Binary pretraining*/</p>
<p>inpu.xBoundary_lower -30 /*lower boundary for the first input*/</p>
<p>inpu.xBoundary_lower -30 /*lower boundary for the second input*/</p>
<p>inpu.xBoundary_lower -30 /*lower boundary for the third input*/</p>
<p>/*inpu.divide: define coarse/fine gird in Binary pretraining*/</p>
<p>inpu.divide 128</p>
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>April 5, 2020, by Xu Han, Cary Faulkner, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/MixedConvectionWithExteriorWall.mos" "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false),
        graphics));
end MixedConvectionWithExteriorWall;
