within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointSingleStepChange "Single-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(unit="K",displayUnit="degC",quantity="ThermodynamicTemperature")
    "Building Automation System temperature setpoint"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange
    setpointSingleStepChange "Setpoint single-step change block"
    annotation (Placement(transformation(extent={{8,-4},{38,22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    "Have priority boolean value"
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 20.718)
    "Baseline setpoint example value"
    annotation (Placement(transformation(extent={{-86,-48},{-66,-28}})));
  CDL.Discrete.UnitDelay
    uniDel(samplePeriod=10, y_start=273.15 + 20.718)
    "Represent a time delay of the temperature setpoint actually changes after the temperature setpoint is asked to change"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,10})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=273.15 + 16.385)
    "Target setpoint example value"
    annotation (Placement(transformation(extent={{-86,0},{-66,20}})));
equation
  connect(booPul.y, setpointSingleStepChange.have_pri) annotation (Line(points={{-64,66},
          {-30,66},{-30,18.3407},{6,18.3407}},              color={255,0,255}));
  connect(con1.y,setpointSingleStepChange.uSetBas)  annotation (Line(points={{-64,-38},
          {-28,-38},{-28,3.8963},{6,3.8963}},               color={0,0,127}));
  connect(con2.y, setpointSingleStepChange.uSetTar) annotation (Line(points={{-64,10},
          {6,10},{6,8.71111}},          color={0,0,127}));
  connect(setpointSingleStepChange.ySetCom, uniDel.u)
    annotation (Line(points={{40,10.4444},{40,10},{48,10}}, color={0,0,127}));
  connect(uniDel.y, setpointSingleStepChange.uSetCur) annotation (Line(points={
          {72,10},{96,10},{96,-14},{-2,-14},{-2,13.5259},{6,13.5259}}, color={0,
          0,127}));
  connect(uniDel.y, TSet)
    annotation (Line(points={{72,10},{120,10}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange</a>.</p>
<p>This validation test uses two constant temperature values as the baseline temperature setpoint
and the target temperature setpoint. It uses a boolean pulse signal to represent the \"have priority\" 
signal. It also uses an instance of <a href=\"modelica://cdl_models.Move.Generic.Subsequences.SingleTemperatureSetpointBAS\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS</a> to represent
the behavior of a temperature setpoint within a Building Automation System (BAS).
This validation test forms a close loop between the temperature setpoint within the BAS and the single-step
setpoint change controller.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end SetpointSingleStepChange;
