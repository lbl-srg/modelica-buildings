within Buildings.Examples.BoilerPlant;
model ClosedLoopTest "Closed loop testing model"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium model";

  replaceable package MediumW = Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=113.45
    "Radiator nominal mass flow rate";

  parameter Real boiDesCap(
    final unit="W",
    displayUnit="W",
    final quantity="Power")= 5134933.83
    "Total boiler plant design capacity";

  parameter Real boiCapRat(
    final unit="1",
    displayUnit="1") = 0.4
    "Ratio of boiler-1 capacity to total capacity";

  Buildings.Examples.BoilerPlant.Baseclasses.BoilerPlant boiPla(
    final Q_flow_nominal=boiDesCap,
    final boiCap1=(1 - boiCapRat)*boiDesCap,
    final boiCap2=boiCapRat*boiDesCap,
    final mSec_flow_nominal=mRad_flow_nominal,
    final TBoiSup_nominal=333.15,
    final TBoiRet_min=323.15,
    final dpValve_nominal_value=20000,
    final dpFixed_nominal_value=1000,
    final controllerTypeBoi1=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final controllerTypeBoi2=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Boiler plant model"
    annotation (Placement(transformation(extent={{40,-14},{60,14}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller boiPlaCon(
    final controllerType_priPum=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final controllerType_bypVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final have_priOnl=true,
    final have_heaPriPum=true,
    final have_varPriPum=true,
    final have_varSecPum=false,
    final nSenPri=1,
    final nPumPri_nominal=1,
    final nPumSec=0,
    final nSenSec=0,
    final nPumSec_nominal=0,
    final TPlaHotWatSetMax=273.15 + 50,
    final triAmoVal=-1.111,
    final resAmoVal=1.667,
    final maxResVal=3.889,
    final VHotWatPri_flow_nominal=0.02,
    final maxLocDpPri=50000,
    final minLocDpPri=50000,
    final VHotWatSec_flow_nominal=1e-6,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={boiCapRat*boiDesCap*0.8,(1 - boiCapRat)*boiDesCap*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*boiCapRat*mRad_flow_nominal/2000,0.3*(1 - boiCapRat)*mRad_flow_nominal/2000},
    final maxFloSet={boiCapRat*mRad_flow_nominal/2000,(1 - boiCapRat)*mRad_flow_nominal/2000},
    final bypSetRat=0.000005,
    final nPumPri=1,
    final TMinSupNonConBoi=333.2,
    final k_bypVal=1,
    final Ti_bypVal=90,
    final Td_bypVal=10e-9,
    final boiDesFlo=boiPlaCon.maxFloSet,
    final k_priPum=0.1,
    final Ti_priPum=75,
    final Td_priPum=10e-9,
    final minPriPumSpeSta={0,0,0},
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boiler plant controller"
    annotation (Placement(transformation(extent={{-40,-34},{-20,34}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPID(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=10e-2,
    final Ti=300)
    "Radiator valve controller"
    annotation (Placement(transformation(extent={{50,100},{70,120}})));

  Buildings.Examples.BoilerPlant.Baseclasses.SimplifiedZoneWithRadiator zon(
    final Q_flow_nominal=4359751.36,
    final TRadSup_nominal=333.15,
    final TRadRet_nominal=323.15,
    final mRad_flow_nominal=96.323,
    dpRad_nominal(displayUnit="Pa") = 40000,
    final V=126016.35,
    final zonTheCap=6987976290)
    "Zone thermal model with radiator"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal(displayUnit="bar") = 20000,
    final dpFixed_nominal(displayUnit="bar") = 1000)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={44,38})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    final k=fill(true,2))
    "Constant boiler availability status"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}}),
        iconTransformation(extent={{-60,50},{-40,70}})));

  Modelica.Blocks.Sources.CombiTimeTable timTab(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=ModelicaServices.ExternalReferences.loadResource(
          "modelica://Buildings/Resources/Data/Examples/BoilerPlant/ClosedLoopTest.txt"),
    final columns={2,5},
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final table=[-6,0;8,10000;18,0],
    final timeScale=60)
    "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=0.05,
    final uHigh=0.1)
    "Check if radiator control valve opening is above threshold for enabling boiler plant"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=0.85,
    final uHigh=0.9)
    "Check if radiator control valve opening is above threshold for rasing HHW supply temperature"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=3)
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{150,20},{170,40}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1)
    "Convert to heating load"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=273.15)
    "Convert temperature to Kelvin"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

