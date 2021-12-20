within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase11 "VDI 6007 Test Case 11 model"
  extends Modelica.Icons.Example;

  RC.TwoElements thermalZoneTwoElements(
    hConExt=2.7,
    hConWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    RWin=0.00000001,
    hRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    hConInt=3,
    indoorPortIntWalls=true,
    VAir=0,
    nOrientations=1,
    redeclare final package Medium = Modelica.Media.Air.SimpleAir,
    AWin={0},
    ATransparent={0},
    AExt={10.5},
    extWallRC(thermCapExt(each der_T(fixed=true))),
    T_start=295.15,
    intWallRC(thermCapInt(each der_T(fixed=true))))
    "Thermal zone"
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(
    T=295.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWall(
    dT(start=0))
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
    annotation (Placement(transformation(extent={{6,-96},{22,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2,3,4},
    table=[0,22,0,0; 3600,22,0,0; 7200,22,0,0; 10800,22,0,0; 14400,22,0,0;
        18000,22,0,0; 21600,22,0,500; 25200,24.9,500,500; 28800,25.2,500,500;
        32400,25.6,500,500; 36000,25.9,500,500; 39600,26.2,500,500; 43200,26.5,
        500,500; 46800,26.8,500,464; 50400,27,464,397; 54000,27,397,333; 57600,
        27,333,272; 61200,27,272,215; 64800,27,215,-500; 68400,25.3,-500,-500;
        72000,25.2,-500,-500; 75600,25.1,-500,-500; 79200,24.9,-500,-500; 82800,
        24.8,-500,-500; 86400,24.7,-500,-500; 781200,26.2,-500,-500; 784800,
        26.1,-500,-500; 788400,26,-500,-500; 792000,25.8,-500,-500; 795600,25.7,
        -500,-500; 799200,25.6,-500,126; 802800,27,126,76; 806400,27,76,28;
        810000,27,28,100; 813600,27,-121,-391; 817200,27,-391,-500; 820800,27,-500,
        -500; 824400,27.1,-500,-500; 828000,27.2,-500,-500; 831600,27.3,-500,-500;
        835200,27.4,-500,-500; 838800,27.5,-500,-500; 842400,27.6,-500,-500;
        846000,27,-500,-500; 849600,26.9,-500,-500; 853200,26.7,-500,-500;
        856800,26.6,-500,-500; 860400,26.5,-500,-500; 864000,26.4,-500,-500;
        5101200,26.2,-500,-500; 5104800,26.1,-500,-500; 5108400,26,-500,-500;
        5112000,25.8,-500,-500; 5115600,25.7,-500,-500; 5119200,25.6,-500,126;
        5122800,27,126,76; 5126400,27,76,28; 5130000,27,28,100; 5133600,27,-122,
        -391; 5137200,27,-391,-500; 5140800,27,-500,-500; 5144400,27.1,-500,-500;
        5148000,27.2,-500,-500; 5151600,27.3,-500,-500; 5155200,27.4,-500,-500;
        5158800,27.5,-500,-500; 5162400,27.6,-500,-500; 5166000,27,-500,-500;
        5169600,26.9,-500,-500; 5173200,26.7,-500,-500; 5176800,26.6,-500,-500;
        5180400,26.5,-500,-500; 5184000,26.4,-500,-500])
    "Reference results"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    "Radiative heat flow machines"
    annotation (Placement(transformation(extent={{48,-98},{68,-78}})));
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heat
    "Ideal heater with limit"
    annotation (Placement(transformation(extent={{46,-44},{66,-24}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow cool
    "Ideal cooler with limit"
    annotation (Placement(transformation(extent={{2,76},{22,96}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22;
        21600.1,27; 28800,27; 32400,27; 36000,27; 39600,27; 43200,27; 46800,27;
        50400,27; 54000,27; 57600,27; 61200,27; 64800,27; 64800.1,22; 72000,22;
        75600,22; 79200,22; 82800,22; 86400,22])
    "Set temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{-96,16},{-80,32}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    "Convert set temperature from degC to Kelvin"
    annotation (Placement(transformation(extent={{-74,18},{-62,30}})));
  Modelica.Blocks.Math.Gain gainHea(k=500)
    "Gain for heating"
    annotation (Placement(transformation(extent={{-16,-40},{-4,-28}})));
  Controls.Continuous.LimPID conHeaCoo(
    yMin=-1,
    Td=5,
    yMax=1,
    k=0.1,
    Ti=1.2)
    "Heating and cooling controller"
    annotation (Placement(transformation(extent={{-50,16},{-34,32}})));
  Modelica.Blocks.Math.Gain gainCoo(k=500)
    "Gain for cooling"
    annotation (Placement(transformation(extent={{-16,80},{-4,92}})));
  Modelica.Blocks.Logical.Switch switchCoo
    "Switch to limit cooling power"
    annotation (Placement(transformation(extent={{-46,81},{-36,91}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(
    uLow=-0.0000001,
    uHigh=0.0000001,
    y(start=true))
    "Threshold for switching between heating and cooling"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={-67,51})));
  Modelica.Blocks.Sources.Constant DefPow(k=0)
    "Default power"
    annotation (Placement(transformation(extent={{-90,-4},{-82,4}})));
  Modelica.Blocks.Logical.Switch switchHea
    "Switch to limit heating power"
    annotation (Placement(transformation(extent={{-44,-39},{-34,-29}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    "Sensor for ideal heater"
    annotation (Placement(transformation(extent={{88,-40},{76,-28}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor coolFlowSensor
    "Sensor for ideal cooler"
    annotation (Placement(transformation(extent={{20,64},{8,76}})));
  Modelica.Blocks.Math.Add add(k1=1, k2=-1)
    "Addition for mean of results"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  BaseClasses.VerifyDifferenceThreePeriods assEqu(
    endTime=86400,
    endTime2=864000,
    endTime3=5184000,
    threShold=1.5,
    startTime=3600,
    startTime2=781200,
    startTime3=5101200)
    "Checks validation criteria"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));
  Modelica.Blocks.Math.Mean mean(f=1/3600)
    "Hourly mean of indoor air temperature"
    annotation (Placement(transformation(extent={{150,70},{170,90}})));
  Modelica.Blocks.Logical.Switch switchMea
    "Switch to guess values"
    annotation (Placement(transformation(extent={{140,119},{160,140}})));
  Modelica.Blocks.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Modelica.Blocks.Logical.Timer timer
    "Timer since the control mode changed"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Modelica.Blocks.Logical.LessEqualThreshold thr(threshold=120)
    "Skip the first 120 seconds of the day for comparison with reference values"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Modelica.Blocks.Logical.Change cha
    "Outputs true if the input changes"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
equation
  connect(theConWall.fluid, preTem.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, theConWall.solid)
    annotation (Line(points={{44,12},{40,12},{40,1},{36,1}}, color={191,0,0}));
  connect(hConWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(intGai.y[1], machinesRad.Q_flow)
    annotation (Line(points={{
    22.8,-88},{22.8,-88},{48,-88}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-88},{68,-88},{96,-88},{96,24},{92,24}},
    color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{43,31}}, color={0,0,127}));
  connect(setTemp.y[1],from_degC. u) annotation (Line(points={{-79.2,24},{-75.2,
          24}},                    color={0,0,127}));
  connect(gainHea.y, heat.Q_flow)
    annotation (Line(points={{-3.4,-34},{46,-34}},          color={0,0,127}));
  connect(gainCoo.y, cool.Q_flow)
    annotation (Line(points={{-3.4,86},{2,86}}, color={0,0,127}));
  connect(switchHea.y, gainHea.u) annotation (Line(points={{-33.5,-34},{-33.5,
          -34},{-17.2,-34}}, color={0,0,127}));
  connect(DefPow.y, switchHea.u3) annotation (Line(points={{-81.6,0},{-81.6,0},
          {-56,0},{-56,-38},{-45,-38}}, color={0,0,127}));
  connect(from_degC.y, conHeaCoo.u_s)
    annotation (Line(points={{-61.4,24},{-51.6,24}}, color={0,0,127}));
  connect(switchCoo.y, gainCoo.u) annotation (Line(points={{-35.5,86},{-26.75,
          86},{-17.2,86}}, color={0,0,127}));
  connect(hysteresis.y, switchCoo.u2) annotation (Line(points={{-61.5,51},{-54,
          51},{-54,86},{-47,86}}, color={255,0,255}));
  connect(DefPow.y, switchCoo.u1) annotation (Line(points={{-81.6,0},{-76,0},{
          -76,14},{-98,14},{-98,90},{-47,90}}, color={0,0,127}));
  connect(hysteresis.y, switchHea.u2) annotation (Line(points={{-61.5,51},{-54,
          51},{-54,-34},{-45,-34}}, color={255,0,255}));
  connect(conHeaCoo.y, switchHea.u1) annotation (Line(points={{-33.2,24},{-24,
          24},{-24,-24},{-50,-24},{-50,-30},{-45,-30}}, color={0,0,127}));
  connect(thermalZoneTwoElements.TAir, conHeaCoo.u_m) annotation (Line(
        points={{93,32},{96,32},{96,44},{-20,44},{-20,8},{-42,8},{-42,14.4}},
        color={0,0,127}));
  connect(heat.port, heatFlowSensor.port_b)
    annotation (Line(points={{66,-34},{76,-34}}, color={191,0,0}));
  connect(heatFlowSensor.port_a, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{88,-34},{96,-34},{96,20},{92,20}}, color={191,0,0}));
  connect(cool.port, coolFlowSensor.port_a) annotation (Line(points={{22,86},{26,
          86},{26,70},{20,70}},    color={191,0,0}));
  connect(coolFlowSensor.port_b, thermalZoneTwoElements.intWallIndoorSurface)
    annotation (Line(points={{8,70},{4,70},{4,-24},{44,-24},{44,-6},{56,-6},{56,
          -2}}, color={191,0,0}));
  connect(coolFlowSensor.Q_flow, add.u1)
    annotation (Line(points={{14,64},{14,62},{14,62},{14,60},{30,60},{30,76},{38,
          76}},                                        color={0,0,127}));
  connect(heatFlowSensor.Q_flow, add.u2) annotation (Line(points={{82,-40},{82,-58},
          {0,-58},{0,52},{32,52},{32,64},{38,64}},
                                        color={0,0,127}));
  connect(hysteresis.u, switchHea.u1) annotation (Line(points={{-73,51},{-76,51},
          {-76,40},{-24,40},{-24,-24},{-50,-24},{-50,-30},{-45,-30}}, color={0,
          0,127}));
  connect(conHeaCoo.y, switchCoo.u3) annotation (Line(points={{-33.2,24},{-24,
          24},{-24,68},{-52,68},{-52,82},{-47,82}}, color={0,0,127}));
  connect(add.y, switchMea.u3) annotation (Line(points={{61,70},{69,70},{69,73},
          {69,110},{126,110},{126,121.1},{138,121.1}},
                              color={0,0,127}));
  connect(reference.y[3], switchMea.u1) annotation (Line(points={{101,90},{130,90},
          {130,108},{130,137.9},{138,137.9}},          color={0,0,127}));
  connect(timer.y, thr.u)
    annotation (Line(points={{81,130},{86,130},{98,130}}, color={0,0,127}));
  connect(cha.y, not1.u)
    annotation (Line(points={{1,130},{1,130},{18,130}}, color={255,0,255}));
  connect(not1.y, timer.u)
    annotation (Line(points={{41,130},{44,130},{58,130}}, color={255,0,255}));
  connect(thr.y, switchMea.u2) annotation (Line(points={{121,130},{130,130},{
          134,130},{136,130},{136,129.5},{138,129.5}},       color={255,0,255}));
  connect(cha.u, hysteresis.y) annotation (Line(points={{-22,130},{-54,130},{-54,
          51},{-61.5,51}}, color={255,0,255}));
  connect(switchMea.y, mean.u) annotation (Line(points={{161,129.5},{170,129.5},
          {170,100},{140,100},{140,80},{148,80}}, color={0,0,127}));
  connect(reference.y[2], assEqu.u2) annotation (Line(points={{101,90},{114,90},
          {120,90},{120,64},{198,64}}, color={0,0,127}));
  connect(mean.y, assEqu.u1) annotation (Line(points={{171,80},{180,80},{180,76},
          {198,76}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{240,160}})),
                      Documentation(info="<html>
  <p>Test Case 11 of the VDI 6007 Part 1: Calculation of heat load
  excited with a given radiative heat source and a setpoint profile
  for room version S. It is based on Test Case 7, but with a cooling ceiling for
  cooling purposes instead of a pure convective ideal cooler.</p>
  <h4>Boundary conditions</h4>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows and ambient
  environment</li>
  </ul>
  <p>This test validates implementation of cooling ceiling or
  floor heating.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  November 4, 2021, by Michael Wetter:<br/>
  Increased solver tolerance so that the model passes the assertion in OpenModelica
  after applying <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2713\">Buildings, #2713</a>.
  </li>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaWall</code> to <code>hConWall</code>
  </li>
  <li>
  January 25, 2019, by Michael Wetter:<br/>
  Added start value to avoid warning in JModelica.
  </li>
  <li>
  July 7, 2016, by Moritz Lauster:<br/>
  Added automatic check against validation thresholds and changes threshold to hysteresis.
  </li>
  <li>
  July 6, 2016, by Michael Wetter:<br/>
  Simplified implementation of validation test versus reference data.
  </li>
  <li>
  January 11, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),experiment(Tolerance=1e-7, StopTime=5.184e+006, Interval=60),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase11.mos"
        "Simulate and plot"));
end TestCase11;
