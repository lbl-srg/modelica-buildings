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
<p>This tutorial gives step by step instructions on building and simulating a mixed convection model. The model tests the coupled simulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a> with the ISAT program by simulating ventilation with mixed convection in an empty room. </p>
<h4>Case Description</h4>
<p>There are four inputs and two outputs in the ISAT model for this case. The inputs are (1) supply air temperature, (2) supply air flow rate, (3) temperature of the ceiling and walls and (4) temperature of the floor. The outputs are (1) average room temperature and (2) velocity.</p>
<p><br>Figure (a) shows the schematic of the FFD simulation and Figure (b) shows the velocity vectors and temperatures on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. </p>
<ol>
<li>Add the following model components into the <span style=\"font-family: Courier New;\">MixedConvection</span> model: </li>
<li><ul>
<li><a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>. This model is used to implement data exchange between Modelica and ISAT. Name it as <span style=\"font-family: Courier New;\">roo</span>. </li>
<li><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <span style=\"font-family: Courier New;\">weaDat</span>. </li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>. Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero. Name these models as <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span>, respectively. </li>
<li><a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>. This block is used to convert three numbers into a vector. Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>. </li>
<li><a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">Buildings.HeatTransfer.Sources.FixedTemperature</a>. Two models are needed to specify the temperature on the floor and other walls. Name them as <span style=\"font-family: Courier New;\">TFlo</span> and <span style=\"font-family: Courier New;\">TOthWal</span> respectively. Please note that it is necessary to declare <span style=\"font-family: Courier New;\">TOthWal</span> as a vector of <i>5</i> elements. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>. This model provides inlet air for the <span style=\"font-family: Courier New;\">roo</span>. Name it as <span style=\"font-family: Courier New;\">bouIn</span>. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>. This model is the outdoor environment to which the outlet of <span style=\"font-family: Courier New;\">roo</span> is connected. Name it as <span style=\"font-family: Courier New;\">bouOut</span>. </li>
</ul></li>
<li>In the text editor mode, add the medium and the number of surfaces as below: </li>
<p><span style=\"font-family: Courier New;\">package MediumA = Buildings.Media.Air (T_default=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExtWin=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConBou=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nSurBou=6;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExt=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConPar=0;</span></p>
<li>Edit <span style=\"font-family: Courier New;\">roo</span> as below: </li>
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
<p><span style=\"font-family: Courier New;\">haveSource=false,</span></p>
<p><span style=\"font-family: Courier New;\">nSou=0,</span></p>
<p><span style=\"font-family: Courier New;\">sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/input.ffd&quot;,</span></p>
<p><span style=\"font-family: Courier New;\">nConExt = nConExt,</span></p>
<p><span style=\"font-family: Courier New;\">nConExtWin = nConExtWin,</span></p>
<p><span style=\"font-family: Courier New;\">nConPar = nConPar,</span></p>
<p><span style=\"font-family: Courier New;\">nConBou = nConBou,</span></p>
<p><span style=\"font-family: Courier New;\">nSurBou = nSurBou,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts = 2,</span></p>
<p><span style=\"font-family: Courier New;\">portName={&quot;Inlet&quot;,&quot;Outlet&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">samplePeriod = 200);</span></p>
<li>Set the parameters for the following components: </li>
<li><ul>
<li>Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>. </li>
<li>Set <span style=\"font-family: Courier New;\">TFlo</span> to <i>303.15</i> Kelvin. </li>
<li>Set <span style=\"font-family: Courier New;\">TOthWal</span> to <i>283.15</i> Kelvin. </li>
</ul></li>
<li>Set the values for the parameters of <span style=\"font-family: Courier New;\">bouIn</span> and <span style=\"font-family: Courier New;\">bouOut</span> as below: </li>
<p><span style=\"font-family: Courier New;\">Fluid.Sources.MassFlowSource_T bouIn(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1,</span></p>
<p><span style=\"font-family: Courier New;\">m_flow=0.1,</span></p>
<p><span style=\"font-family: Courier New;\">T=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">Fluid.Sources.FixedBoundary bouOut(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1);</span></p>
<li>Connect the components as shown in the figure below. </li>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionModel.png\" alt=\"image\"/> </p>
<li>Confirm in the textual editor that the connections to <span style=\"font-family: Courier New;\">roo.ports</span> are as follows: </li>
<p><span style=\"font-family: Courier New;\">connect(bouIn.ports[1], roo.ports[1]);</span></p>
<p><span style=\"font-family: Courier New;\">connect(bouOut.ports[1], roo.ports[2]);</span></p>
<li>Define the settings for the ISAT model: </li>
<p><span style=\"font-family: Courier New;\">In the set.isat file, the parameters for the ISAT model can be defined:</span></p>
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
<p>/* outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen, temp_rack */</p>
<p>outp.outp_name temp_roo</p>
<p>outp.outp_name vel_sen</p>
<p>/* outp.outp_weight: weights for error control, when outputs have different order of magnitudes */</p>
<p>outp.outp_weight 1.0</p>
<p>outp.outp_weight 10.0</p>
<li>Use the Simplified CFD Interface (SCI) to generate the input file for the FFD. </li>
<li><ul>
<li>Use a 20 X 20 X 20 stretched grid. </li>
<li>Set the time step size of the FFD to <i>0.1</i> seconds. </li>
<li>Generate the input files, which have by default the names <span style=\"font-family: Courier New;\">input.cfd</span> (mesh file) and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file). </li>
<li>Rename the files as Mixed<span style=\"font-family: Courier New;\">Convection.cfd</span> and Mixed<span style=\"font-family: Courier New;\">Convection.dat</span>, respectively. </li>
</ul></li>
<li>Revise the FFD parameter input file <span style=\"font-family: Courier New;\">MixedConvection.ffd</span> (an example file is available in <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/</span>): </li>
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_format SCI</span></p>
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_name MixedConvection.cfd</span></p>
<p><span style=\"font-family: Courier New;\">inpu.block_file_name MixedConvection.dat</span></p>
<p><span style=\"font-family: Courier New;\">outp.result_file NO //PLT, VTK, NO</span></p>
<p><span style=\"font-family: Courier New;\">prob.nu 0.000015 // Kinematic viscosity</span></p>
<p><span style=\"font-family: Courier New;\">prob.rho 1.20 // Density</span></p>
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
<li>Put the files <span style=\"font-family: Courier New;\">input.isat</span>, <span style=\"font-family: Courier New;\">output.isat</span>, <span style=\"font-family: Courier New;\">set.isat</span>, <span style=\"font-family: Courier New;\">input.ffd</span>, <span style=\"font-family: Courier New;\">input.dat</span>, and <span style=\"font-family: Courier New;\">input.cfd</span> in the directory <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvection/</span>. </li>
<li>Set the simulation stop time of the Modelica model to <span style=\"font-family: Courier New;\">180</span> seconds and choose, for example, the Radau solver. </li>
<li>Translate the model and start the simulation. </li>
<li>Post-process: the generation of FFD output file (plt or vtk) is blocked by default, the users should revise the codes to output. </li>
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
<p>This tutorial gives step by step instructions on building and simulating a mixed convection model. The model tests the coupled simulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a> with the ISAT program by simulating ventilation with mixed convection in a room with a box. </p>
<h4>Case Description</h4>
<p>There are five inputs and two outputs in the ISAT model for this case. The inputs are (1) supply air temperature, (2) supply air flow rate, (3) temperature of the box, (4) temperature of the ceiling and walls and (5) temperature of the floor. The outputs are (1) average room temperature and (2) velocity.</p>
<p><br>Figure (a) shows the schematic of the FFD simulation. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. </p>
<ol>
<li>Add the following model components into the <span style=\"font-family: Courier New;\">MixedConvectionWithBox</span> model: </li>
<li><ul>
<li><a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>. This model is used to implement data exchange between Modelica and ISAT. Name it as <span style=\"font-family: Courier New;\">roo</span>. </li>
<li><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <span style=\"font-family: Courier New;\">weaDat</span>. </li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>. Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain are zero. Name these models as <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span>, respectively. </li>
<li><a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>. This block is used to convert three numbers into a vector. Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>. </li>
<li><a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">Buildings.HeatTransfer.Sources.FixedTemperature</a>. Two models are needed to specify the temperature on the floor and other walls. Name them as <span style=\"font-family: Courier New;\">TFlo</span> and <span style=\"font-family: Courier New;\">TOthWal</span> respectively. Please note that it is necessary to declare <span style=\"font-family: Courier New;\">TOthWal</span> as a vector of <i>5</i> elements. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">Buildings.Fluid.Sources.MassFlowSource_T</a>. This model provides inlet air for the <span style=\"font-family: Courier New;\">roo</span>. Name it as <span style=\"font-family: Courier New;\">bouIn</span>. </li>
<li><a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>. This model is the outdoor environment to which the outlet of <span style=\"font-family: Courier New;\">roo</span> is connected. Name it as <span style=\"font-family: Courier New;\">bouOut</span>. </li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Step\">Modelica.Blocks.Sources.Step</a>. This is a step function that generates the heat source. Name it as <span style=\"font-family: Courier New;\">step</span>. </li>
</ul></li>
<li>In the text editor mode, add the medium and the number of surfaces as below: </li>
<p><span style=\"font-family: Courier New;\">package MediumA = Buildings.Media.Air (T_default=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExtWin=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConBou=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nSurBou=6;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExt=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConPar=0;</span></p>
<li>Edit <span style=\"font-family: Courier New;\">roo</span> as below: </li>
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
<p><span style=\"font-family: Courier New;\">haveSource=true,</span></p>
<p><span style=\"font-family: Courier New;\">nSou=1,</span></p>
<p><span style=\"font-family: Courier New;\">sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBox.ffd&quot;,</span></p>
<p><span style=\"font-family: Courier New;\">nConExt = nConExt,</span></p>
<p><span style=\"font-family: Courier New;\">nConExtWin = nConExtWin,</span></p>
<p><span style=\"font-family: Courier New;\">nConPar = nConPar,</span></p>
<p><span style=\"font-family: Courier New;\">nConBou = nConBou,</span></p>
<p><span style=\"font-family: Courier New;\">nSurBou = nSurBou,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts = 2,</span></p>
<p><span style=\"font-family: Courier New;\">portName={&quot;Inlet&quot;,&quot;Outlet&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">samplePeriod = 200);</span></p>
<li>Set the parameters for the following components: </li>
<li><ul>
<li>Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>. </li>
<li>Set <span style=\"font-family: Courier New;\">TFlo</span> to <i>303.15</i> Kelvin. </li>
<li>Set <span style=\"font-family: Courier New;\">TOthWal</span> to <i>283.15</i> Kelvin. </li>
</ul></li>
<li>Set the values for the parameters of <span style=\"font-family: Courier New;\">bouIn</span> and <span style=\"font-family: Courier New;\">bouOut</span> as below: </li>
<p><span style=\"font-family: Courier New;\">Fluid.Sources.MassFlowSource_T bouIn(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1,</span></p>
<p><span style=\"font-family: Courier New;\">m_flow=0.1,</span></p>
<p><span style=\"font-family: Courier New;\">T=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">Fluid.Sources.FixedBoundary bouOut(</span></p>
<p><span style=\"font-family: Courier New;\">redeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">nPorts=1);</span></p>
<li>Connect the components as shown in the figure below. </li>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBoxModel.png\" alt=\"image\"/> </p>
<li>Confirm in the textual editor that the connections to <span style=\"font-family: Courier New;\">roo.ports</span> are as follows: </li>
<p><span style=\"font-family: Courier New;\">connect(bouIn.ports[1], roo.ports[1]);</span></p>
<p><span style=\"font-family: Courier New;\">connect(bouOut.ports[1], roo.ports[2]);</span></p>
<li>Define the settings for the ISAT model: </li>
<p><span style=\"font-family: Courier New;\">In the set.isat file, the parameters for the ISAT model can be defined:</span></p>
<p>/********************************************************************************</p>
<p>| Section 1: General settings of isat</p>
<p>********************************************************************************/</p>
<p>isat.useISAT 1 /*If use ISAT*/</p>
<p>isat.useBinarySelectedPoint 0 /*If use binary pre-training*/</p>
<p>isat.digAftdec 2 /*Digitals after decimal*/</p>
<p>isat.read_existing 0 /*1: read existing database; 0: train from scratch*/</p>
<p>isat.write_existing 0 /*1: write ffd results to database; 0: do not write*/</p>
<p>isat.err_global 0.2 /* user-defined global error tolerance */</p>
<p>isat.num_input 5 /* number of isat inputs */</p>
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
<p>inpu.inpu_name block_temp</p>
<p>inpu.inpu_name sur_temp</p>
<p>inpu.inpu_name sur_temp</p>
<p>/* number of inlets, blocks and walls */</p>
<p>inpu.num_inlet 1</p>
<p>inpu.num_block 1</p>
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
<p>/*inpu.block_re: temperature or heat flux of blocks will be overwritten or not*/</p>
<p>inpu.block_re 1</p>
<p>/*inpu.block_wh: temperature or heat flux of blocks will be assigned by which isat input*/</p>
<p>inpu.block_wh 3</p>
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
<p>inpu.wall_wh 4</p>
<p>inpu.wall_wh 4</p>
<p>inpu.wall_wh 4</p>
<p>inpu.wall_wh 4</p>
<p>inpu.wall_wh 4</p>
<p>inpu.wall_wh 5</p>
<p>/********************************************************************************</p>
<p>| Section 3: Output settings of isat and ffd</p>
<p>********************************************************************************/</p>
<p>/* outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen, temp_rack */</p>
<p>outp.outp_name temp_roo</p>
<p>outp.outp_name vel_sen</p>
<p>/* outp.outp_weight: weights for error control, when outputs have different order of magnitudes */</p>
<p>outp.outp_weight 1.0</p>
<p>outp.outp_weight 10.0</p>
<li>Use the Simplified CFD Interface (SCI) to generate the input file for the FFD. </li>
<li><ul>
<li>Use a 20 X 20 X 20 stretched grid. </li>
<li>Set the time step size of the FFD to <i>0.1</i> seconds. </li>
<li>Generate the input files, which have by default the names <span style=\"font-family: Courier New;\">input.cfd</span> (mesh file) and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file). </li>
<li>Rename the files as <span style=\"font-family: Courier New;\">MixedConvectionWithBox.cfd</span> and <span style=\"font-family: Courier New;\">MixedConvectionWithBox.dat</span>, respectively. </li>
</ul></li>
<li>Revise the FFD parameter input file <span style=\"font-family: Courier New;\">MixedConvectionWithBox.ffd</span> (an example file is available in <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBox/</span>): </li>
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
<li>Put the files <span style=\"font-family: Courier New;\">input.isat</span>, <span style=\"font-family: Courier New;\">output.isat</span>, <span style=\"font-family: Courier New;\">set.isat</span>, <span style=\"font-family: Courier New;\">input.ffd</span>, <span style=\"font-family: Courier New;\">input.dat</span>, and <span style=\"font-family: Courier New;\">input.cfd</span> in the directory <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/MixedConvectionWithBox/</span>. </li>
<li>Set the simulation stop time of the Modelica model to <span style=\"font-family: Courier New;\">180</span> seconds and choose, for example, the Radau solver. </li>
<li>Translate the model and start the simulation. </li>
<li>Post-process: the generation of FFD output file (plt or vtk) is blocked by default, the users should revise the codes to output. </li>
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
<p>This tutorial gives step by step instructions for building and simulating a natural convection model. The model tests the coupled simulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a> with the ISAT program by simulating the natural convection in an empty room with only surface boundary conditions. </p>
<h4>Case Description</h4>
<p>The Rayleigh number is a dimensionless number associated with natural convection, defined as </p>
<p align=\"center\"><i>R<sub>a</sub> = g &beta; (T<sub>w</sub>-T<sub>e</sub>)L<sup>3</sup> &frasl; (&nu; &alpha;) </i></p>
<p>To get a Rayleigh number of <i>1E5</i>, the flow properties are manually set as acceleration due to gravity <i>g<sub>z</sub>=-0.01</i> m/s<sup>2</sup>, thermal expansion coefficient <i>&beta;=3e-3</i> K<sup>-1</sup>, kinematic viscosity <i>&nu;=1.5e-5</i> m<sup>2</sup>/s, thermal diffusivity <i>&alpha;=2e-5</i> m<sup>2</sup>/s, and characteristic length <i>L=1</i> m. </p>
<p>There are two inputs and two outputs in the ISAT model for this case. The inputs are (1) temperature of the west wall and (2) temperature of the east wall. The outputs are (1) average room temperature and (2) velocity.</p>
<p>Figure (a) shows the schematic of the FFD simulation. The following conditions are applied in Modelica.: </p>
<ul>
<li>East wall: Fixed temperature at <i>T<sub>e</sub>=0</i>&circ;C, </li>
<li>West wall: Fixed temperature at <i>T<sub>w</sub>=1</i>&circ;C, </li>
<li>North &amp; South wall, Ceiling, Floor: Fixed heat flux at <i>0</i> W/m<sup>2</sup>. </li>
</ul>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p>Figure (b) shows the velocity vectors and temperature contour in degree Celsius on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<p>More details of the case description can be found in <a href=\"#ZuoEtAl2012\">Zuo et al. (2012)</a>. </p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. </p>
<ol>
<li>Add the following component models to the <span style=\"font-family: Courier New;\">NaturalConvection</span> model: </li>
<li><ul>
<li><a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.ISAT</a>. This model is used to implement the data exchange between Modelica and ISAT. Name it as <span style=\"font-family: Courier New;\">roo</span>. </li>
<li><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>. Use weather data from OHare Intl. Airport, Chicago, Illinoi, U.S.A. Name it as <span style=\"font-family: Courier New;\">weaDat</span>. </li>
<li><a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>. Three models are needed to specify that internal radiation, internal convective heat gain and internal latent heat gain zero. Name these models as <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span>, respectively. </li>
<li><a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Modelica.Blocks.Routing.Multiplex3</a>. This block is used to combine three scalar signals to a vector. Name it as <span style=\"font-family: Courier New;\">multiple_x3</span>. </li>
<li><a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">Buildings.HeatTransfer.Sources.FixedTemperature</a>. Two models are needed to specify the temperatures on the east and west walls. Name them as <span style=\"font-family: Courier New;\">TeasWal</span> and <span style=\"font-family: Courier New;\">TwesWal</span>, respectively. </li>
</ul></li>
</ul>
<p><br>Note that for the other four walls with adiabatic boundary conditions, we do not need to specify a zero heat flow boundary condition because the heat flow rate transferred through a heat port from the outside is zero if the heat port is not connected from the outside. </p>

