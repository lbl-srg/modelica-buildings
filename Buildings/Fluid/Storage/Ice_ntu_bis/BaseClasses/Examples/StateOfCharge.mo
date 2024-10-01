within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.Examples;
model StateOfCharge "Example that tests the ice mass calculation"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.StateOfCharge soc(E_nominal=
        2846.35*333550, SOC_start=1/2) "State of charge"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Cosine q(
    f=1/3600,
    amplitude=1,
    offset=0)
    "Heat transfer rate: postive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain hf(k=333550) "Fusion of heat of ice"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(q.y, hf.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(hf.y, soc.Q_flow)
    annotation (Line(points={{-19,0},{-10,0},{-10,-5},{-2,-5}},
                                              color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/BaseClasses/Examples/StateOfCharge.mos"
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
      Tolerance=1e-06));
end StateOfCharge;
