within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Validation;
model Controller "Validate condenser water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaHavWse
    "Pump speed control for plant with headered condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    dedHavWse(isHeadered=false)
    "Pump speed control for plant with dedicated condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaNoWse(haveWSE=false)
    "Pump speed control for plant with headered condenser water pump and without waterside economizer"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  CDL.Continuous.Sources.Pulse pumSpe(
    amplitude=0.2,
    period=900,
    offset=0.3) "Measured pump speed"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  CDL.Continuous.Sources.Ramp                        ramp1(duration=3600,
      height=2.4)
                "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  CDL.Continuous.Round                        round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  CDL.Conversions.RealToInteger                        reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  CDL.Integers.GreaterThreshold leaChi "Lead chiller status"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  CDL.Logical.Sources.Pulse wseSta(period=1800) "Waterside economizer status"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  CDL.Continuous.Sources.Constant zer(final k=0) "Zero pump speed"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation

  connect(ramp1.y,round1. u)
    annotation (Line(points={{-69,120},{-52,120}},
                                               color={0,0,127}));
  connect(round1.y,reaToInt. u)
    annotation (Line(points={{-29,120},{-12,120}},
                                              color={0,0,127}));
  connect(reaToInt.y, leaChi.u) annotation (Line(points={{11,120},{20,120},{20,
          100},{-20,100},{-20,80},{-12,80}}, color={255,127,0}));
  connect(reaToInt.y, heaHavWse.uChiSta) annotation (Line(points={{11,120},{20,
          120},{20,138},{58,138}}, color={255,127,0}));
  connect(reaToInt.y, dedHavWse.uChiSta) annotation (Line(points={{11,120},{20,
          120},{20,88},{58,88}}, color={255,127,0}));
  connect(reaToInt.y, heaNoWse.uChiSta) annotation (Line(points={{11,120},{20,
          120},{20,8},{58,8}}, color={255,127,0}));
  connect(leaChi.y, heaHavWse.uLeaChiOn) annotation (Line(points={{11,80},{26,
          80},{26,134},{58,134}}, color={255,0,255}));
  connect(leaChi.y, dedHavWse.uLeaChiOn) annotation (Line(points={{11,80},{26,
          80},{26,84},{58,84}}, color={255,0,255}));
  connect(leaChi.y, heaNoWse.uLeaChiOn) annotation (Line(points={{11,80},{26,80},
          {26,4},{58,4}}, color={255,0,255}));
  connect(leaChi.y, heaHavWse.uLeaConWatReq) annotation (Line(points={{11,80},{
          26,80},{26,130},{58,130}}, color={255,0,255}));
  connect(leaChi.y, dedHavWse.uLeaConWatReq)
    annotation (Line(points={{11,80},{58,80}}, color={255,0,255}));
  connect(leaChi.y, heaNoWse.uLeaConWatReq) annotation (Line(points={{11,80},{
          26,80},{26,0},{58,0}}, color={255,0,255}));
  connect(wseSta.y, heaHavWse.uWSE) annotation (Line(points={{11,40},{32,40},{
          32,126},{58,126}}, color={255,0,255}));
  connect(wseSta.y, dedHavWse.uWSE) annotation (Line(points={{11,40},{32,40},{
          32,76},{58,76}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})));
end Controller;
