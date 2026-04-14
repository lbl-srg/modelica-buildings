within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SingleStepSetpointChange "Single-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(final unit="K",displayUnit="degC",final quantity="ThermodynamicTemperature")
    "Temperature setpoint of the zone temperature setpoint controller"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange
    singleStepSetpointChange(samPer=300, alwDev=0.01)
                             "Single-step setpoint change block"
    annotation (Placement(transformation(extent={{0,20},{40,80}})));
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
        origin={70,10})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=273.15 + 16.385)
    "Target setpoint example value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(con1.y,singleStepSetpointChange.uBasSet)  annotation (Line(points={{-58,-70},
          {-38,-70},{-38,32},{-2.5,32}},                    color={0,0,127}));
  connect(singleStepSetpointChange.yComSet, uniDel.u)
    annotation (Line(points={{42.5,50},{50,50},{50,10},{58,10}},
                                                            color={0,0,127}));
  connect(uniDel.y,singleStepSetpointChange. uCurSet) annotation (Line(points={{82,10},
          {90,10},{90,-12},{-24,-12},{-24,56},{-2.5,56}},              color={0,
          0,127}));
  connect(uniDel.y, TSet)
    annotation (Line(points={{82,10},{120,10}}, color={0,0,127}));
  connect(booPul.y,singleStepSetpointChange. uEna) annotation (Line(points={{-58,70},
          {-30,70},{-30,68},{-2.5,68}},        color={255,0,255}));
  connect(con2.y, singleStepSetpointChange.uTarSet) annotation (Line(points={{
          -58,10},{-54,10},{-54,44},{-2.5,44}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
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
