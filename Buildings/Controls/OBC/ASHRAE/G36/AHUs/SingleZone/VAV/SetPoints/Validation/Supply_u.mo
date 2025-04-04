within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model Supply_u "Validation model for temperature and fan speed"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSup_max=303.15,
    final TSup_min=289.15,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV1(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSup_max=303.15,
    final TSup_min=289.15,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV2(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSup_max=303.15,
    final TSup_min=289.15,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(
    final k=273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    final k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final duration=900,
    final height=-1,
    final offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(final duration=900,
      final startTime=2700)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon1(
    final k=273.15 + 23)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonHeaSet(final k=273.15
         + 22)
    "Zone heating set point"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonCooSet(
    final k=273.15 + 24)
    "Zone cooling set point"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-58,20},{-39.5,20},{
          -39.5,56.4},{58,56.4}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,-10},{-34,-10},{
          -34,54},{58,54}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-58,80},{-12,80},{-12,
          51},{58,51}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          48},{58,48}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TOut) annotation (Line(points={{-58,-10},{-34,-10},
          {-34,14},{58,14}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV1.uHea) annotation (Line(points={{-58,80},{-12,80},{-12,
          11},{58,11}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV1.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          8},{58,8}},   color={0,0,127}));
  connect(TOut.y, setPoiVAV2.TOut)
    annotation (Line(points={{-58,-10},{-34,-10},{-34,-26},{58,-26}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV2.uHea) annotation (Line(points={{-58,80},{-12,80},{-12,
          -29},{58,-29}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV2.uCoo) annotation (Line(points={{-58,50},{-16,50},{-16,
          -32},{58,-32}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TZon) annotation (Line(points={{-58,-10},{-30,-10},
          {-30,16.4},{58,16.4}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(TZon1.y, setPoiVAV2.TZon)
     annotation (Line(points={{-58,-40},{-20,-40},{-20,-23.6},{58,-23.6}}, color={0,0,127},
       pattern=LinePattern.Dash));
  connect(opeMod.y, setPoiVAV.uOpeMod) annotation (Line(points={{22,80},{40,80},
          {40,59},{58,59}}, color={255,127,0}));
  connect(opeMod.y, setPoiVAV1.uOpeMod) annotation (Line(points={{22,80},{40,80},
          {40,19},{58,19}}, color={255,127,0}));
  connect(opeMod.y, setPoiVAV2.uOpeMod) annotation (Line(points={{22,80},{40,80},
          {40,-21},{58,-21}}, color={255,127,0}));
  connect(TZonCooSet.y, setPoiVAV.TCooSet) annotation (Line(points={{-58,-70},{32,
          -70},{32,44},{58,44}}, color={0,0,127}));
  connect(TZonCooSet.y, setPoiVAV1.TCooSet) annotation (Line(points={{-58,-70},{
          32,-70},{32,4},{58,4}}, color={0,0,127}));
  connect(TZonCooSet.y, setPoiVAV2.TCooSet) annotation (Line(points={{-58,-70},{
          32,-70},{32,-36},{58,-36}}, color={0,0,127}));
  connect(TZonHeaSet.y, setPoiVAV.THeaSet) annotation (Line(points={{-58,-100},{
          36,-100},{36,41},{58,41}}, color={0,0,127}));
  connect(TZonHeaSet.y, setPoiVAV1.THeaSet) annotation (Line(points={{-58,-100},
          {36,-100},{36,1},{58,1}}, color={0,0,127}));
  connect(TZonHeaSet.y, setPoiVAV2.THeaSet) annotation (Line(points={{-58,-100},
          {36,-100},{36,-39},{58,-39}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/Supply_u.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for different control signals.
Each controller is configured identical, but the input signal for <code>TZon</code> differs
in order to validate that the fan speed is increased correctly.
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})));
end Supply_u;
