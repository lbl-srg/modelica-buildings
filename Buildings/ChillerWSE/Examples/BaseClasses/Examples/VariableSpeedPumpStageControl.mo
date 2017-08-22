within Buildings.ChillerWSE.Examples.BaseClasses.Examples;
model VariableSpeedPumpStageControl
  "Test the model ChillerWSE.Examples.BaseClasses.VariableSpeedPumpStageControl"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=100 "Nominal mass flowrate";

  Buildings.ChillerWSE.Examples.BaseClasses.VariableSpeedPumpStageControl varSpePumSta(tWai=30,
      m_flow_nominal=m_flow_nominal)
    "Staging controller for variable speed pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse          speSig(
    amplitude=0.8,
    period=180,
    offset=0.2) "Speed signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Sine masFlo(
    offset=0.5*m_flow_nominal,
    freqHz=1/360,
    amplitude=0.5*m_flow_nominal)
                               "Mass flowrate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(speSig.y, varSpePumSta.speSig) annotation (Line(points={{-39,-20},{-32,
          -20},{-32,4},{-12,4}}, color={0,0,127}));
  connect(masFlo.y, varSpePumSta.masFloPum) annotation (Line(points={{-39,40},{-30,
          40},{-30,8},{-12,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/BaseClasses/Examples/VariableSpeedPumpStageControl.mos"
        "Simulate and Plot"));
end VariableSpeedPumpStageControl;
