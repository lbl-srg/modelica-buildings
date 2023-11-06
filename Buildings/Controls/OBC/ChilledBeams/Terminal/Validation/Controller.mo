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
    annotation (Placement(transformation(extent={{20,-16},{40,16}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.5)
    "Convert Real signal to Boolean"
    annotation (Placement(transformation(extent={{-40,16},{-20,36}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when occupancy is expected"
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin1(
    final amplitude=10,
    final freqHz=1/720,
    final offset=297.15)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-80,-66},{-60,-46}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=4000)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15+22)
    "Zone occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15+26)
    "Zone occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,56},{-42,56}}, color={255,0,255}));

  connect(sin1.y, terCon.TZon)
    annotation (Line(points={{-58,-56},{-20,-56},{-20,-6},{18,-6}},
                                              color={0,0,127}));
  connect(sin.y, terCon.VDis_flow) annotation (Line(points={{-58,-84},{0,-84},{
          0,-10},{18,-10}},
                        color={0,0,127}));
  connect(not1.y, terCon.uConSen) annotation (Line(points={{-18,56},{0,56},{0,
          -2},{18,-2}},
                   color={255,0,255}));
  connect(terCon.yChiVal, uniDel.u)
    annotation (Line(points={{42,4},{50,4},{50,0},{58,0}}, color={0,0,127}));
  connect(uniDel.y, terCon.uChiVal) annotation (Line(points={{82,0},{90,0},{90,
          -20},{10,-20},{10,-14},{18,-14}},
                                     color={0,0,127}));
  connect(terCon.TZonHeaSet, con.y)
    annotation (Line(points={{18,6},{-40,6},{-40,0},{-58,0}},
                                                           color={0,0,127}));
  connect(con1.y, terCon.TZonCooSet) annotation (Line(points={{-58,-30},{-30,
          -30},{-30,2},{18,2}},              color={0,0,127}));
  connect(terCon.uOccDet, booPul1.y) annotation (Line(points={{18,14},{8,14},{8,
          84},{-58,84}}, color={255,0,255}));
  connect(greThr.u,enaSch. y[1])
    annotation (Line(points={{-42,26},{-58,26}},   color={0,0,127}));
  connect(terCon.uOccExp, greThr.y) annotation (Line(points={{18,10},{-8,10},{
          -8,26},{-18,26}},
                         color={255,0,255}));
annotation (
  experiment(
      StopTime=3600,
      Tolerance=1e-06),
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
Valve position signal <code>yChiVal</code> is used to maintain measured zone temperature
<code>TZon</code> at or below the zone cooling setpoint temperature <code>TZonCooSet</code>.
It is reduced to <code>0</code> whenever <code>uConSen</code> becomes <code>true</code>
for duration <code>conSenOnThr</code>.
</li>
<li>
It also determines the number of chilled water supply requests 
<code>yChiWatSupReq</code> and temperature reset requests <code>TChiWatReq</code>.
<code>TChiWatReq</code> becomes zero whenever <code>uConSen</code> becomes <code>true</code> 
for <code>conSenOnThr</code>.
</li>
<li>
Terminal reheat signal <code>yReh</code> is used to maintain <code>TZon</code> 
at or above the the zone heating setpoint temperature <code>TZonHeaSet</code>.
</li>
<li>
Terminal damper position signal <code>yDam</code> is used to maintain measured 
supply air flowrate <code>VDis_flow</code> at setpoint <code>terCon.zonRegCon.mulSum.y</code>. 
It is changed to <code>1</code> whenever <code>uConSen</code> becomes <code>true</code> 
for duration <code>conSenOnThr</code>.
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
