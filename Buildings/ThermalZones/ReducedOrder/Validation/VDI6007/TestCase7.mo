within Buildings.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase7 "VDI 6007 Test Case 7 model"
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
    intWallRC(thermCapInt(each der_T(fixed=true))),
    T_start=295.15) "Thermal zone"
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
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,500; 25200,500;
        28800,500; 32400,500; 36000,500; 39600,481; 43200,426; 46800,374; 50400,
        324; 54000,276; 57600,230; 61200,186; 64800,-500; 68400,-500; 72000,-500;
        75600,-500; 79200,-500; 82800,-500; 86400,-500; 781200,-500; 784800,-500;
        788400,-500; 792000,-500; 795600,-500; 799200,-142; 802800,-172; 806400,
        -201; 810000,-228; 813600,-254; 817200,-278; 820800,-302; 824400,-324;
        828000,-345; 831600,-366; 835200,-385; 838800,-404; 842400,-500; 846000,
        -500; 849600,-500; 853200,-500; 856800,-500; 860400,-500; 864000,-500;
        5101200,-500; 5104800,-500; 5108400,-500; 5112000,-500; 5115600,-500;
        5119200,-149; 5122800,-179; 5126400,-207; 5130000,-234; 5133600,-259;
        5137200,-284; 5140800,-307; 5144400,-329; 5148000,-350; 5151600,-371;
        5155200,-390; 5158800,-408; 5162400,-500; 5166000,-500; 5169600,-500;
        5173200,-500; 5176800,-500; 5180400,-500]) "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow machinesRad(T_ref=
        295.15) "Radiative heat flow machines"
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
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaCoo(T_ref=295.15)
    "Ideal heater/cooler with limit"
    annotation (Placement(transformation(extent={{64,-46},{84,-26}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=[0,22; 3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22;
        21600.1,27; 28800,27; 32400,27; 36000,27; 39600,27; 43200,27; 46800,27;
        50400,27; 54000,27; 57600,27; 61200,27; 64800,27; 64800.1,22; 72000,22;
        75600,22; 79200,22; 82800,22; 86400,22])
    "Set temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{-68,-44},{-52,-28}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    "Convert set temperature from degC to Kelvin"
    annotation (Placement(transformation(extent={{-38,-42},{-26,-30}})));
  Controls.Continuous.LimPID conHeaCoo(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=-1,
    k=0.1,
    Ti=5) "Heating and cooling controller"
    annotation (Placement(transformation(extent={{-18,-44},{-2,-28}})));
  Modelica.Blocks.Math.Gain gainHeaCoo(k=500)
    "Gain for heating and cooling controller"
    annotation (Placement(transformation(extent={{8,-42},{20,-30}})));

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
  connect(heaCoo.port, thermalZoneTwoElements.intGainsConv) annotation (Line(
        points={{84,-36},{84,-36},{96,-36},{96,20},{92,20}}, color={191,0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{36.25,31},{43,31}}, color={0,0,127}));
  connect(from_degC.y, conHeaCoo.u_s)
    annotation (Line(points={{-25.4,-36},{-19.6,-36}}, color={0,0,127}));
  connect(thermalZoneTwoElements.TAir, conHeaCoo.u_m) annotation (Line(
        points={{93,32},{100,32},{100,-54},{-10,-54},{-10,-45.6}}, color={0,0,
          127}));
  connect(conHeaCoo.y, gainHeaCoo.u)
    annotation (Line(points={{-1.2,-36},{6.8,-36}}, color={0,0,127}));
  connect(gainHeaCoo.y, heaCoo.Q_flow) annotation (Line(points={{20.6,-36},{40,
          -36},{60,-36},{64,-36}}, color={0,0,127}));
  connect(setTemp.y[1], from_degC.u) annotation (Line(points={{-51.2,-36},{
          -39.2,-36}},             color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}})), Documentation(info="<html>
  <p>Test Case 7 of the VDI 6007 Part 1: Calculation of heat load excited with a
  given radiative heat source and a setpoint profile for room version S. Is
  similar with Test Case 6, but with a maximum heating/cooling power.</p>
  <p>Boundary Condtions:</p>
  <ul>
  <li>constant outdoor air temperature 22&deg;C</li>
  <li>no solar or short-wave radiation on the exterior wall</li>
  <li>no solar or short-wave radiation through the windows</li>
  <li>no long-wave radiation exchange between exterior wall, windows and ambient
  environment</li>
  </ul>
  <p>This test case is thought to test heat load calculation with maximum
  heating power.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  January 11, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase7.mos"
        "Simulate and plot"));
end TestCase7;
