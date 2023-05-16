within Buildings.ThermalZones.Detailed.Examples.ISAT.Tutorial;
model NaturalConvection "Tutorial for the natural convection case"
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
   nSou=0,
   sensorName = {"Zone air temperature", "Velocity"},
   cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection/input.ffd",
   nConExt = nConExt,
   nConExtWin = nConExtWin,
   nConPar = nConPar,
   nConBou = nConBou,
   nSurBou = nSurBou,
   samplePeriod = 7200,
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
      points={{120,-70},{76.2,-70},{76.2,-52.4167}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TWesWal.port, roo.surf_surBou[2])
    annotation (Line(
      points={{120,-110},{76.2,-110},{76.2,-52.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{140,50},{154,50},{154,-20.1},{97.9,-20.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
annotation (Diagram(coordinateSystem(extent={{-80,-140},{180,80}},
          preserveAspectRatio=false)),
          __Dymola_Commands(file = "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=7200),
Documentation(info="<html>
<p>
This tutorial gives step by step instructions for building and simulating a
natural convection model. The model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>
with the ISAT program by simulating the natural convection in an empty room with
only surface boundary conditions.
</p>
<h4>Case Description</h4>
<p>
The Rayleigh number is a dimensionless number associated with natural convection,
defined as
</p>
<p align=\"center\"><i>R<sub>a</sub> = g &beta; (T<sub>w</sub>-T<sub>e</sub>)L<sup>3</sup> &frasl; (&nu; &alpha;) </i></p>
<p>
To get a Rayleigh number of <i>1E5</i>, the flow properties are manually set as
acceleration due to gravity <i>g<sub>z</sub>=-0.01</i> m/s<sup>2</sup>, thermal
expansion coefficient <i>&beta;=3e-3</i> K<sup>-1</sup>, kinematic viscosity
<i>&nu;=1.5e-5</i> m<sup>2</sup>/s, thermal diffusivity <i>&alpha;=2e-5</i> m<sup>2</sup>/s,
and characteristic length <i>L=1</i> m.
</p>
<p>
There are two inputs and two outputs in the ISAT model for this case. The inputs
are (1) temperature of the west wall and (2) temperature of the east wall.
The outputs are (1) average room temperature and (2) velocity.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation. The following conditions are applied in Modelica.:
</p>
<ul>
<li>East wall: Fixed temperature at <i>T<sub>e</sub>=0</i>&circ;C,</li>
<li>West wall: Fixed temperature at <i>T<sub>w</sub>=1</i>&circ;C,</li>
<li>North &amp; South wall, Ceiling, Floor: Fixed heat flux at <i>0</i> W/m<sup>2</sup>.</li>
</ul>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p>
Figure (b) shows the velocity vectors and temperature contour in degree Celsius
on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<p>
More details of the case description can be found in <a href=\"#ZuoEtAl2012\">Zuo et al. (2012)</a>.
</p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. </p> 
<ol>
<li>Add the following component models to the <span style=\"font-family: Courier New;\">NaturalConvection</span> model: </li>
<li><ul>
<li>
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.ISAT</a>.
This model is used to implement the data exchange between Modelica and ISAT.
Name it as <span style=\"font-family: Courier New;\">roo</span>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A.
Name it as <span style=\"font-family: Courier New;\">weaDat</span>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>.
Three models are needed to specify that internal radiation, internal convective heat
gain and internal latent heat gain zero. Name these models as
<span style=\"font-family: Courier New;\">qRadGai_flow</span>,
<span style=\"font-family: Courier New;\">qConGai_flow</span>
and <span style=\"font-family: Courier New;\">qLatGai_flow</span>,
respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>.
This block is used to combine three scalar signals to a vector.
Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">Buildings.HeatTransfer.Sources.FixedTemperature</a>.
Two models are needed to specify the temperatures on the east and west walls.
Name them as <span style=\"font-family: Courier New;\">TeasWal</span>
and <span style=\"font-family: Courier New;\">TwesWal</span>, respectively.
</li>
</ul>
<p>Note that for the other four walls with adiabatic boundary conditions,
we do not need to specify a zero heat flow boundary condition because the
heat flow rate transferred through a heat port from the outside is zero if the heat
port is not connected from the outside. </p>
</li>
<li>In the textual editor mode, add the medium and the number of surfaces as shown below:
<pre>
package MediumA = Buildings.Media.Air (T_default=283.15);
parameter Integer nConExtWin=0;
parameter Integer nConBou=0;
parameter Integer nSurBou=6;
parameter Integer nConExt=0;
parameter Integer nConPar=0;
</pre>
</li> 
<li>Edit <span style=\"font-family: Courier New;\">roo</span> as below:
<pre>
Buildings.ThermalZones.Detailed.CFD roo(
redeclare package Medium = MediumA,
surBou(
name={&quot;East Wall&quot;,&quot;West Wall&quot;,&quot;North Wall&quot;,&quot;South Wall&quot;,&quot;Ceiling&quot;,&quot;Floor&quot;},
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
sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},
cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection/input.ffd&quot;,
nConExt = nConExt,
nConExtWin = nConExtWin,
nConPar = nConPar,
nConBou = nConBou,
nSurBou = nSurBou,
T_start=273.15,
samplePeriod = 7200);
massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);
</pre>
</li>
<li>Connect the component as shown in the figure below.
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvectionModel.png\" alt=\"image\"/> </p>
</li>
<li>Set the values for the following components: </li>
<li><ul>
<li>
Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>,
<span style=\"font-family: Courier New;\">qConGai_flow</span> and
<span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>.
</li>
<li>Set <span style=\"font-family: Courier New;\">TEasWal</span> to <i>273.15</i> Kelvin.</li>
<li>Set <span style=\"font-family: Courier New;\">TWesWal</span> to <i>274.15</i> Kelvin.</li>
</ul></li>
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
<p>isat.num_input 2 /* number of isat inputs */</p>
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
<p>inpu.inpu_name sur_temp</p>
<p>inpu.inpu_name sur_temp</p>
<p>/* number of inlets, blocks and walls */</p>
<p>inpu.num_inlet 0</p>
<p>inpu.num_block 0</p>
<p>inpu.num_wall 6</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.1: Settings of inlets</p>
<p>// Note: Users should define inlet_temp, inlet_u, inlet_v, inlet_w, </p>
<p>// respectively. The number of inlets should be consistent.</p>
<p>//-------------------------------------------------------------------------</p>
<p>...</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.2: Settings of blocks</p>
<p>// Note: The number of blocks should be consistent</p>
<p>//-------------------------------------------------------------------------</p>
<p>...</p>
<p>//-------------------------------------------------------------------------</p>
<p>// Section 2.3: Settings of walls</p>
<p>// Note: The number of walls should be consistent</p>
<p>//-------------------------------------------------------------------------</p>
<p>/*inpu.wall_re: temperature or heat flux of walls will be overwritten or not*/</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 0</p>
<p>inpu.wall_re 0</p>
<p>inpu.wall_re 0</p>
<p>inpu.wall_re 0</p>
<p>/*inpu.wall_wh: temperature or heat flux of walls will be assigned by which isat input*/</p>
<p>inpu.wall_wh 2</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 0</p>
<p>inpu.wall_wh 0</p>
<p>inpu.wall_wh 0</p>
<p>inpu.wall_wh 0</p>
<p>/********************************************************************************</p>
<p>| Section 3: Output settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/* outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen, temp_rack */</p>
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
<li><ul>
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
<li><span style=\"font-family: Courier New;\">temp_sen,</span>
which outputs the temperature at a defined location (default is center of
the room),
</li>
<li>
<span style=\"font-family: Courier New;\">vel_sen,</span> which outputs the
velocity at the a defined location (default is center of the room).
</li>
</ul>
</li>
</ol>
<p>
Furthermore, advanced users can modify the source code located in
<span style=\"font-family: Courier New;\">Buildings/Resources/src/ISAT</span>
to adjust the current sensors or add new ones.
</p>
<p>
For example, in lines <span style=\"font-family: Courier New;\">324-326</span>
and <span style=\"font-family: Courier New;\">344-346</span>
in <span style=\"font-family: Courier New;\">utility_isat.c,</span>
users can change the location of the temperature or velocity sensor.
</p>
<p>I
n addition, the occupied zones can be adjusted in the
<span style=\"font-family: Courier New;\">average_room_temp</span>
and <span style=\"font-family: Courier New;\">average_room_vel</span>
functions in <span style=\"font-family: Courier New;\">utility_isat.c.</span>
</p>
<ol>
<li>Use the Simplified CFD Interface (SCI) to generate the input file for FFD. </li>
<li><ul>
<li>Use a 20 x 20 x 20 uniform grid. </li>
<li>Set the time step size of the FFD to <i>10</i> seconds. </li>
<li>
Generate the input files which have the default names
<span style=\"font-family: Courier New;\">input.cfd</span> (mesh file)
and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file).
</li>
<li>
Rename the files as <span style=\"font-family: Courier New;\">NaturalConvection.cfd</span>
and <span style=\"font-family: Courier New;\">NaturalConvection.dat</span>,
respectively.
</li>
</ul>
</li>
<li>
Revise the FFD parameter input file
<span style=\"font-family: Courier New;\">NaturalConvection.ffd</span>
(an example file is provided in
<span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/</span>):
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
Please note that some of the physical properties were manipulated to obtain the
desired Rayleigh Number of <i>10<sup>5</sup></i>.
</p>
</li> 
<li>
Store <span style=\"font-family: Courier New;\">NaturalConvection.ffd</span>,
<span style=\"font-family: Courier New;\">NaturalConvection.dat</span>,
and <span style=\"font-family: Courier New;\">NaturalConvection.cfd</span>
at <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial</span>.
</li>
<li>
Set simulation the stop time of the Modelica model
<span style=\"font-family: Courier New;\">7200</span> seconds and choose
for example the Radau solver.
</li>
<li>Translate the model and start the simulation. </li>
<li>
Post-process: click the Tecplot macro script <span style=\"font-family: Courier New;\">
Buildings/Resources/Image/Rooms/Examples/ISAT/Tutorial/NaturalConvection.mcr</span>
that will generate the temperature contour and velocity vectors shown in the
Figure (b). Note: Tecplot is needed for this.
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>April 5, 2020, by Xu Han, Cary Faulkner, Wangda Zuo:<br>First implementation. </li>
</ul>
<h4>References</h4>
<p><a name=\"ZuoEtAl2012\">W</a>angda Zuo, Mingang Jin, Qingyan Chen, 2012.</p>
<p><a href=\"http://doi.org/10.1080/19942060.2012.11015418\">Reduction of numerical viscosity in FFD model.</a></p>
<p>Journal of Engineering Applications of Computational Fluid Mechanics, 6(2), p. 234-247. </p>
</html>"));
end NaturalConvection;
