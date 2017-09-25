within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model CoolingMode
  "Test the model ChillerWSE.Examples.BaseClasses.CoolingModeController"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode
  cooModCon(
    deaBan1=1,
    deaBan2=1,
    tWai=30,
    deaBan3=1,
    deaBan4=1)
    "Cooling mode controller used in integrared waterside economizer chilled water system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse TCHWLeaWSE(
    period=300,
    amplitude=15,
    offset=273.15 + 5) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant TWetBub(k=273.15 + 5) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant TAppTow(k=5) "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Constant TCHWEntWSE(k=273.15 + 12)
    "Chilled water return temperature in waterside economizer"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Constant TCHWLeaSet(k=273.15 + 10)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
equation
  connect(TCHWLeaSet.y, cooModCon.TCHWSupSet) annotation (Line(points={{-39,80},
          {-22,80},{-22,8},{-12,8}}, color={0,0,127}));
  connect(TWetBub.y, cooModCon.TWetBul)
    annotation (Line(points={{-39,50},{-26,50},
          {-26,4},{-12,4}}, color={0,0,127}));
  connect(TAppTow.y, cooModCon.TApp) annotation (Line(points={{-39,10},{-28,10},
          {-28,0},{-12,0}}, color={0,0,127}));
  connect(TCHWLeaWSE.y, cooModCon.TCHWSupWSE) annotation (Line(points={{-39,-30},
          {-28,-30},{-28,-4},{-12,-4}}, color={0,0,127}));
  connect(TCHWEntWSE.y, cooModCon.TCHWRetWSE) annotation (Line(points={{-39,-70},
          {-26,-70},{-26,-8},{-12,-8}}, color={0,0,127}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/CoolingMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the cooling mode controller implemented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode</a>.
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
      StopTime=600,
      Tolerance=1e-06));
end CoolingMode;
