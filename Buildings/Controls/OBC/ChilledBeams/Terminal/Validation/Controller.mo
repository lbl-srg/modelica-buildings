within Buildings.Controls.OBC.ChilledBeams.Terminal.Validation;
model Controller
  "Validate zone temperature setpoint controller"

  parameter Integer nSchRow = 4
    "Number of rows in schedule table";

  parameter Real schTab[nSchRow,2] = [0,0; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.ChilledBeams.Terminal.Controller
    terCon(
    final VDes_occ=0.5,
    final VDes_unoccSch=0.1,
    final VDes_unoccUnsch=0.2)
    "Zone terminal controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  CDL.Continuous.GreaterThreshold greThr(t=0.5) "Covert Real signal to Boolean"
    annotation (Placement(transformation(extent={{-40,16},{-20,36}})));
  CDL.Continuous.Sources.TimeTable enaSch(
    table=schTab,
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    "Table defining when occupancy is expected"
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
protected
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.5,
    final freqHz=1/360,
    final offset=0.5)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-80,-94},{-60,-74}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.9,
    final period=1200)
    "Boolean step signal"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    final amplitude=5,
    final freqHz=1/720,
    final offset=295)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-80,-66},{-60,-46}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=4000)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));

protected
  CDL.Continuous.Sources.Constant                        con(final k=273.15 +
        22)
    "Zone occupied heating setpoint"
    annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
  CDL.Continuous.Sources.Constant                        con1(final k=273.15 +
        26)
    "Zone occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,56},{-42,56}}, color={255,0,255}));

  connect(sin1.y, terCon.TZon)
    annotation (Line(points={{-58,-56},{-20,-56},{-20,-4},{18.6,-4}},
                                              color={0,0,127}));
  connect(sin.y, terCon.VDis_flow) annotation (Line(points={{-58,-84},{0,-84},{0,
          -6},{18.6,-6}},
                        color={0,0,127}));
  connect(not1.y, terCon.uConSen) annotation (Line(points={{-18,56},{0,56},{0,-2},
          {18.6,-2}},
                   color={255,0,255}));
  connect(terCon.yChiVal, uniDel.u)
    annotation (Line(points={{41.4,4},{50,4},{50,0},{58,0}},
                                                           color={0,0,127}));
  connect(uniDel.y, terCon.uChiVal) annotation (Line(points={{82,0},{90,0},{90,-20},
          {10,-20},{10,-8},{18.6,-8}},
                                     color={0,0,127}));
  connect(terCon.TZonHeaSet, con.y)
    annotation (Line(points={{18.6,4},{18.6,4},{-34,4}},   color={0,0,127}));
  connect(con1.y, terCon.TZonCooSet) annotation (Line(points={{-34,-30},{-24,-30},
          {-24,2},{18.6,2},{18.6,2}},        color={0,0,127}));
  connect(terCon.uDetOcc, booPul1.y) annotation (Line(points={{18.6,8},{8,8},{8,
          84},{-58,84}}, color={255,0,255}));
  connect(greThr.u,enaSch. y[1])
    annotation (Line(points={{-42,26},{-58,26}},   color={0,0,127}));
  connect(terCon.uOcc, greThr.y) annotation (Line(points={{18.6,6},{-8,6},{-8,26},
          {-18,26}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=3600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/Terminal/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.Terminal.Controller\">
Buildings.Controls.OBC.ChilledBeams.Terminal.Controller</a>.
</p>
<p>
It consists of an open-loop setup for the terminal controller block <code>terCon</code>,
with boolean pulse signals <code>booPul1</code> and <code>booPul</code> for the 
detected occupancy input <code>terCon.uDetOcc</code> and the detected condensation signal
<code>terCon.uConSen</code>. It also has sinusoidal inputs <code>sin1</code> and <code>sin</code>
for the measured zone temperature input <code>terCon.TZon</code> and the measured terminal
discharge air flowrate <code>terCon.VDis_flow</code>. The chilled water valve position signal
<code>terCon.yChiVal</code> is captured using a unit delay block <code>uniDel</code> and 
is provided as input to the measured chilled water valve position input <code>terCon.uChiVal</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
Valve position signal <code>terCon.yChiVal</code> is increased from <code>0</code> whenever <code>terCon.TZon</code>
exceeds the zone cooling setpoint temperature <code>terCon.zonRegCon.TZonSet.TZonCooSet</code>.
It is reduced to <code>0</code> whenever <code>terCon.uConSen</code> becomes <code>true</code>
for duration <code>conSenOnThr</code>.
</li>
<li>
It also determines the number of chilled water supply requests 
<code>terCon.yChiWatSupReq</code> and temperature reset requests <code>terCon.TChiWatReq</code>.
<code>terCon.TChiWatReq</code> should be zero whenever <code>terCon.uConSen</code>
becomes <code>true</code> for duration <code>conSenOnThr</code>.
</li>
<li>
Terminal reheat signal <code>terCon.yReh</code> is increased from <code>0</code> 
whenever <code>terCon.TZon</code> falls below the zone heating setpoint temperature 
<code>terCon.zonRegCon.TZonSet.TZonHeaSet</code>.
</li>
<li>
Terminal damper position signal <code>terCon.yDam</code> is increased from <code>0</code>
whenever <code>terCon.VDis_flow</code> falls below the discharge air flowrate setpoint
<code>terCon.zonRegCon.mulSum.y</code>. It is changed to <code>1</code> whenever
<code>terCon.uConSen</code> becomes <code>true</code> for duration <code>conSenOnThr</code>.
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
end Controller;
