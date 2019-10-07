within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase6 "VDI 6007 Test Case 6 model"
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
    VAir=0,
    nOrientations=1,
    AWin={0},
    ATransparent={0},
    AExt={10.5},
    extWallRC(thermCapExt(each der_T(fixed=true))),
    intWallRC(thermCapInt(each der_T(fixed=true))),
    RExt={0.004367913},
    CExt={1600800},
    RInt={0.000595515},
    CInt={14836200},
    RExtRem=0.038959197,
    T_start=295.15)
    "Thermal zone"
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(T=295.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{5,-5},{17,7}})));
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
    annotation (Placement(transformation(extent={{6,-82},{22,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 25200,-764;
        28800,-696; 32400,-632; 36000,-570; 39600,-511; 43200,-455; 46800,-402;
        50400,-351; 54000,-302; 57600,-255; 61200,-210; 64800,-167; 68400,638;
        72000,610; 75600,583; 79200,557; 82800,533; 86400,511; 781200,774;
        784800,742; 788400,711; 792000,682; 795600,654; 799200,627; 802800,-163;
        806400,-120; 810000,-79; 813600,-40; 817200,-2; 820800,33; 824400,67;
        828000,99; 831600,130; 835200,159; 838800,187; 842400,214; 846000,1004;
        849600,960; 853200,919; 856800,880; 860400,843; 864000,808; 5101200,774;
        5104800,742; 5108400,711; 5112000,682; 5115600,654; 5119200,627;
        5122800,-163; 5126400,-120; 5130000,-78; 5133600,-39; 5137200,-2;
        5140800,33; 5144400,67; 5148000,99; 5151600,130; 5155200,159; 5158800,
        187; 5162400,214; 5166000,1004; 5169600,960; 5173200,919; 5176800,880;
        5180400,843; 5184000,808])
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
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    "Sensor for ideal heater/cooler"
    annotation (Placement(transformation(extent={{90,-40},{78,-28}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1
    "Prescribed temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{56,-40},{68,-28}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22;
        21600.1,27; 28800,27; 32400,27; 36000,27; 39600,27; 43200,27; 46800,27;
        50400,27; 54000,27; 57600,27; 61200,27; 64800,27; 64800.1,22; 72000,22;
        75600,22; 79200,22; 82800,22; 86400,22])
    "Set temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{4,-42},{20,-26}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    "Convert set temperature from degC to Kelvin"
    annotation (Placement(transformation(extent={{34,-40},{46,-28}})));
  BaseClasses.VerifyDifferenceThreePeriods assEqu(
    startTime=3600,
    endTime=86400,
    startTime2=781200,
    endTime2=864000,
    startTime3=5101200,
    endTime3=5184000,
    threShold=1.5)
    "Checks validation criteria"
    annotation (Placement(transformation(extent={{84,46},{94,56}})));
  Modelica.Blocks.Math.Mean mean(f=1/3600)
    "Hourly mean of indoor air temperature"
    annotation (Placement(transformation(extent={{62,46},{72,56}})));
equation
  connect(thermalZoneTwoElements.extWall, theConWall.solid)
    annotation (Line(points={{44,12},{40,12},{40,1},{36,1}}, color={191,0,0}));
  connect(hConWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(intGai.y[1], machinesRad.Q_flow)
    annotation (Line(points={{22.8,-74},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-74},{84,-74},{98,-74},{98,24},{92,24}},
    color={191,0,0}));
  connect(preTem1.port, heatFlowSensor.port_b)
    annotation (Line(points={{68,-34},{73,-34},{78,-34}}, color={191,0,0}));
  connect(heatFlowSensor.port_a, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{90,-34},{94,-34},{94,20},{92,20}}, color={191,
    0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{37.25,31},{43,31}}, color={0,0,127}));
  connect(preTem.port, theConWall.fluid) annotation (
      Line(points={{17,1},{21.5,1},{21.5,1},{26,1}}, color={191,0,0}));
  connect(from_degC.y, preTem1.T)
    annotation (Line(points={{46.6,-34},{54.8,-34}}, color={0,0,127}));
  connect(setTemp.y[1], from_degC.u)
    annotation (Line(points={{20.8,-34},{32.8,-34}}, color={0,0,127}));
  connect(mean.y,assEqu. u2) annotation (Line(points={{72.5,51},{78,51},{78,48},
          {83,48}}, color={0,0,127}));
  connect(reference.y[1],assEqu. u1) annotation (Line(points={{97,82},{100,82},
          {100,62},{78,62},{78,54},{83,54}}, color={0,0,127}));
  connect(heatFlowSensor.Q_flow, mean.u) annotation (Line(points={{84,-40},{84,
          -54},{-6,-54},{-6,51},{61,51}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
  <p>Test Case 6 of the VDI 6007 Part 1: Calculation of heat load excited with a
  given radiative heat source and a setpoint profile for room version S. Is
  based on Test Case 2.</p>
  <h4>Boundary conditions</h4>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows
  and ambient environment</li>
  </ul>
  <p>This test validates heat load calculation without
  maximum heating power.</p>
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
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase6.mos"
        "Simulate and plot"));
end TestCase6;
