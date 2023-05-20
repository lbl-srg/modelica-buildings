within Buildings.Controls.OBC.ChilledBeams.SetPoints.Validation;
model ZoneRegulation
  "Validate zone regulation controller"

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneRegulation
    zonRegCon(
    final VDes_occ=0.5,
    final VDes_unoccSch=0.1,
    final VDes_unoccUnsch=0.2)
    "Zone temperature regulator"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=3,
    final duration=3600)
    "Ramp input signal"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(
    final amplitude=0.5,
    final freqHz=1/360,
    final offset=0.5)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-70,-58},{-50,-38}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.95,
    final period=1200)
    "Boolean step signal"
    annotation (Placement(transformation(extent={{-70,38},{-50,58}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-30,38},{-10,58}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin1(
    final amplitude=5,
    final freqHz=1/720,
    final offset=295)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-70,72},{-50,92}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15+22)
    "Zone occupied heating setpoint"
    annotation (Placement(transformation(extent={{-70,6},{-50,26}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15+26)
    "Zone occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-70,-26},{-50,-6}})));

equation
  connect(ram.y, reaToInt.u)
    annotation (Line(points={{-48,-80},{-42,-80}},
                                               color={0,0,127}));

  connect(reaToInt.y, zonRegCon.uOpeMod) annotation (Line(points={{-18,-80},{0,
          -80},{0,-8.33333},{18.3333,-8.33333}},
                           color={255,127,0}));

  connect(sin.y, zonRegCon.VDis_flow) annotation (Line(points={{-48,-48},{-16,
          -48},{-16,-5},{18.3333,-5}},
                          color={0,0,127}));

  connect(booPul.y, not1.u)
    annotation (Line(points={{-48,48},{-32,48}}, color={255,0,255}));

  connect(not1.y, zonRegCon.uConSen) annotation (Line(points={{-8,48},{10,48},{
          10,-1.66667},{18.3333,-1.66667}},
                      color={255,0,255}));

  connect(sin1.y, zonRegCon.TZon) annotation (Line(points={{-48,82},{14,82},{14,
          5},{18.3333,5}},
                      color={0,0,127}));

  connect(zonRegCon.TZonCooSet, con1.y) annotation (Line(points={{18.3333,
          1.66667},{-28,1.66667},{-28,-16},{-48,-16}},
                                color={0,0,127}));
  connect(zonRegCon.TZonHeaSet, con.y) annotation (Line(points={{18.3333,
          8.33333},{18.3333,8},{-28,8},{-28,16},{-48,16}},
                                           color={0,0,127}));
annotation (
  experiment(
      StopTime=3600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SetPoints/Validation/ZoneRegulation.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneRegulation\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneRegulation</a>.
</p>
<p>
It consists of an open-loop setup for block <code>zonRegCon</code> with
two sine input signals <code>sin1</code> and <code>sin1</code> that are used to simulated 
the measured zone temperature signal <code>zonRegCon.TZon</code> and measured discharge airflow rate signal 
<code>zonRegCon.VDis_flow</code>, respectively, 
a Boolean step input signal <code>booPul</code> that is used to simulate the signal from condensation sensor 
in zone <code>zonRegCon.uConSen</code>, two constant Real input sigals that are used to simulate 
the zone heating and cooling setpoint temperatures <code>zonRegCon.TZonHeaSet</code> and <code>zonRegCon.TZonCooSet</code>, respectively, 
and a ramp signal <code>ram</code> that generates Real integer signal and uses <code>reaToInt</code> 
to simulate the zone operation mode <code>zonRegCon.uOpeMod</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
The block <code>zonRegCon</code> generates the CAV reheat signal <code>zonRegCon.yReh</code> greater than 0 
when the measured zone temperature <code>zonRegCon.TZon</code> is below the zone heating setpoint <code>zonRegCon.TZonHeaSet</code>. 
</li>
<li>
The block <code>zonRegCon</code> generates the CAV damper position signal <code>zonRegCon.yDam</code> that is greater than 0 to 
adjust the supply air at volume flow rates <code>VDes_occ</code>, <code>VDes_unoccUnsch</code>, and <code>VDes_unoccSch</code>  
when the operating modes <code>zonRegCon.uOpeMod</code> are <code>occupied</code>, 
<code>unoccupiedUnscheduled</code>, and <code>unoccupiedScheduled</code>, respectively. 
</li>
<li>
The block <code>zonRegCon</code> generates the chilled beam control valve position <code>zonRegCon.yVal</code> greater than 0 
when the measured zone temperature <code>zonRegCon.TZon</code> is above the zone cooling setpoint <code>zonRegCon.TZonCooSet</code>. 
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ZoneRegulation;
