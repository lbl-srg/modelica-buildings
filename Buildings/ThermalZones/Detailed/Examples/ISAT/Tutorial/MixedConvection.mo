within Buildings.ThermalZones.Detailed.Examples.ISAT.Tutorial;
model MixedConvection "Tutorial for the mixed convection case"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air (
        T_default=283.15) "Medium model";
  parameter Integer nConExtWin=0 "Number of constructions with a window";
  parameter Integer nConBou=0
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou=6
    "Number of surface that are connected to the room air volume";
  parameter Integer nConExt=0
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
     name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
     A={0.9,0.9,1,1,1,1},
     til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
        Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
     each absIR=1e-5,
     each absSol=1e-5,
     each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
    AFlo = 1*1,
    hRoo = 1,
    linearizeRadiation = false,
    useCFD = true,
    nSou=0,
    sensorName = {"OccupiedZoneAirTemperature", "Velocity"},
    cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/input.ffd",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts=2,
    portName={"Inlet","Outlet"},
    samplePeriod=200) "Room model"
  annotation (Placement(transformation(extent={{80,-38},{120,2}})));
  HeatTransfer.Sources.FixedTemperature TOthWal[nSurBou-1](each T=283.15)
    "Temperature for other walls"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},origin={150,-50})));
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
      points={{140,-90},{96.2,-90},{96.2,-31.5833}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[1].port, roo.surf_surBou[1]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.4167}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[2].port, roo.surf_surBou[2]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[3].port, roo.surf_surBou[3]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.0833}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[4].port, roo.surf_surBou[4]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-31.9167}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[5].port, roo.surf_surBou[5]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-31.75}},
      color={191,0,0},
      smooth=Smooth.None));
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
This tutorial gives step by step instructions on building and simulating a mixed
convection model. The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>
with the ISAT program by simulating ventilation with mixed convection in an empty room.
</p>
<h4>Case Description</h4>
<p>
There are four inputs and two outputs in the ISAT model for this case. The inputs
are (1) supply air temperature, (2) supply air flow rate, (3) temperature of
the ceiling and walls and (4) temperature of the floor. The outputs are (1)
average room temperature and (2) velocity.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation and Figure (b) shows
the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as
simulated by the FFD.
</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionSchematic.png\" alt=\"image\"/></p>
<p align=\"center\">Figure (a)</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection.png\" alt=\"image\"/></p>
<p align=\"center\">Figure (b)</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
Add the following model components into the <span style=\"font-family: Courier New;\">
MixedConvection</span> model:
</li>
<li>
<ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">
Buildings.ThermalZones.Detailed.ISAT</a>.
This model is used to implement data exchange between Modelica and ISAT. Name it as
<span style=\"font-family: Courier New;\">roo</span>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as
<span style=\"font-family: Courier New;\">weaDat</span>.
</li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective
heat gain and internal latent heat gain are zero.
Name these models as <span style=\"font-family: Courier New;\">qRadGai_flow</span>,
<span style=\"font-family: Courier New;\">qConGai_flow</span> and
<span style=\"font-family: Courier New;\">qLatGai_flow</span>,
respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">
Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to convert three numbers into a vector.
Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperature on the floor and other walls.
Name them as <span style=\"font-family: Courier New;\">TFlo</span> and
<span style=\"font-family: Courier New;\">TOthWal</span> respectively.
Please note that it is necessary to declare
<span style=\"font-family: Courier New;\">TOthWal</span> as a vector of <i>5</i> elements.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">
Buildings.Fluid.Sources.MassFlowSource_T</a>.
This model provides inlet air for the <span style=\"font-family: Courier New;\">roo</span>.
Name it as <span style=\"font-family: Courier New;\">bouIn</span>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>.
This model is the outdoor environment to which the outlet of
<span style=\"font-family: Courier New;\">roo</span> is connected.
Name it as <span style=\"font-family: Courier New;\">bouOut</span>.
</li>
</ul>
</li>
<li>
In the text editor mode, add the medium and the number of surfaces as below:
<pre>
package MediumA = Buildings.Media.Air (T_default=283.15);
parameter Integer nConExtWin=0;
parameter Integer nConBou=0;
parameter Integer nSurBou=6;
parameter Integer nConExt=0;
parameter Integer nConPar=0;
</pre>
</li>
<li>
Edit <span style=\"font-family: Courier New;\">roo</span> as below:
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
redeclare package Medium = MediumA,
surBou(
name={&quot;East Wall&quot;,&quot;West Wall&quot;,&quot;North Wall&quot;,&quot;South Wall&quot;,&quot;Ceiling&quot;,&quot;Floor&quot;},
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
sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},
cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/input.ffd&quot;,
nConExt = nConExt,
nConExtWin = nConExtWin,
nConPar = nConPar,
nConBou = nConBou,
nSurBou = nSurBou,
nPorts = 2,
portName={&quot;Inlet&quot;,&quot;Outlet&quot;},
samplePeriod = 200);
</pre>
</li>
<li>
Set the parameters for the following components:
</li>
<li>
<ul>
<li>Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>,
<span style=\"font-family: Courier New;\">qConGai_flow</span>
and <span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>.
</li>
<li>
Set <span style=\"font-family: Courier New;\">TFlo</span> to <i>303.15</i> Kelvin.
</li>
<li>
Set <span style=\"font-family: Courier New;\">TOthWal</span> to <i>283.15</i> Kelvin.
</li>
</ul>
</li>
<li>
Set the values for the parameters of <span style=\"font-family: Courier New;\">bouIn</span>
and <span style=\"font-family: Courier New;\">bouOut</span> as below:
<pre>
Fluid.Sources.MassFlowSource_T bouIn(
redeclare package Medium = MediumA,
nPorts=1,
m_flow=0.1,
T=283.15);
Fluid.Sources.FixedBoundary bouOut(
redeclare package Medium = MediumA,
nPorts=1);
</pre>
</li>
<li>
Connect the components as shown in the figure below.
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionModel.png\" alt=\"image\"/></p>
</li>
<li>
Confirm in the textual editor that the connections to <span style=\"font-family: Courier New;\">roo.ports</span>
are as follows:
<pre>
connect(bouIn.ports[1], roo.ports[1]);
connect(bouOut.ports[1], roo.ports[2]);
</pre>
</li>
<li>Define the settings for the ISAT model:
<p>In the <span style=\"font-family: Courier New;\">set.isat</span> file, the parameters for the ISAT model can be defined:</p>
<p>/********************************************************************************</p>
<p>| Section 1: General settings of isat</p>
<p>********************************************************************************/</p>
<p>isat.useISAT 1 /*If use ISAT*/</p>
<p>isat.useBinarySelectedPoint 0 /*If use binary pre-training*/</p>
<p>isat.digAftdec 2 /*Digitals after decimal*/</p>
<p>isat.read_existing 0 /*1: read existing database; 0: train from scratch*/</p>
<p>isat.write_existing 0 /*1: write ffd results to database; 0: do not write*/</p>
<p>isat.err_global 0.2 /* user-defined global error tolerance */</p>
<p>isat.num_input 4 /* number of isat inputs */</p>
<p>isat.num_output 2 /* number of isat outputs */</p>
<p>/********************************************************************************</p>
<p>| Section 2: Input settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.0: Settings of numbers</p>
<p>// Note: Users define numbers of inlets, blocks and walls, respectively, if</p>
<p>// there exists at least one inlet, block or wall that will be</p>
<p>// overwirtten by isat inputs. The number should be 0 if none of the inlets</p>
<p>// blocks or walls will be overwritten by isat inputs</p>
<p>//-------------------------------------------------------------------------</p>
<p>/* inpu.inpu_name: names of inputs including inlet_temp, inlet_mass, inlet_vel, block_temp, block_hea, sur_temp, sur_hea */</p>
<p>inpu.inpu_name inlet_temp</p>
<p>inpu.inpu_name inlet_mass</p>
<p>inpu.inpu_name sur_temp</p>
<p>inpu.inpu_name sur_temp</p>
<p>/* number of inlets, blocks and walls */</p>
<p>inpu.num_inlet 1</p>
<p>inpu.num_block 0</p>
<p>inpu.num_wall 6</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.1: Settings of inlets</p>
<p>// Note: Users should define inlet_temp, inlet_u, inlet_v, inlet_w, </p>
<p>// respectively. The number of inlets should be consistent.</p>
<p>//-------------------------------------------------------------------------</p>
<p>/*inpu.dir_inlet: 1: x; 2: y; 3: z*/</p>
<p>inpu.dir_inlet 1</p>
<p><br>/*inpu.default_mass_flowrate: set a default mass flowrate if using prescribed outlet bc. NOTE: for advanced users only.*/</p>
<p>inpu.default_mass_flowrate 0.1205</p>
<p><br>/*inlet_area_value: inlet area*/</p>
<p>inpu.inlet_area_value 0.1</p>
<p><br>/*inpu.inlet_temp_re: inlet_temp will be overwritten or not*/</p>
<p>inpu.inlet_temp_re 1</p>
<p>/*inpu.inlet_vel_re: inlet_u will be overwritten or not*/</p>
<p>inpu.inlet_vel_re 1</p>
<p><br>/*inpu.inlet_temp_wh: value of inlet_temp will be assigned by which isat input*/</p>
<p>inpu.inlet_temp_wh 1</p>
<p>/*inpu.inlet_vel_wh: value of inlet_u will be assigned by which isat input*/</p>
<p>inpu.inlet_vel_wh 2</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.2: Settings of blocks</p>
<p>// Note: The number of blocks should be consistent</p>
<p>//-------------------------------------------------------------------------</p>
<p>...</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.3: Settings of walls</p>
<p>// Note: The number of walls should be consistent</p>
<p>//-------------------------------------------------------------------------</p>
<p>/* inpu.wall_re: temperature or heat flux of walls will be overwritten or not */</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>/* inpu.wall_wh: temperature or heat flux of walls will be assigned by which isat input */</p>
<p>inpu.wall_wh 3</p>
<p>inpu.wall_wh 3</p>
<p>inpu.wall_wh 3</p>
<p>inpu.wall_wh 3</p>
<p>inpu.wall_wh 3</p>
<p>inpu.wall_wh 4</p>
<p>/********************************************************************************</p>
<p>| Section 3: Output settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/* outp.outp_name: names of outputs including temp_roo, temp_occ, vel_occ, temp_sen, vel_sen, temp_rack */</p>
<p>outp.outp_name temp_roo</p>
<p>outp.outp_name vel_sen</p>
<p>/* outp.outp_weight: weights for error control, when outputs have different order of magnitudes */</p>
<p>outp.outp_weight 1.0</p>
<p>outp.outp_weight 10.0</p>
</li>
<li>
Note: the desired outputs of isat can be altered by changing the output sensors
in section 3 of the set.isat file. The available default sensors include:
</li>
<li>
<ul>
<li>
<span style=\"font-family: Courier New;\">temp_roo,</span>
which outputs the average room temperature,
</li>
<li>
<span style=\"font-family: Courier New;\">temp_occ</span>,
which outputs the average temperature of the occupied zone,
</li>
<li>
<span style=\"font-family: Courier New;\">vel_occ,</span>
which outputs the average velocity of the occupied zone,
</li>
<li>
<span style=\"font-family: Courier New;\">temp_sen,</span>
which outputs the temperature at a defined location (default is
center of the room),
</li>
<li>
<span style=\"font-family: Courier New;\">vel_sen,</span> which outputs the
velocity at the a defined location (default is center of the room).
</li>
</ul>
</li>
</ol>
<p>Furthermore, advanced users can modify the source code located in
<span style=\"font-family: Courier New;\">Buildings/Resources/src/ISAT</span>
to adjust the current sensors or add new ones.
</p>
<p>
For example, in lines <span style=\"font-family: Courier New;\">324-326</span>
and <span style=\"font-family: Courier New;\">344-346</span>
in <span style=\"font-family: Courier New;\">utility_isat.c,</span>
users can change the location of the temperature or velocity sensor.
</p>
<p>
In addition, the occupied zones can be adjusted in the
<span style=\"font-family: Courier New;\">average_room_temp</span>
and <span style=\"font-family: Courier New;\">average_room_vel</span>
functions in <span style=\"font-family: Courier New;\">utility_isat.c.</span>
</p>
<ol>
<li>Use the Simplified CFD Interface (SCI) to generate the input file for the FFD. </li>
<li>
<ul>
<li>Use a 20 X 20 X 20 stretched grid. </li>
<li>Set the time step size of the FFD to <i>0.1</i> seconds. </li>
<li>Generate the input files, which by default have the names
<span style=\"font-family: Courier New;\">input.cfd</span> (mesh file)
and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file).
</li>
<li>
Rename the files as <span style=\"font-family: Courier New;\">MixedConvection.cfd</span>
and <span style=\"font-family: Courier New;\">MixedConvection.dat</span>, respectively.
</li>
</ul>
</li>
<li>
Revise the FFD parameter input file <span style=\"font-family: Courier New;\">MixedConvection.ffd</span>
(an example file is available in <span style=\"font-family: Courier New;\">
Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/</span>):
<pre>
inpu.parameter_file_format SCI
inpu.parameter_file_name MixedConvection.cfd
inpu.block_file_name MixedConvection.dat
outp.result_file NO //PLT, VTK, NO
prob.nu 0.000015 // Kinematic viscosity
prob.rho 1.20 // Density
prob.gravx 0 // Gravity in x direction
prob.gravy 0 // Gravity in y direction
prob.gravz -9.81 // Gravity in z direction
prob.cond 0.0257 // Conductivity
prob.Cp 1006.0 // Specific heat capacity
prob.beta 0.00343 // Thermal expansion coefficient
prob.diff 0.00001 // Diffusivity for contaminants
prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall
prob.Temp_Buoyancy 10.0 // Reference temperature for calculating buoyance force
bc.outlet_bc ZERO_GRADIENT // ZERO_GRADIENT, PRESCRIBED_VALUE
init.T 10.0 // Initial condition for Temperature
init.u 0.0 // Initial condition for velocity u
init.v 0.0 // Initial condition for velocity v
init.w 0.0 // Initial condition for velocity w
</pre>
</li>
<li>
Put the files <span style=\"font-family: Courier New;\">input.isat</span>,
<span style=\"font-family: Courier New;\">output.isat</span>,
<span style=\"font-family: Courier New;\">set.isat</span>,
<span style=\"font-family: Courier New;\">input.ffd</span>,
<span style=\"font-family: Courier New;\">input.dat</span>,
and <span style=\"font-family: Courier New;\">input.cfd</span> in the
directory <span style=\"font-family: Courier New;\">
Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/</span>.
</li>
<li>
Set the simulation stop time of the Modelica model to
<span style=\"font-family: Courier New;\">180</span> seconds and choose,
for example, the Radau solver.
</li>
<li>Translate the model and start the simulation. </li>
<li>Post-process: the generation of FFD output file (plt or vtk) is blocked by
default, the users should revise the codes to output.
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>April 5, 2020, by Xu Han, Cary Faulkner, Wangda Zuo:<br>First implementation. </li>
</ul>
</html>"),
    experiment(Tolerance=1e-06, StopTime=1800),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection.mos" "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false),
        graphics));
end MixedConvection;
