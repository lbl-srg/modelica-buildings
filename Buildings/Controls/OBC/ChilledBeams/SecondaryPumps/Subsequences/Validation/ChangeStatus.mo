within Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Validation;
model ChangeStatus
  "Validate sequence for changing pump status"

  Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.ChangeStatus
    chaPumSta(
    final nPum=3)
    "Scenario testing pump status changer"
    annotation (Placement(transformation(extent={{60,-10},{82,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Pre pre[3](
    final pre_u_start=fill(false, 3))
    "Logical pre block"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    final period=5,
    final shift=1)
    "Sample trigger"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt
    "Boolean True pulse counter"
    annotation (Placement(transformation(extent={{-100,-6},{-88,6}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=3)
    "Switch pump staging to staging-down after 3 pump stage-ups"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Logical switch"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract subInt
    "Generate stage setpoints for staging down processes"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=7)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

equation

  connect(samTri.y, onCouInt.trigger)
    annotation (Line(points={{-108,0},{-101.2,0}}, color={255,0,255}));

  connect(onCouInt.y, intGreThr.u)
    annotation (Line(points={{-86.8,0},{-82,0}}, color={255,127,0}));

  connect(onCouInt.y, chaPumSta.uNexLagPum) annotation (Line(points={{-86.8,0},{
          -84,0},{-84,-20},{20,-20},{20,-4},{57.8,-4}},color={255,127,0}));

  connect(samTri.y, logSwi1.u1) annotation (Line(points={{-108,0},{-106,0},{-106,
          28},{-42,28}}, color={255,0,255}));

  connect(samTri.y, logSwi.u3) annotation (Line(points={{-108,0},{-106,0},{-106,
          42},{-42,42}}, color={255,0,255}));

  connect(intGreThr.y, logSwi1.u2) annotation (Line(points={{-58,0},{-54,0},{-54,
          20},{-42,20}}, color={255,0,255}));

  connect(con.y, logSwi.u1) annotation (Line(points={{-108,80},{-50,80},{-50,58},
          {-42,58}}, color={255,0,255}));

  connect(con.y, logSwi1.u3) annotation (Line(points={{-108,80},{-50,80},{-50,12},
          {-42,12}}, color={255,0,255}));

  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-58,0},{-54,0},{-54,
          50},{-42,50}}, color={255,0,255}));

  connect(logSwi1.y, not1.u)
    annotation (Line(points={{-18,20},{-12,20}}, color={255,0,255}));

  connect(not1.y, chaPumSta.uLasLagPumSta) annotation (Line(points={{12,20},{30,
          20},{30,4},{57.8,4}},
                              color={255,0,255}));

  connect(logSwi.y, chaPumSta.uNexLagPumSta) annotation (Line(points={{-18,50},{
          50,50},{50,8},{57.8,8}},color={255,0,255}));

  connect(subInt.y, chaPumSta.uLasLagPum) annotation (Line(points={{-18,-40},{52,
          -40},{52,-8},{57.8,-8}},  color={255,127,0}));

  connect(con.y, onCouInt.reset) annotation (Line(points={{-108,80},{-104,80},{-104,
          -14},{-94,-14},{-94,-7.2}}, color={255,0,255}));

  connect(pre.y, chaPumSta.uChiWatPum) annotation (Line(points={{112,0},{120,0},
          {120,20},{40,20},{40,0},{57.8,0}},
                                           color={255,0,255}));

  connect(chaPumSta.yChiWatPum, pre.u)
    annotation (Line(points={{84.2,0},{88,0}},
                                             color={255,0,255}));

  connect(conInt.y,subInt. u1) annotation (Line(points={{-78,-50},{-60,-50},{-60,
          -34},{-42,-34}}, color={255,127,0}));
  connect(onCouInt.y,subInt. u2) annotation (Line(points={{-86.8,0},{-84,0},{-84,
          -30},{-50,-30},{-50,-46},{-42,-46}}, color={255,127,0}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SecondaryPumps/Subsequences/Validation/ChangeStatus.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.ChangeStatus\">
Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.ChangeStatus</a>.
</p>
<p>
It consists of an open-loop setup for block <code>chaPumSta</code> that changes the status of pumps, with
a constant Boolean input <code>con</code> that generates constant Boolean false signal, a sample trigger input block <code>samTri</code> 
that generates a sample trigger signal with a period of 5 seconds and a shift time of 1 second, 
and a constant integer input <code>conInt</code> that generates a constant output value of 7. 
A logical pre block <code>pre</code> is used to capture the pump enable output signal <code>chaPumSta.yChiWatPum</code> and provide it 
back as an input to the pump status signal <code>chaPumSta.uChiWatPum</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
The lead pump enable signal <code>chaPumSta.yChiWatPum[1]</code> becomes <code>true</code>
when <code>chaPumSta.uNexLagPum</code> changes from <code>0</code> to <code>1</code> and 
<code>chaPumSta.uLasLagPum</code> changes from <code>7</code> to <code>6</code>. 
It becomes <code>false</code>
when <code>chaPumSta.uNexLagPum</code> changes from <code>5</code> to <code>6</code> and
<code>chaPumSta.uLasLagPum</code> changes from <code>2</code> to <code>1</code>.
</li>
<li>
The lag pump enable signal <code>chaPumSta.yChiWatPum[2]</code> becomes <code>true</code>  
when <code>chaPumSta.uNexLagPum</code> changes from <code>1</code> to <code>2</code> and 
<code>chaPumSta.uLasLagPum</code> changes from <code>6</code> to <code>5</code>. 
It becomes <code>false</code>
when <code>chaPumSta.uNexLagPum</code> changes from <code>4</code> to <code>5</code> and
<code>chaPumSta.uLasLagPum</code> changes from <code>3</code> to <code>2</code>.
</li>
<li>
The lag pump enable signal <code>chaPumSta.yChiWatPum[3]</code> becomes <code>true</code>  
when <code>chaPumSta.uNexLagPum</code> changes from <code>2</code> to <code>3</code> and 
<code>chaPumSta.uLasLagPum</code> changes from <code>5</code> to <code>4</code>. 
It becomes <code>false</code>
when <code>chaPumSta.uNexLagPum</code> changes from <code>3</code> to <code>4</code> and
<code>chaPumSta.uLasLagPum</code> changes from <code>4</code> to <code>3</code>.
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
August 19, 2020, by Karthik Devaprasad:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})));
end ChangeStatus;
