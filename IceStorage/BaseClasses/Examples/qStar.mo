within IceStorage.BaseClasses.Examples;
model QStar "Example to calculate qStar"
  extends Modelica.Icons.Example;

  IceStorage.BaseClasses.QStar qSta(
    coeff={5.54E-05,-0.000145679,9.28E-05,0.001126122,-0.0011012,0.000300544},
    dt=10) "Q star"
           annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    freqHz=1/3600,
    offset=0.5) "Fraction of charge"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Cosine lmtd(
    amplitude=0.5,
    freqHz=1/3600,
    offset=1) "LMTD star"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(fra.y, qSta.fraCha) annotation (Line(points={{-39,30},{-26,30},{-26,4},
          {-12,4}}, color={0,0,127}));
  connect(lmtd.y, qSta.lmtdSta) annotation (Line(points={{-39,-30},{-26,-30},{
          -26,-4},{-12,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StartTime=0,
              StopTime=3600,
              Tolerance=1e-06,
              __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://IceStorage/Resources/scripts/dymola/BaseClasses/Examples/QStar.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>This example is to validate the <a href=modelica://IceStorage.BaseClasses.QStar>QStar</a>.</p>
</html>", revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end QStar;
