within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case600FF
  "Basic test with light-weight construction and free floating temperature"
  extends Modelica.Icons.Example;
  Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC
                zonHVAC(
    airRat=0.414,
    AWin={0,0,12,0},
    UWin=3.1,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.534,
    URoo=0.327,
    UFlo=0.0377,
    b=1,
    AFlo=48,
    VRoo=129.6,
    hInt=2.1,
    redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600Mass buiMas,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.789,
    coeFac={1,-0.189,0.644,-0.596},
    redeclare package Medium = Buildings.Media.Air)
                "Thermal zone"
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CO_Denver.Intl.AP.725650_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant intGai(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  MovingAverage TRooHou(delta=3600)
    "Continuous mean of room air temperature"
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  MovingAverage TRooAnn(delta=86400*365)
    "Continuous mean of room air temperature"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Constant latGai(k=0)   "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
protected

block MovingAverage "Block to output moving average"
  parameter Real delta(
    final quantity="Time",
    final unit="s",
    min=1E-5)
    "Time horizon over which the input is averaged";
  Modelica.Blocks.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  parameter Real tStart(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Start time";
  Real mu
    "Internal integrator variable";
  Real muDel
    "Internal integrator variable with delay";
  Boolean mode(
    start=false,
    fixed=true)
    "Calculation mode";

initial equation
  tStart=time;
  mu=0;

equation
  u=der(mu);
  muDel=delay(
    mu,
    delta);
  // Compute the mode so that Dymola generates
  // time and not state events as it would with
  // an if-then construct
  when time >= tStart+delta then
    mode=true;
  end when;
  if mode then
    y=(mu-muDel)/delta;
  else
    y=(mu-muDel)/(time-tStart+1E-3);
  end if;
  annotation (
    defaultComponentName="movAve",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-78,90},{-86,68},{-70,68},{-78,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,68},{-78,-80}},
          color={192,192,192}),
        Line(
          points={{-88,0},{70,0}},
          color={192,192,192}),
        Polygon(
          points={{92,0},{70,8},{70,-8},{92,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,-31},{-64,-31},{-64,-15},{-56,-15},{-56,-63},{-48,-63},
          {-48,-41},{-40,-41},{-40,43},{-32,43},{-32,11},{-32,11},{-32,-49},
          {-22,-49},{-22,-31},{-12,-31},{-12,-59},{-2,-59},{-2,23},{4,23},
          {4,37},{10,37},{10,-19},{20,-19},{20,-7},{26,-7},{26,-37},
          {36,-37},{36,35},{46,35},{46,1},{54,1},{54,-65},{64,-65}},
          color={215,215,215}),
        Line(
          points={{-78,-24},{68,-24}}),
        Text(
          extent={{-140,152},{160,112}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-42,-63},{41,-106}},
          textColor={192,192,192},
          textString="%delta s"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
This block outputs the mean value of its input signal as
</p>
<pre>
      1  t
y =   -  &int;   u(s) ds
      &delta;  t-&delta;
</pre>
<p>
where <i>&delta;</i> is a parameter that determines the time window over
which the input is averaged.
For
<i> t &lt; &delta;</i> seconds, it outputs
</P>
<pre>
           1      t
y =   --------    &int;   u(s) ds
      t-t<sub>0</sub>+10<sup>-10</sup>   t<sub>0</sub>
</pre>
<p>
where <i>t<sub>0</sub></i> is the initial time.
</p>
<p>
This block can for example be used to output the moving
average of a noisy measurement signal.
</p>
<p>
See
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Validation.MovingAverage\">
Buildings.Controls.OBC.CDL.Continuous.Validation.MovingAverage</a>
and
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Validation.MovingAverage_nonZeroStart\">
Buildings.Controls.OBC.CDL.Continuous.Validation.MovingAverage_nonZeroStart</a>
for example.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from MovingMean to MovingAverage.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
October 24, 2017, by Michael Wetter:<br/>
Set initial condition for <code>mu</code>.
</li>
<li>
October 17, 2017, by Michael Wetter:<br/>
Reformulated implementation to avoid direct feedthrough.
</li>
<li>
October 16, 2017, by Michael Wetter:<br/>
Reformulated implementation to handle division by zero as the previous
implementation caused division by zero in the VAV reheat model with the Radau solver.
</li>
<li>
September 27, 2017, by Thierry S. Nouidui:<br/>
Reformulated implementation to handle division by zero.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/978\">issue 978</a>.
</li>
<li>
September 15, 2017, by Thierry S. Nouidui:<br/>
Reformulated implementation to avoid state events.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Revised implementation to allow non-zero start time.
</li>
<li>
June 29, 2017, by Jianjun Hu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">issue 825</a>.
</li>
</ul>
</html>"));
end MovingAverage;


equation
  connect(weaDat.weaBus,zonHVAC. weaBus) annotation (Line(
      points={{-60,20},{10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));

  connect(intGai.y,zonHVAC. intSenGai) annotation (Line(points={{-59,-10},{-30,
          -10},{-30,10},{-16,10}},   color={0,0,127}));
  connect(zonHVAC.TAir, TRooHou.u)
    annotation (Line(points={{15,8},{58,8}}, color={0,0,127}));
  connect(TRooAnn.u,zonHVAC. TAir) annotation (Line(points={{58,50},{26,50},{26,
          8},{15,8}},    color={0,0,127}));
  connect(latGai.y, zonHVAC.intLatGai) annotation (Line(points={{-59,-50},{-24,
          -50},{-24,4},{-16,4}}, color={0,0,127}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case600FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 600FF of the BESTEST validation suite.
Case 600FF is a light-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html><ul>
<li>
May 2, 2024, by Alessandro Maccarini:<br/>
Updated according to ASHRAE 140-2020.
</li>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case600FF;
