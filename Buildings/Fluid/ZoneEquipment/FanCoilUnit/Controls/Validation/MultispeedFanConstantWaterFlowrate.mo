within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model MultispeedFanConstantWaterFlowrate
  "Validation model for controller with constant water flow rates and variable speed fan"
  extends Modelica.Icons.Example;
  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFanConstantWaterFlowrate
    conMulSpeFanConWat(
    final nSpe=5,
    final fanSpe={0,0.25,0.5,0.75,1},
    final tSpe=2,
    final kCoo=0.1,
    final TiCoo=1,
    final kHea=0.1,
    final TiHea=1,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Controller for the fan coil unit"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 25)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon(
    final amplitude=2,
    final freqHz=1/3600,
    final offset=273.15 + 24)
    "Measured zone temperature signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occ(
    final k=true)
    "Occupancy signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(cooSetPoi.y, conMulSpeFanConWat.TCooSet) annotation (Line(points={{-18,20},
          {-6,20},{-6,0},{18,0}},     color={0,0,127}));
  connect(heaSetPoi.y, conMulSpeFanConWat.THeaSet) annotation (Line(points={{-18,-20},
          {0,-20},{0,-4},{18,-4}},      color={0,0,127}));
  connect(conMulSpeFanConWat.yFan, conMulSpeFanConWat.uFan) annotation (Line(
        points={{42,-6},{50,-6},{50,20},{10,20},{10,8},{18,8}}, color={255,0,255}));
  connect(TZon.y, conMulSpeFanConWat.TZon)
    annotation (Line(points={{-18,60},{0,60},{0,4},{18,4}}, color={0,0,127}));
  connect(occ.y, conMulSpeFanConWat.uOcc) annotation (Line(points={{-18,-60},{10,
          -60},{10,-8},{18,-8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/MultispeedFanConstantWaterFlowrate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFanConstantWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFanConstantWaterFlowrate</a>.
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
    experiment(
      Tolerance=1e-6));
end MultispeedFanConstantWaterFlowrate;
