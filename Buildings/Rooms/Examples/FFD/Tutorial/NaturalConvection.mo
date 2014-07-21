within Buildings.Rooms.Examples.FFD.Tutorial;
model NaturalConvection "Tutorial for Natural Convection case"
  extends Modelica.Icons.Example;
  package MediumA =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated (
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
  inner Modelica.Fluid.System system(T_ambient=283.15)
    annotation (Placement(transformation(extent={{-60,
            -120},{-40,-100}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic matLayRoo(final nLay=
        1, material={HeatTransfer.Data.Solids.Concrete(x=0.0001)})
    "Construction material for roof"
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
      TDryBul=293.15)
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Rooms.CFD roo(
   redeclare package Medium = MediumA,
   surBou(
   name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
   each A=1*1,
   til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
        Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
        Buildings.HeatTransfer.Types.Tilt.Floor,Buildings.HeatTransfer.Types.Tilt.Ceiling},
   each absIR=1e-5,
   each absSol=1e-5,
   boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
       Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
       Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
       Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
       Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate}),
   lat = 0.012787839282646,
   AFlo = 1*1,
   hRoo = 1,
   linearizeRadiation = false,
   useCFD = true,
   sensorName = {"Occupied zone air temperature", "Velocity"},
   cfdFilNam = "Resources/Data/Rooms/FFD/Tutorial/NaturalConvection.ffd",
   nConExt = nConExt,
   nConExtWin = nConExtWin,
   nConPar = nConPar,
   nConBou = nConBou,
   nSurBou = nSurBou,
   samplePeriod = 60,
   T_start=273.15)
  annotation (Placement(transformation(extent={{60,-58},{100,-18}})));
  HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[nSurBou - 2](each Q_flow=0)
    annotation (Placement(transformation(extent={{26,-102},
            {46,-82}})));
  HeatTransfer.Sources.FixedTemperature           TWesWal(T=274.15)
    "Boundary condition for the west wall" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-110})));
  HeatTransfer.Sources.FixedTemperature           TEasWal(T=273.15)
    "Temperature of east wall"            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
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
      points={{21,-30},{30,-30},{30,-30},{40,-30},{40,-30},{58,-30}},
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

  connect(fixedHeatFlow[1].port, roo.surf_surBou[3])
    annotation (Line(
      points={{46,-92},{76.2,-92},{76.2,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow[2].port, roo.surf_surBou[4])
    annotation (Line(
      points={{46,-92},{76.2,-92},{76.2,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow[3].port, roo.surf_surBou[5])
    annotation (Line(
      points={{46,-92},{76.2,-92},{76.2,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow[4].port, roo.surf_surBou[6])
    annotation (Line(
      points={{46,-92},{76.2,-92},{76.2,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{140,50},{154,50},{154,-20.1},{97.9,-20.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This tutorial gives step by step instruction on building and simulating natural convection model. The model tests the coupled simulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only surface boundaries.
</p>
<h4>Case Description</h4>
<p>
The Rayleigh number is a dimensionless number associated with natural convection, defined as 
<p align=\"center\" style=\"font-style:italic;\">
  R<sub>a</sub> = g &beta; (T<sub>w</sub>-T<sub>e</sub>)L<sup>3</sup> &frasl; (&nu; &alpha;)
</p>
<p>
To get a Rayleigh number of 1E5, the flow properties are mannually set as
acceleration due to gravity <i>g<sub>z</sub>=-0.01</i> m/s2, 
thermal expansion coefficient <i>&beta;=3e-3</i> 1/K, 
kinematic viscosity <i>&nu;=1.5e-5</i> m2/s, 
thermal diffusivity <i>&alpha;=2e-5</i> m2/s,
characteristic length <i>L=1</i> m. 
</p>
<p>
Figure (a) shows the schematic of the FFD simulation. 
The following conditions are applied at Modelica side:
</p>
<ul>
<li>
East wall: Fixed temperature at <i>T<sub>e</sub>=0</i> degC, 
</li>
<li>
West wall: Fixed temperature at <i>T<sub>w</sub>=1</i> degC,
</li>
<li>
North &amp; South wall, Ceiling, Floor: Fixed heat flux at 0 W/m2.
</li>
</ul>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/Tutorial/NaturalConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p>
Figure (b) shows the velocity vectors and temperature contour [degC] on the X-Z plane at Y = 0.5m simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/Tutorial/NaturalConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
More details of the case description can be found in 
<a href=\"#ZuoEtAl2011\">Zuo et al. (2011)</a>.
</p>
<h4>Step by Step Guide</h4>
<p>
This section describes step by step how to build and simulate the model.
</p>
<ol>
<li>
<p> 
Add the following model components into NaturalConvection model:
</p>
<ul>
<li>
<a href=\"modelica://Modelica.Fluid.System\">Modelica.Fluid.System</a>. 
This model provides a basic physical environment for simulation.
</li>
<li>
<a href=\"modelica://Buildings.Rooms.CFD\">Buildings.Rooms.CFD</a>. 
This model is used to implement data exchange between Modelica and FFD. Name it as <code>roo</code>.
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. 
Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <code>weaDat</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions.Generic\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</a>. 
This model provides room construction properties. 
Name it as <code>matLayRoo</code>.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>. Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain  zero.
Name these models as <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code>, respectively.
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>. 
This block is used to concentrate three number inputs into one vector output. Name it as <code>multiple_x3</code>.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Source.FixedTemperature\">Buildings.HeatTransfer.Source.FixedTemperature</a>. 
Two models are needed to specify the temperature on the east and west walls. 
Name them as <code>TeasWal</code> and <code>TwesWal</code>, respectively.
</li>
<li>
<a href=\"modelica://Buildings.HeatTransfer.Source.FixedHeatFlow\">Buildings.HeatTransfer.Source.FixedHeatFlow</a>. 
This model is used to specify that the other four walls are adiabatic. Please note that it is necessary
to claim it as a vector whose number of elements is 4.
Define it as <code>fixedHeatFlow[nSurBou - 2]</code>.
</li>
</ul>
</li>
<li>
<p>
In script mode, add medium and number of surfaces as below:
</p>
<pre>
Buildings.Rooms.CFD roo(
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
redeclare package Medium = MediumA,
surBou(
 name={\"East Wall\",\"West Wall\",\"North Wall\",\"South Wall\",\"Ceiling\",\"Floor\"},
 each A=1*1,
 til={Buildings.HeatTransfer.Types.Tilt.Wall,
      Buildings.HeatTransfer.Types.Tilt.Wall,
      Buildings.HeatTransfer.Types.Tilt.Wall,
      Buildings.HeatTransfer.Types.Tilt.Wall,
      Buildings.HeatTransfer.Types.Tilt.Ceiling,
      Buildings.HeatTransfer.Types.Tilt.Floor},
 each absIR=1e-5,
 each absSol=1e-5,
 boundaryCondition={
      Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
      Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
      Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
      Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
      Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
      Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate}),
 lat = 0.012787839282646,
 AFlo = 1*1,
 hRoo = 1,
 linearizeRadiation = false,
 useCFD = true,
 sensorName = {\"Occupied zone air temperature\", \"Velocity\"},
 cfdFilNam = \"Resources/Data/Rooms/FFD/Tutorial/NaturalConvection.ffd\",
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
Edit <code>matLayRoo</code> as below:
</p>
<pre>
parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayRoo(
 final nLay=1, material={HeatTransfer.Data.Solids.Concrete(x=0.0001)});
</pre>
</li> 
<li>
<p>
Connect components as shown in below figure.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/Tutorial/NaturalConvectionModel.png\"/> 
</p>
</li>
<li>
Set the values for components:
<ul>
<li>
Set <code>qRadGai_flow</code>, <code>qConGai_flow</code> and <code>qLatGai_flow</code> to 0. 
</li>
<li>
Set <code>fixedHeatFlow</code> to 0. 
</li>
<li>
Set <code>TEasWal</code> to 273.15.
</li>
<li>
Set <code>TWesWal</code> to 274.15.
</li>
</ul>
</li>
<li>
Use Simplified CFD Interface (SCI) to generate input file for FFD. 
<ul>
<li>
Use 20 x 20 x 20 uniform grids.
</li>
<li>
Set the time step size as 10 seconds. 
</li>
<li>
Generate the input files which are by default name as <code>input.cfd</code> (mesh file) and <code>zeroone.dat</code> (obstacles file).
</li>
<li>
Rename the files as <code>NaturalConvection.cfd</code> and <code>NaturalConvection.dat</code>, respectively.
</li>
</ul>
</li>
<li>
Revise the FFD parameter input file <code>NaturalConvection.ffd</code> (example file already in <code>Buildings/Resources/Data/Rooms/FFD/Tutorial/</code>):     
<pre>
 inpu.parameter_file_format SCI
 inpu.parameter_file_name Resources/Data/Rooms/FFD/Tutorial/NaturalConvection.cfd 
 inpu.block_file_name Resources/Data/Rooms/FFD/Tutorial/NaturalConvection.dat
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
Please note that some of the physical properties were manipulated to obtained the desired Rayleigh Number of 1E5.
</p>
</li>
<li>
Put <Code>NaturalConvection.ffd</code>, <Code>NaturalConvection.dat</code>, and <Code>NaturalConvection.cfd</code> at <code>Buildings/Resources/Data/Rooms/FFD/Tutorial</code>.
</li>
<li>
Set simulation stop time to <code>7200</code> seconds and choose <code>Radau solver</code>. 
</li>
<li>
Translate the model and start the simulation.
</li> 
<li>
Post-process: click the Tecplot macro script <code>Buildings/Resources/Image/Rooms/Examples/FFD/Tutorial/NaturalConvection.mcr</code> that will generate the temperature contour and velocity vectors shown in the Figure (b). 
Note: Tecplot is needed for this.
</li> 
</ol>
</html>",revisions="<html>
<ul>
<li>
June 27, 2014, by Wei Tian, Thomas Sevilla, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
<h4>References</h4>
<p>
<a NAME=\"ZuoEtAl2011\"/>
Wangda Zuo, Mingang Jin, Qingyan Chen, 2011<br/></a>
<a href=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/2011-Zuo-EACFD.pdf\">
Reduction of numerical viscosity in FFD model.</a><br/> 
Journal of Engineering Applications of Computational Fluid Mechanics, 6(2), p. 234-247.
</p>
</html>"),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/Tutorial/NaturalConvection.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-100,-180},{240,100}},
          preserveAspectRatio=false), graphics));
end NaturalConvection;
