within Buildings.Rooms.Examples.FFD;
model ForcedConvection "Ventilation with forced convection in an empty room"
  extends Modelica.Icons.Example;
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(
    roo(
      surBou(
        name={"East Wall","West Wall","North Wall","South Wall","Ceiling","Floor"},
        A={0.9,0.9,1,1,1,1},
        til={Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Ceiling,
            Buildings.Types.Tilt.Floor},
        each absIR=1e-5,
        each absSol=1e-5,
        each boundaryCondition= Buildings.Rooms.Types.CFDBoundaryConditions.Temperature),
      nPorts=2,
      portName={"Inlet","Outlet"},
      cfdFilNam="modelica://Buildings/Resources/Data/Rooms/FFD/ForcedConvection.ffd",
      samplePeriod=6,
      linearizeRadiation=true,
      massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
      nSurBou=6);
  HeatTransfer.Sources.FixedTemperature TWal[nSurBou](each T=283.15)
    "Temperature of other walls"
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,10})));
  Fluid.Sources.FixedBoundary bouOut(nPorts=1, redeclare package Medium =
        MediumA)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.MassFlowSource_T bounIn(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=0.01,
    T=283.15) annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  for i in 1:nSurBou loop
    connect(TWal[i].port, roo.surf_surBou[i])    annotation (Line(
      points={{100,10},{62.2,10},{62.2,26}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;
    connect(bounIn.ports[1], roo.ports[1]) annotation (Line(
      points={{20,30},{51,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouOut.ports[1], roo.ports[2]) annotation (Line(
      points={{20,0},{36,0},{36,30},{51,30}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,200}})),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/ForcedConvection.mos"
        "Simulate and plot"),
    experiment(StopTime=12),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the ventilation with forced convection in an empty room.
Figure (a) shows the schematic of the FFD simulation and Figure (b) shows streamlines and contours of the horizontal velocity U as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/ConvectionSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/ForcedConvection.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
December 31, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ForcedConvection;
