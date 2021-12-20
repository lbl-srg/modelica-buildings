within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase2 "VDI 6007 Test Case 2 model"
  extends Modelica.Icons.Example;

  RC.TwoElements thermalZoneTwoElements(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    hConExt=2.7,
    hConWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    hConInt=2.24,
    RWin=0.00000001,
    hRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    VAir=0,
    nOrientations=1,
    AWin={0},
    ATransparent={0},
    AExt={10.5},
    extWallRC(thermCapExt(each der_T(fixed=true))),
    T_start=295.15,
    intWallRC(thermCapInt(each der_T(fixed=true))))
    "Thermal zone"
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
    columns={2})
    "Table with internal gains"
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    offset={273.15},
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22;
        25200,22.6; 28800,22.9; 32400,23.1; 36000,23.3; 39600,23.5; 43200,23.7;
        46800,23.9; 50400,24.1; 54000,24.3; 57600,24.6; 61200,24.8; 64800,25;
        68400,24.5; 72000,24.5; 75600,24.5; 79200,24.5; 82800,24.5; 86400,24.5;
        781200,37.7; 784800,37.7; 788400,37.6; 792000,37.5; 795600,37.5; 799200,
        37.4; 802800,38; 806400,38.2; 810000,38.3; 813600,38.5; 817200,38.6;
        820800,38.8; 824400,38.9; 828000,39.1; 831600,39.2; 835200,39.4; 838800,
        39.5; 842400,39.7; 846000,39.2; 849600,39.1; 853200,39.1; 856800,39;
        860400,38.9; 864000,38.9; 5101200,50; 5104800,49.9; 5108400,49.8;
        5112000,49.7; 5115600,49.6; 5119200,49.5; 5122800,50; 5126400,50.1;
        5130000,50.2; 5133600,50.3; 5137200,50.5; 5140800,50.6; 5144400,50.7;
        5148000,50.8; 5151600,50.9; 5155200,51; 5158800,51.1; 5162400,51.2;
        5166000,50.7; 5169600,50.6; 5173200,50.4; 5176800,50.3; 5180400,50.2;
        5184000,50.1])
    "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    "Radiative heat flow machines"
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.Constant hConWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(
    transformation(
    extent={{-4,-4},{4,4}},
    rotation=90,
    origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0)
    "Solar radiation"
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  BaseClasses.VerifyDifferenceThreePeriods assEqu(
    startTime=3600,
    endTime=86400,
    startTime2=781200,
    endTime2=864000,
    startTime3=5101200,
    endTime3=5184000,
    threShold=0.15)
    "Checks validation criteria"
    annotation (Placement(transformation(extent={{84,46},{94,56}})));
  Modelica.Blocks.Math.Mean mean(f=1/3600)
    "Hourly mean of indoor air temperature"
    annotation (Placement(transformation(extent={{62,46},{72,56}})));
equation
  connect(theConWall.fluid, preTem.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, theConWall.solid)
    annotation (Line(points={{44,12},{40,12},{40,1},{36,1}},   color={191,0,0}));
  connect(hConWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}},color={0,0,127}));
  connect(intGai.y[1], machinesRad.Q_flow)
    annotation (Line(points={{
    22.8,-52},{36,-52},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-74},{84,-74},{98,-74},{98,24},{92,24}},
    color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{36.25,31},{43,31}}, color={0,0,127}));
  connect(thermalZoneTwoElements.TAir, mean.u) annotation (Line(points={{93,32},
          {98,32},{98,42},{52,42},{52,51},{61,51}}, color={0,0,127}));
  connect(mean.y, assEqu.u2) annotation (Line(points={{72.5,51},{78,51},{78,48},
          {83,48}}, color={0,0,127}));
  connect(reference.y[1], assEqu.u1) annotation (Line(points={{97,82},{100,82},
          {100,62},{78,62},{78,54},{83,54}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
  <p>Test Case 2 of the VDI 6007 Part 1: Calculation of indoor air
  temperature excited by a radiative heat source for room version S.</p>
  <h4>Boundary conditions</h4>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows
  and ambient environment</li>
  </ul>
  <p>This test validates basic functionalities.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaWall</code> to <code>hConWall</code>
  </li>
  <li>
  July 7, 2016, by Moritz Lauster:<br/>
  Added automatic check against validation thresholds.
  </li>
  <li>
  January 11, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),experiment(Tolerance=1e-6, StopTime=5.184e+006, Interval=60),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase2.mos"
        "Simulate and plot"));
end TestCase2;
