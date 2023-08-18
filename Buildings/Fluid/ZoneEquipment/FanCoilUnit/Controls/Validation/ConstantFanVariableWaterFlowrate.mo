within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model ConstantFanVariableWaterFlowrate
  "Validation model for controller with variable water flow rates and constant speed fan"

  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate
    conVarWatConFan(
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Controller for the fan coil unit"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=6,
    final duration=3600,
    final offset=273.15 + 21)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 25)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occ(
    final k=true)
    "Occupancy signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(cooSetPoi.y, conVarWatConFan.TCooSet)
    annotation (Line(points={{-18,20},{-10,20},{-10,0},{8,0}},
                                                             color={0,0,127}));
  connect(heaSetPoi.y, conVarWatConFan.THeaSet) annotation (Line(points={{-18,-20},
          {-10,-20},{-10,-4},{8,-4}},
                                  color={0,0,127}));
  connect(conVarWatConFan.yFan, conVarWatConFan.uFan) annotation (Line(points={{32,-6},
          {40,-6},{40,20},{4,20},{4,8},{8,8}},        color={255,0,255}));
  connect(TZon.y, conVarWatConFan.TZon)
    annotation (Line(points={{-18,60},{0,60},{0,4},{8,4}}, color={0,0,127}));
  connect(occ.y, conVarWatConFan.uOcc) annotation (Line(points={{-18,-60},{0,-60},
          {0,-8},{8,-8}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/ConstantFanVariableWaterFlowrate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate</a>.
      </p>
</html>
      ", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(Tolerance=1e-06));
end ConstantFanVariableWaterFlowrate;
