within Buildings.ThermalZones.Detailed.Examples.FFD.Tutorial;
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
  Buildings.ThermalZones.Detailed.CFD roo(
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
    sensorName = {"Occupied zone air temperature", "Velocity"},
    cfdFilNam = "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.ffd",
    nConExt = nConExt,
    nConExtWin = nConExtWin,
    nConPar = nConPar,
    nConBou = nConBou,
    nSurBou = nSurBou,
    nPorts=2,
    portName={"Inlet","Outlet"},
    samplePeriod = 6)
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
      points={{140,-90},{96.2,-90},{96.2,-31.1667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[1].port, roo.surf_surBou[1]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[2].port, roo.surf_surBou[2]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[3].port, roo.surf_surBou[3]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-32.1667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[4].port, roo.surf_surBou[4]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-31.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOthWal[5].port, roo.surf_surBou[5]) annotation (Line(
      points={{140,-50},{96.2,-50},{96.2,-31.5}},
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
The temperature of the floor is fixed at <i>30</i>&deg;C and the temperature of the walls and the ceiling are fixed
at <i>10</i>&deg;C. The supply air temperature is fixed at <i>10</i>&deg;C.
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
Set the simulation stop time of the Modelica model to <code>180</code> seconds and choose, for example, the CVode solver.
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
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-80,-160},{200,120}}, preserveAspectRatio=false),
        graphics));
end MixedConvection;
