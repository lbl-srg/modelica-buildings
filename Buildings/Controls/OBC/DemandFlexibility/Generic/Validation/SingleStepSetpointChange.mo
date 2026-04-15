within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SingleStepSetpointChange "Single-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange sinSteSetCha(
             alwDev=0.01) "Single-step setpoint change block"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    "Have priority boolean value"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 19.718)
    "Baseline setpoint example value"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay
    uniDel(samplePeriod=10, y_start=273.15 + 20)
    "Represent a time delay of the temperature setpoint actually changes after the temperature setpoint is asked to change"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,30})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=273.15 + 16.385)
    "Target setpoint example value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(final samplePeriod=300)
    "Sample period for the single-step change"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(con1.y, sinSteSetCha.uBasSet) annotation (Line(points={{-58,-70},{-38,
          -70},{-38,24},{-22,24}},color={0,0,127}));
  connect(uniDel.y, sinSteSetCha.uCurSet) annotation (Line(points={{82,30},{90,30},
          {90,-12},{-28,-12},{-28,32},{-22,32}},color={0,0,127}));
  connect(booPul.y, sinSteSetCha.uEna) annotation (Line(points={{-58,70},{-30,70},
          {-30,36},{-22,36}},color={255,0,255}));
  connect(con2.y, sinSteSetCha.uTarSet) annotation (Line(points={{-58,10},{-54,10},
          {-54,28.2},{-22,28.2}},color={0,0,127}));
  connect(sinSteSetCha.yComSet, sam.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(sam.y, uniDel.u)
    annotation (Line(points={{42,30},{58,30}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SingleStepSetpointChange.mos"
        "Simulate and plot"),
       Documentation(info="<html>
<p>
This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange</a>.
</p>

<p>This validation test uses two constant temperature values as the baseline temperature setpoint
and the target temperature setpoint. It uses a boolean pulse signal to represent the \"enable\" 
signal. It also uses a delay block to represent
the behavior of a temperature setpoint within an external zone temperature setpoint controller.
This validation test forms a close loop between the temperature setpoint in the 
external zone temperature setpoint controller and <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleStepSetpointChange;
