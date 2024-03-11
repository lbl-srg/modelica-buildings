within Buildings.Templates.Plants.Controls.Utilities.Validation;
model StageIndex
  parameter Integer nSta=4
    "Number of stages"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ena(
    width=0.9,
    period=160,
    shift=10) "Enable signal"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Templates.Plants.Controls.Utilities.StageIndex idxSta(
    have_inpAva=false,
    final nSta=nSta)
    "Compute stage index - No minimum runtime, all stages available"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger upPul(
    period=20)
    "Stage up command pulse"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger dowPul(
    period=20)
    "Stage down command pulse"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Templates.Plants.Controls.Utilities.StageIndex idxStaUna(
    final nSta=nSta)
    "Compute stage index - No minimum runtime, some unavailable stages"
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[nSta](k={false,
        false,true,true}) "Stage available signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Templates.Plants.Controls.Utilities.StageIndex idxStaRun(
    have_inpAva=false,
    final nSta=nSta,
    dtRun=25)
    "Compute stage index - Minimum runtime, all stages available"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Templates.Plants.Controls.Utilities.StageIndex idxStaRunUna(
    final nSta=nSta,
    dtRun=25)
    "Compute stage index - Minimum runtime, some unavailable stages"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[
      0, 0, 0;
      10, 1, 0;
      70, 0, 1],
    period=160)
    "Signal to inhibit up and down commands"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Buildings.Controls.OBC.CDL.Logical.And u1Up "Stage up command"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.And u1Dow "Stage down command"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold u1UpHol(trueHoldDuration=0.1,
      falseHoldDuration=0) "Hold stage up command for plotting"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold u1DowHol(trueHoldDuration=
        0.1, falseHoldDuration=0) "Hold stage down command for plotting"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
equation
  connect(ena.y, idxSta.u1Lea)
    annotation (Line(points={{-68,60},{0,60},{0,66},{18,66}},color={255,0,255}));
  connect(ena.y, idxStaUna.u1Lea)
    annotation (Line(points={{-68,60},{0,60},{0,36},{60,36}},color={255,0,255}));
  connect(ena.y, idxStaRun.u1Lea)
    annotation (Line(points={{-68,60},{0,60},{0,-24},{18,-24}},color={255,0,255}));
  connect(u1AvaSta.y, idxStaUna.u1AvaSta) annotation (Line(points={{-68,-80},{
          50,-80},{50,24},{60,24}}, color={255,0,255}));
  connect(ena.y, idxStaRunUna.u1Lea)
    annotation (Line(points={{-68,60},{0,60},{0,-54},{58,-54}},color={255,0,255}));
  connect(u1AvaSta.y, idxStaRunUna.u1AvaSta) annotation (Line(points={{-68,-80},
          {50,-80},{50,-66},{58,-66}}, color={255,0,255}));
  connect(upPul.y, u1Up.u2) annotation (Line(points={{-68,20},{-60,20},{-60,12},
          {-42,12}}, color={255,0,255}));
  connect(dowPul.y, u1Dow.u2) annotation (Line(points={{-68,-20},{-60,-20},{-60,
          -28},{-42,-28}}, color={255,0,255}));
  connect(booTimTab.y[2], u1Dow.u1) annotation (Line(points={{-68,90},{-50,90},
          {-50,-20},{-42,-20}}, color={255,0,255}));
  connect(u1Up.y, idxSta.u1Up) annotation (Line(points={{-18,20},{-10,20},{-10,
          62},{18,62}}, color={255,0,255}));
  connect(u1Dow.y, idxSta.u1Dow) annotation (Line(points={{-18,-20},{-4,-20},{-4,
          58},{18,58}}, color={255,0,255}));
  connect(u1Up.y, idxStaUna.u1Up) annotation (Line(points={{-18,20},{30,20},{30,
          32},{60,32}}, color={255,0,255}));
  connect(u1Dow.y, idxStaUna.u1Dow) annotation (Line(points={{-18,-20},{-4,-20},
          {-4,28},{60,28}}, color={255,0,255}));
  connect(u1Dow.y, idxStaRun.u1Dow) annotation (Line(points={{-18,-20},{-4,-20},
          {-4,-32},{18,-32}}, color={255,0,255}));
  connect(u1Dow.y, idxStaRunUna.u1Dow) annotation (Line(points={{-18,-20},{-4,-20},
          {-4,-62},{58,-62}}, color={255,0,255}));
  connect(u1Up.y, idxStaRun.u1Up) annotation (Line(points={{-18,20},{-10,20},{-10,
          -28},{18,-28}}, color={255,0,255}));
  connect(u1Up.y, idxStaRunUna.u1Up) annotation (Line(points={{-18,20},{-10,20},
          {-10,-58},{58,-58}}, color={255,0,255}));
  connect(booTimTab.y[1], u1Up.u1) annotation (Line(points={{-68,90},{-50,90},{
          -50,20},{-42,20}}, color={255,0,255}));
  connect(u1Up.y, u1UpHol.u) annotation (Line(points={{-18,20},{-10,20},{-10,
          100},{-2,100}}, color={255,0,255}));
  connect(u1Dow.y, u1DowHol.u) annotation (Line(points={{-18,-20},{-4,-20},{-4,
          -100},{-2,-100}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/StageIndex.mos"
        "Simulate and plot"),
    experiment(
      StopTime=160.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-120,-120},{120,120}})));
end StageIndex;
