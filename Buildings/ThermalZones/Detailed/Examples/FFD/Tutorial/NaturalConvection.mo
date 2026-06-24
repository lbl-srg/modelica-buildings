within Buildings.ThermalZones.Detailed.Examples.FFD.Tutorial;
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
  Buildings.ThermalZones.Detailed.CFD roo(
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
   sensorName = {"Occupied zone air temperature", "Velocity"},
   cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvection.ffd",
   nConExt = nConExt,
   nConExtWin = nConExtWin,
   nConPar = nConPar,
   nConBou = nConBou,
   nSurBou = nSurBou,
   samplePeriod = 60,
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
          __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/NaturalConvection.mos"
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
East wall: Fixed temperature at <i>T<sub>e</sub>=0</i>&deg;C,
</li>
<li>
West wall: Fixed temperature at <i>T<sub>w</sub>=1</i>&deg;C,
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
Set simulation the stop time of the Modelica model <code>3600</code> seconds and choose for example the CVode solver.
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
</html>",revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
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
<a href=\"https://doi.org/10.1080/19942060.2012.11015418\">
Reduction of numerical viscosity in FFD model.</a><br/>
Journal of Engineering Applications of Computational Fluid Mechanics, 6(2), p. 234-247.
</p>
</html>"));
end NaturalConvection;
