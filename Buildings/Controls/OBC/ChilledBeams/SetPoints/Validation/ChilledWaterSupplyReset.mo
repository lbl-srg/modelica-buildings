within Buildings.Controls.OBC.ChilledBeams.SetPoints.Validation;
model ChilledWaterSupplyReset
  "Validate chilled water request generation sequence"

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterSupplyReset
    chiWatSupRes
    "Testing low valve opening"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterSupplyReset
    chiWatSupRes1
    "Testing medium valve opening"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterSupplyReset
    chiWatSupRes2
    "Testing large valve opening"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.15)
    "Low valve openign signal"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0.55)
    "Medium valve opening signal"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1)
    "High valve opening signal"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600,
    final shift=1800)
    "Condensation sensor signal"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=3600,
    final shift=1800)
    "Condensation sensor signal"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final period=3600,
    final shift=1800)
    "Condensation sensor signal"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

equation

  connect(con.y, chiWatSupRes.uValPos) annotation (Line(points={{-68,70},{-60,70},
          {-60,54},{-42,54}}, color={0,0,127}));
  connect(con1.y, chiWatSupRes1.uValPos) annotation (Line(points={{32,70},{40,70},
          {40,54},{58,54}}, color={0,0,127}));
  connect(con2.y, chiWatSupRes2.uValPos) annotation (Line(points={{-68,-30},{-60,
          -30},{-60,-46},{-42,-46}}, color={0,0,127}));
  connect(booPul.y, chiWatSupRes.uConSen) annotation (Line(points={{-68,30},{-60,
          30},{-60,46},{-42,46}}, color={255,0,255}));
  connect(booPul1.y, chiWatSupRes1.uConSen) annotation (Line(points={{32,30},{40,
          30},{40,46},{58,46}}, color={255,0,255}));
  connect(booPul2.y, chiWatSupRes2.uConSen) annotation (Line(points={{-68,-70},{
          -60,-70},{-60,-54},{-42,-54}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SetPoints/Validation/ChilledWaterSupplyReset.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterSupplyReset\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterSupplyReset</a>.
</p>
It consists of three open-loop setup for blocks <code>chiWatSupRes</code>, <code>chiWatSupRes1</code>, and <code>chiWatSupRes2</code>.
Each block has the similar input and output signals, in which, for example, a constant Real input signal <code>ram</code> 
that is used to simulate Chilled water control valve position signal
(<code>chiWatSupRes.uValPos</code>), a Boolean pulse input signal that is used to simulate the condensation sensor signal, 
and two outputs signals (<code>chiWatSupRes.yChiWatSupReq</code> and <code>chiWatSupRes.TChiWatReq</code>)
that generate the number of requests for chilled water supply and its temperature setpoint reset, respectively. 
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
When the control valve position (<code>chiWatSupRes.uValPos=0.15</code>) is open greater than 
(<code>chiWatSupRes.valPosHigOpeReq=0.1</code>) for (<code>chiWatSupRes.thrTimLowReq=300</code>) continuously, 
one request (<code>chiWatSupRes.yChiWatSupReq=1</code>) is generated for chilled water supply. 
When the control valve position (<code>chiWatSupRes.uValPos=0.15</code>) is less than 
(<code>chiWatSupRes.valPosLowOpeTemRes=0.5</code>), no requests (<code>chiWatSupRes.TChiWatReq=0</code>) 
are generated for chilled water supply temperature setpoint reset. 
</li>
<li>
When the control valve position (<code>chiWatSupRes1.uValPos=0.55</code>) is open greater than 
(<code>chiWatSupRes1.valPosHigOpeReq=0.5</code>) for (<code>chiWatSupRes1.thrTimHigReq=60</code>) continuously, 
two requests (<code>chiWatSupRes1.yChiWatSupReq=2</code>) is generated for chilled water supply. 
When the control valve position (<code>chiWatSupRes1.uValPos=0.55</code>) is greater than 
(<code>chiWatSupRes1.valPosLowOpeTemRes=0.5</code>) and when (<code>chiWatSupRes1.uConSen=false<code>), one request 
(<code>chiWatSupRes1.TChiWatReq=1</code>) are generated for chilled water supply temperature setpoint reset. 
</li>
<li>
When the control valve position (<code>chiWatSupRes2.uValPos=1.0</code>) is open greater than 
(<code>chiWatSupRe2.valPosHigOpeReq=0.5</code>) for (<code>chiWatSupRes2.thrTimHigReq=60</code>) continuously, 
two requests (<code>chiWatSupRes2.yChiWatSupReq=2</code>) is generated for chilled water supply. 
When the control valve position (<code>chiWatSupRes2.uValPos=1.0</code>) is greater than 
(<code>chiWatSupRe2.valPosHigOpeTemRes=0.99</code>) and and when (<code>chiWatSupRes2.uConSen=false<code>), two requests 
(<code>chiWatSupRes2.TChiWatReq=2</code>) are generated for chilled water supply temperature setpoint reset. 
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2021, by Karthik Devaprasad:<br/>
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
end ChilledWaterSupplyReset;
