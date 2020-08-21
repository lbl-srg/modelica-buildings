within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model TSupSet "This model simulates TSupSet"
  Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet TSupSet
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse sbcGenerator(
    width=0.155,
    period=680,
    startTime=830)
    annotation (Placement(transformation(extent={{-34,-6},{-14,14}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse sbhGenerator(
    width=0.155,
    period=720,
    startTime=440)
    annotation (Placement(transformation(extent={{-34,-40},{-14,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse coolReqGen(
    width=0.25,
    period=440,
    startTime=1000)
    annotation (Placement(transformation(extent={{-34,30},{-14,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant
  con(final k=false)
    annotation (Placement(transformation(extent={{-72,12},{-52,32}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter
  totCoolReqsGen(y_start=0)
    annotation (Placement(transformation(extent={{-4,34},{8,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine
  highSpaceTGen(
    amplitude=5,
    freqHz=1/3600,
    offset=27 + 273.15)
    annotation (Placement(transformation(extent={{-34,-76},{-14,-56}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant totTU(final k=12)
    annotation (Placement(transformation(extent={{-34,62},{-14,82}})));
equation
  connect(coolReqGen.y, totCoolReqsGen.trigger)
    annotation (Line(points={{-12,40},{-5.2,40}}, color={255,0,255}));
  connect(con.y,totCoolReqsGen. reset) annotation (Line(points={{-50,22},{2,22},
          {2,32.8}},              color={255,0,255}));
  connect(totTU.y, TSupSet.TotalTU) annotation (Line(points={{-12,72},{40,72},{
          40,7.6},{52,7.6}}, color={255,127,0}));
  connect(totCoolReqsGen.y, TSupSet.totCoolReqs) annotation (Line(points={{9.2,40},
          {30,40},{30,4},{52,4}}, color={255,127,0}));
  connect(sbcGenerator.y, TSupSet.sbc) annotation (Line(points={{-12,4},{20,4},
          {20,0.4},{52,0.4}}, color={255,0,255}));
  connect(sbhGenerator.y, TSupSet.sbh) annotation (Line(points={{-12,-30},{20,-30},
          {20,-3.2},{52,-3.2}}, color={255,0,255}));
  connect(highSpaceTGen.y, TSupSet.highSpaceT) annotation (Line(points={{-12,-66},
          {30,-66},{30,-6.8},{52,-6.8}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=5760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/Validation/TSupSet.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>August 21, 2020, by Henry Nickels:<br/>
Built simulation script.</li>
<li>August 16, 2020, by Henry Nickels:<br/>
Added 'experiment' annotation.</li>
<li>July 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>
"));
end TSupSet;
