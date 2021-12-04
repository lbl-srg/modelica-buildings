within IceTank.BaseClasses.Examples;
model LMTDStar "Test LMTDStar model"
  extends Modelica.Icons.Example;

  IceTank.BaseClasses.LMTDStar lmtdSta
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.Cosine Tin(
    amplitude=4,
    freqHz=1/3600,
    offset=273.15 + 2)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Cosine Tout(
    amplitude=4,
    freqHz=1/3600,
    offset=273.15 + 2,
    phase=3.1415926535898)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(Tin.y, lmtdSta.TIn) annotation (Line(points={{-59,20},{-32,20},{-32,4},
          {-10,4}}, color={0,0,127}));
  connect(Tout.y, lmtdSta.TOut) annotation (Line(points={{-59,-20},{-32,-20},{
          -32,-4},{-10,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7200, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/LMTDStar.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<p>April 2021, Yangyang Fu First implementation</p>
</html>", info="<html>
<p>This example is to validate the <code>LMTDStar </code>&quot;Normalized&nbsp;log&nbsp;mean&nbsp;temperature&nbsp;difference&nbsp;across&nbsp;the&nbsp;ice&nbsp;storage&nbsp;unit&quot;.</p>
</html>"));
end LMTDStar;
