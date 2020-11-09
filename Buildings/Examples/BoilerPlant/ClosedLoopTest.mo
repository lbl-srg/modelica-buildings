within Buildings.Examples.BoilerPlant;
model ClosedLoopTest "Closed loop testing model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant boilerPlant
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
    final nPumSec_nominal=1,
    final VHotWatPri_flow_nominal=0.0006,
    final maxLocDpPri=4000,
    final minLocDpPri=4000,
    final VHotWatSec_flow_nominal=1e-6,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={15000*0.8,15000*0.8},
    final boiFirMin={0.2,0.3},
    final minFloSet={0.2*0.0003,0.3*0.0003},
    final maxFloSet={0.0003,0.0003},
    final bypSetRat=0.000005,
    final nPumPri=2,
    final TMinSupNonConBoi=333.2,
    final k_bypVal=1,
    final Ti_bypVal=50,
    final Td_bypVal=0,
    final boiDesFlo={0.0003,0.0003},
    final k_priPum=1,
    final Ti_priPum=90,
    final Td_priPum=3,
    final minPriPumSpeSta={0,0,0},
    final speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    "Boiler plant controller"
    annotation (Placement(transformation(extent={{-40,-20},{-20,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    final k=1)
    "Radiator isolation valve controller"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 21.11)
    "Zone temperature setpoint"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=+1.5,
    final k2=-1.5)
    "Compute difference between measured zone temperature and setpoint"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    final k=fill(true,2))
    "Constant boiler availability status"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

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
    annotation (Line(points={{-18,8.18182},{16,8.18182},{16,8},{40,8}},
                                                           color={255,0,255}));
  connect(controller.yHotWatIsoVal, boilerPlant.uHotIsoVal)
    annotation (Line(points={{-18,5.45455},{16,5.45455},{16,5},{40,5}},
                                                           color={0,0,127}));
  connect(controller.yBypValPos, boilerPlant.uBypValSig)
    annotation (Line(points={{-18,2.72727},{12,2.72727},{12,-4},{40,-4}},
                                                             color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{32,60},{48,60}}, color={0,0,127}));
  connect(conPID.y, boilerPlant.uRadIsoVal) annotation (Line(points={{72,60},{78,
          60},{78,34},{38,34},{38,-7},{40,-7}}, color={0,0,127}));
  connect(con.y, add2.u1) annotation (Line(points={{32,60},{34,60},{34,-44},{38,
          -44}}, color={0,0,127}));
  connect(reaToInt.u, add2.y)
    annotation (Line(points={{68,-50},{62,-50}}, color={0,0,127}));
  connect(reaToInt.y, controller.supResReq) annotation (Line(points={{92,-50},{96,
          -50},{96,-64},{-64,-64},{-64,19.0909},{-42,19.0909}},
                                                      color={255,127,0}));
  connect(boilerPlant.yZonTem, conPID.u_m) annotation (Line(points={{64,8},{80,8},
          {80,28},{60,28},{60,48}}, color={0,0,127}));
  connect(boilerPlant.yZonTem, add2.u2) annotation (Line(points={{64,8},{80,8},{
          80,-30},{30,-30},{30,-56},{38,-56}}, color={0,0,127}));
  connect(con3.y, controller.uBoiAva) annotation (Line(points={{-38,-50},{-30,-50},
          {-30,-30},{-60,-30},{-60,0},{-42,0}},               color={255,0,255}));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-70,60},{-50,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, controller.TOut) annotation (Line(
      points={{-50,60},{-28,60},{-28,40},{-72,40},{-72,16.3636},{-42,16.3636}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus.TDryBul, boilerPlant.TOutAir) annotation (Line(
      points={{-50,60},{-28,60},{-28,40},{8,40},{8,-8},{40,-8},{40,-10}},
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
  connect(controller.yPriPumSpe, boilerPlant.uPumSpe) annotation (Line(points={{-18,
          -2.72727},{4,-2.72727},{4,-1},{40,-1}},     color={0,0,127}));
  connect(boilerPlant.ySupTem, controller.TSupPri) annotation (Line(points={{64,4},{
          100,4},{100,-68},{-68,-68},{-68,13.6364},{-42,13.6364}},     color={0,
          0,127}));
  connect(boilerPlant.yRetTem, controller.TRetPri) annotation (Line(points={{64,0},{
          104,0},{104,-72},{-72,-72},{-72,10.9091},{-42,10.9091}},     color={0,
          0,127}));
  connect(boilerPlant.yHotWatDp, controller.dpHotWatPri_rem) annotation (Line(
        points={{64,-4},{108,-4},{108,-76},{-76,-76},{-76,2.72727},{-42,2.72727}},
        color={0,0,127}));
  connect(boilerPlant.VHotWat_flow, controller.VHotWatPri_flow) annotation (
      Line(points={{64,-8},{112,-8},{112,-80},{-80,-80},{-80,8.18182},{-42,8.18182}},
        color={0,0,127}));

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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlant/ClosedLoopTest.mos"
        "Simulate and plot"),
    experiment(
      StartTime=259200,
      StopTime=432000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoopTest;
