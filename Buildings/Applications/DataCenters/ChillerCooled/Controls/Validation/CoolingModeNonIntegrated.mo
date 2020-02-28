within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model CoolingModeNonIntegrated
  "Example that illustrates the use of Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated
  cooModCon(
    tWai=30,
    deaBan=1,
    TSwi=280.15)
    "Cooling mode controller used in integrared waterside economizer chilled water system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse TCHWSup(
    period=300,
    amplitude=2,
    offset=273.15 + 7) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Sine TWetBub(
    amplitude=4,
    f=1/300,
    offset=273.15 + 8) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant TCHWSupSet(k=273.15 + 10)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.IntegerTable chiNumOn(table=[0,0; 360,1; 540,2; 720,1;
        900,2])
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(points={{-39,70},{-20,70},{-20,6},{-12,6}},
                                     color={0,0,127}));
  connect(TWetBub.y, cooModCon.TWetBul)
    annotation (Line(points={{-39,30},{-26,30},{-26,2},{-12,2}},
                            color={0,0,127}));
  connect(TCHWSup.y, cooModCon.TCHWSup)
    annotation (Line(points={{-39,-30},{-26,
          -30},{-26,-2},{-12,-2}}, color={0,0,127}));
  connect(chiNumOn.y, cooModCon.numOnChi)
    annotation (Line(points={{-39,-70},{
          -20,-70},{-20,-6},{-12,-6}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/CoolingModeNonIntegrated.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the cooling mode controller implemented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingModeNonIntegrated</a>.
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
end CoolingModeNonIntegrated;
