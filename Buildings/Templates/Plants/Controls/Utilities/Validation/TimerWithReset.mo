within Buildings.Templates.Plants.Controls.Utilities.Validation;
model TimerWithReset
  "Validation model for the Timer block"
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset noThr
    "Timer that do not compare threshold – No Reset"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset thrTim(
    final t=0.3) "Timer that compares threshold – No Reset"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset thrTim1(
    final t=0.3) "Timer that compares threshold – No Reset"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.7,
    final period=2)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.7,
    final period=2,
    final shift=-1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant
                                                   con(k=false) "Constant"
    annotation (Placement(transformation(extent={{-40,-38},{-20,-18}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset noThrRes
    "Timer that do not compare threshold – With Reset"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset thrTimRes(final t=
        0.3) "Timer that compares threshold – With Reset"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset thrTim1Res(final t=
        0.3) "Timer that compares threshold – With Reset"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger
                                                   samTri(final period=1.5,
      shift=1.2) "Block that generates periodic reset signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold res(trueHoldDuration=0.01,
      falseHoldDuration=0) "Hold signal for plotting"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
equation
  connect(booPul.y,noThr.u)
    annotation (Line(points={{-18,20},{18,20}},color={255,0,255}));
  connect(booPul.y,thrTim.u)
    annotation (Line(points={{-18,20},{0,20},{0,-20},{18,-20}},color={255,0,255}));
  connect(booPul1.y,thrTim1.u)
    annotation (Line(points={{-18,-60},{18,-60}},color={255,0,255}));
  connect(con.y, noThr.reset) annotation (Line(points={{-18,-28},{10,-28},{10,
          12},{18,12}},
                    color={255,0,255}));
  connect(con.y, thrTim.reset) annotation (Line(points={{-18,-28},{18,-28}},
                     color={255,0,255}));
  connect(con.y, thrTim1.reset) annotation (Line(points={{-18,-28},{10,-28},{10,
          -68},{18,-68}},
                     color={255,0,255}));
  connect(samTri.y, noThrRes.reset) annotation (Line(points={{-18,60},{60,60},{
          60,32},{68,32}}, color={255,0,255}));
  connect(booPul.y, noThrRes.u) annotation (Line(points={{-18,20},{0,20},{0,40},
          {68,40}}, color={255,0,255}));
  connect(booPul.y, thrTimRes.u) annotation (Line(points={{-18,20},{0,20},{0,0},
          {70,0}}, color={255,0,255}));
  connect(samTri.y, thrTimRes.reset) annotation (Line(points={{-18,60},{60,60},
          {60,-8},{70,-8}}, color={255,0,255}));
  connect(samTri.y, thrTim1Res.reset) annotation (Line(points={{-18,60},{60,60},
          {60,-48},{68,-48}}, color={255,0,255}));
  connect(booPul1.y, thrTim1Res.u) annotation (Line(points={{-18,-60},{0,-60},{
          0,-40},{68,-40}}, color={255,0,255}));
  connect(samTri.y, res.u) annotation (Line(points={{-18,60},{60,60},{60,80},{
          68,80}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/TimerWithReset.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.TimerWithReset\">
Buildings.Templates.Plants.Controls.Utilities.TimerWithReset</a>.
</p>
</html>",
      revisions="<html>
      <ul>
      <li>
March 29, 2024, by Antoine Gautier:<br/>
Updated implementation to reset timer with boolean input.
</li>
<li>
July 23, 2018, by Jianjun Hu:<br/>
Updated implementation to reset accumulate timer with boolean input.
</li>
<li>
July 18, 2018, by Jianjun Hu:<br/>
Updated implementation to include accumulate timer.
</li>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TimerWithReset;
