within Buildings.Examples.BoilerPlants;
model ClosedLoopTest "Closed loop testing model"
  extends Modelica.Icons.Example;

  replaceable package MediumW = Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=30
    "Radiator nominal mass flow rate";

  parameter Real boiDesCap(
    final unit="W",
    displayUnit="W",
    final quantity="Power")= 3000000
    "Total boiler plant design capacity";

  parameter Real boiCapRat(
    final unit="1",
    displayUnit="1") = 0.4
    "Ratio of boiler-1 capacity to total capacity";

  Buildings.Examples.BoilerPlants.Baseclasses.BoilerPlantPrimary boiPlaPri(
    final nSec=2,
    final Q_flow_nominal=boiDesCap,
    final boiCap1=(1 - boiCapRat)*boiDesCap,
    final boiCap2=boiCapRat*boiDesCap,
    final mSec_flow_nominal=2*mRad_flow_nominal,
    final TBoiSup_nominal=333.15,
    final TBoiRet_min=323.15,
    final dpValve_nominal_value(displayUnit="Pa") = 2000,
    final dpFixed_nominal_value(displayUnit="Pa") = 1000,
    final controllerTypeBoi1=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kBoi1=0.1,
    final controllerTypeBoi2=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final kBoi2=0.1)
    "Boiler plant primary loop model"
    annotation (Placement(transformation(extent={{40,-20},{60,12}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.PrimaryController conBoiPri(
    final controllerType_priPum=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final controllerType_bypVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_priOnl=false,
    final have_heaPriPum=true,
    final have_varPriPum=true,
    final have_secFloSen=false,
    final nIgnReq=1,
    final nHotWatResReqIgn=6,
    final nSenPri=1,
    final nPumPri_nominal=1,
    final TPlaHotWatSetMax=273.15 + 50,
    final triAmoVal=-1.111,
    final resAmoVal=1.667,
    final maxResVal=3.889,
    final minPumSpePri=0.1,
    final VHotWatPri_flow_nominal=0.02,
    final maxLocDpPri=50000,
    final minLocDpPri=50000,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={boiCapRat*boiDesCap*0.8,(1 - boiCapRat)*boiDesCap*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*boiCapRat*mRad_flow_nominal/2000,0.3*(1 - boiCapRat)*
        mRad_flow_nominal/2000},
    final maxFloSet={boiCapRat*mRad_flow_nominal/2000,(1 - boiCapRat)*
        mRad_flow_nominal/2000},
    final bypSetRat=0.000005,
    final nPumPri=2,
    final TMinSupNonConBoi=333.2,
    final k_bypVal=1,
    final Ti_bypVal=90,
    final Td_bypVal=10e-9,
    final boiDesFlo=conBoiPri.maxFloSet,
    final k_priPum=0.1,
    final Ti_priPum=15,
    final minPriPumSpeSta={0,0,0},
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.flowrate)
    "Boiler plant primary loop controller"
    annotation (Placement(transformation(extent={{-40,-40},{-20,40}})));

  Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad secLoo2(
    final mRad_flow_nominal=1.25*0.6*30,
    final dpRad_nominal(displayUnit="Pa") = 40000,
    conPID(
      final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      final k=0.05,
      final Ti=10))
    "Secondary loop-2"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad secLoo1(
    final mRad_flow_nominal=1.25*0.4*30,
    final dpRad_nominal(displayUnit="Pa") = 40000,
    conPID(
      final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      final k=0.05,
      final Ti=30))
    "Secondary loop-1"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Sum requests from both secondary loops"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller
    conPumSec2(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_varSecPum=true,
    final have_secFloSen=false,
    final nPum=1,
    final nSen=1,
    final VHotWat_flow_nominal=secLoo1.mRad_flow_nominal/1000,
    final k=1,
    final Ti=12.5,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControlTypes.remoteDP,
    enaHeaLeaPum(intGreThr(t=-1)))
    "Secondary pump controller-2"
    annotation (Placement(transformation(extent={{-8,40},{12,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.SecondaryPumps.Controller
    conPumSec1(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_varSecPum=true,
    final have_secFloSen=false,
    final nPum=1,
    final nSen=1,
    final VHotWat_flow_nominal=secLoo1.mRad_flow_nominal/1000,
    final k=1,
    final Ti=12.5,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControlTypes.remoteDP,
    enaHeaLeaPum(intGreThr(t=-1)))
    "Secondary pump controller-1"
    annotation (Placement(transformation(extent={{-10,128},{10,168}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=15000)
    "Constant Real source for secondary loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonUnc(
    final k=273.15 + 18)
    "Unconditioned zone temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

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
    final columns={2,3,4},
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final table=[-6,0;8,10000;18,0],
    final timeScale=1)
    "Time table for heating load"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.4)
    "Split load between two secondary loops"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=273.15)
    "Convert temperature to Kelvin"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=0.6)
    "Split load between two secondary loops"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

equation

  connect(con3.y, conBoiPri.uBoiAva) annotation (Line(points={{-98,0},{-70,0},{
          -70,2},{-42,2}}, color={255,0,255}));

  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-100,60},{-80,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(weaBus.TDryBul, conBoiPri.TOut) annotation (Line(
      points={{-79.95,60.05},{-72,60.05},{-72,26},{-42,26}},
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

  connect(boiPlaPri.yHotWatDp, conBoiPri.dpHotWatPri_rem) annotation (Line(
        points={{62,-6},{108,-6},{108,-76},{-76,-76},{-76,6},{-42,6}}, color={0,
          0,127}));

  connect(boiPlaPri.VHotWatPri_flow, conBoiPri.VHotWatPri_flow) annotation (
      Line(points={{62,-10},{112,-10},{112,-80},{-80,-80},{-80,14},{-42,14}},
        color={0,0,127}));


  connect(boiPlaPri.yBoiSta, conBoiPri.uBoi) annotation (Line(points={{62,-14},
          {120,-14},{120,-88},{-88,-88},{-88,-22},{-42,-22}}, color={255,0,255}));

  connect(boiPlaPri.yPumSta, conBoiPri.uPriPum) annotation (Line(points={{62,-18},
          {124,-18},{124,-92},{-92,-92},{-92,-26},{-42,-26}}, color={255,0,255}));

  connect(boiPlaPri.yHotWatIsoVal, conBoiPri.uHotWatIsoVal) annotation (Line(
        points={{62,-22},{128,-22},{128,-96},{-96,-96},{-96,-30},{-42,-30}},
        color={0,0,127}));

  connect(conBoiPri.yPriPum, boiPlaPri.uPumSta) annotation (Line(points={{-18,-12},
          {-6,-12},{-6,-8},{38,-8}}, color={255,0,255}));
  connect(conBoiPri.yBoi, boiPlaPri.uBoiSta)
    annotation (Line(points={{-18,8},{38,8}}, color={255,0,255}));
  connect(conBoiPri.TBoiHotWatSupSet, boiPlaPri.TBoiHotWatSupSet)
    annotation (Line(points={{-18,4},{38,4}}, color={0,0,127}));
  connect(conBoiPri.yHotWatIsoVal, boiPlaPri.uHotIsoVal)
    annotation (Line(points={{-18,0},{38,0}}, color={0,0,127}));
  connect(conBoiPri.yPriPumSpe, boiPlaPri.uPumSpe) annotation (Line(points={{-18,
          -16},{0,-16},{0,-12},{38,-12}}, color={0,0,127}));
  connect(con3[1].y, conBoiPri.uSchEna) annotation (Line(points={{-98,0},{-90,0},
          {-90,38},{-42,38}}, color={255,0,255}));
  connect(boiPlaPri.port_b[2], secLoo1.port_a) annotation (Line(points={{43,10.25},
          {43,50},{82,50},{82,134},{46,134},{46,140}}, color={0,127,255}));
  connect(boiPlaPri.port_a[2], secLoo1.port_b) annotation (Line(points={{57,10.25},
          {57,54},{70,54},{70,132},{54,132},{54,140}}, color={0,127,255}));
  connect(secLoo1.nReq, addInt.u1) annotation (Line(points={{62,156},{84,156},{84,
          36},{138,36}}, color={255,127,0}));
  connect(secLoo2.nReq, addInt.u2) annotation (Line(points={{62,76},{80,76},{80,
          24},{138,24}}, color={255,127,0}));
  connect(addInt.y, conBoiPri.TSupResReq) annotation (Line(points={{162,30},{
          170,30},{170,90},{-50,90},{-50,34},{-42,34}}, color={255,127,0}));
  connect(addInt.y, conBoiPri.plaReq) annotation (Line(points={{162,30},{170,30},
          {170,90},{-50,90},{-50,30},{-42,30}}, color={255,127,0}));
  connect(secLoo1.nReq,conPumSec1. supResReq) annotation (Line(points={{62,156},
          {70,156},{70,174},{-20,174},{-20,154},{-12,154}}, color={255,127,0}));
  connect(secLoo2.nReq,conPumSec2. supResReq) annotation (Line(points={{62,76},{
          80,76},{80,86},{-18,86},{-18,66},{-10,66}}, color={255,127,0}));
  connect(secLoo1.dPSec,conPumSec1. dpHotWat_remote[1]) annotation (Line(points={{62,144},
          {72,144},{72,176},{-22,176},{-22,138},{-12,138}},          color={0,0,
          127}));
  connect(conPumSec1.yHotWatPum[1], secLoo1.uPum) annotation (Line(points={{12,148},
          {38,148}},                   color={255,0,255}));
  connect(conPumSec1.yPumSpe, secLoo1.uPumSpe) annotation (Line(points={{12,138},
          {26,138},{26,144},{38,144}}, color={0,0,127}));
  connect(conPumSec2.yHotWatPum[1], secLoo2.uPum) annotation (Line(points={{14,60},
          {26,60},{26,68},{38,68}}, color={255,0,255}));
  connect(conPumSec2.yPumSpe, secLoo2.uPumSpe) annotation (Line(points={{14,50},
          {32,50},{32,64},{38,64}}, color={0,0,127}));
  connect(secLoo2.dPSec,conPumSec2. dpHotWat_remote[1]) annotation (Line(points
        ={{62,64},{72,64},{72,88},{-20,88},{-20,50},{-10,50}}, color={0,0,127}));
  connect(conBoiPri.yMaxSecPumSpe,conPumSec2. uMaxSecPumSpeCon) annotation (
      Line(points={{-18,-8},{-14,-8},{-14,42},{-10,42}}, color={0,0,127}));
  connect(conBoiPri.yMaxSecPumSpe,conPumSec1. uMaxSecPumSpeCon) annotation (
      Line(points={{-18,-8},{-14,-8},{-14,130},{-12,130}}, color={0,0,127}));
  connect(conBoiPri.yPla,conPumSec2. uPlaEna) annotation (Line(points={{-18,16},
          {-16,16},{-16,70},{-10,70}}, color={255,0,255}));
  connect(conBoiPri.yPla,conPumSec1. uPlaEna) annotation (Line(points={{-18,16},
          {-16,16},{-16,158},{-12,158}}, color={255,0,255}));
  connect(secLoo2.yPumEna,conPumSec2. uHotWatPum[1]) annotation (Line(points={{62,
          72},{74,72},{74,92},{-22,92},{-22,74},{-10,74}}, color={255,0,255}));
  connect(secLoo1.yPumEna,conPumSec1. uHotWatPum[1]) annotation (Line(points={{62,152},
          {74,152},{74,178},{-26,178},{-26,162},{-12,162}},      color={255,0,255}));
  connect(boiPlaPri.yPriPumSpe, conBoiPri.uPriPumSpe) annotation (Line(points={
          {62,6},{70,6},{70,-46},{-42,-46},{-42,-38}}, color={0,0,127}));
  connect(con.y,conPumSec1. dpHotWatSet) annotation (Line(points={{-58,150},{
          -26,150},{-26,134},{-12,134}}, color={0,0,127}));
  connect(con.y,conPumSec2. dpHotWatSet) annotation (Line(points={{-58,150},{-26,
          150},{-26,46},{-10,46}}, color={0,0,127}));
  connect(boiPlaPri.TRetSec, conBoiPri.TRetSec) annotation (Line(points={{62,14},
          {62,22},{24,22},{24,-48},{-50,-48},{-50,10},{-42,10}}, color={0,0,127}));
  connect(boiPlaPri.VDec_flow, conBoiPri.VHotWatDec_flow) annotation (Line(
        points={{62,10},{72,10},{72,-52},{-52,-52},{-52,-6},{-42,-6}}, color={0,
          0,127}));
  connect(TZonUnc.y, boiPlaPri.TZon) annotation (Line(points={{22,-30},{30,-30},
          {30,-16},{38,-16}}, color={0,0,127}));
  connect(addPar.y, secLoo1.THotWatRet) annotation (Line(points={{-38,120},{24,120},
          {24,152},{38,152}}, color={0,0,127}));
  connect(addPar.y, secLoo2.THotWatRet) annotation (Line(points={{-38,120},{24,120},
          {24,72},{38,72}}, color={0,0,127}));
  connect(timTab.y[1], addPar.u) annotation (Line(points={{-99,100},{-92,100},{
          -92,120},{-62,120}}, color={0,0,127}));
  connect(timTab.y[2], gai.u) annotation (Line(points={{-99,100},{-92,100},{-92,
          180},{-82,180}}, color={0,0,127}));
  connect(timTab.y[2], gai1.u)
    annotation (Line(points={{-99,100},{-82,100}}, color={0,0,127}));
  connect(gai.y, secLoo1.uHotWat_flow) annotation (Line(points={{-58,180},{-30,180},
          {-30,190},{30,190},{30,156},{38,156}}, color={0,0,127}));
  connect(gai1.y, secLoo2.uHotWat_flow) annotation (Line(points={{-58,100},{30,100},
          {30,76},{38,76}}, color={0,0,127}));
  connect(boiPlaPri.port_b[1], secLoo2.port_a) annotation (Line(points={{43,9.75},
          {43,56},{46,56},{46,60}}, color={0,127,255}));
  connect(boiPlaPri.port_a[1], secLoo2.port_b) annotation (Line(points={{57,9.75},
          {58,9.75},{58,56},{54,56},{54,60}}, color={0,127,255}));
  connect(secLoo1.yPumSpe,conPumSec1. uPumSpe) annotation (Line(points={{62,148},
          {76,148},{76,184},{-28,184},{-28,152},{-20,152},{-20,150},{-12,150}},
        color={0,0,127}));
  connect(secLoo2.yPumSpe,conPumSec2. uPumSpe) annotation (Line(points={{62,68},
          {76,68},{76,94},{-24,94},{-24,62},{-10,62}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model couples the boiler plant model for a primary-secondary, condensing boiler
plant with variable speed primary and secondary pumps with controllers for the
primary loop and the secondary loops.
<br>
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
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlants/ClosedLoopTest.mos"
        "Simulate and plot"),
    experiment(
      StartTime=86400,
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoopTest;
