within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.Validation;
model MultispeedFan_ConstantWaterFlowrate
  "Validation model for controller with constant water flow rates and variable speed fan"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.MultispeedFan_ConstantWaterFlowrate
    conMulSpeFanConWat(
    final nSpe=5,
    final fanSpe={0,0.25,0.5,0.75,1},
    final kCoo=0.1,
    final TiCoo=1,
    final kHea=0.1,
    final TiHea=1,
    final dTHys=0.5)
    "Instance of controller with variable fan speed and constant water flowrate"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=25)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=23)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/3600,
    final offset=24)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(con.y, conMulSpeFanConWat.TCooSet)
    annotation (Line(points={{-18,0},{18,0}},color={0,0,127}));
  connect(con1.y, conMulSpeFanConWat.THeaSet) annotation (Line(points={{-18,-40},
          {0,-40},{0,-4},{18,-4}},color={0,0,127}));
  connect(sin.y, conMulSpeFanConWat.TZon)
    annotation (Line(points={{-18,40},{0,40},{0,4},{18,4}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Controls/Validation/MultispeedFan_ConstantWaterFlowrate.mos"
      "Simulate and plot"),
    experiment(
      StopTime=3600,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end MultispeedFan_ConstantWaterFlowrate;
