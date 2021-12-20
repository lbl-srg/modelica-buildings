within IceStorage.BaseClasses.Examples;
model IceMass "Example that tests the ice mass calculation"
  extends Modelica.Icons.Example;

  IceStorage.BaseClasses.IceMass iceMas(
    mIce_max=2846.35,
    mIce_start=2846.35/2) "Ice mass calculator"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Cosine q(
    freqHz=1/3600,
    amplitude=1,
    offset=0)
    "Heat transfer rate: postive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain hf(k=333550) "Fusion of heat of ice"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(q.y, hf.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(hf.y, iceMas.q)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://IceStorage/Resources/scripts/dymola/BaseClasses/Examples/IceMass.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the model that calculates the ice mass.</p>
</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=0,
      StopTime=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end IceMass;
