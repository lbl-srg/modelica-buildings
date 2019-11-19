within Buildings.Controls.OBC.Utilities;
block OptimalStart
  "Block that outputs the optimal start time for an HVAC system"
  extends Modelica.Blocks.Icons.Block;
  parameter Real occupancy[:] = 3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time tOptMax = 10800
    "Maximum optimal start time";
  parameter Modelica.SIunits.Time tOptIni = tOptMax/2
    "Initial optimal start time";
  parameter Integer n = 3 "Number of previous days for averaging the temperature slope";
  parameter Boolean heating_only = false
    "Set to true if the HVAC system is heating only"
    annotation(Dialog(enable=not cooling_only));
  parameter Boolean cooling_only = false
    "Set to true if the HVAC system is cooling only"
    annotation(Dialog(enable=not heating_only));
  parameter Modelica.SIunits.TemperatureDifference uLow = 0
    "Temperature change hysteresis low parameter, should be a non-negative number";
  parameter Modelica.SIunits.TemperatureDifference uHigh = 1
    "Temperature change hysteresis high parameter, should be greater than uLow";
  CDL.Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not cooling_only
    "Zone heating setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-220,60},{-180,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone temperature" annotation (Placement(transformation(extent={{-220,
            -20},{-180,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) if not heating_only
    "Zone cooling setpoint temperature during occupancy" annotation (Placement(
        transformation(extent={{-220,-100},{-180,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Continuous.Add dTHea(k1=+1, k2=-1) if not cooling_only
    "Temperature difference between heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  CDL.Continuous.Add dTCoo(k1=+1, k2=-1) if not heating_only
    "Temperature difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  CDL.Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  CDL.Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  CDL.Continuous.Sources.Constant period(k=86400)
    "Period of optimal start calculation algorithm"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  CDL.Continuous.Sources.Constant staCal(k=occupancy[1] - tOptMax)
    "Start calculation"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  CDL.Continuous.Sources.Constant stoCal(k=occupancy[1]) "Stop calculation"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.BooleanOutput yStart
    "Boolean signal of optimal start duration" annotation (Placement(
        transformation(extent={{240,-80},{280,-40}}), iconTransformation(extent=
           {{100,-80},{140,-40}})));
  CDL.Interfaces.RealOutput tOpt "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{240,40},{280,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  BaseClasses.TemperatureSlope temSloHea(
    occupancy=occupancy,
    tOptMax=tOptMax,
    tOptIni=tOptIni,
    n=n,
    uLow=uLow,
    uHigh=uHigh) if not cooling_only
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  BaseClasses.TemperatureSlope temSloCoo(
    occupancy=occupancy,
    tOptMax=tOptMax,
    tOptIni=tOptIni,
    n=n,
    uLow=uLow,
    uHigh=uHigh) if not heating_only
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  CDL.Continuous.Sources.Constant maxStaTim(k=tOptMax)
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  CDL.Continuous.Min minHea if not cooling_only
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  CDL.Discrete.TriggeredSampler triSamHea if not cooling_only
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  CDL.Continuous.Division tOptHea if not cooling_only
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  CDL.Continuous.Division tOptCoo if not heating_only
    "Calculate optimal start time based on the averaged previous temperature slope"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  CDL.Discrete.TriggeredSampler triSamCoo if not heating_only
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  CDL.Continuous.Min minCoo if not heating_only
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{200,40},{220,60}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Sources.Constant con(k=false) if heating_only
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Continuous.Sources.Constant con2(k=0) if cooling_only
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  CDL.Logical.Sources.Constant con1(k=false) if cooling_only
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  CDL.Continuous.Sources.Constant con3(k=0) if heating_only
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
protected
    parameter Modelica.SIunits.TemperatureSlope temSloDef = 1/3600
    "Default temperature slope in case of zero division";
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-98,0},{-80,0},{-80,-20},{
          -62,-20}},     color={0,0,127}));
  connect(staCal.y, greEqu.u2) annotation (Line(points={{-98,-50},{-80,-50},{-80,
          -28},{-62,-28}},        color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-138,-30},{-134,-30},{-134,
          -6},{-122,-6}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-138,30},{-134,30},{-134,6},
          {-122,6}},        color={0,0,127}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-98,0},{-80,0},{-80,10},{-62,
          10}},             color={0,0,127}));
  connect(stoCal.y, lesEqu.u1) annotation (Line(points={{-98,50},{-80,50},{-80,18},
          {-62,18}},    color={0,0,127}));
  connect(dTHea.y, temSloHea.TDif) annotation (Line(points={{-78,100},{-20,100},
          {-20,66},{-2,66}},
                        color={0,0,127}));
  connect(dTCoo.y, temSloCoo.TDif) annotation (Line(points={{-78,-100},{-40,-100},
          {-40,-84},{-2,-84}},
                        color={0,0,127}));
  connect(greEqu.y, triSamHea.trigger) annotation (Line(points={{-38,-20},{110,-20},
          {110,58.2}}, color={255,0,255}));
  connect(lesEqu.y, temSloHea.StoCal) annotation (Line(points={{-38,18},{-12,18},
          {-12,53.2},{-2,53.2}}, color={255,0,255}));
  connect(lesEqu.y, temSloCoo.StoCal) annotation (Line(points={{-38,18},{-12,18},
          {-12,-96.8},{-2,-96.8}}, color={255,0,255}));
  connect(greEqu.y, temSloHea.StaCal) annotation (Line(points={{-38,-20},{-20,-20},
          {-20,60},{-2,60}}, color={255,0,255}));
  connect(greEqu.y, temSloCoo.StaCal) annotation (Line(points={{-38,-20},{-20,-20},
          {-20,-90},{-2,-90}}, color={255,0,255}));
  connect(temSloHea.TSlo, tOptHea.u2) annotation (Line(points={{22,64},{58,64}},
                           color={0,0,127}));
  connect(dTHea.y, tOptHea.u1) annotation (Line(points={{-78,100},{40,100},{40,76},
          {58,76}}, color={0,0,127}));
  connect(temSloCoo.TSlo, tOptCoo.u2)
    annotation (Line(points={{22,-86},{40,-86},{40,-96},{58,-96}},
                                                             color={0,0,127}));
  connect(dTCoo.y, tOptCoo.u1) annotation (Line(points={{-78,-100},{-40,-100},{-40,
          -68},{40,-68},{40,-84},{58,-84}},
                                   color={0,0,127}));
  connect(tOptHea.y, triSamHea.u) annotation (Line(points={{82,70},{98,70}},
                    color={0,0,127}));
  connect(tOptCoo.y, triSamCoo.u)
    annotation (Line(points={{82,-90},{98,-90}},color={0,0,127}));
  connect(triSamCoo.y, minCoo.u2) annotation (Line(points={{122,-90},{148,-90},{
          148,-96},{158,-96}},
                       color={0,0,127}));
  connect(triSamHea.y, minHea.u1) annotation (Line(points={{122,70},{146,70},{146,
          76},{158,76}}, color={0,0,127}));
  connect(maxStaTim.y, minHea.u2) annotation (Line(points={{142,-30},{152,-30},{
          152,64},{158,64}},
                         color={0,0,127}));
  connect(maxStaTim.y, minCoo.u1) annotation (Line(points={{142,-30},{152,-30},{
          152,-84},{158,-84}},
                         color={0,0,127}));
  connect(minHea.y, max.u1) annotation (Line(points={{182,70},{188,70},{188,56},
          {198,56}}, color={0,0,127}));
  connect(minCoo.y, max.u2) annotation (Line(points={{182,-90},{188,-90},{188,44},
          {198,44}}, color={0,0,127}));
  connect(or2.y, yStart) annotation (Line(points={{82,10},{210,10},{210,-60},{260,
          -60}},     color={255,0,255}));
  connect(TSetZonCoo, dTCoo.u2) annotation (Line(points={{-200,-80},{-170,-80},{
          -170,-106},{-102,-106}},
                               color={0,0,127}));
  connect(TZon, dTCoo.u1) annotation (Line(points={{-200,0},{-166,0},{-166,-94},
          {-102,-94}},
                     color={0,0,127}));
  connect(TZon, dTHea.u2) annotation (Line(points={{-200,0},{-166,0},{-166,94},{
          -102,94}}, color={0,0,127}));
  connect(TSetZonHea, dTHea.u1) annotation (Line(points={{-200,80},{-172,80},{-172,
          106},{-102,106}},
                          color={0,0,127}));
  connect(max.y, tOpt) annotation (Line(points={{222,50},{232,50},{232,60},{260,
          60}}, color={0,0,127}));
  connect(greEqu.y, triSamCoo.trigger) annotation (Line(points={{-38,-20},{-20,-20},
          {-20,-110},{110,-110},{110,-101.8}}, color={255,0,255}));
  connect(temSloHea.yStart, or2.u1) annotation (Line(points={{22,54},{40,54},{40,
          10},{58,10}}, color={255,0,255}));
  connect(temSloCoo.yStart, or2.u2) annotation (Line(points={{22,-96},{30,-96},{
          30,2},{58,2}}, color={255,0,255}));
  connect(con.y, or2.u2) annotation (Line(points={{22,-50},{30,-50},{30,2},{58,2}},
        color={255,0,255}));
  connect(con1.y, or2.u1)
    annotation (Line(points={{22,10},{58,10}}, color={255,0,255}));
  connect(con2.y, max.u1) annotation (Line(points={{182,110},{188,110},{188,56},
          {198,56}}, color={0,0,127}));
  connect(con3.y, max.u2) annotation (Line(points={{182,30},{188,30},{188,44},{198,
          44}}, color={0,0,127}));
   annotation (
defaultComponentName="optSta",
  Documentation(info="<html>
<p>
This block outputs the optimal start time each day for an HVAC system prior to the occupied time. 
The calculation is based on the concept of temperature slope, indicating the 
temperature change rate of a zone, with the unit <code>K/s</code>. The algorithm is described briefly 
in the steps blow.
</p>
<p>
<h4>Step 1: get sampled temperature difference <code>&Delta;T</code></h4>
Each day at a certain time before the occupancy, the algorithm takes a sample of the zone 
temperature. The sampling time is defined as occupancy start
time <code> - tOptMax</code>, where <code>tOptMax</code> denotes the maximum
optimal start time.
<p>
After getting the zone temperature at the sampling time, the difference <code>&Delta;T</code> between this zone 
temperature and the occupied zone setpoint is calculated.
</p>
</p>
<p>
<h4>Step 2: calculate temeperature slope <code>Ts</code></h4>
After the HVAC system is started, a timer is used to record how much time <code>&Delta;t</code> the zone temperature 
reaches the setpoint. When the time becomes greater than the maximum start time, the maximum start time is used.
The temperature slope is thus approximated using the equation: <code>Ts=&Delta;T/&Delta;t</code>. 
</p>
<p>
<h4>Step 3: calculate temperature slope moving average</h4>
After getting the temperature slope of each day, the moving average of the temperature slope <code>Ts_m</code> during the 
previous <code>n</code> days is calculated. 
</p>
<p>
<h4>Step 4: calculate optimal start time</h4>
The optimal start time is calculated using <code>&Delta;T</code> from Step 1 and the averaged temperature slope <code>Ts_m</code>
of the previous <code>n</code> days: <code>t_opt = &Delta;T/Ts_m</code>.
</p>
<p>
<h4>Initialization</h4>
During the initial day, the initial optimal start time parameter <code>tOptIni</code> is used.
</p>
<p>
<h4>Multiple zones</h4>
When there are multiple zones in the system, use the maximum zone temperature for cooling system and minimum zone temperature for 
heating system.
</p>
<h4>Validation</h4>
<p>
A validation can be found at
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Validation.OptimalStart\">
Buildings.Controls.OBC.CDL.Utilities.Validation.OptimalStart</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-180,-140},{240,140}})));
end OptimalStart;
