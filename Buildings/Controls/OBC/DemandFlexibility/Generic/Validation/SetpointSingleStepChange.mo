within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointSingleStepChange "Single-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(unit="K",displayUnit="degC",quantity="ThermodynamicTemperature")
    "Building Automation System temperature setpoint"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange
    setpointSingleStepChange "Setpoint single-step change block"
    annotation (Placement(transformation(extent={{18,-62},{48,-36}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    "Have priority boolean value"
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 20.718)
    "Baseline setpoint example value"
    annotation (Placement(transformation(extent={{-58,-92},{-38,-72}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS
    singleTemperatureSetpointBAS(TRes=0.5, T_start=295.15)
    "Represent a single temperature setpoint in a Building Automation System"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-8})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=273.15 + 16.385)
    "Target setpoint example value"
    annotation (Placement(transformation(extent={{-84,-60},{-64,-40}})));
equation
  connect(booPul.y, setpointSingleStepChange.have_pri) annotation (Line(points={{-48,10},
          {-30,10},{-30,-39.6593},{16,-39.6593}},           color={255,0,255}));
  connect(con1.y,setpointSingleStepChange.uSetBas)  annotation (Line(points={{-36,-82},
          {-6,-82},{-6,-54.1037},{16,-54.1037}},            color={0,0,127}));
  connect(singleTemperatureSetpointBAS.yTSet, setpointSingleStepChange.uSetCur)
    annotation (Line(points={{24,-8},{-22,-8},{-22,-44.4741},{16,-44.4741}},
        color={0,0,127}));
  connect(singleTemperatureSetpointBAS.yTSet, TSet) annotation (Line(points={{24,
          -8},{-16,-8},{-16,10},{120,10}}, color={0,0,127}));
  connect(con2.y, setpointSingleStepChange.uSetTar) annotation (Line(points={{-62,-50},
          {16,-50},{16,-49.2889}},      color={0,0,127}));
  connect(singleTemperatureSetpointBAS.uTSet, setpointSingleStepChange.ySetCom)
    annotation (Line(points={{48,-8},{80,-8},{80,-47.5556},{50,-47.5556}},
        color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange</a>.</p>
<p>This validation test uses two constant temperature values as the baseline temperature setpoint
and the target temperature setpoint. It uses a boolean pulse signal to represent the \"have priority\" 
signal. It also uses an instance of <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS\">
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
