within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model ConstantFanVariableWaterFlowrate
  "Validation model for controller with variable water flow rates and constant speed fan"

  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableWaterFlowrate
    conVarWatConFan(
    final controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final nRowOccSch=5,
    final tableOcc=[0,0; 15,1; 30,0; 45,1; 60,1],
    final timeScaleOcc=1,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=6,
    final duration=60,
    final offset=273.15 + 21)
    "Input signal for measured zone temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 25)
    "Signal source for zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15 + 23)
    "Signal source for zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(con.y,conVarWatConFan. TCooSet)
    annotation (Line(points={{-18,0},{-6,0},{-6,-2},{8,-2}},
                                             color={0,0,127}));
  connect(con1.y,conVarWatConFan. THeaSet) annotation (Line(points={{-18,-40},{0,
          -40},{0,-6},{8,-6}}, color={0,0,127}));
  connect(conVarWatConFan.yFan, conVarWatConFan.uFan) annotation (Line(points={{
          32,-6},{40,-6},{40,20},{4,20},{4,6},{8,6}}, color={255,0,255}));
  connect(ram.y, conVarWatConFan.TZon)
    annotation (Line(points={{-18,40},{0,40},{0,2},{8,2}}, color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/ConstantFanVariableWaterFlowrate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFan_VariableWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFan_VariableWaterFlowrate</a>.
      
      The instance <code>conVarWatConFan</code> is set-up with parameters and a
      time-varying input signal for measured zone temperature <code>conVarWatConFan.TZon</code> to 
      replicate the output values for fan enable status <code>yFan</code>, fan speed
      <code>yFanSpe</code>, cooling coil signal signal <code>yCoo</code> and heating
      coil signal <code>yHea</code> as seen in the logic chart below.
      </p>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FanCoilUnit/Controls/constantFanVariableFlowrate.png\"/>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end ConstantFanVariableWaterFlowrate;
