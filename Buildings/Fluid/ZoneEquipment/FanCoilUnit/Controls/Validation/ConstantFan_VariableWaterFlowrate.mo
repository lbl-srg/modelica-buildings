within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model ConstantFan_VariableWaterFlowrate
  "Validation model for controller with variable water flow rates and constant speed fan"

  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFan_VariableWaterFlowrate
    conVarWatConFan(
    final nRowOccSch=5,
    final tableOcc=[0,0; 15,1; 30,0; 45,1; 60,1],
    final timeScaleOcc=1,
    tFanEnaDel=2,
    final tFanEna=5)
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=25)
    "Signal source for zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=23)
    "Signal source for zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/60,
    final offset=24)
    "Signal source for measured zone temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(con.y,conVarWatConFan. TCooSet)
    annotation (Line(points={{-18,0},{-6,0},{-6,-2},{8,-2}},
                                             color={0,0,127}));
  connect(con1.y,conVarWatConFan. THeaSet) annotation (Line(points={{-18,-40},{0,
          -40},{0,-6},{8,-6}}, color={0,0,127}));
  connect(sin.y,conVarWatConFan. TZon)
    annotation (Line(points={{-18,40},{0,40},{0,2},{8,2}}, color={0,0,127}));
  connect(conVarWatConFan.yFan, conVarWatConFan.uFan) annotation (Line(points={{
          32,-6},{40,-6},{40,20},{4,20},{4,6},{8,6}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/ConstantFan_VariableWaterFlowrate.mos"
      "Simulate and plot"));
end ConstantFan_VariableWaterFlowrate;
