within Buildings.Examples.BoilerPlants;
model Guideline36 "Closed loop testing model"
  extends Modelica.Icons.Example;

  replaceable package MediumW = Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal=21
    "Boiler plant nominal mass flow rate";

  parameter Real QPla_flow_nominal(
    final unit="W",
    displayUnit="W",
    final quantity="Power")= 1750000
    "Boiler plant design heating capacity";

  parameter Real boiCapRat(
    final unit="1",
    displayUnit="1") = 0.4
    "Ratio of boiler-1 capacity to total capacity";

  Buildings.Examples.BoilerPlants.Baseclasses.BoilerPlantPrimary boiPlaPri(
    final Q_flow_nominal=QPla_flow_nominal,
    final QBoi1_flow_nominal=(1 - boiCapRat)*QPla_flow_nominal,
    final QBoi2_flow_nominal=boiCapRat*QPla_flow_nominal,
    final mPla_flow_nominal=secLoo1.mRad_flow_nominal + secLoo2.mRad_flow_nominal,
    final dpValve_nominal_value(displayUnit="Pa") = 25000,
    final dpFixed_nominal_value(displayUnit="Pa") = 25000,
    final dpPumPri_nominal_value(displayUnit="Pa") = 100000,
    final controllerTypeBoi1=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kBoi1=0.1,
    TiBoi1=60,
    final controllerTypeBoi2=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kBoi2=0.1,
    TiBoi2=60)
    "Boiler plant primary loop model"
    annotation (Placement(transformation(extent={{40,-20},{60,12}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.PrimaryController conBoiPri(
    controllerType_priPum=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_priOnl=false,
    final have_heaPriPum=true,
    final have_isoValSen=true,
    final have_secFloSen_select=false,
    final have_priTemSen_select=true,
    final nLooSec=2,
    nHotWatResReqIgn=0,
    final nSenPri=1,
    final nPumPri_nominal=1,
    TPlaHotWatSetMax=273.15 + 60,
    THotWatSetMinConBoi=305.35,
    triAmoVal=-1.111,
    resAmoVal=1.667,
    maxResVal=3.889,
    minPumSpePri=0.1,
    final nBoi=2,
    final boiTyp_select=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.Boilers.Condensing,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={boiCapRat*QPla_flow_nominal,(1 - boiCapRat)*
        QPla_flow_nominal},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*boiCapRat*mPla_flow_nominal/1000,0.3*(1 - boiCapRat)*
        mPla_flow_nominal/1000},
    final nPumPri=2,
    k_priPum=0.1,
    Ti_priPum=60,
    minPriPumSpeSta={0,0,0},
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControl.Flowrate)
    "Boiler plant primary loop controller"
    annotation (Placement(transformation(extent={{-40,-40},{-20,40}})));

  Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad secLoo2(
    final mRad_flow_nominal=(1 - boiCapRat)*mPla_flow_nominal,
    dpRad_nominal(displayUnit="Pa") = 20000,
    dpValve_nominal(displayUnit="Pa") = 60000)
    "Secondary loop-2"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad secLoo1(
    final mRad_flow_nominal=boiCapRat*mPla_flow_nominal,
    dpRad_nominal(displayUnit="Pa") = 20000,
    dpValve_nominal(displayUnit="Pa") = 60000)
    "Secondary loop-1"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));

  Buildings.Controls.OBC.CDL.Integers.Add addIntReqPla
    "Sum plant requests from both secondary loops"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller
    conPumSec2(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_secFloSen=false,
    final have_looPriNonCon=false,
    final nPum=1,
    final nSen=1,
    final VHotWat_flow_nominal=secLoo1.mRad_flow_nominal/1000,
    final maxRemDp={secLoo2.dpRad_nominal + secLoo2.dpValve_nominal},
    k=0.1,
    Ti=60,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControl.RemoteDP)
    "Secondary pump controller-2"
    annotation (Placement(transformation(extent={{-8,40},{12,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller
    conPumSec1(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_secFloSen=false,
    final have_looPriNonCon=false,
    final nPum=1,
    final nSen=1,
    final VHotWat_flow_nominal=secLoo1.mRad_flow_nominal/1000,
    final maxRemDp={secLoo1.dpRad_nominal + secLoo1.dpValve_nominal},
    k=0.1,
    Ti=60,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControl.RemoteDP)
    "Secondary pump controller-1"
    annotation (Placement(transformation(extent={{-10,128},{10,168}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonUnc(
    final k=273.15 + 18)
    "Unconditioned zone temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={secLoo2.mRad_flow_nominal + secLoo1.mRad_flow_nominal,
        -secLoo2.mRad_flow_nominal,-secLoo1.mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={40,40})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={secLoo1.mRad_flow_nominal,-secLoo2.mRad_flow_nominal -
        secLoo1.mRad_flow_nominal,secLoo2.mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={100,70})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    final k=fill(true,2))
    "Constant boiler availability status"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}}),
        iconTransformation(extent={{-60,50},{-40,70}})));

  Modelica.Blocks.Sources.CombiTimeTable timTab(
    final tableOnFile=true,
    final tableName="EnergyPlus",
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Examples/BoilerPlant/loads.dat"),
    final columns={9},
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final table=[-6,0;8,10000;18,0],
    final timeScale=1)
    "Time table for heating load"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=boiCapRat)
    "Normalize and sS"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=1 -
        boiCapRat) "Split load between two secondary loops"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Detect completion of valve open commands"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[2]
    "Detect completion of valve close commands"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Add addIntReqRes
    "Sum reset requests from both secondary loops"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

equation

  connect(weaBus.TDryBul, conBoiPri.TOut) annotation (Line(
      points={{-79.95,60.05},{-60,60.05},{-60,26},{-42,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(boiPlaPri.ySupTem, conBoiPri.TSupPri) annotation (Line(points={{62,2},
          {100,2},{100,-68},{-68,-68},{-68,22},{-42,22}}, color={0,0,127}));

  connect(boiPlaPri.yRetTem, conBoiPri.TRetPri) annotation (Line(points={{62,-2},
          {104,-2},{104,-72},{-72,-72},{-72,18},{-42,18}}, color={0,0,127}));

  connect(boiPlaPri.VHotWatPri_flow, conBoiPri.VHotWatPri_flow) annotation (
      Line(points={{62,-6},{112,-6},{112,-80},{-80,-80},{-80,14},{-42,14}},
        color={0,0,127}));


  connect(boiPlaPri.yPumSta, conBoiPri.uPriPum) annotation (Line(points={{62,-10},
          {124,-10},{124,-92},{-92,-92},{-92,-26},{-42,-26}}, color={255,0,255}));

  connect(conBoiPri.yPriPum, boiPlaPri.uPumSta) annotation (Line(points={{-18,-10},
          {-6,-10},{-6,-6},{38,-6}}, color={255,0,255}));
  connect(conBoiPri.yBoi, boiPlaPri.uBoiSta)
    annotation (Line(points={{-18,10},{10,10},{10,6},{38,6}},
                                              color={255,0,255}));
  connect(conBoiPri.TBoiHotWatSupSet, boiPlaPri.TBoiHotWatSupSet)
    annotation (Line(points={{-18,6},{10,6},{10,2},{38,2}},
                                              color={0,0,127}));
  connect(conBoiPri.yPriPumSpe, boiPlaPri.uPumSpe) annotation (Line(points={{-18,-14},
          {0,-14},{0,-10},{38,-10}},      color={0,0,127}));
  connect(con3[1].y, conBoiPri.uSchEna) annotation (Line(points={{-98,0},{-90,0},
          {-90,38},{-42,38}}, color={255,0,255}));
  connect(secLoo1.nReqPla, addIntReqPla.u1) annotation (Line(points={{62,154},{
          84,154},{84,36},{138,36}}, color={255,127,0}));
  connect(secLoo2.nReqPla, addIntReqPla.u2) annotation (Line(points={{62,74},{
          80,74},{80,24},{138,24}}, color={255,127,0}));
  connect(addIntReqPla.y, conBoiPri.plaReq) annotation (Line(points={{162,30},{
          170,30},{170,90},{-50,90},{-50,30},{-42,30}}, color={255,127,0}));
  connect(secLoo1.nReqPla, conPumSec1.plaReq) annotation (Line(points={{62,154},
          {70,154},{70,174},{-20,174},{-20,154},{-12,154}}, color={255,127,0}));
  connect(secLoo2.nReqPla, conPumSec2.plaReq) annotation (Line(points={{62,74},
          {80,74},{80,86},{-18,86},{-18,66},{-10,66}}, color={255,127,0}));
  connect(secLoo1.dPSec,conPumSec1. dpHotWat_remote[1]) annotation (Line(points={{62,142},
          {72,142},{72,176},{-22,176},{-22,138},{-12,138}},          color={0,0,
          127}));
  connect(conPumSec1.yHotWatPum[1], secLoo1.uPum) annotation (Line(points={{12,148},
          {38,148}},                   color={255,0,255}));
  connect(conPumSec1.yPumSpe, secLoo1.uPumSpe) annotation (Line(points={{12,138},
          {26,138},{26,144},{38,144}}, color={0,0,127}));
  connect(conPumSec2.yHotWatPum[1], secLoo2.uPum) annotation (Line(points={{14,60},
          {26,60},{26,68},{38,68}}, color={255,0,255}));
  connect(conPumSec2.yPumSpe, secLoo2.uPumSpe) annotation (Line(points={{14,50},
          {32,50},{32,64},{38,64}}, color={0,0,127}));
  connect(secLoo2.dPSec,conPumSec2. dpHotWat_remote[1]) annotation (Line(points={{62,62},
          {72,62},{72,88},{-20,88},{-20,50},{-10,50}},         color={0,0,127}));
  connect(conBoiPri.yPla,conPumSec2. uPlaEna) annotation (Line(points={{-18,14},
          {-16,14},{-16,70},{-10,70}}, color={255,0,255}));
  connect(conBoiPri.yPla,conPumSec1. uPlaEna) annotation (Line(points={{-18,14},
          {-16,14},{-16,158},{-12,158}}, color={255,0,255}));
  connect(secLoo2.yPumEna,conPumSec2. uHotWatPum[1]) annotation (Line(points={{62,70},
          {74,70},{74,92},{-22,92},{-22,74},{-10,74}},     color={255,0,255}));
  connect(secLoo1.yPumEna,conPumSec1. uHotWatPum[1]) annotation (Line(points={{62,150},
          {74,150},{74,178},{-26,178},{-26,162},{-12,162}},      color={255,0,255}));
  connect(boiPlaPri.VDec_flow, conBoiPri.VHotWatDec_flow) annotation (Line(
        points={{62,6},{72,6},{72,-52},{-52,-52},{-52,-6},{-42,-6}},   color={0,
          0,127}));
  connect(TZonUnc.y, boiPlaPri.TZon) annotation (Line(points={{22,-30},{30,-30},
          {30,-14},{38,-14}}, color={0,0,127}));
  connect(gai.y, secLoo1.QLoa_flow) annotation (Line(points={{-58,180},{-30,180},
          {-30,190},{30,190},{30,156},{38,156}}, color={0,0,127}));
  connect(gai1.y, secLoo2.QLoa_flow) annotation (Line(points={{-58,100},{30,100},
          {30,76},{38,76}}, color={0,0,127}));
  connect(boiPlaPri.TRetSec, conBoiPri.TRetSec) annotation (Line(points={{62,10},
          {70,10},{70,-46},{-54,-46},{-54,10},{-42,10}}, color={0,0,127}));
  connect(boiPlaPri.port_b, spl4.port_1) annotation (Line(points={{43.4,8},{43.4,
          24},{40,24},{40,30}},
                            color={0,127,255}));
  connect(spl4.port_2, secLoo2.port_a)
    annotation (Line(points={{40,50},{40,54},{46,54},{46,60}},
                                               color={0,127,255}));
  connect(spl4.port_3, secLoo1.port_a) annotation (Line(points={{50,40},{82,40},
          {82,134},{46,134},{46,140}}, color={0,127,255}));
  connect(secLoo1.port_b, spl1.port_1) annotation (Line(points={{54,140},{54,136},
          {100,136},{100,80}},                 color={0,127,255}));
  connect(spl1.port_3, secLoo2.port_b) annotation (Line(points={{90,70},{86,70},
          {86,54},{54,54},{54,60}},                  color={0,127,255}));
  connect(spl1.port_2, boiPlaPri.port_a) annotation (Line(points={{100,60},{100,
          22},{57,22},{57,8}},  color={0,127,255}));
  connect(conBoiPri.yHotWatIsoVal, boiPlaPri.uHotIsoVal) annotation (Line(
        points={{-18,2},{30,2},{30,-2},{38,-2}},
                                               color={255,0,255}));
  connect(edg.y, conBoiPri.uHotWatIsoValOpe)
    annotation (Line(points={{-98,-30},{-42,-30}}, color={255,0,255}));
  connect(falEdg.y, conBoiPri.uHotWatIsoValClo) annotation (Line(points={{-98,-60},
          {-60,-60},{-60,-34.2},{-42,-34.2}}, color={255,0,255}));
  connect(boiPlaPri.yHotWatIsoVal, edg.u) annotation (Line(points={{62,-18},{80,
          -18},{80,-100},{-130,-100},{-130,-30},{-122,-30}}, color={255,0,255}));
  connect(boiPlaPri.yHotWatIsoVal, falEdg.u) annotation (Line(points={{62,-18},{
          80,-18},{80,-100},{-130,-100},{-130,-60},{-122,-60}}, color={255,0,255}));
  connect(secLoo1.nReqRes, addIntReqRes.u1) annotation (Line(points={{62,158},{130,
          158},{130,156},{138,156}},  color={255,127,0}));
  connect(secLoo2.nReqRes, addIntReqRes.u2) annotation (Line(points={{62,78},{70,
          78},{70,32},{116,32},{116,144},{138,144}},            color={255,127,
          0}));
  connect(addIntReqRes.y, conBoiPri.resReq) annotation (Line(points={{162,150},{
          170,150},{170,182},{-28,182},{-28,92},{-52,92},{-52,34},{-42,34}},
        color={255,127,0}));
  connect(timTab.y[1], gai1.u)
    annotation (Line(points={{-99,140},{-90,140},{-90,100},{-82,100}},
                                                   color={0,0,127}));
  connect(timTab.y[1], gai.u) annotation (Line(points={{-99,140},{-90,140},{-90,
          180},{-82,180}}, color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-100,60},{-80,60}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p>
This model couples the boiler plant model for a primary-secondary, condensing boiler
plant with variable speed primary and secondary pumps with controllers for the
primary loop and the secondary loops.
</p>
<p>
The primary loop is modeled by the
<a href=\"modelica://Buildings.Examples.BoilerPlants.Baseclasses.BoilerPlantPrimary\">
Buildings.Examples.BoilerPlants.Baseclasses.BoilerPlantPrimary</a> instance <code>boiPlaPri</code>
and is coupled with the secondary loop instances <code>secLoo1</code> and <code>secLoo2</code>
of class <a href=\"modelica://Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad\">
Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad</a>. The primary
loop is controlled by the <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.PrimaryController\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.PrimaryController</a> instance
<code>conBoiPlaPri</code>, and the secondary loops <code>secLoo1</code> and <code>secLoo2</code>
are controlled by the secondary loop controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller</a> instances
<code>secPumCon1</code> and <code>secPumCon2</code>, respectively.
</p>
<p>
The reference loads for activating the system are calculated by simulating the DOE
prototype large office building EnergyPlus model (ASHRAE 90.1-2019 version), and then summing
up the simulated flowrates through each of the heating coils in the building. The
return temperature to the hot water plant is also noted. The values are then used
to apply loads on this model by simulating equivalent loads on the secondary loops.
</p>
<p>
A few salient points about the default system sizing values.
<ul>
<li>
The boiler plant nominal flowrate <code>mPla_flow_nominal</code> is set to a value
that corresponds with the maximum mass flowrate of the reference simulated load data.
</li>
<li>
The boiler plant heating capacity <code>QPla_flow_nominal</code> is experimentally set to
a value that ensures supply temperature setpoint is met at highest reference flowrate.
</li>
<li>
The primary pump pressure head <code>boiPlaPri.dpPumPri_nominal_value</code> is
set to ensure positive flow through the decoupler leg (as measured by
<code>boiPlaPri.VDec_flow</code>) when the secondary loops are drawing hot water
at maximum flowrate. The fixed and valve pressure losses for the
primary loop, <code>boiPlaPri.dpFixed_nominal_value</code> and
<code>boiPlaPri.dpValve_nominal_value</code> respectively, are also assigned values
based off equipment data.
</li>
<li>
The pressure loss across the radiator in the secondary loops, i.e.,
<code>secLoo1.dpRad_nominal</code> and <code>secLoo2.dpRad_nominal</code>, are
set to <code>20kPa</code> each, which is an acceptable pressure drop for a heating coil
in real-world applications. The fully-open valve pressure drops
(<code>secLoo1.dpValve_nominal</code> and <code>secLoo2.dpValve_nominal</code>)
are set to a value of 60kPa to achieve valve authority <code>75%</code>.
The differential pressure setpoint for the secondary
pump speed control, <code>conPumSec1.maxRemDp</code> and <code>conPumSec2.maxRemDp</code>,
are set to the sum of the fixed and open-valve pressure drops, to overcome the total
pressure drop in the secondary loops. The setpoint will dynamically change if the
user chooses to change either <code>dpRad_nominal</code> or <code>dpValve_nominal</code>
for either secondary loop.
</li>
</ul>
</p>
<p>
The validation plots are as follows.
<ol>
<li>
Plot-1 represents the operation of the secondary loop-1 <code>secLoo1</code>. The plot
shows how the load model within the secondary loop applies a load fraction proportional
to the input return temperature and mass flow rate when the plant is enabled. The
plot also shows the secondary pump speed control to achieve the required differential
pressure setpoint.
</li>
<li>
Plot-2 is similar to plot-1, and demonstrates the same operations for the secondary
loop-2, <code>secLoo2</code>.
</li>
<li>
Plot-3 represents the primary loop operation, consisting of plant enable,
temperature setpoint reset, and the subsequent staging operations
to meet that load. It shows the enable and disable of the two boilers, and the
opening and closing of their respective isolation valves based on the staging setpoint.
The user can observe that the plant operates at the highest stage setpoint when the
maximum flowrate is drawn by the secondary loops.
</li>
<li>
Plot-4 represents the hydronic operations in the primary loop, including the staging
of the primary pumps such that the number of enabled pumps is equal to the number
of enabled boilers. The primary pump speed regulates the flow measured in the
decoupler leg to zero flowrate.
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2025, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-120},{180,
            200}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlants/Guideline36.mos"
        "Simulate and plot"),
    experiment(
      StartTime=86400,
      StopTime=259200,
      Interval=60,
      Tolerance=1e-05),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36;
