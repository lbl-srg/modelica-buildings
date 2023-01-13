within Buildings.Fluid.ZoneEquipment.WindowAC.Controls.Validation;
model ConstantFanVariableHeating
  "Validation model for controller with variable heating and constant speed fan"

  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.WindowAC.Controls.ConstantFanCyclingCooling
    conVarWatConFan(
    final controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=300)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod(
    final period=900) "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=6,
    final duration=3600,
    final offset=273.15 + 21) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(heaSetPoi.y, conVarWatConFan.THeaSet) annotation (Line(points={{-18,20},
          {-10,20},{-10,-1.66667},{8.88889,-1.66667}},
                                  color={0,0,127}));
  connect(TZon.y, conVarWatConFan.TZon)
    annotation (Line(points={{-18,60},{0,60},{0,5},{8.88889,5}},
                                                           color={0,0,127}));
  connect(supFanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{-18,-60},
          {0,-60},{0,-8.33333},{8.88889,-8.33333}},      color={255,0,255}));
  connect(uAva.y, conVarWatConFan.uAva) annotation (Line(points={{-18,-20},{-10,
          -20},{-10,-5},{8.88889,-5}},             color={255,0,255}));
  connect(conVarWatConFan.yFan, truDel.u) annotation (Line(points={{31.1111,
          -8.33333},{40.5555,-8.33333},{40.5555,0},{48,0}}, color={255,0,255}));
  connect(truDel.y, conVarWatConFan.uFan) annotation (Line(points={{72,0},{80,0},
          {80,20},{4,20},{4,8.33333},{8.88889,8.33333}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/UnitHeater/Controls/Validation/ConstantFanVariableHeating.mos"
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
      </html>"),
    experiment(Tolerance=1e-06));
end ConstantFanVariableHeating;
