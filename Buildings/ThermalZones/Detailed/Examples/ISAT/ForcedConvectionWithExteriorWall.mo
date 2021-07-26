within Buildings.ThermalZones.Detailed.Examples.ISAT;
model ForcedConvectionWithExteriorWall
  "Ventilation with forced convection in an empty room"
  extends Modelica.Icons.Example;
  extends Buildings.ThermalZones.Detailed.Examples.ISAT.BaseClasses.PartialRoom(
    roo(
      surBou(
        name={"West Wall","North Wall","South Wall","Ceiling",
            "Floor"},
        A={0.9,1,1,1,1},
        til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},
        each absIR=1e-5,
        each absSol=1e-5,
        each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),
      datConExt(
        name={"East Wall"},
        A={0.9},
        layers={matLayExt},
        til={
            Buildings.Types.Tilt.Wall},
        boundaryCondition={Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature}),
      nPorts=2,
      portName={"Inlet","Outlet"},
      sensorName = {"Occupied zone air temperature","Velocity","East wall heat flux"},
      cfdFilNam=
          "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/ForcedConvectionWithExteriorWall/input.ffd",
      samplePeriod=200,
      linearizeRadiation=true,
      massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
      nConExt=1,
      nSurBou=5);

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

  HeatTransfer.Sources.FixedTemperature TWal[nSurBou-1](each T=283.15)
    "Temperature of other walls"
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,10})));
  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
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
  for i in 1:(nSurBou-1) loop
    connect(TWal[i].port, roo.surf_surBou[i])    annotation (Line(
      points={{100,10},{62.2,10},{62.2,26}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,200}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/ForcedConvectionWithExteriorWall.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-06, StopTime=600),
    Documentation(info="<html>
<h4>Case Description</h4>
<p>There are two inputs and three outputs in the ISAT model for this case. The inputs are (1) temperature of the exterior (east) wall and (2) temperature of the remaining walls. The outputs are (1) occupant zone temperature, (2) velocity sensor and (3) heat flux through east wall.</p>
<p>The temperature of the east wall is calculated based on the weather data, indoor environment and thermal properties of the wall materials. The remaining walls have a fixed temperature of <i>10</i>&circ;C. The supply air temperature is fixed at <i>10</i>&circ;C.</p>
<p>Figure (a) shows the schematic of the FFD simulation. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Tutorial/MixedConvectionSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<h4>Model Information</h4>
<p>The exterior wall is defined by editing <span style=\"font-family: Courier New;\">roo</span> in the Modelica model text editor to include the code shown below.</p>
<p><span style=\"font-family: Courier New;\">datConExt(</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;name={&quot;East&nbsp;Wall&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A={0.9},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;layers={matLayExt},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;til={Buildings.Types.Tilt.Wall},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;boundaryCondition={Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature}),</span></p>
<p><br>The other walls are defined as regular surface boundaries in the roo model as shown below.</p>
<p><span style=\"font-family: Courier New;\">surBou(</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;name={&quot;West&nbsp;Wall&quot;,&quot;North&nbsp;Wall&quot;,&quot;South&nbsp;Wall&quot;,&quot;Ceiling&quot;,</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;Floor&quot;},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A={0.9,1,1,1,1},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Floor},</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">each&nbsp;</span>absIR=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">each&nbsp;</span>absSol=1e-5,</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">each&nbsp;</span>boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature),</span></p>
<p>The heat flux through the east wall is defined as an ISAT output in Section 3 of the set.isat file located in the directory Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/ForcedConvectionWithExteriorWall/. </p>
<p><span style=\"font-family: Courier New;\">/********************************************************************************</span></p>
<p><span style=\"font-family: Courier New;\">| Section 3: Output settings of isat and ffd</span></p>
<p><span style=\"font-family: Courier New;\">********************************************************************************/</span></p>
<p><span style=\"font-family: Courier New;\">/*outp.outp_name: names of outputs including temp_occ, vel_occ, temp_sen, vel_sen, temp_rack, heat_wall1, heat_wall2, heat_wall3, heat_wall4, heat_wall5, heat_wall6*/</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_name temp_occ</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_name vel_sen</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_name heat_wall1</span></p>
<p><span style=\"font-family: Courier New;\">/*outp.outp_weight: weights for error control, when outputs have different order of magnitudes*/</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_weight 1.0</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_weight 0.1</span></p>
<p><span style=\"font-family: Courier New;\">outp.outp_weight 1.0</span></p>
<p><span style=\"font-family: Courier New;\">/*outp.wall_heat_re: heat flux of walls will be returned or not*/</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 1</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 0</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 0</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 0</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 0</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_re 0</span></p>
<p><span style=\"font-family: Courier New;\">/*outp.wall_heat_wh: heat flux of walls will be assigned by which isat output*/</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 3</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 1</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 1</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 1</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 1</span></p>
<p><span style=\"font-family: Courier New;\">outp.wall_heat_wh 1</span></p>
<p>The third output, <span style=\"font-family: Courier New;\">heat_wall1</span>, corresponds to the heat flux through the east wall. The walls are ordered as:</p>
<ol>
<li>East wall</li>
<li>West wall</li>
<li>North wall</li>
<li>South wall</li>
<li>Ceiling</li>
<li>Floor.</li>
</ol>
<p><br>Note that the heat flux through the wall should be defined as an ISAT output if that wall is an exterior wall. The sequence of the walls defined in the Modelica model should be identical with that in the ISAT-FFD input files Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/ForcedConvectionWithExteriorWall/input.cfd. The ISAT outputs heat_wall1, heat_wall2, ... heat_wall6 correspond to the first, second, ... sixth wall defined in the ISAT-FFD input files.</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ForcedConvectionWithExteriorWall;
