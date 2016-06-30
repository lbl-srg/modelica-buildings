within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase11 "VDI 6007 Test Case 11 model"
  extends Modelica.Icons.Example;

  RC.TwoElements thermalZoneTwoElements(
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    RWin=0.00000001,
    alphaRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    alphaInt=3,
    indoorPortIntWalls=true,
    VAir=0,
    nOrientations=1,
    redeclare final package Medium = Modelica.Media.Air.SimpleAir,
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
    annotation (Placement(transformation(extent={{6,-96},{22,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[0,22,0; 3600,22,0; 7200,22,0; 10800,22,0; 14400,22,0; 18000,22,0;
        21600,24.9,500; 25200,25.2,500; 28800,25.6,500; 32400,25.9,500; 36000,
        26.2,500; 39600,26.5,500; 43200,26.8,500; 46800,27,464; 50400,27,397;
        54000,27,333; 57600,27,272; 61200,27,215; 64800,25.3,-500; 68400,25.2,-500;
        72000,25.1,-500; 75600,24.9,-500; 79200,24.8,-500; 82800,24.7,-500;
        86400,26.2,-500; 781200,26.1,-500; 784800,26,-500; 788400,25.8,-500;
        792000,25.7,-500; 795600,25.6,-500; 799200,27,126; 802800,27,76; 806400,
        27,28; 810000,27,-121; 813600,27,-391; 817200,27,-500; 820800,27.1,-500;
        824400,27.2,-500; 828000,27.3,-500; 831600,27.4,-500; 835200,27.5,-500;
        838800,27.6,-500; 842400,27,-500; 846000,26.9,-500; 849600,26.7,-500;
        853200,26.6,-500; 856800,26.5,-500; 860400,26.4,-500; 864000,26.2,-500;
        5101200,26.1,-500; 5104800,26,-500; 5108400,25.8,-500; 5112000,25.7,-500;
        5115600,25.6,-500; 5119200,27,126; 5122800,27,76; 5126400,27,28;
        5130000,27,-122; 5133600,27,-391; 5137200,27,-500; 5140800,27.1,-500;
        5144400,27.2,-500; 5148000,27.3,-500; 5151600,27.4,-500; 5155200,27.5,-500;
        5158800,27.6,-500; 5162400,27,-500; 5166000,26.9,-500; 5169600,26.7,-500;
        5173200,26.6,-500; 5176800,26.5,-500; 5180400,26.4,-500])
    "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    "Radiative heat flow machines"
    annotation (Placement(transformation(extent={{48,-98},{68,-78}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(
    transformation(
    extent={{-4,-4},{4,4}},
    rotation=90,
    origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0) "Solar radiation"
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heat
    "Ideal heater with limit"
    annotation (Placement(transformation(extent={{66,-44},{86,-24}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow cool(T_ref=295.15)
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
  Modelica.Blocks.Math.Gain gainHea(k=500) "Gain for heating"
    annotation (Placement(transformation(extent={{-16,-40},{-4,-28}})));
  Controls.Continuous.LimPID conHeaCoo(
    yMin=-1,
    k=0.1,
    Td=5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    Ti=4) "Heating and cooling controller"
    annotation (Placement(transformation(extent={{-48,16},{-32,32}})));
  Modelica.Blocks.Math.Gain gainCoo(k=500) "Gain for cooling"
    annotation (Placement(transformation(extent={{-16,80},{-4,92}})));
  Modelica.Blocks.Logical.Switch switchCoo "Switch to limit cooling power"
    annotation (Placement(transformation(extent={{-46,81},{-36,91}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=0, y(start=
          false)) "Threshold for sunblind for one direction"
    annotation (Placement(transformation(
    extent={{-5,-5},{5,5}},
    rotation=0,
    origin={-67,51})));
  Modelica.Blocks.Sources.Constant DefPow(k=0) "Default power"
    annotation (Placement(transformation(extent={{-90,-4},{-82,4}})));
  Modelica.Blocks.Logical.Switch switchHea "Switch to limit heating power"
    annotation (Placement(transformation(extent={{-44,-39},{-34,-29}})));

equation
  connect(theConWall.fluid, preTem.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, theConWall.solid)
    annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, theConWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(intGai.y[1], machinesRad.Q_flow)
    annotation (Line(points={{
    22.8,-88},{22.8,-88},{48,-88}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-88},{84,-88},{98,-88},{98,24},{92.2,24}},
    color={191,0,0}));
  connect(heat.port, thermalZoneTwoElements.intGainsConv)
    annotation (Line(
    points={{86,-34},{86,-34},{96,-34},{96,20},{92,20}}, color={191,0,0}));
  connect(cool.port, thermalZoneTwoElements.intWallIndoorSurface)
    annotation (
    Line(points={{22,86},{26,86},{26,84},{26,72},{4,72},{4,-24},{44,-24},{44,-6},
          {56,-6},{56,-2}},
                      color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{43,31}}, color={0,0,127}));
  connect(setTemp.y[1],from_degC. u) annotation (Line(points={{-79.2,24},{-75.2,
          24}},                    color={0,0,127}));
  connect(gainHea.y, heat.Q_flow)
    annotation (Line(points={{-3.4,-34},{66,-34}},          color={0,0,127}));
  connect(gainCoo.y, cool.Q_flow)
    annotation (Line(points={{-3.4,86},{2,86}}, color={0,0,127}));
  connect(switchHea.y, gainHea.u) annotation (Line(points={{-33.5,-34},{-33.5,
          -34},{-17.2,-34}}, color={0,0,127}));
  connect(DefPow.y, switchHea.u3) annotation (Line(points={{-81.6,0},{-81.6,0},
          {-56,0},{-56,-38},{-45,-38}}, color={0,0,127}));
  connect(from_degC.y, conHeaCoo.u_s)
    annotation (Line(points={{-61.4,24},{-49.6,24}}, color={0,0,127}));
  connect(switchCoo.y, gainCoo.u) annotation (Line(points={{-35.5,86},{-26.75,
          86},{-17.2,86}}, color={0,0,127}));
  connect(conHeaCoo.y, greaterThreshold1.u) annotation (Line(points={{-31.2,24},
          {-28,24},{-28,40},{-76,40},{-76,51},{-73,51}}, color={0,0,127}));
  connect(greaterThreshold1.y, switchCoo.u2) annotation (Line(points={{-61.5,51},
          {-54,51},{-54,86},{-47,86}}, color={255,0,255}));
  connect(DefPow.y, switchCoo.u1) annotation (Line(points={{-81.6,0},{-76,0},{
          -76,14},{-98,14},{-98,90},{-47,90}}, color={0,0,127}));
  connect(greaterThreshold1.y, switchHea.u2) annotation (Line(points={{-61.5,51},
          {-54,51},{-54,-34},{-45,-34}}, color={255,0,255}));
  connect(conHeaCoo.y, switchCoo.u3) annotation (Line(points={{-31.2,24},{-24,
          24},{-24,74},{-52,74},{-52,82},{-47,82}}, color={0,0,127}));
  connect(conHeaCoo.y, switchHea.u1) annotation (Line(points={{-31.2,24},{-24,
          24},{-24,-24},{-50,-24},{-50,-30},{-45,-30}}, color={0,0,127}));
  connect(thermalZoneTwoElements.TAir, conHeaCoo.u_m) annotation (Line(
        points={{93,32},{96,32},{96,44},{-20,44},{-20,8},{-40,8},{-40,14.4}},
        color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}})), Documentation(info="<html>
  <p>Test Case 11 of the VDI 6007 Part 1: Calculation of heat load excited with
  a given radiative heat source and a setpoint profile for room version S. It is
  based on Test Case 7, but with a cooling ceiling for cooling purposes instead
  of a pure convective ideal cooler.</p>
  <p>Boundary Condtions:</p>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows and ambient
  environment</li>
  </ul>
  <p>This test case is thought to test implementation of cooling ceiling or
  floor heating.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  January 11, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase11.mos"
        "Simulate and plot"));
end TestCase11;
