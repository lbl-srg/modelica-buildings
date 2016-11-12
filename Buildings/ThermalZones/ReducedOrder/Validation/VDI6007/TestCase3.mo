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
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22;
        25200,30.2; 28800,30.8; 32400,31.2; 36000,31.6; 39600,32; 43200,32.4;
        46800,32.8; 50400,33.2; 54000,33.6; 57600,34; 61200,34.3; 64800,34.7;
        68400,26.9; 72000,26.7; 75600,26.7; 79200,26.6; 82800,26.6; 86400,26.6;
        781200,43.7; 784800,43.5; 788400,43.4; 792000,43.2; 795600,43; 799200,
        42.9; 802800,50.9; 806400,51.3; 810000,51.6; 813600,51.8; 817200,52.1;
        820800,52.3; 824400,52.5; 828000,52.8; 831600,53; 835200,53.3; 838800,
        53.5; 842400,53.7; 846000,45.8; 849600,45.4; 853200,45.3; 856800,45.1;
        860400,44.9; 864000,44.7; 5101200,48.7; 5104800,48.5; 5108400,48.3;
        5112000,48.1; 5115600,47.9; 5119200,47.7; 5122800,55.7; 5126400,56;
        5130000,56.3; 5133600,56.5; 5137200,56.7; 5140800,56.9; 5144400,57.1;
        5148000,57.3; 5151600,57.5; 5155200,57.7; 5158800,57.9; 5162400,58.1;
        5166000,50.1; 5169600,49.8; 5173200,49.5; 5176800,49.3; 5180400,49.1;
        5184000,48.9],
    offset={273.15})
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
  Modelica.Blocks.Sources.Constant const(k=0)
    "Solar radiation"
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  BaseClasses.AssertEqualityThreePeriods assEqu(
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
  connect(thermalZoneTwoElements.TAir, mean.u) annotation (Line(points={{93,32},
          {98,32},{98,42},{52,42},{52,51},{61,51}}, color={0,0,127}));
  connect(mean.y, assEqu.u2) annotation (Line(points={{72.5,51},{78,51},{78,48},
          {83,48}}, color={0,0,127}));
  connect(reference.y[1], assEqu.u1) annotation (Line(points={{97,82},{100,82},
          {100,62},{78,62},{78,54},{83,54}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
  <p>Test Case 3 of the VDI 6007 Part 1: Calculation of indoor air
  temperature excited by a convective heat source for room version L.</p>
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
  July 7, 2016, by Moritz Lauster:<br/>
  Added automatic check against validation thresholds.
  </li>
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
