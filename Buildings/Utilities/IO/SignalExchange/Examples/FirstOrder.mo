within Buildings.Utilities.IO.SignalExchange.Examples;
model FirstOrder
  "Uses signal exchange block for a first order dynamic system"
  extends Modelica.Icons.Example;

  BaseClasses.ExportedModel expMod
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant uSet(k=2)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.BooleanStep actSet(startTime=50)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.BooleanStep actAct(startTime=100)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Constant uAct(k=3)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

equation
  connect(uSet.y, expMod.oveWriSet_u) annotation (Line(points={{-39,70},{
          -20,70},{-20,10},{-12,10}}, color={0,0,127}));
  connect(actSet.y, expMod.oveWriSet_activate) annotation (Line(points={{
          -39,40},{-30,40},{-30,6},{-12,6}}, color={255,0,255}));
  connect(actAct.y, expMod.oveWriAct_activate) annotation (Line(points={{
          -39,-20},{-30,-20},{-30,-4},{-12,-4}}, color={255,0,255}));
  connect(uAct.y, expMod.oveWriAct_u) annotation (Line(points={{-39,10},{
          -34,10},{-34,0},{-12,0}}, color={0,0,127}));

  annotation (experiment(StopTime=150,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/SignalExchange/Examples/FirstOrder.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses the signal exchange blocks in an original model,
<a href=\"modelica://Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses.OriginalModel\">
Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses.OriginalModel</a>
along with a corresponding model that would result if the original model were
compiled with the BOPTEST parser, <a href=\"modelica://Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses.ExportedModel\">
Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses.ExportedModel</a>
to demonstrate the overwriting of either setpoint or actuator control signals
and reading of signals.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end FirstOrder;
