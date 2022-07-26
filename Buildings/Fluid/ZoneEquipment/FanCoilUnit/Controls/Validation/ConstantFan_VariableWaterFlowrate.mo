within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model ConstantFan_VariableWaterFlowrate
  "Validation model for controller with variable water flow rates and constant speed fan"
    extends Modelica.Icons.Example;
  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFan_VariableWaterFlowrate
    conVarWatConFan
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=25)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=23)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=2,
    freqHz=1/60,
    offset=24)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(con.y,conVarWatConFan. TCooSet)
    annotation (Line(points={{-18,0},{8,0}}, color={0,0,127}));
  connect(con1.y,conVarWatConFan. THeaSet) annotation (Line(points={{-18,-40},{0,
          -40},{0,-4},{8,-4}}, color={0,0,127}));
  connect(sin.y,conVarWatConFan. TZon)
    annotation (Line(points={{-18,40},{0,40},{0,4},{8,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/ConstantFan_VariableWaterFlowrate.mos"
      "Simulate and plot"));
end ConstantFan_VariableWaterFlowrate;
