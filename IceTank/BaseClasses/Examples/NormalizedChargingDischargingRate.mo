within IceTank.BaseClasses.Examples;
model NormalizedChargingDischargingRate "Example to calculate qStar"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/7200)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  IceTank.BaseClasses.NormalizedChargingDischargingRate norQSta(coeffCha={
        0.0021,0,0,0,0,0})
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.IntegerStep integerStep(          startTime=3600,
    height=-1,
    offset=3)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Sources.Step lmt(
    startTime=3600,
    offset=1,
    height=-2) "lmtdSta"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(fra.y, norQSta.fraCha) annotation (Line(points={{-59,10},{-40,10},{-40,
          0},{-2,0}}, color={0,0,127}));
  connect(integerStep.y, norQSta.u) annotation (Line(points={{-59,50},{-20,50},{
          -20,6},{-2,6}}, color={255,127,0}));
  connect(lmt.y, norQSta.lmtdSta) annotation (Line(points={{-59,-30},{-20,-30},
          {-20,-6},{-2,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7200, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/BaseClasses/Examples/NormalizedChargingDischargingRate.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<p>April 2021, Yangyang Fu First implementation</p>
</html>", info="<html>
<p>This example is to validate the NormalizedChargingDischargingRate &quot;Charging&nbsp;or&nbsp;discharging&nbsp;rate&nbsp;based&nbsp;on&nbsp;the&nbsp;curves&quot;.</p>
</html>"));
end NormalizedChargingDischargingRate;