equation

  connect(con3.y, boiPlaCon.uBoiAva) annotation (Line(points={{-88,0},{-60,0},{-60,
          8},{-42,8}}, color={255,0,255}));

  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-100,60},{-80,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(weaBus.TDryBul, boiPlaCon.TOut) annotation (Line(
      points={{-80,60},{-72,60},{-72,26},{-42,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(boiPla.ySupTem, boiPlaCon.TSupPri) annotation (Line(points={{62,8},{100,
          8},{100,-68},{-68,-68},{-68,23},{-42,23}}, color={0,0,127}));

  connect(boiPla.yRetTem, boiPlaCon.TRetPri) annotation (Line(points={{62,5},{104,
          5},{104,-72},{-72,-72},{-72,20},{-42,20}}, color={0,0,127}));

  connect(boiPla.yHotWatDp, boiPlaCon.dpHotWatPri_rem) annotation (Line(points={
          {62,2},{108,2},{108,-76},{-76,-76},{-76,11},{-42,11}}, color={0,0,127}));

  connect(boiPla.VHotWat_flow, boiPlaCon.VHotWatPri_flow) annotation (Line(
        points={{62,-2},{112,-2},{112,-80},{-80,-80},{-80,17},{-42,17}}, color={
          0,0,127}));


  connect(boiPla.yBoiSta, boiPlaCon.uBoi) annotation (Line(points={{62,-5},{120,
          -5},{120,-88},{-88,-88},{-88,-17},{-42,-17}}, color={255,0,255}));

  connect(boiPla.yPumSta, boiPlaCon.uPriPum) annotation (Line(points={{62,-8},{124,
          -8},{124,-92},{-92,-92},{-92,-20},{-42,-20}}, color={255,0,255}));

  connect(boiPla.yHotWatIsoVal, boiPlaCon.uHotWatIsoVal) annotation (Line(
        points={{62,-11},{128,-11},{128,-96},{-96,-96},{-96,-26},{-42,-26}},
        color={0,0,127}));

  connect(conPID.y, hys.u) annotation (Line(points={{72,110},{78,110}},
                 color={0,0,127}));

  connect(conPID.y, hys1.u) annotation (Line(points={{72,110},{76,110},{76,30},{
          88,30}},
                color={0,0,127}));

  connect(booToInt1.y, boiPlaCon.TSupResReq) annotation (Line(points={{172,30},{
          184,30},{184,-104},{-54,-104},{-54,32},{-42,32}}, color={255,127,0}));

  connect(hys.y, booToInt.u)
    annotation (Line(points={{102,110},{158,110}}, color={255,0,255}));

  connect(hys1.y, booToInt1.u)
    annotation (Line(points={{112,30},{148,30}}, color={255,0,255}));

  connect(timTab.y[1], gai.u)
    annotation (Line(points={{-79,100},{-62,100}}, color={0,0,127}));

  connect(timTab.y[2], addPar.u) annotation (Line(points={{-79,100},{-70,100},{
          -70,120},{-42,120}}, color={0,0,127}));

  connect(addPar.y, conPID.u_s) annotation (Line(points={{-18,120},{40,120},{40,
          110},{48,110}},
                        color={0,0,127}));

  connect(booToInt.y, boiPlaCon.plaReq) annotation (Line(points={{182,110},{190,
          110},{190,-100},{-48,-100},{-48,29},{-42,29}}, color={255,127,0}));
  connect(boiPla.port_a, zon.port_b) annotation (Line(points={{57,14},{56,14},{56,
          60},{54,60}}, color={0,127,255}));
  connect(zon.TZon, conPID.u_m) annotation (Line(points={{62,70},{68,70},{68,90},
          {60,90},{60,98}}, color={0,0,127}));
  connect(gai.y, zon.QFlo) annotation (Line(points={{-38,100},{30,100},{30,70},{
          38,70}}, color={0,0,127}));
  connect(boiPla.yBypValPos, boiPlaCon.uBypValPos) annotation (Line(points={{62,
          11},{116,11},{116,-84},{-84,-84},{-84,-29},{-42,-29}}, color={0,0,127}));
  connect(boiPlaCon.yPla, boiPla.uPla) annotation (Line(points={{-18,18},{20,18},
          {20,12},{38,12}}, color={255,0,255}));
  connect(boiPlaCon.yPriPum, boiPla.uPumSta) annotation (Line(points={{-18,-6},{
          20,-6},{20,3},{38,3}}, color={255,0,255}));
  connect(boiPlaCon.yBoi, boiPla.uBoiSta)
    annotation (Line(points={{-18,10},{38,10},{38,9}}, color={255,0,255}));
  connect(boiPlaCon.TPlaHotWatSupSet, boiPla.TPlaHotWatSupSet) annotation (Line(
        points={{-18,14},{18,14},{18,-12},{38,-12}}, color={0,0,127}));
  connect(boiPlaCon.TBoiHotWatSupSet, boiPla.TBoiHotWatSupSet) annotation (Line(
        points={{-18,6},{10,6},{10,-9},{38,-9}}, color={0,0,127}));
  connect(boiPlaCon.yHotWatIsoVal, boiPla.uHotIsoVal)
    annotation (Line(points={{-18,2},{16,2},{16,6},{38,6}}, color={0,0,127}));
  connect(boiPlaCon.yPriPumSpe, boiPla.uPumSpe) annotation (Line(points={{-18,-10},
          {14,-10},{14,0},{38,0}}, color={0,0,127}));
  connect(boiPlaCon.yBypValPos, boiPla.uBypValSig) annotation (Line(points={{-18,
          -2},{6,-2},{6,-3},{38,-3}}, color={0,0,127}));
  connect(zon.TZon, boiPla.TZon) annotation (Line(points={{62,70},{68,70},{68,20},
          {30,20},{30,-6},{38,-6}}, color={0,0,127}));
  connect(boiPla.port_b, val.port_a)
    annotation (Line(points={{43,14},{44,14},{44,28}}, color={0,127,255}));
  connect(val.port_b, zon.port_a)
    annotation (Line(points={{44,48},{44,60},{46,60}}, color={0,127,255}));
  connect(conPID.y, val.y) annotation (Line(points={{72,110},{76,110},{76,86},{20,
          86},{20,38},{32,38}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model couples the boiler plant model for a primary-only, condensing boiler
plant with a headered variable pump 
<a href=\"modelica://Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant\">
Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant</a> with the boiler plant
controller <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller</a> developed
as per ASHRAE RP-1711, March 2020 draft.
</p>
</html>", revisions="<html>
<ul>
<li>
November 6, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-140},{200,
            140}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlant/ClosedLoopTest.mos"
        "Simulate and plot"),
    experiment(
      StartTime=518400,
      StopTime=691200,
      Interval=60,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoopTest;
