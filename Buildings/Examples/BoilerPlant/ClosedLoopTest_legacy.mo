within Buildings.Examples.BoilerPlant;
model ClosedLoopTest_legacy "Closed loop testing model"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Real TSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15+21.11
    "Temperature setpoint for zone";

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//

//------------------------------------------------------------------------------//
//--- Weather data -------------------------------------------------------------//
//------------------------------------------------------------------------------//

  Buildings.Examples.BoilerPlant.PlantModel.BoilerPlant_legacy
    boilerPlant(TRadRet_nominal=273.15 + 50)
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller controller(
    have_priOnl=true,
    have_heaPriPum=true,
    have_varPriPum=true,
    have_varSecPum=false,
    nSenPri=1,
    nPumPri_nominal=2,
    nPumSec=0,
    nSenSec=0,
    nPumSec_nominal=0,
    VHotWatPri_flow_nominal=0.0006,
    maxLocDpPri=4000,
    minLocDpPri=4000,
    VHotWatSec_flow_nominal=1e-6,
    nBoi=2,
    boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    nSta=3,
    staMat=[1,0; 0,1; 1,1],
    boiDesCap={15000*0.8,15000*0.8},
    boiFirMin={0.2,0.3},
    minFloSet={0.2*0.0003,0.3*0.0003},
    maxFloSet={0.0003,0.0003},
    bypSetRat=0.000005,
    nPumPri=2,
    TMinSupNonConBoi=333.2,
    k_bypVal=1,
    Ti_bypVal=50,
    Td_bypVal=10e-10,
    boiDesFlo={0.0003,0.0003},
    k_priPum=1,
    Ti_priPum=90,
    Td_priPum=3,
    minPriPumSpeSta={0,0,0},
    speConTypPri=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.PrimaryPumpSpeedControlTypes.remoteDP)
    annotation (Placement(transformation(extent={{-40,-20},{-20,20}})));

  Controls.OBC.CDL.Continuous.PID conPID(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
      k=1) annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=273.15 + 21.11)
    "Zone temperature setpoint"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Controls.OBC.CDL.Logical.Sources.Constant con3[2](k={true,true})
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
protected
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[-6,0; 8,10000; 18,0],
    timeScale=3600) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
equation

  connect(controller.yBoi, boilerPlant.uBoiSta)
    annotation (Line(points={{-18,8.18182},{16,8.18182},{16,6},{40,6}},
                                                           color={255,0,255}));
  connect(controller.yHotWatIsoVal, boilerPlant.uHotIsoVal)
    annotation (Line(points={{-18,5.45455},{16,5.45455},{16,3},{40,3}},
                                                           color={0,0,127}));
  connect(controller.yBypValPos, boilerPlant.uBypValSig)
    annotation (Line(points={{-18,2.72727},{12,2.72727},{12,-6},{40,-6}},
                                                             color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{32,60},{48,60}}, color={0,0,127}));
  connect(conPID.y, boilerPlant.uRadIsoVal) annotation (Line(points={{72,60},{78,
          60},{78,34},{38,34},{38,-9},{40,-9}}, color={0,0,127}));
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
      points={{-50,60},{-28,60},{-28,40},{8,40},{8,-20},{43,-20},{43,-12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(timTab.y[1], boilerPlant.QRooInt_flowrate)
    annotation (Line(points={{-8,80},{0,80},{0,9},{40,9}}, color={0,0,127}));
  connect(controller.yPriPum, boilerPlant.uPumSta)
    annotation (Line(points={{-18,0},{40,0}}, color={255,0,255}));
  connect(controller.yPriPumSpe, boilerPlant.uPumSpe) annotation (Line(points={{-18,
          -2.72727},{4,-2.72727},{4,-3},{40,-3}},     color={0,0,127}));
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
This part of the system model adds to the model that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
weather data, and it changes the control to PI control.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System6</code>.
</p>
</li>
<li>
<p>
Next, we added the weather data as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Weather.png\" border=\"1\"/>
</p>
<p>
The weather data reader is implemented using
</p>
<pre>
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=\"modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos\")
    \"Weather data reader\";
</pre>
<p>
The yellow icon in the middle of the figure is an instance of
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.Bus\">
Buildings.BoundaryConditions.WeatherData.Bus</a>.
This is required to extract the dry bulb temperature from the weather data bus.
</p>
<p>
Note that we changed the instance <code>TOut</code> from
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.FixedTemperature</a>
to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature</a>
in order to use the dry-bulb temperature as an input signal.
</p>
</li>
</ol>
<!-- ============================================== -->
<p>
This completes the closed loop control.
When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures1.png\" border=\"1\"/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures2.png\" border=\"1\"/>
</p>
<p>
The figure shows that the boiler temperature is regulated between
<i>70</i>&deg;C and
<i>90</i>&deg;C,
that
the boiler inlet temperature is above
<i>60</i>&deg;C,
and that the room temperature and the supply water temperature are
maintained at their set point.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Michael Wetter:<br/>
Added missing density to computation of air mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/673\">#673</a>.
</li>
<li>
July 2, 2015, by Michael Wetter:<br/>
Changed control input for <code>conPIDBoi</code> and set
<code>reverseActing=false</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valves as
this parameter no longer has a default value.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/BoilerPlant/ClosedLoopTest_legacy.mos"
        "Simulate and plot"),
    experiment(
      StartTime=259200,
      StopTime=432000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoopTest_legacy;
