within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase3 "VDI 6007 Test Case 3 model"
  extends Modelica.Icons.Example;

  RC.TwoElements thermalZoneTwoElements(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    alphaRad=5,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
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
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,30.2;
        25200,30.8; 28800,31.2; 32400,31.6; 36000,32; 39600,32.4; 43200,32.8;
        46800,33.2; 50400,33.6; 54000,34; 57600,34.3; 61200,34.7; 64800,26.9;
        68400,26.7; 72000,26.7; 75600,26.6; 79200,26.6; 82800,26.6; 86400,43.7;
        781200,43.5; 784800,43.4; 788400,43.2; 792000,43; 795600,42.9; 799200,
        50.9; 802800,51.3; 806400,51.6; 810000,51.8; 813600,52.1; 817200,52.3;
        820800,52.5; 824400,52.8; 828000,53; 831600,53.3; 835200,53.5; 838800,
        53.7; 842400,45.8; 846000,45.4; 849600,45.3; 853200,45.1; 856800,44.9;
        860400,44.7; 864000,48.7; 5101200,48.5; 5104800,48.3; 5108400,48.1;
        5112000,47.9; 5115600,47.7; 5119200,55.7; 5122800,56; 5126400,56.3;
        5130000,56.5; 5133600,56.7; 5137200,56.9; 5140800,57.1; 5144400,57.3;
        5148000,57.5; 5151600,57.7; 5155200,57.9; 5158800,58.1; 5162400,50.1;
        5166000,49.8; 5169600,49.5; 5173200,49.3; 5176800,49.1; 5180400,48.9])
    "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow macConv
    "Convective heat flow machines"
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
    annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},   color={191,0,0}));
  connect(alphaWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(intGai.y[1], macConv.Q_flow)
    annotation (Line(points={{
    22.8,-52},{36,-52},{36,-74},{48,-74}}, color={0,0,127}));
  connect(macConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-74},{82,-74},{98,-74},{98,20},{92,20}}, color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{36.25,31},{43,31}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}})), Documentation(info="<html>
  <p>Test Case 3 of the VDI 6007 Part 1: Calculation of indoor air temperature
  excited by a convective heat source for room version L.</p>
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
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase3.mos"
        "Simulate and plot"));
end TestCase3;
