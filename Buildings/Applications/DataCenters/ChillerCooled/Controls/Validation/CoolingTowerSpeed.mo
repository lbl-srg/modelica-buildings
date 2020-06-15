within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model CoolingTowerSpeed
  "Test the model ChillerWSE.Examples.BaseClasses.CoolingTowerSpeedControl"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed
    cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Cooling tower speed controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine CHWST(
    amplitude=2,
    freqHz=1/360,
    offset=273.15 + 5)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Constant CWSTSet(k=273.15 + 20)
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Sine CWST(
    amplitude=5,
    freqHz=1/360,
    offset=273.15 + 20)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant CHWSTSet(k=273.15 + 6)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.IntegerTable cooMod(table=[0,1; 360,2; 720,3])
    "Cooling mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(CWSTSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(points={{-39,80},{-20,80},{-20,80},{-20,22},{-20,10},{-12,
          10}},                                         color={0,0,127}));
  connect(CHWSTSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(points={{-39,10},
          {-32,10},{-32,1.11111},{-12,1.11111}}, color={0,0,127}));
  connect(CWST.y, cooTowSpeCon.TCWSup)
    annotation (Line(points={{-39,-30},{-32,-30},
          {-32,-3.33333},{-12,-3.33333}}, color={0,0,127}));
  connect(CHWST.y, cooTowSpeCon.TCHWSup)
    annotation (Line(points={{-39,-70},{-32,
          -70},{-24,-70},{-24,-7.77778},{-12,-7.77778}}, color={0,0,127}));
  connect(cooMod.y, cooTowSpeCon.cooMod)
    annotation (Line(points={{-39,50},{-26,
          50},{-26,5.55556},{-12,5.55556}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/CoolingTowerSpeed.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the controller for the cooling tower fan speed. Detailed control logic can be found in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1080,
      Tolerance=1e-06));
end CoolingTowerSpeed;
