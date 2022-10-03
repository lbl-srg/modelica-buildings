within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model VariableFanConstantWaterFlowrate
  "Validation model for controller with constant water flow rates and variable speed fan"
  extends Modelica.Icons.Example;
  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFanConstantWaterFlowrate
    conVarFanConWat(
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Controller for the fan coil unit"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 25)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=6,
    final duration=3600,
    final offset=273.15 + 21)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occ(
    final k=true)
    "Occupancy status"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(cooSetPoi.y, conVarFanConWat.TCooSet)
    annotation (Line(points={{-18,20},{-6,20},{-6,0},{8,0}}, color={0,0,127}));
  connect(heaSetPoi.y, conVarFanConWat.THeaSet) annotation (Line(points={{-18,-20},
          {0,-20},{0,-4},{8,-4}},      color={0,0,127}));
  connect(conVarFanConWat.yFan, conVarFanConWat.uFan) annotation (Line(points={{32,-6},
          {40,-6},{40,30},{4,30},{4,8},{8,8}},        color={255,0,255}));
  connect(TZon.y, conVarFanConWat.TZon)
    annotation (Line(points={{-18,60},{0,60},{0,4},{8,4}}, color={0,0,127}));
  connect(occ.y, conVarFanConWat.uOcc) annotation (Line(points={{-18,-60},{4,-60},
          {4,-8},{8,-8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/VariableFanConstantWaterFlowrate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFan_ConstantWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFan_ConstantWaterFlowrate</a>.
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
end VariableFanConstantWaterFlowrate;
