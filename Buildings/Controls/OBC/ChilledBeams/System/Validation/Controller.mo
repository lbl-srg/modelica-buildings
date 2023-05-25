within Buildings.Controls.OBC.ChilledBeams.System.Validation;
model Controller
  "Validate zone temperature setpoint controller"

  Buildings.Controls.OBC.ChilledBeams.System.Controller
    sysCon(
    final nPum=2,
    final nVal=3,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final dPChiWatMax=31000,
    final chiWatStaPreMax=30000,
    final chiWatStaPreMin=20000,
    final triAmoVal=-500,
    final resAmoVal=750,
    final maxResVal=1000,
    final samPerVal=30,
    final delTimVal=120)
    "System controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul[3](
    final width=fill(0.9, 3),
    final period=fill(3600, 3),
    final shift=fill(100, 3))
    "Real pulse source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin2(
    final amplitude=7500,
    final freqHz=1/1800,
    final offset=25000)
    "Sine signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(pul.y, sysCon.uValPos)
    annotation (Line(points={{-58,0},{-40,0},{-40,-6},{-12,-6}}, color={0,0,127}));
  connect(sysCon.yChiWatPum, pre1.u)
    annotation (Line(points={{12,6},{20,6},{20,0},{28,0}}, color={255,0,255}));
  connect(pre1.y, sysCon.uPumSta)
    annotation (Line(points={{52,0},{60,0},{60,50},{-20,50},{-20,6},{-12,6}},
      color={255,0,255}));

  connect(sin2.y, sysCon.dPChiWatLoo) annotation (Line(points={{-58,40},{-30,40},
          {-30,0},{-12,0}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/System/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.System.Controller\">
Buildings.Controls.OBC.ChilledBeams.System.Controller</a>.
</p>
<p>
It consists of an open-loop setup for the system controller <code>sysCon</code>
block, with a time-varying sinusoidal input <code>sin2</code> (varying between 
<code>17500 Pa</code> and <code>32500 Pa</code>) for the measured chilled water 
loop differential pressure <code>sysCon.dPChiWatLoo</code>, and a periodic pulse 
input <code>pul</code> for the measured chilled water valve 
position <code>sysCon.uValPos</code>. A logical pre block <code>pre1</code> is 
used to capture the pump enable output signal <code>sysCon.yChiWatPum</code> and 
provide it back as an input to the pump status signal <code>sysCon.uPumSta</code>. 
The trim-and-respond parameters for the chilled water static pressure setpoint 
reset in <code>sysCon</code> use nominal pressure <code>30000 Pa</code> and minimum 
pressure <code>20000 Pa</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
The lead pump enable signal <code>sysCon.yChiWatPum[1]</code> becomes <code>true</code>
when <code>sysCon.uValPos</code> changes to <code>1</code>. It becomes <code>false</code>
when <code>sysCon.uValPos</code> changes to <code>0</code>.
</li>
<li>
When <code>sysCon.dPChiWatLoo</code> falls below the calculated static pressure 
setpoint <code>sysCon.chiWatStaPreSetRes.yStaPreSetPoi</code>, an increase in pump 
speed output signal <code>sysCon.yPumSpe</code> is observed.
</li>
<li>
The lag pump enable signal <code>sysCon.yChiWatPum[2]</code> becomes <code>true</code> when 
<code>sysCon.yPumSpe</code> exceeds pump speed limit <code>sysCon.speLim1</code>
for duration <code>sysCon.timPer2</code>, and becomes <code>false</code> when it
falls below <code>sysCon.speLim2</code> for <code>sysCon.timPer3</code>.
</li>
<li>
The bypass valve position signal <code>sysCon.yBypValPos</code> becomes <code>0</code>
when <code>sysCon.yChiWatPum[1] == true</code> and is <code>1</code>
when <code>sysCon.yChiWatPum[1] == false</code>.
<code>sysCon.yBypValPos</code> is increased from <code>0</code> if <code>sysCon.yChiWatPum[1] == true</code>,
<code>sysCon.yPumSpe</code> is at minimum pump speed <code>sysCon.minPumSpe</code>
and <code>sysCon.dPChiWatLoo</code> exceeds maximum pressure allowed <code>sysCon.dPChiWatMax</code>.
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
