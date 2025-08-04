within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model SupplyFan "Validation model for supply fan speed"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan
    setPoiVAV(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan
    setPoiVAV1(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan
    setPoiVAV2(
    final maxHeaSpe=0.7,
    final maxCooSpe=1,
    final minSpe=0.3,
    final TSupDew_max=297.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(
    final k=273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    final k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final duration=900,
    final height=-1,
    final offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final duration=900,
    final startTime=2700)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon1(
    final k=273.15 + 23)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-58,0},{-29.5,0},{-29.5,
          48},{58,48}}, color={0,0,127}, pattern=LinePattern.Dash));
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,-50},{-20,-50},{
          -20,43},{58,43}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-58,80},{20,80},{20,
          37},{58,37}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,40},{10,40},{10,
          32},{58,32}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TOut) annotation (Line(points={{-58,-50},{-20,-50},
          {-20,3},{58,3}},   color={0,0,127}));
  connect(uHea.y, setPoiVAV1.uHea) annotation (Line(points={{-58,80},{20,80},{20,
          -3},{58,-3}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV1.uCoo) annotation (Line(points={{-58,40},{10,40},{10,
          -8},{58,-8}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV2.TOut)
    annotation (Line(points={{-58,-50},{-20,-50},{-20,-37},{58,-37}}, color={0,0,127}));
  connect(uHea.y, setPoiVAV2.uHea) annotation (Line(points={{-58,80},{20,80},{20,
          -43},{58,-43}}, color={0,0,127}));
  connect(uCoo.y, setPoiVAV2.uCoo) annotation (Line(points={{-58,40},{10,40},{10,
          -48},{58,-48}}, color={0,0,127}));
  connect(TOut.y, setPoiVAV1.TZon) annotation (Line(points={{-58,-50},{-10,-50},
          {-10,8},{58,8}}, color={0,0,127}, pattern=LinePattern.Dash));
  connect(TZon1.y, setPoiVAV2.TZon)
     annotation (Line(points={{-58,-90},{0,-90},{0,-32},{58,-32}}, color={0,0,127},
       pattern=LinePattern.Dash));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/SupplyFan.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan</a>
for different control signals.
Each controller is configured identical, but the input signal for <code>TZon</code> differs
in order to validate that the fan speed is increased correctly.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2025, by Jianjun Hu:<br/>
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
end SupplyFan;
