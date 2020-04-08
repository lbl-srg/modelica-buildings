within Buildings.ThermalZones.Detailed.Examples.ISAT;
model DataCenter
  "Ventilation in a data center room"
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
      nSou=1,
      haveSource=true,
      sourceName={"IT-Rack"},
      cfdFilNam=
          "modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/ISAT/DataCenter/input.ffd",
      samplePeriod=200,
      linearizeRadiation=true,
      massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
      nSurBou=6);

  HeatTransfer.Sources.FixedTemperature TWal[nSurBou](each T=298.15)
    "Temperature of other walls"
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,10})));
  Buildings.Fluid.Sources.Boundary_pT bouOut(
    nPorts=1,
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.MassFlowSource_T bounIn(
    nPorts=1,
    redeclare package Medium = MediumA,
  m_flow=2.0,
  T=293.15)   annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.TimeTable qRackPower(table=[0,2000; 198,2000; 199,
        3000; 200,3000; 398,3000; 399,3500; 400,3500; 598,3500; 599,2500; 600,
        2500; 800,2500]) "Internal heat source from IT rack heat dissipation"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
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
  connect(qRackPower.y, roo.QIntSou[1]) annotation (Line(points={{-39,130},{4,
          130},{4,58},{44.4,58}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,200}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/ISAT/DataCenter.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-06, StopTime=120),
    Documentation(info="<html>
<p>This model tests the coupled simulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a> with the ISAT program by simulating the ventilation in a data center room. Figure (a) shows the schematic of the FFD simulation; Figure (b) shows the Modelica model of the data center case. </p>
<p>In this case, the inputs of the ISAT model are rack power profiles. The outputs of the ISAT model is the maximum rack-inlet temperature. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/DataCenterSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/ISAT/DataCenterModel.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<h4>Step by Step Guide</h4>
<p>This section describes step by step how to build and simulate the model. This case shares the same precedure as the <a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.ISAT.ForcedConvection\">ForcedConvection</a> case.</p>
<p>Compared to the <a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.ISAT.ForcedConvection\">ForcedConvection</a> case, this case has different inputs and outputs. For more details, please refer to <span style=\"font-family: Courier New;\">Buildings\\Resources\\Data\\ThermalZones\\Detailed\\Examples\\ISAT\\DataCenter\\set.isat</span></p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DataCenter;
