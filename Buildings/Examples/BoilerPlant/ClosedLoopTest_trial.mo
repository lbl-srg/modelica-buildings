within Buildings.Examples.BoilerPlant;
model ClosedLoopTest_trial "Closed loop testing model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Real boiCapRat = 0.5
    "Ratio of boiler-1 capacity to total capacity";

  Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant boilerPlant(boiCap1=(2 -
        boiCapRat)*15000, boiCap2=boiCapRat*15000)
    "Boiler plant model"
    annotation (Placement(transformation(extent={{42,-12},{62,12}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller(
    final have_priOnl=true,
    final have_heaPriPum=true,
    final have_varPriPum=true,
    final have_varSecPum=false,
    final nSenPri=1,
    final nPumPri_nominal=2,
    final nPumSec=0,
    final nSenSec=0,
    final nPumSec_nominal=0,
    TPlaHotWatSetMax=273.15 + 70,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4000,
    final minLocDpPri=4000,
    final VHotWatSec_flow_nominal=1e-6,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={boiCapRat*15000*0.8,(2 - boiCapRat)*15000*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*boiCapRat*0.0003,0.3*(2 - boiCapRat)*0.0003},
    final maxFloSet={boiCapRat*0.0003,(2 - boiCapRat)*0.0003},
    final bypSetRat=0.000005,
    final nPumPri=2,
    final TMinSupNonConBoi=333.2,
    final k_bypVal=1,
    final Ti_bypVal=50,
    final Td_bypVal=10e-9,
    final boiDesFlo={boiCapRat*0.0003,(2 - boiCapRat)*0.0003},
    final k_priPum=1,
    final Ti_priPum=90,
    final Td_priPum=3,
    final minPriPumSpeSta={0,0,0},
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boiler plant controller"
    annotation (Placement(transformation(extent={{-40,-34},{-20,34}})));

  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=0.01, uHigh=0.05)
    "Check if radiator control valve opening is above threshold for enabling boiler plant"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Controls.OBC.CDL.Logical.Timer tim(t=30) "Timer"
    annotation (Placement(transformation(extent={{110,100},{130,120}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{170,50},{190,70}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=0.85, uHigh=0.9)
    "Check if radiator control valve opening is above threshold for rasing HHW supply temperature"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
  Controls.OBC.CDL.Logical.Timer tim1(t=30) "Timer"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(integerTrue=3)
    annotation (Placement(transformation(extent={{150,20},{170,40}})));
  Controls.OBC.CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Controls.OBC.CDL.Logical.Timer tim2(t=30) "Timer"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{90,60},{110,80}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=10e-4,
    Ti=30)
    "Radiator isolation valve controller"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 21.11)
    "Zone temperature setpoint"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    final k=fill(true,2))
    "Constant boiler availability status"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[-6,0; 8,10000; 18,0],
    final timeScale=3600)
    "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

equation
  connect(controller.yBoi, boilerPlant.uBoiSta)
    annotation (Line(points={{-18,9},{16,9},{16,8},{40,8}},color={255,0,255}));
  connect(controller.yHotWatIsoVal, boilerPlant.uHotIsoVal)
    annotation (Line(points={{-18,6},{16,6},{16,5},{40,5}},color={0,0,127}));
  connect(controller.yBypValPos, boilerPlant.uBypValSig)
    annotation (Line(points={{-18,3},{12,3},{12,-4},{40,-4}},color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{32,60},{48,60}}, color={0,0,127}));
  connect(conPID.y, boilerPlant.uRadIsoVal) annotation (Line(points={{72,60},{76,
          60},{76,34},{38,34},{38,-7},{40,-7}}, color={0,0,127}));
  connect(boilerPlant.yZonTem, conPID.u_m) annotation (Line(points={{64,9},{80,
          9},{80,28},{60,28},{60,48}},
                                    color={0,0,127}));
  connect(con3.y, controller.uBoiAva) annotation (Line(points={{-88,0},{-60,0},
          {-60,8},{-42,8}},                                   color={255,0,255}));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-70,60},{-50,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, controller.TOut) annotation (Line(
      points={{-50,60},{-28,60},{-28,40},{-72,40},{-72,26},{-42,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus.TDryBul, boilerPlant.TOutAir) annotation (Line(
      points={{-50,60},{-28,60},{-28,40},{8,40},{8,-10},{40,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(timTab.y[1], boilerPlant.QRooInt_flowrate)
    annotation (Line(points={{-8,80},{0,80},{0,11},{40,11}},
                                                           color={0,0,127}));
  connect(controller.yPriPum, boilerPlant.uPumSta)
    annotation (Line(points={{-18,0},{4,0},{4,2},{40,2}},
                                              color={255,0,255}));
  connect(controller.yPriPumSpe, boilerPlant.uPumSpe) annotation (Line(points={{-18,-3},
          {4,-3},{4,-1},{40,-1}},                     color={0,0,127}));
  connect(boilerPlant.ySupTem, controller.TSupPri) annotation (Line(points={{64,6},{
          100,6},{100,-68},{-68,-68},{-68,23},{-42,23}},               color={0,
          0,127}));
  connect(boilerPlant.yRetTem, controller.TRetPri) annotation (Line(points={{64,3},{
          104,3},{104,-72},{-72,-72},{-72,20},{-42,20}},               color={0,
          0,127}));
  connect(boilerPlant.yHotWatDp, controller.dpHotWatPri_rem) annotation (Line(
        points={{64,0},{108,0},{108,-76},{-76,-76},{-76,11},{-42,11}},
        color={0,0,127}));
  connect(boilerPlant.VHotWat_flow, controller.VHotWatPri_flow) annotation (
      Line(points={{64,-3},{112,-3},{112,-80},{-80,-80},{-80,17},{-42,17}},
        color={0,0,127}));

  connect(boilerPlant.yBypValSig, controller.uBypValPos) annotation (Line(
        points={{64,12},{116,12},{116,-84},{-84,-84},{-84,-29},{-42,-29}},
        color={0,0,127}));
  connect(boilerPlant.yBoiSta, controller.uBoi) annotation (Line(points={{64,-6},
          {120,-6},{120,-88},{-88,-88},{-88,-17},{-42,-17}}, color={255,0,255}));
  connect(boilerPlant.yPumSta, controller.uPriPum) annotation (Line(points={{64,
          -9},{124,-9},{124,-92},{-92,-92},{-92,-20},{-42,-20}}, color={255,0,
          255}));
  connect(boilerPlant.yHotWatIsoVal, controller.uHotWatIsoVal) annotation (Line(
        points={{64,-12},{128,-12},{128,-96},{-96,-96},{-96,-26},{-42,-26}},
        color={0,0,127}));
  connect(conPID.y, hys.u) annotation (Line(points={{72,60},{76,60},{76,110},{78,
          110}}, color={0,0,127}));
  connect(hys.y, tim.u)
    annotation (Line(points={{102,110},{108,110}}, color={255,0,255}));
  connect(booToInt.y, controller.supResReq) annotation (Line(points={{192,60},{196,
          60},{196,-100},{-50,-100},{-50,29},{-42,29}}, color={255,127,0}));
  connect(conPID.y, hys1.u) annotation (Line(points={{72,60},{76,60},{76,30},{88,
          30}}, color={0,0,127}));
  connect(hys1.y, tim1.u)
    annotation (Line(points={{112,30},{118,30}}, color={255,0,255}));
  connect(tim1.passed, booToInt1.u) annotation (Line(points={{142,22},{146,22},{
          146,30},{148,30}}, color={255,0,255}));
  connect(booToInt1.y, controller.TSupResReq) annotation (Line(points={{172,30},
          {184,30},{184,-104},{-54,-104},{-54,32},{-42,32}}, color={255,127,0}));
  connect(booToInt.u, lat.y) annotation (Line(points={{168,60},{166,60},{166,110},
          {162,110}}, color={255,0,255}));
  connect(tim.passed, lat.u) annotation (Line(points={{132,102},{134,102},{134,110},
          {138,110}}, color={255,0,255}));
  connect(tim2.u, not1.y)
    annotation (Line(points={{118,70},{112,70}}, color={255,0,255}));
  connect(hys.y, not1.u) annotation (Line(points={{102,110},{104,110},{104,88},{
          84,88},{84,70},{88,70}}, color={255,0,255}));
  connect(tim2.passed, lat.clr) annotation (Line(points={{142,62},{150,62},{150,
          88},{136,88},{136,104},{138,104}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model couples the boiler plant model for a primary-only, condensing boiler
plant with headered variable pumps 
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
      StopTime=777600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-140,-140},{200,140}})));
end ClosedLoopTest_trial;
