within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Terminal.Validation;
model TerminalController
  "Validate zone temperature setpoint controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Terminal.TerminalController
    terCon(
    final VDes_occ=0.5,
    final VDes_unoccSch=0.1,
    final VDes_unoccUnsch=0.2)
    "Zone terminal controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

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
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.9,
    final period=1200)
    "Boolean step signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    final amplitude=5,
    final freqHz=1/720,
    final offset=295)
    "Continuous sine signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=4000)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));

  connect(sin1.y, terCon.TZon)
    annotation (Line(points={{-58,0},{18,0}}, color={0,0,127}));
  connect(sin.y, terCon.VDis_flow) annotation (Line(points={{-58,-40},{0,-40},{0,
          -4},{18,-4}}, color={0,0,127}));
  connect(not1.y, terCon.uConSen) annotation (Line(points={{-18,40},{0,40},{0,4},
          {18,4}}, color={255,0,255}));
  connect(booPul1.y, terCon.uDetOcc) annotation (Line(points={{-58,80},{10,80},{
          10,8},{18,8}}, color={255,0,255}));
  connect(terCon.yChiVal, uniDel.u)
    annotation (Line(points={{42,4},{50,4},{50,0},{58,0}}, color={0,0,127}));
  connect(uniDel.y, terCon.uChiVal) annotation (Line(points={{82,0},{90,0},{90,-20},
          {10,-20},{10,-8},{18,-8}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=3600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeamSystem/Terminal/Validation/TerminalController.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Terminal.TerminalController\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Terminal.TerminalController</a>.
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
end TerminalController;
