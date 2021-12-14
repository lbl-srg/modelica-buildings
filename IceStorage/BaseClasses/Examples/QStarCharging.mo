within IceStorage.BaseClasses.Examples;
model QStarCharging "Example to calculate QStarCharing"
  extends Modelica.Icons.Example;

  parameter Real coeCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for charging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    freqHz=1/86400,
    offset=0.5) "Fraction of charge"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant lmtd(k=1) "Log mean temperature difference"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  IceStorage.BaseClasses.QStarCharging qSta(coeff=coeCha, dt=dt)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(fra.y, qSta.fraCha) annotation (Line(points={{-39,30},{-26,30},{-26,4},
          {-12,4}}, color={0,0,127}));
  connect(lmtd.y, qSta.lmtdSta) annotation (Line(points={{-39,-30},{-26,-30},{-26,
          -4},{-12,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StartTime=0,
              StopTime=86400,
              Tolerance=1e-06,
              __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://IceStorage/Resources/scripts/dymola/BaseClasses/Examples/QStarCharging.mos"
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
end QStarCharging;
