within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase4 "VDI 6007 Test Case 4 model"
  extends Modelica.Icons.Example;

  RC.TwoElements thermalZoneTwoElements(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
    alphaRad=5,
    RExt={0.00404935160802},
    VAir=0,
    nOrientations=1,
    CExt={47900},
    RInt={0.003237138},
    CInt={7297100},
    RExtRem=0.039330865,
    AWin={0},
    ATransparent={0},
    AExt={10.5},
    extWallRC(thermCapExt(each der_T(fixed=true))),
    T_start=295.15,
    intWallRC(thermCapInt(each der_T(fixed=true)))) "Thermal zone"
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(T=295.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWall
    "Outdoor convective heat transfer"
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 21600,1000;
        25200,1000; 28800,1000; 32400,1000; 36000,1000; 39600,1000; 43200,1000;
        46800,1000; 50400,1000; 54000,1000; 57600,1000; 61200,1000; 64800,1000;
        64800,0; 68400,0; 72000,0; 75600,0; 79200,0; 82800,0; 86400,0],
    columns={2}) "Table with internal gains"
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,25.1;
        25200,25.7; 28800,26.1; 32400,26.5; 36000,26.9; 39600,27.3; 43200,27.7;
        46800,28.1; 50400,28.5; 54000,28.9; 57600,29.3; 61200,29.7; 64800,26.9;
        68400,26.7; 72000,26.7; 75600,26.7; 79200,26.6; 82800,26.6; 86400,43.8;
        781200,43.6; 784800,43.5; 788400,43.3; 792000,43.1; 795600,43; 799200,
        45.9; 802800,46.3; 806400,46.6; 810000,46.8; 813600,47.1; 817200,47.3;
        820800,47.6; 824400,47.8; 828000,48.1; 831600,48.3; 835200,48.5; 838800,
        48.8; 842400,45.9; 846000,45.6; 849600,45.4; 853200,45.2; 856800,45;
        860400,44.8; 864000,48.8; 5101200,48.6; 5104800,48.4; 5108400,48.2;
        5112000,48; 5115600,47.8; 5119200,50.7; 5122800,51.1; 5126400,51.3;
        5130000,51.5; 5133600,51.7; 5137200,51.9; 5140800,52.1; 5144400,52.4;
        5148000,52.6; 5151600,52.8; 5155200,53; 5158800,53.2; 5162400,50.2;
        5166000,49.9; 5169600,49.7; 5173200,49.5; 5176800,49.2; 5180400,49])
    "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    "Radiative heat flow machines"
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(
    transformation(
    extent={{-4,-4},{4,4}},
    rotation=90,
    origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0) "Solar radiation"
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
    
equation
  connect(theConWall.fluid, preTem.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, theConWall.solid)
    annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(intGai.y[1], machinesRad.Q_flow)
    annotation (Line(points={{
    22.8,-52},{36,-52},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-74},{84,-74},{98,-74},{98,24},{92.2,24}},
    color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{36.25,31},{43,31}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}})), Documentation(info="<html>
  <p>Test Case 4 of the VDI 6007 Part 1: Calculation of indoor air temperature
  excited by a radiative heat source for room version L.</p>
  <p>Boundary Condtions:</p>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows and ambient
  environment</li>
  </ul>
  <p>This test case is thought to test basic functionalities.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  January 11, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase4.mos"
        "Simulate and plot"));
end TestCase4;
