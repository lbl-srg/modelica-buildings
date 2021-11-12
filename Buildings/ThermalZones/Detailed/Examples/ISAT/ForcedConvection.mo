within Buildings.ThermalZones.Detailed.Examples.ISAT;
model ForcedConvection
  "Ventilation with forced convection in an empty room"
  extends Modelica.Icons.Example;
  extends Buildings.ThermalZones.Detailed.Examples.ISAT.BaseClasses.PartialRoom(
    roo(
      surBou(
        name={"East Wall","West Wall","North Wall","South Wall","Ceiling",
            "Floor"},
        A={0.9,0.9,1,1,1,1},
        til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
        each absIR=1e-5,
        each absSol=1e-5,
        each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
      nPorts=2,
      portName={"Inlet","Outlet"},
      cfdFilNam=
          "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/ForcedConvection/input.ffd",
      samplePeriod=200,
      linearizeRadiation=true,
      massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
      nSurBou=6);

  Buildings.Fluid.Sources.Boundary_pT bouOut(
    nPorts=1,
    redeclare package Medium = MediumA)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.MassFlowSource_T bounIn(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=0.1,
    T=283.15)
    "Mass flow boundary condition"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  HeatTransfer.Sources.PrescribedTemperature TWalls
    "Temperature for ceiling and walls"
    annotation (Placement(transformation(extent={{120,-20},{100,0}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,293.15; 49,293.15; 50,
        296.15; 99,296.15; 100,298.15; 149,298.15; 150,296.15; 199,296.15; 200,
        295.65; 249,295.65; 250,299.65; 299,299.65; 300,302.15; 349,302.15; 350,
        298.15; 399,298.15; 400,295.65; 449,295.65; 450,293.65; 499,293.65; 500,
        292.65; 549,292.65; 550,294.15; 599,294.15; 600,294.15])
    "Time table for surface temperature"
    annotation (Placement(transformation(extent={{160,-20},{140,0}})));
  HeatTransfer.Sources.PrescribedTemperature TFloor
    "Temperature for floor"
    annotation (Placement(transformation(extent={{120,-56},{100,-36}})));

equation
  connect(bounIn.ports[1], roo.ports[1])
   annotation (Line(
      points={{20,30},{51,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouOut.ports[1], roo.ports[2])
   annotation (Line(
      points={{20,0},{36,0},{36,30},{51,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(timeTable.y,TWalls. T)
   annotation (Line(points={{139,-10},{122,-10}}, color={0,0,127}));
  connect(TWalls.port, roo.surf_surBou[1])
   annotation (Line(points={{100,-10},{62,
          -10},{62,26},{62.2,26}}, color={191,0,0}));
  connect(TWalls.port, roo.surf_surBou[2])
   annotation (Line(points={{100,-10},{62,
          -10},{62,26},{62.2,26}}, color={191,0,0}));
  connect(TWalls.port, roo.surf_surBou[3])
   annotation (Line(points={{100,-10},{62,
          -10},{62,26},{62.2,26}}, color={191,0,0}));
  connect(TWalls.port, roo.surf_surBou[4])
   annotation (Line(points={{100,-10},{62,
          -10},{62,26},{62.2,26}}, color={191,0,0}));
  connect(TWalls.port, roo.surf_surBou[5])
   annotation (Line(points={{100,-10},{62,
          -10},{62,26},{62.2,26}}, color={191,0,0}));
  connect(TFloor.port, roo.surf_surBou[6])
   annotation (Line(points={{100,-46},{62,
          -46},{62,26},{62.2,26}}, color={191,0,0}));
  connect(timeTable.y, TFloor.T)
   annotation (Line(points={{139,-10},{132,-10},{132,
          -46},{122,-46}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,200}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/ForcedConvection.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-06, StopTime=600),
    Documentation(info="<html>
<p>This tutorial gives step by step instructions on building and simulating a forced convection model. The model tests the coupled simulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a> with the ISAT program by simulating ventilation with forced convection in an empty room. </p>
<h4>Case Description</h4>
<p>There are two inputs and two outputs in the ISAT model for this case. The inputs are (1) temperature of the ceiling and walls and (2) temperature of the floor. The outputs are (1) occupant zone temperature and (2) velocity.</p>
<p>The temperature of the floor, ceiling and walls are assigned by two tables with varying values. The supply air temperature is fixed at <i>10</i>&circ;C.</p>
<p>Figure (a) shows the schematic of the FFD simulation and Figure (b) shows the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvection.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. </p>
<ol>
<li>Add the following model components into the <span style=\"font-family: Courier New;\">ForcedConvection</span> model: </li>
<li><ul>
<li><a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>. This model is used to implement data exchange between Modelica and FFD. Name it as <span style=\"font-family: Courier New;\">roo</span>. </li>
<li><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <span style=\"font-family: Courier New;\">weaDat</span>. </li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>. Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero. Name these models as <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span>, respectively. </li>
<li><a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>. This block is used to convert three numbers into a vector. Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>. </li>
<li><a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">Buildings.HeatTransfer.Sources.FixedTemperature</a>. Two models are needed to specify the temperature on the floor and other walls. Name them as <span style=\"font-family: Courier New;\">TFlo</span> and <span style=\"font-family: Courier New;\">TOthWal</span> respectively. Please note that it is necessary to declare <span style=\"font-family: Courier New;\">TOthWal</span> as a vector of <i>5</i> elements. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>. This model provides inlet air for the <span style=\"font-family: Courier New;\">roo</span>. Name it as <span style=\"font-family: Courier New;\">bouIn</span>. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>. This model is the outdoor environment to which the outlet of <span style=\"font-family: Courier New;\">roo</span> is connected. Name it as <span style=\"font-family: Courier New;\">bouOut</span>. </li>
</ul></li>
<li>In the text editor mode, add the medium and the number of surfaces as below: 
<p><span style=\"font-family: Courier New;\">package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated (T_default=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExtWin=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConBou=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nSurBou=6;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExt=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConPar=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nSou=0;</span></p>
</li>
<li>Edit <span style=\"font-family: Courier New;\">roo</span> as below: 
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.CFD roo(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">surBou(</span></p>
<p><span style=\"font-family: Courier New;\">name={&quot;East Wall&quot;,&quot;West Wall&quot;,&quot;North Wall&quot;,&quot;South Wall&quot;,&quot;Ceiling&quot;,&quot;Floor&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">A={0.9,0.9,1,1,1,1},</span></p>
<p><span style=\"font-family: Courier New;\">til={Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Ceiling,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Floor},</span></p>
<p><span style=\"font-family: Courier New;\">each absIR=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">each absSol=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),</span></p>
<p><span style=\"font-family: Courier New;\">lat = 0.012787839282646,</span></p>
<p><span style=\"font-family: Courier New;\">AFlo = 1*1,</span></p>
<p><span style=\"font-family: Courier New;\">hRoo = 1,</span></p>
<p><span style=\"font-family: Courier New;\">linearizeRadiation = false,</span></p>
<p><span style=\"font-family: Courier New;\">useCFD = true,</span></p>
<p><span style=\"font-family: Courier New;\">sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/ForcedConvection.ffd&quot;,</span></p>
<p><span style=\"font-family: Courier New;\">nConExt = nConExt,</span></p>
<p><span style=\"font-family: Courier New;\">nConExtWin = nConExtWin,</span></p>
<p><span style=\"font-family: Courier New;\">nConPar = nConPar,</span></p>
<p><span style=\"font-family: Courier New;\">nConBou = nConBou,</span></p>
<p><span style=\"font-family: Courier New;\">nSurBou = nSurBou,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts = 2,</span></p>
<p><span style=\"font-family: Courier New;\">portName={&quot;Inlet&quot;,&quot;Outlet&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">samplePeriod = 200);</span></p>
</li> 
<li>Set the parameters for the following components: </li>
<li><ul>
<li>Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>. </li>
<li>Set <span style=\"font-family: Courier New;\">TFlo</span> to <i>303.15</i> Kelvin. </li>
<li>Set <span style=\"font-family: Courier New;\">TOthWal</span> to <i>283.15</i> Kelvin. </li>
</ul></li>
<li>Set the values for the parameters of <span style=\"font-family: Courier New;\">bouIn</span> and <span style=\"font-family: Courier New;\">bouOut</span> as below:
<p><span style=\"font-family: Courier New;\">Fluid.Sources.MassFlowSource_T bouIn(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1,</span></p>
<p><span style=\"font-family: Courier New;\">m_flow=0.1,</span></p>
<p><span style=\"font-family: Courier New;\">T=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">Fluid.Sources.FixedBoundary bouOut(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1);</span></p>
</li>
<li>Connect the components as shown in the figure below.
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/ForcedConvectionModel.png\" alt=\"image\"/> </p>
</li>
<li>Confirm in the textual editor that the connections to <span style=\"font-family: Courier New;\">roo.ports</span> are as follows:
<p><span style=\"font-family: Courier New;\">connect(bouIn.ports[1], roo.ports[1]);</span></p>
<p><span style=\"font-family: Courier New;\">connect(bouOut.ports[1], roo.ports[2]);</span></p>
</li>
<li>Define the settings for the ISAT model:
<p><span style=\"font-family: Courier New;\">In the set.isat file, the parameters for the ISAT model can be defined:</span></p>
<p>/********************************************************************************</p>
<p>| Section 1: General settings of isat</p>
<p>********************************************************************************/</p>
<p>isat.useISAT 1 /*If use ISAT*/</p>
<p>isat.useBinarySelectedPoint 0 /*If use binary pre-training*/</p>
<p>isat.digAftdec 1 /*Digitals after decimal*/</p>
<p>isat.read_existing 1 /*1: read existing database; 0: train from scratch*/</p>
<p>isat.write_existing 1 /*1: write ffd results to database; 0: do not write*/</p>
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
<p>/* inpu.wall_re: temperature or heat flux of walls will be overwritten or not */</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>inpu.wall_re 1</p>
<p>/* inpu.wall_wh: temperature or heat flux of walls will be assigned by which isat input */</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 1</p>
<p>inpu.wall_wh 2</p>
<p>/********************************************************************************</p>
<p>| Section 3: Output settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/* outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen, temp_rack */</p>
<p>outp.outp_name temp_occ</p>
<p>outp.outp_name vel_sen</p>
<p>/* outp.outp_weight: weights for error control, when outputs have different order of magnitudes */</p>
<p>outp.outp_weight 0.1</p>
<p>outp.outp_weight 1.0</p>
</li>
<li>Use the Simplified CFD Interface (SCI) to generate the input file for the FFD. </li>
<li><ul>
<li>Define the grid. </li>
<li>Set the time step size of the FFD to <i>0.1</i> seconds. </li>
<li>Generate the input files, which have by default the names <span style=\"font-family: Courier New;\">input.cfd</span> (mesh file) and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file). </li>
<li>Rename the files as <span style=\"font-family: Courier New;\">ForcedConvection.cfd</span> and <span style=\"font-family: Courier New;\">ForcedConvection.dat</span>, respectively. </li>
</ul></li>
<li>Revise the FFD parameter input file <span style=\"font-family: Courier New;\">ForcedConvection.ffd</span> (an example file is available in <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/Tutorial/</span>):
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_format SCI</span></p>
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_name input.cfd</span></p>
<p><span style=\"font-family: Courier New;\">inpu.block_file_name zeroone.dat</span></p>
<p><span style=\"font-family: Courier New;\">outp.result_file NO //PLT, VTK, NO</span></p>
<p><span style=\"font-family: Courier New;\">prob.nu 0.000015 // Kinematic viscosity</span></p>
<p><span style=\"font-family: Courier New;\">prob.rho 1.205 // Density</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravx 0 // Gravity in x direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravy 0 // Gravity in y direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravz -9.81 // Gravity in z direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.cond 0.0257 // Conductivity</span></p>
<p><span style=\"font-family: Courier New;\">prob.Cp 1006.0 // Specific heat capacity</span></p>
<p><span style=\"font-family: Courier New;\">prob.beta 0.00343 // Thermal expansion coefficient</span></p>
<p><span style=\"font-family: Courier New;\">prob.diff 0.00001 // Diffusivity for contaminants</span></p>
<p><span style=\"font-family: Courier New;\">prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall</span></p>
<p><span style=\"font-family: Courier New;\">prob.Temp_Buoyancy 10.0 // Reference temperature for calculating buoyance force</span></p>
<p><span style=\"font-family: Courier New;\">bc.outlet_bc ZERO_GRADIENT // ZERO_GRADIENT, PRESCRIBED_VALUE</span></p>
<p><span style=\"font-family: Courier New;\">init.T 10.0 // Initial condition for Temperature</span></p>
<p><span style=\"font-family: Courier New;\">init.u 0.0 // Initial condition for velocity u</span></p>
<p><span style=\"font-family: Courier New;\">init.v 0.0 // Initial condition for velocity v</span></p>
<p><span style=\"font-family: Courier New;\">init.w 0.0 // Initial condition for velocity w</span></p>
</li>
<li>Put the files <span style=\"font-family: Courier New;\">input.isat</span>, <span style=\"font-family: Courier New;\">output.isat</span>, <span style=\"font-family: Courier New;\">set.isat</span>, <span style=\"font-family: Courier New;\">input.ffd</span>, <span style=\"font-family: Courier New;\">input.dat</span>, and <span style=\"font-family: Courier New;\">input.cfd</span> in the directory <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/ForcedConvection/</span>. </li>
<li>Set the simulation stop time of the Modelica model to <span style=\"font-family: Courier New;\">180</span> seconds and choose, for example, the Radau solver. </li>
<li>Translate the model and start the simulation. </li>
<li>Post-process: the generation of FFD output file (plt or vtk) is blocked by default, the users should revise the codes to output. </li>
</ol>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ForcedConvection;
