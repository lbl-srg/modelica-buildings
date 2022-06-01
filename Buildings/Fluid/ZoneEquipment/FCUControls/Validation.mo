within Buildings.Fluid.ZoneEquipment.FCUControls;

package Validation

  extends Modelica.Icons.ExamplesPackage;

  block Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate
    extends Modelica.Icons.Example;
    Buildings.Fluid.ZoneEquipment.FCUControls.Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate
      controller_MultiSpeedCyclingFan_ConstantWaterFlowrate
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=25)
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=23)
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
      amplitude=2,
      freqHz=1/60,
      offset=24)
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  equation
    connect(con.y, controller_MultiSpeedCyclingFan_ConstantWaterFlowrate.TCooSet)
      annotation (Line(points={{-38,20},{-30,20},{-30,0},{-10,0}}, color={0,0,127}));

    connect(con1.y, controller_MultiSpeedCyclingFan_ConstantWaterFlowrate.THeaSet)
      annotation (Line(points={{-38,-20},{-30,-20},{-30,-4},{-10,-4}}, color={0,0,
            127}));

    connect(sin.y, controller_MultiSpeedCyclingFan_ConstantWaterFlowrate.TZon)
      annotation (Line(points={{-58,50},{-20,50},{-20,4},{-10,4}}, color={0,0,127}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=60, __Dymola_Algorithm="Dassl"));

  end Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate;
end Validation;
