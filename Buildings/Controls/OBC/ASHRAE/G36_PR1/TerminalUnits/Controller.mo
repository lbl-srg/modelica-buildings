within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block Controller "Controller for room VAV box"

  parameter Modelica.SIunits.Time samplePeriod
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate of this thermal zone";
  final parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal=
     m_flow_nominal / 1.2
    "Volume flow rate of this thermal zone";
  parameter Modelica.SIunits.Area zonAre "Area of the zone";
  parameter Real kPCoo=0.5
    "Proportional gain for cooling control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeatingLoop", group="Cooling loop"));
  parameter Modelica.SIunits.Time TiCoo=1800
    "Time constant of integrator block for cooling control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeatingLoop", group="Cooling loop"));
  parameter Real kPHea=0.5
    "Proportional gain for heating control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeatingLoop", group="Heating loop"));
  parameter Modelica.SIunits.Time TiHea=1800
    "Time constant of integrator block for heating control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeatingLoop", group="Heating loop"));
  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Zone sensors"));
  parameter Modelica.SIunits.VolumeFlowRate VCooMax=V_flow_nominal
    "Zone maximum cooling airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMin=0.15*V_flow_nominal
    "Zone minimum airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax=V_flow_nominal
    "Zone maximum heating airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon=0.1*V_flow_nominal
    "VAV box controllable minimum"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real outAirPerAre=3e-4
    "Outdoor air rate per unit area"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air rate per person"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Real CO2Set=894 "CO2 setpoint in ppm"
    annotation (Evaluate=true,
      Dialog(tab="Airflow setpoint", group="Nominal conditions"));
  parameter Modelica.SIunits.TemperatureDifference dTDisMax=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="Parameters"));
  parameter Modelica.SIunits.Temperature TDisMin=283.15
    "Lowest discharge air temperature"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="Parameters"));
  parameter Real kWatVal=0.5
    "Gain of controller for valve control"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="PID Controller"));
  parameter Modelica.SIunits.Time TiWatVal=300
    "Time constant of Integrator block for valve control"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="PID Controller"));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="PID Controller"));
  parameter Modelica.SIunits.Time TiDam=300
    "Time constant of Integrator block for damper control"
    annotation (Evaluate=true,
      Dialog(tab="Damper and valve", group="PID Controller"));
  parameter Boolean have_heaWatCoi=true
    "Flag, true if there is a hot water coil"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Boolean have_heaPla=false
    "Flag, true if there is a boiler plant"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_1=2.8
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 3 cooling SAT reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_2=1.7
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 2 cooling SAT reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_1=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_2=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Parameters"));
  parameter Modelica.SIunits.Time durTimTem=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimFlo=60
    "Duration time of airflow rate less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimDisAir=300
    "Duration time of discharge air temperature is less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="System requests", group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,130},{-100,170}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis(
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAHU(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Measured CO2 concentration"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    min=0,
    max=1,
    final unit="1")
    "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    min=0,
    max=1,
    final unit="1")
    "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,90},{120,110}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.Valves.HeatingAndCooling heaCoo(
    final kPCoo=kPCoo,
    final TiCoo=TiCoo,
    final kPHea=kPHea,
    final TiHea=TiHea)
    "Heating and cooling controller"
    annotation (Placement(transformation(extent={{-70,120},{-50,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet(
    final zonAre=zonAre,
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_CO2Sen=have_CO2Sen,
    final VCooMax=VCooMax,
    final VMin=VMin,
    final VHeaMax=VHeaMax,
    final VMinCon=VMinCon,
    final outAirPerAre=outAirPerAre,
    final outAirPerPer=outAirPerPer,
    final CO2Set=CO2Set)
    "Active airflow rate setpoint"
    annotation (Placement(transformation(extent={{-32,90},{-12,110}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves damVal(
    final kWatVal=kWatVal,
    final TiWatVal=TiWatVal,
    final kDam=kDam,
    final TiDam=TiDam,
    final dTDisMax=dTDisMax,
    final TDisMin=TDisMin) "Damper and valve controller"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests sysReq(
    final samplePeriod=samplePeriod,
    final have_heaWatCoi=have_heaWatCoi,
    final have_heaPla=have_heaPla,
    final cooSetDif_1=cooSetDif_1,
    final cooSetDif_2=cooSetDif_2,
    final disAirSetDif_1=disAirSetDif_1,
    final disAirSetDif_2=disAirSetDif_2,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final durTimDisAir=durTimDisAir)
    "Number of system requests"
    annotation (Placement(transformation(extent={{52,-62},{72,-42}})));

equation
  connect(sysReq.TCooSet, TRooCooSet)
    annotation (Line(points={{51,-43},{-78,-43},{-78,120},{-120,120}},
      color={0,0,127}));
  connect(sysReq.TRoo, TRoo)
    annotation (Line(points={{51,-45},{-40,-45},{-40,0},{-120,0}},
      color={0,0,127}));
  connect(sysReq.VDisSet, damVal.VDisSet) annotation (Line(points={{51,-50},{44,
          -50},{44,78},{31,78}},color={0,0,127}));
  connect(sysReq.VDis, VDis)
    annotation (Line(points={{51,-52},{24,-52},{24,-30},{-120,-30}},
      color={0,0,127}));
  connect(sysReq.TDisSet, damVal.TDisSet)
    annotation (Line(points={{51,-57},{42,-57},{42,62},{31,62}},
                                                             color={0,0,127}));
  connect(damVal.yDam, yDam) annotation (Line(points={{31,74},{80,74},{80,100},
          {110,100}}, color={0,0,127}));
  connect(damVal.yHeaVal, yVal) annotation (Line(points={{31,66},{80,66},{80,0},
          {110,0}}, color={0,0,127}));
  connect(damVal.VDis, VDis)
    annotation (Line(points={{24,57},{24,-30},{-120,-30}}, color={0,0,127}));
  connect(damVal.TDis, TDis)
    annotation (Line(points={{16,57},{16,-60},{-120,-60}}, color={0,0,127}));
  connect(sysReq.TDis, TDis)
    annotation (Line(points={{51,-59},{16,-59},{16,-60},{-120,-60}},
      color={0,0,127}));
  connect(sysReq.uDam, damVal.yDam)
    annotation (Line(points={{51,-54},{46,-54},{46,74},{31,74}},
                                                             color={0,0,127}));
  connect(damVal.yHeaVal, sysReq.uHeaVal)
    annotation (Line(points={{31,66},{40,66},{40,-61},{51,-61}},
                                                             color={0,0,127}));
  connect(TRoo, damVal.TRoo) annotation (Line(points={{-120,0},{-40,0},{-40,61},
          {9,61}}, color={0,0,127}));
  connect(damVal.TSup, TSupAHU) annotation (Line(points={{9,63},{-80,63},{-80,
          -90},{-120,-90}},
                       color={0,0,127}));
  connect(damVal.THeaSet, TRooHeaSet) annotation (Line(points={{9,65},{-80,65},
          {-80,150},{-120,150}}, color={0,0,127}));
  connect(damVal.uHea, heaCoo.yHea) annotation (Line(points={{9,67},{-40,67},{
          -40,134},{-49,134}},
                           color={0,0,127}));
  connect(damVal.uCoo, heaCoo.yCoo) annotation (Line(points={{9,69},{-42,69},{
          -42,126},{-49,126}},
                           color={0,0,127}));
  connect(actAirSet.VActCooMax, damVal.VActCooMax) annotation (Line(points={{-11,108},
          {0,108},{0,79},{9,79}},      color={0,0,127}));
  connect(actAirSet.VActCooMin, damVal.VActCooMin) annotation (Line(points={{-11,105},
          {-2,105},{-2,77},{9,77}},      color={0,0,127}));
  connect(actAirSet.VActMin, damVal.VActMin) annotation (Line(points={{-11,102},
          {-4,102},{-4,71},{9,71}}, color={0,0,127}));
  connect(actAirSet.VActHeaMin, damVal.VActHeaMin) annotation (Line(points={{-11,99},
          {-6,99},{-6,73},{9,73}},     color={0,0,127}));
  connect(actAirSet.VActHeaMax, damVal.VActHeaMax) annotation (Line(points={{-11,96},
          {-8,96},{-8,75},{9,75}},     color={0,0,127}));
  connect(heaCoo.TRooHeaSet, TRooHeaSet)
    annotation (Line(points={{-71,136},{-80,136},{-80,150},{-120,150}},
      color={0,0,127}));
  connect(heaCoo.TRooCooSet, TRooCooSet)
    annotation (Line(points={{-71,130},{-78,130},{-78,120},{-120,120}},
      color={0,0,127}));
  connect(heaCoo.TRoo, TRoo)
    annotation (Line(points={{-71,124},{-76,124},{-76,0},{-120,0}},
      color={0,0,127}));
  connect(actAirSet.uOpeMod, uOpeMod)
    annotation (Line(points={{-33,97},{-60,97},{-60,-120},{-120,-120}},
      color={255,127,0}));
  connect(sysReq.yZonTemResReq, yZonTemResReq)
    annotation (Line(points={{73,-45},{78,-45},{78,-60},{110,-60}},
      color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq)
    annotation (Line(points={{73,-50},{76,-50},{76,-100},{110,-100}},
      color={255,127,0}));
  connect(heaCoo.yCoo, sysReq.uCoo)
    annotation (Line(points={{-49,126},{-42,126},{-42,-47},{51,-47}},
      color={0,0,127}));
  connect(actAirSet.ppmCO2, ppmCO2)
    annotation (Line(points={{-33,106},{-64,106},{-64,90},{-120,90}},
      color={0,0,127}));
  connect(actAirSet.nOcc, nOcc)
    annotation (Line(points={{-33,102},{-56,102},{-56,60},{-120,60}},
      color={0,0,127}));
  connect(actAirSet.uWin, uWin)
    annotation (Line(points={{-33,93},{-52,93},{-52,30},{-120,30}},
      color={255,0,255}));

  connect(damVal.uOpeMod, uOpeMod) annotation (Line(points={{9,59},{-60,59},{
          -60,-120},{-120,-120}}, color={255,127,0}));
annotation (Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-26},{-70,-36}},
          lineColor={0,0,127},
          textString="TDis"),
        Text(
          extent={{-98,-46},{-68,-58}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{70,18},{98,4}},
          lineColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{68,70},{96,56}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-96,56},{-44,44}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-98,14},{-74,4}},
          lineColor={0,0,127},
          textString="VDis"),        Text(
        extent={{-120,160},{114,108}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-96,-4},{-74,-18}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-96,34},{-42,24}},
          lineColor={0,0,127},
          textString="TRooCooSet"),
        Text(
          extent={{-96,-64},{-48,-76}},
          lineColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-100,96},{-68,86}},
          lineColor={0,0,127},
          textString="nOcc"),
        Text(
          extent={{-94,78},{-56,60}},
          lineColor={0,0,127},
          textString="ppmCO2"),
        Text(
          extent={{-100,-82},{-64,-92}},
          lineColor={0,0,127},
          textString="uWin"),
        Text(
          extent={{22,-20},{96,-58}},
          lineColor={0,0,127},
          textString="yZonTemResReq"),
        Text(
          extent={{24,-62},{96,-96}},
          lineColor={0,0,127},
          textString="yZonPreResReq")}),
    Diagram(coordinateSystem(extent={{-100,-140},{100,160}})),
Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat according to ASHRAE 
Guideline 36, Part 5.E. It outputs damper position <code>yDam</code>,
hot water valve position <code>yVal</code>, AHU cooling supply temperature 
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>.
</p>
<p>The sequence consists of four subsequences. </p>
<h4>a. Heating and cooling control loop</h4>
<p>
The subsequence is implementd according to Part 5.B.5. The measured zone
temperature <code>TRoo</code>, zone setpoints temperatures <code>TRooHeaSet</code> and
<code>TRooCooSet</code> are inputs to the block to generate the control loop signal 
<code>yHea</code> and <code>yCoo</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.Valves.HeatingAndCooling\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.Valves.HeatingAndCooling</a>.
</p>
<h4>b. Active airflow setpoint calculation</h4>
<p>
This sequence sets the active maximum and minimum airflow according to 
Part 5.E.3-5. Depending on operation modes <code>uOpeMod</code>, it sets the 
airflow rate limits for cooling and heating supply. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit. 
The implementation is according to Part 5.E.6. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint 
<code>TDisSet</code>. Along with the defined maximum and minimum airflow, measured 
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VDisSet</code>.   
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Part 5.E.9, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset 
requests <code>yHeaValResReq</code>, and the boiler plant reset requests 
<code>yHeaPlaReq</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 27, 2017, by Jianjun Hu:<br/>
Moved it from example package.
</li>
<li>
September 25, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
