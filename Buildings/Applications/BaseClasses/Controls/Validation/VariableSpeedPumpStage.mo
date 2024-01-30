within Buildings.Applications.BaseClasses.Controls.Validation;
model VariableSpeedPumpStage
  "Test the model ChillerWSE.Examples.BaseClasses.VariableSpeedPumpStageControl"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=100
    "Nominal mass flowrate";

  Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage
    varSpePumSta(tWai=30, m_flow_nominal=m_flow_nominal,
    criPoiSpe=0.6)
    "Staging controller for variable speed pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse speSig(
    amplitude=0.8,
    period=180,
    offset=0.2) "Speed signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Sine masFlo(
    offset=0.5*m_flow_nominal,
    f=1/360,
    amplitude=0.5*m_flow_nominal) "Mass flowrate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.BooleanConstant on "Plant on signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(speSig.y, varSpePumSta.speSig)
    annotation (Line(points={{-39,-20},{-30,-20},{-30,0},{-12,0}},
      color={0,0,127}));
  connect(masFlo.y, varSpePumSta.masFloPum)
    annotation (Line(points={{-39,40},{-30,40},{-30,4},{-12,4}},
      color={0,0,127}));
  connect(on.y, varSpePumSta.on)
   annotation (Line(points={{-39,70},{-20,70},{-20,8},{-12,8}},
     color={255,0,255}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/BaseClasses/Controls/Validation/VariableSpeedPumpStage.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model test the staging controller for variable-speed pumps. The staging controller is located in
<a href=\"modelica://Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage\">
Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Added the <code>on</code> input to the example model.
</li>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1080,
      Tolerance=1e-06));
end VariableSpeedPumpStage;
