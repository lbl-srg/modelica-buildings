within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SingleStepSetpointChange "Single-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(final unit="K",displayUnit="degC",final quantity="ThermodynamicTemperature")
    "Temperature setpoint of the zone temperature setpoint controller"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange
    singleStepSetpointChange "Single-step setpoint change block"
    annotation (Placement(transformation(extent={{8,-4},{38,22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    "Have priority boolean value"
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 19.718)
    "Baseline setpoint example value"
    annotation (Placement(transformation(extent={{-86,-48},{-66,-28}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay
    uniDel(samplePeriod=10, y_start=273.15 + 20)
    "Represent a time delay of the temperature setpoint actually changes after the temperature setpoint is asked to change"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,10})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=273.15 + 16.385)
    "Target setpoint example value"
    annotation (Placement(transformation(extent={{-86,-2},{-66,18}})));
equation
  connect(con1.y,singleStepSetpointChange.uBasSet)  annotation (Line(points={{-64,-38},
          {-28,-38},{-28,1.46},{5.8,1.46}},                 color={0,0,127}));
  connect(con2.y,singleStepSetpointChange. uTarSet) annotation (Line(points={{-64,8},
          {5.8,8},{5.8,7.18}},          color={0,0,127}));
  connect(singleStepSetpointChange.yComSet, uniDel.u)
    annotation (Line(points={{40,9},{40,10},{48,10}},       color={0,0,127}));
  connect(uniDel.y,singleStepSetpointChange. uCurSet) annotation (Line(points={{72,10},
          {96,10},{96,-14},{-2,-14},{-2,12.9},{6,12.9}},               color={0,
          0,127}));
  connect(uniDel.y, TSet)
    annotation (Line(points={{72,10},{120,10}}, color={0,0,127}));
  connect(booPul.y,singleStepSetpointChange. uEna) annotation (Line(points={{-64,
          66},{-30,66},{-30,17.97},{6,17.97}}, color={255,0,255}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange</a>.</p>
<p>This validation test uses two constant temperature values as the baseline temperature setpoint
and the target temperature setpoint. It uses a boolean pulse signal to represent the \"enable\" 
signal. It also uses a delay block to represent
the behavior of a temperature setpoint within a typical zone temperature setpoint controller.
This validation test forms a close loop between the temperature setpoint in the 
zone temperature setpoint controller and the <code>SingleStepSetpointChange</code> block.</p>
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