<li>In the textual editor mode, add the medium and the number of surfaces as shown below: </li>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.CFD roo(</span></p>
<p><span style=\"font-family: Courier New;\">package MediumA = Buildings.Media.Air (T_default=283.15);</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExtWin=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConBou=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nSurBou=6;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConExt=0;</span></p>
<p><span style=\"font-family: Courier New;\">parameter Integer nConPar=0;</span> </p>
<li>Edit <span style=\"font-family: Courier New;\">roo</span> as below: </li>
<p><span style=\"font-family: Courier New;\">edeclare package Medium = MediumA,</span></p>
<p><span style=\"font-family: Courier New;\">surBou(</span></p>
<p><span style=\"font-family: Courier New;\">name={&quot;East Wall&quot;,&quot;West Wall&quot;,&quot;North Wall&quot;,&quot;South Wall&quot;,&quot;Ceiling&quot;,&quot;Floor&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">each A=1*1,</span></p>
<p><span style=\"font-family: Courier New;\">til={Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Ceiling,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.Types.Tilt.Floor},</span></p>
<p><span style=\"font-family: Courier New;\">each absIR=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">each absSol=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">boundaryCondition={</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,</span></p>
<p><span style=\"font-family: Courier New;\">Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate}),</span></p>
<p><span style=\"font-family: Courier New;\">lat = 0.012787839282646,</span></p>
<p><span style=\"font-family: Courier New;\">AFlo = 1*1,</span></p>
<p><span style=\"font-family: Courier New;\">hRoo = 1,</span></p>
<p><span style=\"font-family: Courier New;\">linearizeRadiation = false,</span></p>
<p><span style=\"font-family: Courier New;\">useCFD = true,</span></p>
<p><span style=\"font-family: Courier New;\">haveSource=false,</span></p>
<p><span style=\"font-family: Courier New;\">nSou=0,</span></p>
<p><span style=\"font-family: Courier New;\">sensorName = {&quot;Occupied zone air temperature&quot;, &quot;Velocity&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">cfdFilNam = &quot;modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvection/input.ffd&quot;,</span></p>
<p><span style=\"font-family: Courier New;\">nConExt = nConExt,</span></p>
<p><span style=\"font-family: Courier New;\">nConExtWin = nConExtWin,</span></p>
<p><span style=\"font-family: Courier New;\">nConPar = nConPar,</span></p>
<p><span style=\"font-family: Courier New;\">nConBou = nConBou,</span></p>
<p><span style=\"font-family: Courier New;\">nSurBou = nSurBou,</span></p>
<p><span style=\"font-family: Courier New;\">T_start=273.15,</span></p>
<p><span style=\"font-family: Courier New;\">samplePeriod = 7200,</span></p>
<p><span style=\"font-family: Courier New;\">massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);</span></p>
<li>Connect the component as shown in the figure below. </li>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/Tutorial/NaturalConvectionModel.png\" alt=\"image\"/> </p>
<li>Set the values for the following components: </li>
<li><ul>
<li>Set <span style=\"font-family: Courier New;\">qRadGai_flow</span>, <span style=\"font-family: Courier New;\">qConGai_flow</span> and <span style=\"font-family: Courier New;\">qLatGai_flow</span> to <i>0</i>. </li>
<li>Set <span style=\"font-family: Courier New;\">TEasWal</span> to <i>273.15</i> Kelvin. </li>
<li>Set <span style=\"font-family: Courier New;\">TWesWal</span> to <i>274.15</i> Kelvin. </li>
</ul></li>
<li>Define the settings for the ISAT model: </li>
<p><span style=\"font-family: Courier New;\">In the set.isat file, the parameters for the ISAT model can be defined:</span></p>
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
<li>Use the Simplified CFD Interface (SCI) to generate the input file for FFD. </li>
<li><ul>
<li>Use a 20 x 20 x 20 uniform grid. </li>
<li>Set the time step size of the FFD to <i>10</i> seconds. </li>
<li>Generate the input files which have the default names <span style=\"font-family: Courier New;\">input.cfd</span> (mesh file) and <span style=\"font-family: Courier New;\">zeroone.dat</span> (obstacles file). </li>
<li>Rename the files as <span style=\"font-family: Courier New;\">NaturalConvection.cfd</span> and <span style=\"font-family: Courier New;\">NaturalConvection.dat</span>, respectively. </li>
</ul></li>
<li>Revise the FFD parameter input file <span style=\"font-family: Courier New;\">NaturalConvection.ffd</span> (an example file is provided in <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial/</span>): </li>
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_format SCI</span></p>
<p><span style=\"font-family: Courier New;\">inpu.parameter_file_name NaturalConvection.cfd</span></p>
<p><span style=\"font-family: Courier New;\">inpu.block_file_name NaturalConvection.dat</span></p>
<p><span style=\"font-family: Courier New;\">prob.nu 1.5e-5 // Kinematic viscosity</span></p>
<p><span style=\"font-family: Courier New;\">prob.rho 1 // Density</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravx 0 // Gravity in x direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravy 0 // Gravity in y direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.gravz -0.01 // Gravity in z direction</span></p>
<p><span style=\"font-family: Courier New;\">prob.cond 0.02 // Conductivity</span></p>
<p><span style=\"font-family: Courier New;\">prob.Cp 1000.0 // Specific heat capacity</span></p>
<p><span style=\"font-family: Courier New;\">prob.beta 3e-3 // Thermal expansion coefficient</span></p>
<p><span style=\"font-family: Courier New;\">prob.diff 0.00001 // Diffusivity for contaminants</span></p>
<p><span style=\"font-family: Courier New;\">prob.alpha 2e-5 // Thermal diffusivity</span></p>
<p><span style=\"font-family: Courier New;\">prob.coeff_h 0.0004 // Convective heat transfer coefficient near the wall</span></p>
<p><span style=\"font-family: Courier New;\">prob.Temp_Buoyancy 0.0 // Reference temperature for calculating buoyance force</span></p>
<p><span style=\"font-family: Courier New;\">init.T 0.0 // Initial condition for Temperature</span></p>
<p><span style=\"font-family: Courier New;\">init.u 0.0 // Initial condition for velocity u</span></p>
<p><span style=\"font-family: Courier New;\">init.v 0.0 // Initial condition for velocity v</span></p>
<p><span style=\"font-family: Courier New;\">init.w 0.0 // Initial condition for velocity w</span></p>
<p>Please note that some of the physical properties were manipulated to obtain the desired Rayleigh Number of <i>10<sup>5</i></sup>. </p>
<li>Store <span style=\"font-family: Courier New;\">NaturalConvection.ffd</span>, <span style=\"font-family: Courier New;\">NaturalConvection.dat</span>, and <span style=\"font-family: Courier New;\">NaturalConvection.cfd</span> at <span style=\"font-family: Courier New;\">Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/Tutorial</span>. </li>
<li>Set simulation the stop time of the Modelica model <span style=\"font-family: Courier New;\">7200</span> seconds and choose for example the Radau solver. </li>
<li>Translate the model and start the simulation. </li>
<li>Post-process: click the Tecplot macro script <span style=\"font-family: Courier New;\">Buildings/Resources/Image/Rooms/Examples/ISAT/Tutorial/NaturalConvection.mcr</span> that will generate the temperature contour and velocity vectors shown in the Figure (b). Note: Tecplot is needed for this. </li>
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
