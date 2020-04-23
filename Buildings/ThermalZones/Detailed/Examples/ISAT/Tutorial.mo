within Buildings.ThermalZones.Detailed.Examples.ISAT;
package Tutorial
  "Tutorial with step by step instructions for how to do coupled simulation"
  extends Modelica.Icons.Information;

  model MixedConvection "Tutorial for Mixed Convection case"
    extends Modelica.Icons.Example;
    package MediumA = Buildings.Media.Air (
          T_default=283.15) "Medium model";
    parameter Integer nConExtWin=0 "Number of constructions with a window";
    parameter Integer nConBou=0
      "Number of surface that are connected to constructions that are modeled inside the room";
    parameter Integer nSurBou=6
      "Number of surface that are connected to the room air volume";
    parameter Integer nConExt=0
      "Number of exterior constructions withour a window";
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
       name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
       A={0.9,0.9,1,1,1,1},
       til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
       each absIR=1e-5,
       each absSol=1e-5,
       each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
      lat = 0.012787839282646,
      AFlo = 1*1,
      hRoo = 1,
      linearizeRadiation = false,
      useCFD = true,
      haveSource=false,
      nSou=0,
      sensorName = {"Occupied zone air temperature", "Velocity"},
      cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/input.ffd",
      nConExt = nConExt,
      nConExtWin = nConExtWin,
      nConPar = nConPar,
      nConBou = nConBou,
      nSurBou = nSurBou,
      nPorts=2,
      portName={"Inlet","Outlet"},
      samplePeriod = 200)
    annotation (Placement(transformation(extent={{80,-38},{120,2}})));
    HeatTransfer.Sources.FixedTemperature TOthWal[nSurBou-1](each T=283.15)
      "Temperature for other walls"          annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-50})));
    HeatTransfer.Sources.FixedTemperature TFlo(T=303.15) "Temperature of floor"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-90})));
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
    connect(TFlo.port, roo.surf_surBou[6]) annotation (Line(
        points={{140,-90},{96.2,-90},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[1].port, roo.surf_surBou[1]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[2].port, roo.surf_surBou[2]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[3].port, roo.surf_surBou[3]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[4].port, roo.surf_surBou[4]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[5].port, roo.surf_surBou[5]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(bouIn.ports[1], roo.ports[1]) annotation (Line(
        points={{60,-44},{74,-44},{74,-26},{84,-26},{84,-26},{84,-26},{84,-30},{85,
            -30}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(bouOut.ports[1], roo.ports[2]) annotation (Line(
        points={{60,-74},{74,-74},{74,-26},{85,-26}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Documentation(info="<html>
<p>
This tutorial gives step by step instructions on building and simulating a mixed convection model.
The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating ventilation with mixed convection in an empty room.
</p>
<h4>Case Description</h4>
<p>
The temperature of the floor is fixed at <i>30</i>&circ;C and the temperature of the walls and the ceiling are fixed
at <i>10</i>&circ;C. The supply air temperature is fixed at <i>10</i>&circ;C.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation and Figure (b) shows the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
<p>
Add the following model components into the <code>MixedConvection</code> model:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
This model is used to implement data exchange between Modelica and FFD.
Name it as <code>roo</code>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A.
Name it as <code>weaDat</code>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero.
Name these models as <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code>, respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to convert three numbers into a vector.
Name it as <code>multiple_x3</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperature on the floor and other walls.
Name them as <code>TFlo</code> and <code>TOthWal</code> respectively.
Please note that it is necessary to declare <code>TOthWal</code> as a vector of <i>5</i> elements.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>.
This model provides inlet air for the <code>roo</code>.
Name it as <code>bouIn</code>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>.
This model is the outdoor environment to which the outlet of <code>roo</code> is connected.
Name it as <code>bouOut</code>.
</li>
</ul>
</li>
<li>
<p>
In the textual editor mode, add the medium and the number of surfaces as below:
</p>
<pre>
package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated (T_default=283.15);
  parameter Integer nConExtWin=0;
  parameter Integer nConBou=0;
  parameter Integer nSurBou=6;
  parameter Integer nConExt=0;
  parameter Integer nConPar=0;
</pre>
</li>
<li>
<p>
Edit <code>roo</code> as below:
</p>
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
  redeclare package Medium = MediumA,
  surBou(
    name={\"East Wall\",\"West Wall\",\"North Wall\",\"South Wall\",\"Ceiling\",\"Floor\"},
    A={0.9,0.9,1,1,1,1},
    til={Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Ceiling,
        Buildings.Types.Tilt.Floor},
    each absIR=1e-5,
    each absSol=1e-5,
    each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
    lat = 0.012787839282646,
    AFlo = 1*1,
    hRoo = 1,
    linearizeRadiation = false,
    useCFD = true,
    sensorName = {\"Occupied zone air temperature\", \"Velocity\"},
    cfdFilNam = \"modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.ffd\",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts = 2,
    portName={\"Inlet\",\"Outlet\"},
    samplePeriod = 6);
</pre>
</li>
<li>
<p>
Set the parameters for the following components:
</p>
<ul>
<li>
Set <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code> to <i>0</i>.
</li>
<li>
Set <code>TFlo</code> to <i>303.15</i> Kelvin.
</li>
<li>
Set <code>TOthWal</code> to <i>283.15</i> Kelvin.
</li>
</ul>
</li>
<li>
<p>
Set the values for the parameters of <code>bouIn</code> and <code>bouOut</code> as below:
</p>
<pre>
Fluid.Sources.MassFlowSource_T bouIn(
  redeclare package Medium = MediumA,
  nPorts=1,
  m_flow=0.1,
  T=283.15);
</pre>
<pre>
Fluid.Sources.FixedBoundary bouOut(
  redeclare package Medium = MediumA,
  nPorts=1);
</pre>
</li>
<li>
<p>
Connect the components as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionModel.png\"/>
</p>
</li>
<li>
<p>
Confirm in the textual editor that the connections to
<code>roo.ports</code> are as follows:
</p>
<pre>
connect(bouIn.ports[1], roo.ports[1]);
connect(bouOut.ports[1], roo.ports[2]);
</pre>
</li>
<li>
<p>
Use the Simplified CFD Interface (SCI) to generate the input file for the FFD.
</p>
<ul>
<li>
Use a 20 X 20 X 20 stretched grid.
</li>
<li>
Set the time step size of the FFD to <i>0.1</i> seconds.
</li>
<li>
Generate the input files, which have by default the names
<code>input.cfd</code> (mesh file) and <code>zeroone.dat</code> (obstacles file).
</li>
<li>
Rename the files as <code>MixedConvection.cfd</code> and <code>MixedConvection.dat</code>, respectively.
</li>
</ul>
</li>
<li>
<p>
Revise the FFD parameter input file <code>MixedConvection.ffd</code>
(an example file is available in <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>):  </p>
<pre>
  inpu.parameter_file_format SCI
  inpu.parameter_file_name MixedConvection.cfd
  inpu.block_file_name MixedConvection.dat
  prob.nu 0.000015 // Kinematic viscosity
  prob.rho 1.205 // Density
  prob.gravx 0 // Gravity in x direction
  prob.gravy 0 // Gravity in y direction
  prob.gravz -9.81 // Gravity in z direction
  prob.cond 0.0257 // Conductivity
  prob.Cp 1006.0 // Specific heat capacity
  prob.beta 0.00343 // Thermal expansion coefficient
  prob.diff 0.00001 // Diffusivity for contaminants
  prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall
  prob.Temp_Buoyancy 10.0 // Reference temperature for calculating buoyance  force
  init.T 10.0 // Initial condition for Temperature
  init.u 0.0 // Initial condition for velocity u
  init.v 0.0 // Initial condition for velocity v
  init.w 0.0 // Initial condition for velocity w
</pre>
</li>
<li>
Put the files <code>MixedConvection.ffd</code>, <code>MixedConvection.dat</code>, and <code>MixedConvection.cfd</code> in the
directory <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>.
</li>
<li>
Set the simulation stop time of the Modelica model to <code>180</code> seconds and choose, for example, the Radau solver.
</li>
<li>
Translate the model and start the simulation.
</li>
<li>
Post-process: click the Tecplot macro script
<code>Buildings/Resources/Image/Rooms/Examples/FFD/Tutorial/MixedConvection.mcr</code>
that will generate the temperature contour and velocity vectors shown in the Figure (b).
Note: Tecplot is needed for this.
</li>
</ol>
</html>",  revisions="<html>
<ul>
<li>
September 07, 2017, by Thierry Nouidui:<br/>
Refactored the FFD C-code and revised the documentation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
</li>
<li>
July 25, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
June 27, 2014, by Wei Tian, Thomas Sevilla, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
      experiment(Tolerance=1e-06, StopTime=180),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionWithBox.mos"),
      Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false),
          graphics));
  end MixedConvection;

  model MixedConvectionWithBox
    "Tutorial for Mixed Convection case with a heated box"
    extends Modelica.Icons.Example;
    package MediumA = Buildings.Media.Air (
          T_default=283.15) "Medium model";
    parameter Integer nConExtWin=0 "Number of constructions with a window";
    parameter Integer nConBou=0
      "Number of surface that are connected to constructions that are modeled inside the room";
    parameter Integer nSurBou=6
      "Number of surface that are connected to the room air volume";
    parameter Integer nConExt=0
      "Number of exterior constructions withour a window";
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
       name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
       A={0.9,0.9,1,1,1,0.75},
       til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
       each absIR=1e-5,
       each absSol=1e-5,
       each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
      lat = 0.012787839282646,
      AFlo = 1*1,
      hRoo = 1,
      linearizeRadiation = false,
      useCFD = true,
      haveSource=true,
      nSou=1,
      sensorName = {"Occupied zone air temperature", "Velocity"},
      cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBox/input.ffd",
      nConExt = nConExt,
      nConExtWin = nConExtWin,
      nConPar = nConPar,
      nConBou = nConBou,
      nSurBou = nSurBou,
      nPorts=2,
      portName={"Inlet","Outlet"},
      samplePeriod = 200,
      sourceName={"block"})
    annotation (Placement(transformation(extent={{80,-38},{120,2}})));
    HeatTransfer.Sources.FixedTemperature TOthWal[nSurBou-1](each T=283.15)
      "Temperature for other walls"          annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-50})));
    HeatTransfer.Sources.FixedTemperature TFlo(T=303.15) "Temperature of floor"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-90})));
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
    Modelica.Blocks.Sources.Step step(
      height=15,
      offset=283.15,
      startTime=201)
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
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
    connect(TFlo.port, roo.surf_surBou[6]) annotation (Line(
        points={{140,-90},{96.2,-90},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[1].port, roo.surf_surBou[1]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[2].port, roo.surf_surBou[2]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[3].port, roo.surf_surBou[3]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[4].port, roo.surf_surBou[4]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[5].port, roo.surf_surBou[5]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(bouIn.ports[1], roo.ports[1]) annotation (Line(
        points={{60,-44},{74,-44},{74,-26},{84,-26},{84,-26},{84,-26},{84,-30},{85,
            -30}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(bouOut.ports[1], roo.ports[2]) annotation (Line(
        points={{60,-74},{74,-74},{74,-26},{85,-26}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(step.y, roo.QIntSou[1]) annotation (Line(points={{-19,70},{60,70},{60,
            1.77636e-15},{78.4,1.77636e-15}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This tutorial gives step by step instructions on building and simulating a mixed convection model.
The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating ventilation with mixed convection in an empty room.
</p>
<h4>Case Description</h4>
<p>
The temperature of the floor is fixed at <i>30</i>&circ;C and the temperature of the walls and the ceiling are fixed
at <i>10</i>&circ;C. The supply air temperature is fixed at <i>10</i>&circ;C.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation and Figure (b) shows the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
<p>
Add the following model components into the <code>MixedConvection</code> model:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
This model is used to implement data exchange between Modelica and FFD.
Name it as <code>roo</code>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A.
Name it as <code>weaDat</code>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero.
Name these models as <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code>, respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to convert three numbers into a vector.
Name it as <code>multiple_x3</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperature on the floor and other walls.
Name them as <code>TFlo</code> and <code>TOthWal</code> respectively.
Please note that it is necessary to declare <code>TOthWal</code> as a vector of <i>5</i> elements.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>.
This model provides inlet air for the <code>roo</code>.
Name it as <code>bouIn</code>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>.
This model is the outdoor environment to which the outlet of <code>roo</code> is connected.
Name it as <code>bouOut</code>.
</li>
</ul>
</li>
<li>
<p>
In the textual editor mode, add the medium and the number of surfaces as below:
</p>
<pre>
package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated (T_default=283.15);
  parameter Integer nConExtWin=0;
  parameter Integer nConBou=0;
  parameter Integer nSurBou=6;
  parameter Integer nConExt=0;
  parameter Integer nConPar=0;
</pre>
</li>
<li>
<p>
Edit <code>roo</code> as below:
</p>
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
  redeclare package Medium = MediumA,
  surBou(
    name={\"East Wall\",\"West Wall\",\"North Wall\",\"South Wall\",\"Ceiling\",\"Floor\"},
    A={0.9,0.9,1,1,1,1},
    til={Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Ceiling,
        Buildings.Types.Tilt.Floor},
    each absIR=1e-5,
    each absSol=1e-5,
    each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
    lat = 0.012787839282646,
    AFlo = 1*1,
    hRoo = 1,
    linearizeRadiation = false,
    useCFD = true,
    sensorName = {\"Occupied zone air temperature\", \"Velocity\"},
    cfdFilNam = \"modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.ffd\",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts = 2,
    portName={\"Inlet\",\"Outlet\"},
    samplePeriod = 6);
</pre>
</li>
<li>
<p>
Set the parameters for the following components:
</p>
<ul>
<li>
Set <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code> to <i>0</i>.
</li>
<li>
Set <code>TFlo</code> to <i>303.15</i> Kelvin.
</li>
<li>
Set <code>TOthWal</code> to <i>283.15</i> Kelvin.
</li>
</ul>
</li>
<li>
<p>
Set the values for the parameters of <code>bouIn</code> and <code>bouOut</code> as below:
</p>
<pre>
Fluid.Sources.MassFlowSource_T bouIn(
  redeclare package Medium = MediumA,
  nPorts=1,
  m_flow=0.1,
  T=283.15);
</pre>
<pre>
Fluid.Sources.FixedBoundary bouOut(
  redeclare package Medium = MediumA,
  nPorts=1);
</pre>
</li>
<li>
<p>
Connect the components as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionModel.png\"/>
</p>
</li>
<li>
<p>
Confirm in the textual editor that the connections to
<code>roo.ports</code> are as follows:
</p>
<pre>
connect(bouIn.ports[1], roo.ports[1]);
connect(bouOut.ports[1], roo.ports[2]);
</pre>
</li>
<li>
<p>
Use the Simplified CFD Interface (SCI) to generate the input file for the FFD.
</p>
<ul>
<li>
Use a 20 X 20 X 20 stretched grid.
</li>
<li>
Set the time step size of the FFD to <i>0.1</i> seconds.
</li>
<li>
Generate the input files, which have by default the names
<code>input.cfd</code> (mesh file) and <code>zeroone.dat</code> (obstacles file).
</li>
<li>
Rename the files as <code>MixedConvection.cfd</code> and <code>MixedConvection.dat</code>, respectively.
</li>
</ul>
</li>
<li>
<p>
Revise the FFD parameter input file <code>MixedConvection.ffd</code>
(an example file is available in <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>):  </p>
<pre>
  inpu.parameter_file_format SCI
  inpu.parameter_file_name MixedConvection.cfd
  inpu.block_file_name MixedConvection.dat
  prob.nu 0.000015 // Kinematic viscosity
  prob.rho 1.205 // Density
  prob.gravx 0 // Gravity in x direction
  prob.gravy 0 // Gravity in y direction
  prob.gravz -9.81 // Gravity in z direction
  prob.cond 0.0257 // Conductivity
  prob.Cp 1006.0 // Specific heat capacity
  prob.beta 0.00343 // Thermal expansion coefficient
  prob.diff 0.00001 // Diffusivity for contaminants
  prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall
  prob.Temp_Buoyancy 10.0 // Reference temperature for calculating buoyance  force
  init.T 10.0 // Initial condition for Temperature
  init.u 0.0 // Initial condition for velocity u
  init.v 0.0 // Initial condition for velocity v
  init.w 0.0 // Initial condition for velocity w
</pre>
</li>
<li>
Put the files <code>MixedConvection.ffd</code>, <code>MixedConvection.dat</code>, and <code>MixedConvection.cfd</code> in the
directory <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>.
</li>
<li>
Set the simulation stop time of the Modelica model to <code>180</code> seconds and choose, for example, the Radau solver.
</li>
<li>
Translate the model and start the simulation.
</li>
<li>
Post-process: click the Tecplot macro script
<code>Buildings/Resources/Image/Rooms/Examples/FFD/Tutorial/MixedConvection.mcr</code>
that will generate the temperature contour and velocity vectors shown in the Figure (b).
Note: Tecplot is needed for this.
</li>
</ol>
</html>",  revisions="<html>
<ul>
<li>
September 07, 2017, by Thierry Nouidui:<br/>
Refactored the FFD C-code and revised the documentation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
</li>
<li>
July 25, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
June 27, 2014, by Wei Tian, Thomas Sevilla, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
      experiment(Tolerance=1e-06, StopTime=180),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionWithBox.mos"
          "Simulate and plot"),
      Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false)));
  end MixedConvectionWithBox;

  model NaturalConvection "Tutorial for Natural Convection case"
    extends Modelica.Icons.Example;
    package MediumA =
        Buildings.Media.Air (
          T_default=283.15) "Medium model";
    parameter Integer nConExtWin=0 "Number of constructions with a window";
    parameter Integer nConBou=0
      "Number of surface that are connected to constructions that are modeled inside the room";
    parameter Integer nSurBou=6
      "Number of surface that are connected to the room air volume";
    parameter Integer nConExt=0
      "Number of exterior constructions withour a window";
    parameter Integer nConPar=0 "Number of partition constructions";
    Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    Modelica.Blocks.Routing.Multiplex3 multiplex3_1
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
        TDryBul=293.15)
      annotation (Placement(transformation(extent={{120,40},{140,60}})));
    Buildings.ThermalZones.Detailed.ISAT roo(
     redeclare package Medium = MediumA,
     surBou(
     name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
     each A=1*1,
     til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
     each absIR=1e-5,
     each absSol=1e-5,
     boundaryCondition={Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
         Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
         Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
         Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
         Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate}),
     AFlo = 1*1,
     hRoo = 1,
     linearizeRadiation = false,
     useCFD = true,
     haveSource=false,
     nSou=0,
     sensorName = {"Occupied zone air temperature", "Velocity"},
     cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection/input.ffd",
     nConExt = nConExt,
     nConExtWin = nConExtWin,
     nConPar = nConPar,
     nConBou = nConBou,
     nSurBou = nSurBou,
     samplePeriod = 7200,
      lat=0.012787839282646,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{60,-58},{100,-18}})));
    HeatTransfer.Sources.FixedTemperature           TWesWal(T=274.15)
      "Boundary condition for the west wall" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={130,-110})));
    HeatTransfer.Sources.FixedTemperature           TEasWal(T=273.15)
      "Temperature of east wall"            annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={130,-70})));
  equation
    connect(qRadGai_flow.y, multiplex3_1.u1[1]) annotation (Line(
        points={{-39,10},{-10,10},{-10,-23},{-2,-23}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
        points={{-39,-30},{-2,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qLatGai_flow.y, multiplex3_1.u3[1]) annotation (Line(
        points={{-39,-70},{-12,-70},{-12,-37},{-2,-37}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
        points={{21,-30},{58.4,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TEasWal.port, roo.surf_surBou[1])
      annotation (Line(
        points={{120,-70},{76.2,-70},{76.2,-52}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TWesWal.port, roo.surf_surBou[2])
      annotation (Line(
        points={{120,-110},{76.2,-110},{76.2,-52}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(weaDat.weaBus, roo.weaBus) annotation (Line(
        points={{140,50},{154,50},{154,-20.1},{97.9,-20.1}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-80,-140},{180,80}},
            preserveAspectRatio=false)),
            __Dymola_Commands(file =    "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvection.mos"
          "Simulate and plot"),
          experiment(Tolerance=1e-06, StopTime=7200),
         Documentation(info="<html>
<p>
This tutorial gives step by step instructions for building and simulating a natural convection model.
The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only surface boundary conditions.
</p>
<h4>Case Description</h4>
<p>
The Rayleigh number is a dimensionless number associated with natural convection, defined as
<p align=\"center\" style=\"font-style:italic;\">
  R<sub>a</sub> = g &beta; (T<sub>w</sub>-T<sub>e</sub>)L<sup>3</sup> &frasl; (&nu; &alpha;)
</p>
<p>
To get a Rayleigh number of <i>1E5</i>, the flow properties are manually set as
acceleration due to gravity <i>g<sub>z</sub>=-0.01</i> m/s<sup>2</sup>,
thermal expansion coefficient <i>&beta;=3e-3</i> K<sup>-1</sup>,
kinematic viscosity <i>&nu;=1.5e-5</i> m<sup>2</sup>/s,
thermal diffusivity <i>&alpha;=2e-5</i> m<sup>2</sup>/s, and
characteristic length <i>L=1</i> m.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The following conditions are applied in Modelica.:
</p>
<ul>
<li>
East wall: Fixed temperature at <i>T<sub>e</sub>=0</i>&circ;C,
</li>
<li>
West wall: Fixed temperature at <i>T<sub>w</sub>=1</i>&circ;C,
</li>
<li>
North &amp; South wall, Ceiling, Floor: Fixed heat flux at <i>0</i> W/m<sup>2</sup>.
</li>
</ul>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p>
Figure (b) shows the velocity vectors and temperature contour in degree Celsius on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
More details of the case description can be found in
<a href=\"#ZuoEtAl2012\">Zuo et al. (2012)</a>.
</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
<p>
Add the following component models to the <code>NaturalConvection</code> model:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
This model is used to implement the data exchange between Modelica and FFD. Name it as <code>roo</code>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <code>weaDat</code>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain  zero.
Name these models as <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code>, respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to combine three scalar signals to a vector. Name it as <code>multiple_x3</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperatures on the east and west walls.
Name them as <code>TeasWal</code> and <code>TwesWal</code>, respectively.
</li>
</ul>
Note that for the other four walls with adiabatic boundary conditions, we do not need to specify
a zero heat flow boundary condition because the heat flow rate transferred through a heat port
from the outside is zero if the heat port is not connected from the outside.
</li>
<li>
<p>
In the textual editor mode, add the medium and the number of surfaces as shown below:
</p>
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
  package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated(
    T_default=283.15);
  parameter Integer nConExtWin=0;
  parameter Integer nConBou=0;
  parameter Integer nSurBou=6;
  parameter Integer nConExt=0;
  parameter Integer nConPar=0;

</pre>
</li>
<li>
<p>
Edit <code>roo</code> as below:
</p>
<pre>
 edeclare package Medium = MediumA,
surBou(
  name={\"East Wall\",\"West Wall\",\"North Wall\",\"South Wall\",\"Ceiling\",\"Floor\"},
  each A=1*1,
  til={Buildings.Types.Tilt.Wall,
    Buildings.Types.Tilt.Wall,
    Buildings.Types.Tilt.Wall,
    Buildings.Types.Tilt.Wall,
    Buildings.Types.Tilt.Ceiling,
    Buildings.Types.Tilt.Floor},
  each absIR=1e-5,
  each absSol=1e-5,
  boundaryCondition={
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
    Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate}),
  lat = 0.012787839282646,
  AFlo = 1*1,
  hRoo = 1,
  linearizeRadiation = false,
  useCFD = true,
  sensorName = {\"Occupied zone air temperature\", \"Velocity\"},
  cfdFilNam = \"modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvection.ffd\",
  nConExt = nConExt,
  nConExtWin = nConExtWin,
  nConPar = nConPar,
  nConBou = nConBou,
  nSurBou = nSurBou,
  T_start=273.15,
  samplePeriod = 60);
</pre>
</li>
<li>
<p>
Connect the component as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvectionModel.png\"/>
</p>
</li>
<li>
Set the values for the following components:
<ul>
<li>
Set <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code> to <i>0</i>.
</li>
<li>
Set <code>TEasWal</code> to <i>273.15</i> Kelvin.
</li>
<li>
Set <code>TWesWal</code> to <i>274.15</i> Kelvin.
</li>
</ul>
</li>
<li>
Use the Simplified CFD Interface (SCI) to generate the input file for FFD.
<ul>
<li>
Use a 20 x 20 x 20 uniform grid.
</li>
<li>
Set the time step size of the FFD to <i>10</i> seconds.
</li>
<li>
Generate the input files which have the default names <code>input.cfd</code> (mesh file) and <code>zeroone.dat</code> (obstacles file).
</li>
<li>
Rename the files as <code>NaturalConvection.cfd</code> and <code>NaturalConvection.dat</code>, respectively.
</li>
</ul>
</li>
<li>
Revise the FFD parameter input file <code>NaturalConvection.ffd</code>
(an example file is provided in <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>):
<pre>
  inpu.parameter_file_format SCI
  inpu.parameter_file_name NaturalConvection.cfd
  inpu.block_file_name NaturalConvection.dat
  prob.nu 1.5e-5 // Kinematic viscosity
  prob.rho 1 // Density
  prob.gravx 0 // Gravity in x direction
  prob.gravy 0 // Gravity in y direction
  prob.gravz -0.01 // Gravity in z direction
  prob.cond 0.02 // Conductivity
  prob.Cp 1000.0 // Specific heat capacity
  prob.beta 3e-3 // Thermal expansion coefficient
  prob.diff 0.00001 // Diffusivity for contaminants
  prob.alpha 2e-5 // Thermal diffusivity
  prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall
  prob.Temp_Buoyancy 0.0 // Reference temperature for calculating buoyance force
  init.T 0.0 // Initial condition for Temperature
  init.u 0.0 // Initial condition for velocity u
  init.v 0.0 // Initial condition for velocity v
  init.w 0.0 // Initial condition for velocity w
</pre>
<p>
Please note that some of the physical properties were manipulated to obtain the desired Rayleigh Number of <i>10<sup>5</sup></i>.
</p>
</li>
<li>
Store <code>NaturalConvection.ffd</code>, <code>NaturalConvection.dat</code>, and <code>NaturalConvection.cfd</code>
at <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial</code>.
</li>
<li>
Set simulation the stop time of the Modelica model <code>7200</code> seconds and choose for example the Radau solver.
</li>
<li>
Translate the model and start the simulation.
</li>
<li>
Post-process: click the Tecplot macro script
<code>Buildings/Resources/Image/Rooms/Examples/FFD/Tutorial/NaturalConvection.mcr</code>
that will generate the temperature contour and velocity vectors shown in the Figure (b).
Note: Tecplot is needed for this.
</li>
</ol>
</html>",  revisions="<html>
<ul>
<li>
September 07, 2017, by Thierry Nouidui:<br/>
Refactored the FFD C-code and revised the documentation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
</li>
<li>
July 7, 2015 by Michael Wetter:<br/>
Removed model for prescribed heat flow boundary condition
as the value was zero and hence the model is not needed.
This is for <a href=\"/https://github.com/lbl-srg/modelica-buildings/issues/439\">issue 439</a>.
</li>
<li>
July 25, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
June 27, 2014, by Wei Tian, Thomas Sevilla, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
<h4>References</h4>
<p>
<a name=\"ZuoEtAl2012\"/>
Wangda Zuo, Mingang Jin, Qingyan Chen, 2012.<br/>
<a href=\"http://doi.org/10.1080/19942060.2012.11015418\">
Reduction of numerical viscosity in FFD model.</a><br/>
Journal of Engineering Applications of Computational Fluid Mechanics, 6(2), p. 234-247.
</p>
</html>"));
  end NaturalConvection;

  model MixedConvectionWithBox1
    "Tutorial for Mixed Convection case with a heated box"
    extends Modelica.Icons.Example;
    package MediumA = Buildings.Media.Air (
          T_default=283.15) "Medium model";
    parameter Integer nConExtWin=0 "Number of constructions with a window";
    parameter Integer nConBou=0
      "Number of surface that are connected to constructions that are modeled inside the room";
    parameter Integer nSurBou=6
      "Number of surface that are connected to the room air volume";
    parameter Integer nConExt=0
      "Number of exterior constructions withour a window";
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
       name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
       A={0.9,0.9,1,1,1,0.75},
       til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
       each absIR=1e-5,
       each absSol=1e-5,
       each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
      lat = 0.012787839282646,
      AFlo = 1*1,
      hRoo = 1,
      linearizeRadiation = false,
      useCFD = true,
      haveSource=true,
      nSou=1,
      sensorName = {"Occupied zone air temperature", "Velocity"},
      cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBox/input.ffd",
      nConExt = nConExt,
      nConExtWin = nConExtWin,
      nConPar = nConPar,
      nConBou = nConBou,
      nSurBou = nSurBou,
      nPorts=2,
      portName={"Inlet","Outlet"},
      samplePeriod = 200,
      sourceName={"block"})
    annotation (Placement(transformation(extent={{80,-38},{120,2}})));
    HeatTransfer.Sources.FixedTemperature TOthWal[nSurBou-1](each T=283.15)
      "Temperature for other walls"          annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-50})));
    HeatTransfer.Sources.FixedTemperature TFlo(T=303.15) "Temperature of floor"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={150,-90})));
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
    Modelica.Blocks.Sources.Step step(
      height=15,
      offset=298.15,
      startTime=1000)
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
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
    connect(TFlo.port, roo.surf_surBou[6]) annotation (Line(
        points={{140,-90},{96.2,-90},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[1].port, roo.surf_surBou[1]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[2].port, roo.surf_surBou[2]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[3].port, roo.surf_surBou[3]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[4].port, roo.surf_surBou[4]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOthWal[5].port, roo.surf_surBou[5]) annotation (Line(
        points={{140,-50},{96.2,-50},{96.2,-32}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(bouIn.ports[1], roo.ports[1]) annotation (Line(
        points={{60,-44},{74,-44},{74,-26},{84,-26},{84,-26},{84,-26},{84,-30},{85,
            -30}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(bouOut.ports[1], roo.ports[2]) annotation (Line(
        points={{60,-74},{74,-74},{74,-26},{85,-26}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(step.y, roo.QIntSou[1]) annotation (Line(points={{-19,70},{60,70},{60,
            1.77636e-15},{78.4,1.77636e-15}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This tutorial gives step by step instructions on building and simulating a mixed convection model.
The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating ventilation with mixed convection in an empty room.
</p>
<h4>Case Description</h4>
<p>
The temperature of the floor is fixed at <i>30</i>&circ;C and the temperature of the walls and the ceiling are fixed
at <i>10</i>&circ;C. The supply air temperature is fixed at <i>10</i>&circ;C.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation and Figure (b) shows the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
<p>
Add the following model components into the <code>MixedConvection</code> model:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
This model is used to implement data exchange between Modelica and FFD.
Name it as <code>roo</code>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A.
Name it as <code>weaDat</code>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero.
Name these models as <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code>, respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to convert three numbers into a vector.
Name it as <code>multiple_x3</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperature on the floor and other walls.
Name them as <code>TFlo</code> and <code>TOthWal</code> respectively.
Please note that it is necessary to declare <code>TOthWal</code> as a vector of <i>5</i> elements.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>.
This model provides inlet air for the <code>roo</code>.
Name it as <code>bouIn</code>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>.
This model is the outdoor environment to which the outlet of <code>roo</code> is connected.
Name it as <code>bouOut</code>.
</li>
</ul>
</li>
<li>
<p>
In the textual editor mode, add the medium and the number of surfaces as below:
</p>
<pre>
package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated (T_default=283.15);
  parameter Integer nConExtWin=0;
  parameter Integer nConBou=0;
  parameter Integer nSurBou=6;
  parameter Integer nConExt=0;
  parameter Integer nConPar=0;
</pre>
</li>
<li>
<p>
Edit <code>roo</code> as below:
</p>
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
  redeclare package Medium = MediumA,
  surBou(
    name={\"East Wall\",\"West Wall\",\"North Wall\",\"South Wall\",\"Ceiling\",\"Floor\"},
    A={0.9,0.9,1,1,1,1},
    til={Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Ceiling,
        Buildings.Types.Tilt.Floor},
    each absIR=1e-5,
    each absSol=1e-5,
    each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
    lat = 0.012787839282646,
    AFlo = 1*1,
    hRoo = 1,
    linearizeRadiation = false,
    useCFD = true,
    sensorName = {\"Occupied zone air temperature\", \"Velocity\"},
    cfdFilNam = \"modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.ffd\",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts = 2,
    portName={\"Inlet\",\"Outlet\"},
    samplePeriod = 6);
</pre>
</li>
<li>
<p>
Set the parameters for the following components:
</p>
<ul>
<li>
Set <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code> to <i>0</i>.
</li>
<li>
Set <code>TFlo</code> to <i>303.15</i> Kelvin.
</li>
<li>
Set <code>TOthWal</code> to <i>283.15</i> Kelvin.
</li>
</ul>
</li>
<li>
<p>
Set the values for the parameters of <code>bouIn</code> and <code>bouOut</code> as below:
</p>
<pre>
Fluid.Sources.MassFlowSource_T bouIn(
  redeclare package Medium = MediumA,
  nPorts=1,
  m_flow=0.1,
  T=283.15);
</pre>
<pre>
Fluid.Sources.FixedBoundary bouOut(
  redeclare package Medium = MediumA,
  nPorts=1);
</pre>
</li>
<li>
<p>
Connect the components as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionModel.png\"/>
</p>
</li>
<li>
<p>
Confirm in the textual editor that the connections to
<code>roo.ports</code> are as follows:
</p>
<pre>
connect(bouIn.ports[1], roo.ports[1]);
connect(bouOut.ports[1], roo.ports[2]);
</pre>
</li>
<li>
<p>
Use the Simplified CFD Interface (SCI) to generate the input file for the FFD.
</p>
<ul>
<li>
Use a 20 X 20 X 20 stretched grid.
</li>
<li>
Set the time step size of the FFD to <i>0.1</i> seconds.
</li>
<li>
Generate the input files, which have by default the names
<code>input.cfd</code> (mesh file) and <code>zeroone.dat</code> (obstacles file).
</li>
<li>
Rename the files as <code>MixedConvection.cfd</code> and <code>MixedConvection.dat</code>, respectively.
</li>
</ul>
</li>
<li>
<p>
Revise the FFD parameter input file <code>MixedConvection.ffd</code>
(an example file is available in <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>):  </p>
<pre>
  inpu.parameter_file_format SCI
  inpu.parameter_file_name MixedConvection.cfd
  inpu.block_file_name MixedConvection.dat
  prob.nu 0.000015 // Kinematic viscosity
  prob.rho 1.205 // Density
  prob.gravx 0 // Gravity in x direction
  prob.gravy 0 // Gravity in y direction
  prob.gravz -9.81 // Gravity in z direction
  prob.cond 0.0257 // Conductivity
  prob.Cp 1006.0 // Specific heat capacity
  prob.beta 0.00343 // Thermal expansion coefficient
  prob.diff 0.00001 // Diffusivity for contaminants
  prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall
  prob.Temp_Buoyancy 10.0 // Reference temperature for calculating buoyance  force
  init.T 10.0 // Initial condition for Temperature
  init.u 0.0 // Initial condition for velocity u
  init.v 0.0 // Initial condition for velocity v
  init.w 0.0 // Initial condition for velocity w
</pre>
</li>
<li>
Put the files <code>MixedConvection.ffd</code>, <code>MixedConvection.dat</code>, and <code>MixedConvection.cfd</code> in the
directory <code>Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</code>.
</li>
<li>
Set the simulation stop time of the Modelica model to <code>180</code> seconds and choose, for example, the Radau solver.
</li>
<li>
Translate the model and start the simulation.
</li>
<li>
Post-process: click the Tecplot macro script
<code>Buildings/Resources/Image/Rooms/Examples/FFD/Tutorial/MixedConvection.mcr</code>
that will generate the temperature contour and velocity vectors shown in the Figure (b).
Note: Tecplot is needed for this.
</li>
</ol>
</html>",  revisions="<html>
<ul>
<li>
September 07, 2017, by Thierry Nouidui:<br/>
Refactored the FFD C-code and revised the documentation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
</li>
<li>
July 25, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
June 27, 2014, by Wei Tian, Thomas Sevilla, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
      experiment(Tolerance=1e-06, StopTime=180),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionWithBox.mos"
          "Simulate and plot"),
      Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false)));
  end MixedConvectionWithBox1;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains tutorials
for CFD simulations of zones with
natural and mixed convection,
with step by step
instructions for how to build such models.
</p>
</html>"));
end Tutorial;
