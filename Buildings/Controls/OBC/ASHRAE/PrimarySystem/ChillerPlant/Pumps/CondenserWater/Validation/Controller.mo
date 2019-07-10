within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Validation;
model Controller "Validate condenser water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaHavWse
    "Pump speed control for plant with headered condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    dedHavWse(isHeadered=false)
    "Pump speed control for plant with dedicated condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaNoWse(haveWSE=false)
    "Pump speed control for plant with headered condenser water pump and without waterside economizer"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pumSpe(
    final amplitude=0.2,
    final period=900,
    final offset=0.3) "Measured pump speed"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final duration=3600,
    final height=2.4) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold leaChi "Lead chiller status"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(final period=1800)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero pump speed"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

equation
  connect(ramp1.y,round1. u)
    annotation (Line(points={{-69,60},{-52,60}}, color={0,0,127}));
  connect(round1.y,reaToInt. u)
    annotation (Line(points={{-29,60},{-12,60}}, color={0,0,127}));
  connect(reaToInt.y, leaChi.u)
    annotation (Line(points={{11,60},{20,60},{20,40},{-20,40},{-20,20},{-12,20}},
      color={255,127,0}));
  connect(reaToInt.y, heaHavWse.uChiSta)
    annotation (Line(points={{11,60},{20,60},{20,78},{58,78}}, color={255,127,0}));
  connect(reaToInt.y, dedHavWse.uChiSta)
    annotation (Line(points={{11,60},{20,60},{20,28},{58,28}}, color={255,127,0}));
  connect(reaToInt.y, heaNoWse.uChiSta)
    annotation (Line(points={{11,60},{20,60},{20,-52},{58,-52}},  color={255,127,0}));
  connect(leaChi.y, heaHavWse.uLeaChiOn)
    annotation (Line(points={{11,20},{26,20},{26,74},{58,74}}, color={255,0,255}));
  connect(leaChi.y, dedHavWse.uLeaChiOn)
    annotation (Line(points={{11,20},{26,20},{26,24},{58,24}}, color={255,0,255}));
  connect(leaChi.y, heaNoWse.uLeaChiOn)
    annotation (Line(points={{11,20},{26,20},{26,-56},{58,-56}}, color={255,0,255}));
  connect(leaChi.y, heaHavWse.uLeaConWatReq)
    annotation (Line(points={{11,20},{26,20},{26,70},{58,70}}, color={255,0,255}));
  connect(leaChi.y, dedHavWse.uLeaConWatReq)
    annotation (Line(points={{11,20},{58,20}}, color={255,0,255}));
  connect(leaChi.y, heaNoWse.uLeaConWatReq)
    annotation (Line(points={{11,20},{26,20},{26,-60},{58,-60}},color={255,0,255}));
  connect(wseSta.y, heaHavWse.uWSE)
    annotation (Line(points={{11,-20},{32,-20},{32,66},{58,66}}, color={255,0,255}));
  connect(wseSta.y, dedHavWse.uWSE)
    annotation (Line(points={{11,-20},{32,-20},{32,16},{58,16}}, color={255,0,255}));
  connect(heaHavWse.yLeaPum, swi.u2)
    annotation (Line(points={{81,79},{90,79},{90,0},{-40,0},{-40,-80},
      {-12,-80}}, color={255,0,255}));
  connect(pumSpe.y, swi.u1)
    annotation (Line(points={{-59,-60},{-20,-60},{-20,-72},{-12,-72}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-59,-100},{-20,-100},{-20,-88},{-12,-88}},
      color={0,0,127}));
  connect(swi.y, heaHavWse.uConWatPumSpe)
    annotation (Line(points={{11,-80},{40,-80},{40,62},{58,62}}, color={0,0,127}));
  connect(swi.y, dedHavWse.uConWatPumSpe)
    annotation (Line(points={{11,-80},{40,-80},{40,12},{58,12}}, color={0,0,127}));
  connect(swi.y, heaNoWse.uConWatPumSpe)
    annotation (Line(points={{11,-80},{40,-80},{40,-68},{58,-68}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/CondenserWater/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end Controller;
