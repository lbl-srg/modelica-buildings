within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model Supply_T
  "Validation model for outdoor minus room air temperature"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    final TSup_max=303.15,
    final TSup_min=289.15,
    final TSupDew_max=292.15,
    final maxHeaSpe=0.7,
    final maxCooSpe=0.9,
    final minSpe=0.3)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uHea(k=0)
    "Heating control signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCoo(k=0.6)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final duration=3600,
    final height=18,
    final offset=273.15 + 10) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22) "Zone temperature"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dT
    "Difference zone minus outdoor temperature"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSet(
    final k=273.15 + 24)
    "Zone cooling set point"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSet(
    final k=273.15 + 20)
    "Zone heating set point"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,-20},{-12,-20},{
          -12,-12},{58,-12}},  color={0,0,127}));
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-18,50},{34,50},{34,
          -3.6},{58,-3.6}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,30},{28,30},{28,
          -6},{58,-6}},     color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-18,10},{22,10},{22,
          -9},{58,-9}},        color={0,0,127}));
  connect(dT.u1, TZon.y) annotation (Line(points={{58,-44},{34,-44},{34,50},{-18,
          50}},      color={0,0,127}));
  connect(dT.u2, TOut.y) annotation (Line(points={{58,-56},{28,-56},{28,30},{-58,
          30}},      color={0,0,127}));
  connect(opeMod.y, setPoiVAV.uOpeMod) annotation (Line(points={{-58,70},{40,70},
          {40,-1},{58,-1}}, color={255,127,0}));
  connect(TZonCooSet.y, setPoiVAV.TCooSet) annotation (Line(points={{-18,-40},{16,
          -40},{16,-16},{58,-16}}, color={0,0,127}));
  connect(TZonHeaSet.y, setPoiVAV.THeaSet) annotation (Line(points={{-58,-70},{22,
          -70},{22,-19},{58,-19}}, color={0,0,127}));
  annotation (
  experiment(StopTime=3600.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/Supply_T.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for a change in temperature difference between zone air and outdoor air.
Hence, this model validates whether the adjustment of the fan speed for medium
cooling load is correctly implemented.
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
end Supply_T;
