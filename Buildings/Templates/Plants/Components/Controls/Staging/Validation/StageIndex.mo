within Buildings.Templates.Plants.Components.Controls.Staging.Validation;
model StageIndex
  parameter Integer nSta=4
    "Number of stages"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ena(
    width=0.8,
    period=100,
    shift=10)
    "Enable signal"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Templates.Plants.Components.Controls.Staging.StageIndex idxSta(final
      nSta=nSta)
    "Compute stage index - No minimum runtime, all stages available"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger up(period=20)
    "Staging up signal"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger dow(period=70)
           "Staging down signal"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava[nSta](k=fill(true,
        nSta)) "Stage available signal"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Templates.Plants.Components.Controls.Staging.StageIndex idxStaUna(final
      nSta=nSta)
    "Compute stage index - No minimum runtime, some unavailable stages"
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava1[nSta](k={true,false,false,
        true}) "Stage available signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Templates.Plants.Components.Controls.Staging.StageIndex idxStaRun(final
      nSta=nSta, tSta=25)
    "Compute stage index - Minimum runtime, all stages available"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Templates.Plants.Components.Controls.Staging.StageIndex idxStaRunUna(final
      nSta=nSta, tSta=25)
    "Compute stage index - Minimum runtime, some unavailable stages"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
equation
  connect(ena.y, idxSta.u1Lea) annotation (Line(points={{-48,60},{-30,60},{-30,
          66},{18,66}}, color={255,0,255}));
  connect(up.y, idxSta.u1Up) annotation (Line(points={{-48,20},{-10,20},{-10,62},
          {18,62}},
                color={255,0,255}));
  connect(dow.y, idxSta.u1Dow) annotation (Line(points={{-48,-20},{-10,-20},{-10,
          58},{18,58}},
                    color={255,0,255}));
  connect(ava.y, idxSta.u1Ava) annotation (Line(points={{-48,-60},{-6,-60},{-6,54},
          {18,54}}, color={255,0,255}));
  connect(ena.y, idxStaUna.u1Lea) annotation (Line(points={{-48,60},{-18,60},{-18,
          36},{60,36}}, color={255,0,255}));
  connect(up.y, idxStaUna.u1Up) annotation (Line(points={{-48,20},{2,20},{2,32},
          {60,32}},color={255,0,255}));
  connect(dow.y, idxStaUna.u1Dow) annotation (Line(points={{-48,-20},{2,-20},{2,
          28},{60,28}}, color={255,0,255}));
  connect(ena.y, idxStaRun.u1Lea) annotation (Line(points={{-48,60},{-10,60},{-10,
          -24},{18,-24}}, color={255,0,255}));
  connect(up.y, idxStaRun.u1Up) annotation (Line(points={{-48,20},{0,20},{0,-28},
          {18,-28}},      color={255,0,255}));
  connect(dow.y, idxStaRun.u1Dow) annotation (Line(points={{-48,-20},{-10,-20},{
          -10,-32},{18,-32}},
                          color={255,0,255}));
  connect(ava.y, idxStaRun.u1Ava) annotation (Line(points={{-48,-60},{-6,-60},{-6,
          -36},{18,-36}}, color={255,0,255}));
  connect(ava1.y, idxStaUna.u1Ava) annotation (Line(points={{-18,-80},{50,-80},{
          50,24},{60,24}}, color={255,0,255}));
  connect(ena.y, idxStaRunUna.u1Lea) annotation (Line(points={{-48,60},{-20,60},
          {-20,-54},{58,-54}}, color={255,0,255}));
  connect(up.y, idxStaRunUna.u1Up) annotation (Line(points={{-48,20},{0,20},{0,-58},
          {58,-58}}, color={255,0,255}));
  connect(dow.y, idxStaRunUna.u1Dow) annotation (Line(points={{-48,-20},{0,-20},
          {0,-62},{58,-62}}, color={255,0,255}));
  connect(ava1.y, idxStaRunUna.u1Ava) annotation (Line(points={{-18,-80},{50,-80},
          {50,-66},{58,-66}}, color={255,0,255}));
  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Components/Controls/Staging/Validation/StageIndex.mos"
  "Simulate and plot"),
  experiment(StopTime=100.0,Tolerance=1e-06),
  Documentation(
  info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Templates.Plants.Components.Controls.Staging.StageIndex\">
Buildings.Templates.Plants.Components.Controls.Staging.StageIndex</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
FIXME, 2024, by Antoine Gautier:<br/>
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
end StageIndex;
