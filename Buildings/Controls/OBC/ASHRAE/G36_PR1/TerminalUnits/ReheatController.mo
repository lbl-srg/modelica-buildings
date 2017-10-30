within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block ReheatController
  "Controller for room VAV box according to ASHRAE Guideline 36"

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
      Dialog(tab="CoolingHeaingLoop", group="Cooling loop"));
  parameter Modelica.SIunits.Time TiCoo=1800
    "Time constant of integrator block for cooling control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeaingLoop", group="Cooling loop"));
  parameter Real kPHea=0.5
    "Proportional gain for heating control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeaingLoop", group="Heating loop"));
  parameter Modelica.SIunits.Time TiHea=1800
    "Time constant of integrator block for heating control loop"
    annotation (Evaluate=true,
      Dialog(tab="CoolingHeaingLoop", group="Heating loop"));
  parameter Boolean have_occSen=false
    "Set to true if the zone has occupancy sensor"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Zone sensors"));
  parameter Boolean have_winSen=false
    "Set to true if the zone has window status sensor"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Zone sensors"));
  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Zone sensors"));
  parameter Modelica.SIunits.VolumeFlowRate VCooMax=V_flow_nominal
    "Zone maximum cooling airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMin=0.15*V_flow_nominal
    "Zone minimum airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax=V_flow_nominal
    "Zone maximum heating airflow setpoint"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon=0.1*V_flow_nominal
    "VAV box controllable minimum"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Real outAirPerAre=3e-4
    "Outdoor air rate per unit area"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air rate per person"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Real CO2Set=894 "CO2 setpoint in ppm"
    annotation (Evaluate=true,
      Dialog(tab="AirflowSet", group="Nominal conditions"));
  parameter Modelica.SIunits.TemperatureDifference maxDTem=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Evaluate=true, Dialog(tab="DamperValveControl"));
  parameter Modelica.SIunits.Temperature minDisTem=283.15
    "Lowest discharge air temperature"
    annotation (Evaluate=true, Dialog(tab="DamperValveControl"));
  parameter Real kWatVal=0.5
    "Gain of controller for valve control"
    annotation (Evaluate=true,
      Dialog(tab="DamperValveControl", group="Controller parameters"));
  parameter Modelica.SIunits.Time TiWatVal=300
    "Time constant of Integrator block for valve control"
    annotation (Evaluate=true,
      Dialog(tab="DamperValveControl", group="Controller parameters"));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (Evaluate=true,
      Dialog(tab="DamperValveControl", group="Controller parameters"));
  parameter Modelica.SIunits.Time TiDam=300
    "Time constant of Integrator block for damper control"
    annotation (Evaluate=true,
      Dialog(tab="DamperValveControl", group="Controller parameters"));
  parameter Boolean have_heaWatCoi=true
    "Flag, true if there is a hot water coil"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Boolean have_heaPla=false
    "Flag, true if there is a boiler plant"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_1=2.8
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 3 cooling SAT reset requests"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Modelica.SIunits.TemperatureDifference cooSetDif_2=1.7
    "Limit value of difference between zone temperature and cooling setpoint
    for generating 2 cooling SAT reset requests"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_1=17
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 3 hot water reset requests"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Modelica.SIunits.TemperatureDifference disAirSetDif_2=8.3
    "Limit value of difference between discharge air temperature and its setpoint
    for generating 2 hot water reset requests"
    annotation (Evaluate=true, Dialog(tab="SystemRequests"));
  parameter Modelica.SIunits.Time durTimTem=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Evaluate=true,
      Dialog(tab="SystemRequests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimFlo=60
    "Duration time of airflow rate less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="SystemRequests", group="Duration times"));
  parameter Modelica.SIunits.Time durTimDisAir=300
    "Duration time of discharge air temperature is less than setpoint"
    annotation (Evaluate=true,
      Dialog(tab="SystemRequests", group="Duration times"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis(
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAHU(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    min=0,
    max=1,
    final unit="1")
    "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    min=0,
    max=1,
    final unit="1")
    "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}}),
      iconTransformation(extent={{100,-110},{120,-90}})));

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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValve conDamVal(
    final maxDTem=maxDTem,
    final minDisTem=minDisTem,
    final kWatVal=kWatVal,
    final TiWatVal=TiWatVal,
    final kDam=kDam,
    final TiDam=TiDam)
    "Damper and valve controller"
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
    annotation (Placement(transformation(extent={{52,0},{72,20}})));

equation
  connect(sysReq.TCooSet, TRooCooSet)
    annotation (Line(points={{51,19},{-78,19},{-78,90},{-120,90}},
      color={0,0,127}));
  connect(sysReq.TRoo, TRoo)
    annotation (Line(points={{51,17},{-40,17},{-40,10},{-120,10}},
      color={0,0,127}));
  connect(sysReq.VDisSet, conDamVal.VDisSet)
    annotation (Line(points={{51,12},{44,12},{44,78},{31,78}},
      color={0,0,127}));
  connect(sysReq.VDis, VDis)
    annotation (Line(points={{51,10},{-20,10},{-20,50},{-120,50}},
      color={0,0,127}));
  connect(sysReq.TDisSet, conDamVal.TDisSet)
    annotation (Line(points={{51,5},{42,5},{42,62},{31,62}},
      color={0,0,127}));
  connect(conDamVal.yDam, yDam)
    annotation (Line(points={{31,74},{80,74},{80,100},{110,100}},
      color={0,0,127}));
  connect(conDamVal.yHeaVal, yVal)
    annotation (Line(points={{31,66},{80,66},{80,0},{110,0}},
      color={0,0,127}));
  connect(conDamVal.VDis, VDis)
    annotation (Line(points={{24,59},{24,50},{-120,50}}, color={0,0,127}));
  connect(conDamVal.TDis, TDis)
    annotation (Line(points={{16,59},{16,-30},{-120,-30}}, color={0,0,127}));
  connect(sysReq.TDis, TDis)
    annotation (Line(points={{51,3},{-20,3},{-20,-30},{-120,-30}},
      color={0,0,127}));
  connect(sysReq.uDam, conDamVal.yDam)
    annotation (Line(points={{51,8},{46,8},{46,74},{31,74}},
      color={0,0,127}));
  connect(conDamVal.yHeaVal, sysReq.uHeaVal)
    annotation (Line(points={{31,66},{40,66},{40,1},{51,1}},
      color={0,0,127}));
  connect(TRoo, conDamVal.TRoo)
    annotation (Line(points={{-120,10},{-40,10},{-40,61},{9,61}},
      color={0,0,127}));
  connect(conDamVal.TSup, TSupAHU)
    annotation (Line(points={{9,63},{-80,63},{-80,-70},{-120,-70}},
      color={0,0,127}));
  connect(conDamVal.THeaSet, TRooHeaSet)
    annotation (Line(points={{9,65},{-80,65},{-80,130},{-120,130}},
      color={0,0,127}));
  connect(conDamVal.uHea,heaCoo. yHea)
    annotation (Line(points={{9,67},{-40,67},{-40,134},{-49,134}},
      color={0,0,127}));
  connect(conDamVal.uCoo,heaCoo. yCoo)
    annotation (Line(points={{9,69},{-42,69},{-42,126},{-49,126}},
      color={0,0,127}));
  connect(actAirSet.VActCooMax, conDamVal.VActCooMax)
    annotation (Line(points={{-11,108},{0,108},{0,79},{9,79}},
      color={0,0,127}));
  connect(actAirSet.VActCooMin, conDamVal.VActCooMin)
    annotation (Line(points={{-11,105},{-2,105},{-2,77},{9,77}},
      color={0,0,127}));
  connect(actAirSet.VActMin, conDamVal.VActMin)
    annotation (Line(points={{-11,102},{-4,102},{-4,71},{9,71}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMin, conDamVal.VActHeaMin)
    annotation (Line(points={{-11,99},{-6,99},{-6,73},{9,73}},
      color={0,0,127}));
  connect(actAirSet.VActHeaMax, conDamVal.VActHeaMax)
    annotation (Line(points={{-11,96},{-8,96},{-8,75},{9,75}},
      color={0,0,127}));
  connect(heaCoo.TRooHeaSet, TRooHeaSet)
    annotation (Line(points={{-71,136},{-80,136},{-80,130},{-120,130}},
      color={0,0,127}));
  connect(heaCoo.TRooCooSet, TRooCooSet)
    annotation (Line(points={{-71,130},{-78,130},{-78,90},{-120,90}},
      color={0,0,127}));
  connect(heaCoo.TRoo, TRoo)
    annotation (Line(points={{-71,124},{-76,124},{-76,10},{-120,10}},
      color={0,0,127}));
  connect(actAirSet.uOpeMod, uOpeMod)
    annotation (Line(points={{-33,97},{-60,97},{-60,-110},{-120,-110}},
      color={255,127,0}));
  connect(sysReq.yZonTemResReq, yZonTemResReq)
    annotation (Line(points={{73,17},{78,17},{78,-60},{110,-60}},
      color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq)
    annotation (Line(points={{73,12},{76,12},{76,-100},{110,-100}},
      color={255,127,0}));
  connect(heaCoo.yCoo, sysReq.uCoo)
    annotation (Line(points={{-49,126},{-42,126},{-42,16},{-42,15},{51,15}},
      color={0,0,127}));

annotation (Icon(coordinateSystem(extent={{-100,-140},{100,160}}),
        graphics={Rectangle(
        extent={{-100,-140},{100,160}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,-20},{-52,-38}},
          lineColor={0,0,127},
          textString="TDis"),
        Text(
          extent={{-94,-60},{-50,-80}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{54,12},{92,-10}},
          lineColor={0,0,127},
          textString="yVal"),
        Text(
          extent={{52,110},{92,88}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-92,142},{4,110}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-92,60},{-50,42}},
          lineColor={0,0,127},
          textString="VDis"),        Text(
        extent={{-154,204},{146,164}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-94,22},{-46,4}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-92,102},{0,80}},
          lineColor={0,0,127},
          textString="TRooCooSet"),
        Text(
          extent={{-92,-98},{-20,-122}},
          lineColor={0,0,127},
          textString="uOpeMod")}),
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
temperature <code>TRoo</code>, zone setpoints temperature <code>TRooHeaSet</code>,
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
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValve\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValve</a>.
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
end ReheatController;
