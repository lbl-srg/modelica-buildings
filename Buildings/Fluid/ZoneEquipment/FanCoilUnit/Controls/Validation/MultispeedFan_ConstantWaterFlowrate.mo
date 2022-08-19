within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model MultispeedFan_ConstantWaterFlowrate
  "Validation model for controller with constant water flow rates and variable speed fan"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFan_ConstantWaterFlowrate
    conMulSpeFanConWat(
    final nSpe=5,
    final fanSpe={0,0.25,0.5,0.75,1},
    final tSpe=2,
    final kCoo=0.1,
    final TiCoo=1,
    final kHea=0.1,
    final TiHea=1,
    final nRowOccSch=5,
    final tableOcc=[0,0; 15,1; 30,0; 45,1; 60,1],
    final timeScaleOcc=1,
    final tFanEnaDel=2,
    final tFanEna=5)
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 25)
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15 + 23)
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/60,
    final offset=273.15 + 24)
    "Measured zone temperature signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(con.y, conMulSpeFanConWat.TCooSet)
    annotation (Line(points={{-18,0},{-6,0},{-6,-2},{18,-2}},
                                             color={0,0,127}));
  connect(con1.y, conMulSpeFanConWat.THeaSet) annotation (Line(points={{-18,-40},
          {0,-40},{0,-6},{18,-6}},color={0,0,127}));
  connect(conMulSpeFanConWat.yFan, conMulSpeFanConWat.uFan) annotation (Line(
        points={{42,-6},{50,-6},{50,20},{10,20},{10,6},{18,6}}, color={255,0,255}));
  connect(ram.y, conMulSpeFanConWat.TZon)
    annotation (Line(points={{-18,40},{0,40},{0,2},{18,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/MultispeedFan_ConstantWaterFlowrate.mos"
      "Simulate and plot"),
    experiment(
      StopTime=3600,
      Interval=1,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
      <p>
      This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFan_ConstantWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFan_ConstantWaterFlowrate</a>.
      
      The instance <code>conMulSpeFanConWat</code> is set-up with parameters and a
      time-varying input signal for measured zone temperature <code>conMulSpeFanConWat.TZon</code> to 
      replicate the output values for fan enable status <code>yFan</code>, fan speed
      <code>yFanSpe</code>, cooling coil signal signal <code>yCoo</code> and heating
      coil signal <code>yHea</code> as seen in the logic chart below.
      </p>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FanCoilUnit/Controls/constantFlowrateMultispeedFan.png\"/>
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
end MultispeedFan_ConstantWaterFlowrate;
