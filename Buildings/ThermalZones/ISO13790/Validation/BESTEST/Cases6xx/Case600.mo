within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case600
  "Case 600FF, but with dual-setpoint for heating and cooling"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)
    "Sum of heating and cooling heat flow rate"
    annotation (
    Placement(visible = true, transformation(extent={{54,56},{62,64}},      rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(visible=true, transformation(extent={{68,54},{80,66}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(visible=true,
        transformation(
        origin={22,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Buildings.Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) "Controller for heating"
    annotation (Placement(visible=true, transformation(
        origin={0,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable
                                   TSetHea(table=[0.0,273.15 + 20])
    "Setpoint for heating"
    annotation (Placement(
        visible=true, transformation(
        origin={-24,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2
    annotation (
    Placement(visible = true, transformation(extent={{38,56},{46,64}},      rotation = 0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) "Gain for cooling"
    annotation (Placement(visible=true,
        transformation(
        origin={22,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Buildings.Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    reverseActing=false,
    strict=true) "Controller for cooling"
    annotation (Placement(visible=true, transformation(
        origin={0,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Continuous.Integrator ECoo(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J", displayUnit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{54,34},{66,46}})));
  Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC
                zonHVAC(
    airRat=0.414,
    AWin={0,0,12,0},
    UWin=3.1,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.53,
    URoo=0.33,
    UFlo=0.038,
    b=1,
    AFlo=48,
    VRoo=129.6,
    hInt=2.1,
    redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600Mass buiMas,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.769,
    coeFac={1,-0.189,0.644,-0.596},
    redeclare package Medium = Buildings.Media.Air)
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));

  Modelica.Blocks.Sources.Constant intGai(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CO_Denver.Intl.AP.725650_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J", displayUnit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{54,74},{66,86}})));
  MovingAverage PHea(delta=3600)
    "Hourly averaged heating power"
    annotation (Placement(transformation(extent={{34,84},{42,92}})));
  MovingAverage PCoo(delta=3600) "Hourly averaged cooling power"
    annotation (Placement(transformation(extent={{38,22},{46,30}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetCoo(table=[0.0,273.15 + 27])
    "Setpoint for cooling" annotation (Placement(visible=true, transformation(
        origin={-24,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant latGai(k=0) "Internal heat gains"
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

protected
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
  connect(sumHeaCoo.y,preHeaCoo. Q_flow)
    annotation (Line(points={{62.4,60},{68,60}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{6.6,72},{14.8,72}}, color={0,0,127}));
  connect(multiplex2.y,sumHeaCoo. u) annotation (
    Line(points={{46.4,60},{53.2,60}},      color = {0, 0, 127}));
  connect(conCooPID.y,gaiCoo. u)
    annotation (Line(points={{6.6,46},{14.8,46}}, color={0,0,127}));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(points={{28.6,72},{32,72},
          {32,62},{38,62},{38,62.4},{37.2,62.4}},
                            color={0,0,127}));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(points={{28.6,46},{32,46},
          {32,58},{38,58},{38,57.6},{37.2,57.6}},
                            color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{14.8,46},{6.6,46}}, color={0,0,127}));
  connect(ECoo.u, gaiCoo.y) annotation (Line(points={{52.8,40},{44,40},{44,46},
          {28.6,46}}, color={0,0,127}));

  connect(preHeaCoo.port,zonHVAC. heaPorAir) annotation (Line(points={{80,60},{
          90,60},{90,4},{4,4},{4,8}}, color={191,0,0}));
  connect(intGai.y,zonHVAC. intSenGai) annotation (Line(points={{-59,-10},{-30,
          -10},{-30,10},{-16,10}},   color={0,0,127}));
  connect(weaDat.weaBus,zonHVAC. weaBus) annotation (Line(
      points={{-60,20},{10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
  connect(zonHVAC.TAir, conCooPID.u_m) annotation (Line(points={{15,8},{20,8},{
          20,30},{0,30},{0,38.8}}, color={0,0,127}));
  connect(zonHVAC.TAir, conHeaPID.u_m) annotation (Line(points={{15,8},{20,8},{
          20,30},{-40,30},{-40,60},{0,60},{0,64.8}}, color={0,0,127}));
  connect(EHea.u, gaiHea.y) annotation (Line(points={{52.8,80},{44,80},{44,72},
          {28.6,72}}, color={0,0,127}));
  connect(TSetHea.y[1], conHeaPID.u_s)
    annotation (Line(points={{-17.4,72},{-7.2,72}}, color={0,0,127}));
  connect(TSetCoo.y[1], conCooPID.u_s)
    annotation (Line(points={{-17.4,46},{-7.2,46}}, color={0,0,127}));
  connect(gaiCoo.y, PCoo.u) annotation (Line(points={{28.6,46},{32,46},{32,26},
          {37.2,26}}, color={0,0,127}));
  connect(PHea.u, gaiHea.y) annotation (Line(points={{33.2,88},{28.6,88},{28.6,
          72}}, color={0,0,127}));
  connect(latGai.y, zonHVAC.intLatGai) annotation (Line(points={{-59,-50},{-24,
          -50},{-24,4},{-16,4}}, color={0,0,127}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case600.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 600 of the BESTEST validation suite. 
Case 600 is a light-weight building with room temperature control set to <i>20</i>&deg;C 
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south. 
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
end Case600;
