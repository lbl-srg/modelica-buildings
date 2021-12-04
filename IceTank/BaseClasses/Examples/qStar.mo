within IceTank.BaseClasses.Examples;
model qStar "Example to calculate qStar"
  extends Modelica.Icons.Example;

  IceTank.BaseClasses.qStar qSta(
    n=6,
    coeff={5.54E-05,-0.000145679,9.28E-05,0.001126122,-0.0011012,0.000300544},
    dt=10) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    freqHz=1/3600,
    offset=0.5)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Cosine lmtd(
    amplitude=0.5,
    freqHz=1/3600,
    offset=1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(fra.y, qSta.fraCha) annotation (Line(points={{-39,10},{-26,10},{-26,4},
          {-12,4}}, color={0,0,127}));
  connect(lmtd.y, qSta.lmtdSta) annotation (Line(points={{-39,-30},{-26,-30},{
          -26,-4},{-12,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7200, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/qStar.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the <code>qStar</code>&nbsp;&quot;Charging&nbsp;and&nbsp;discharging&nbsp;rate&quot; used in the model <code>NormalizedChargingDischargingRate</code>.</p>
</html>", revisions="<html>
<p>April 2021, Yangyang Fu First implementation</p>
</html>"));
end qStar;
