within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    heaNoLoc(nPum=3, nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={2,1,3})
    "Chilled water pump operating priority"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedNoLoc(
    isHeadered=false,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedLoc(
    isHeadered=false,
    have_LocalSensor=true,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and with local DP sensor"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlo(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen1(
    final offset=8.4*6894.75,
    final freqHz=1/3600,
    final amplitude=0.2*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.05*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine locPreSen(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.2*6894.75) "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre enaStaRet[3](
    final pre_u_start={true,true,false}) "Pump enabled status return"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre enaStaRet1[3](
    final pre_u_start={true,true,false}) "Pump enabled status return"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre enaStaRet2[3](
    final pre_u_start={true,true,false}) "Pump enabled status return"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr plaEna(nu=3) "Plant enabled"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr plaEna1(nu=3) "Plant enabled"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(conInt.y, heaNoLoc.uPumLeaLag)
    annotation (Line(points={{-38,160},{36,160},{36,170},{78,170}}, color={255,127,0}));
  connect(chiWatFlo.y, heaNoLoc.VChiWat_flow)
    annotation (Line(points={{-38,-40},{48,-40},{48,156},{78,156}},
      color={0,0,127}));
  connect(remPreSen1.y, heaNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-60},{52,-60},{52,152},{78,152}},
      color={0,0,127}));
  connect(remPreSen2.y, heaNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-80},{52,-80},{52,152},{78,152}},
      color={0,0,127}));
  connect(difPreSet.y, heaNoLoc.dpChiWatSet)
    annotation (Line(points={{-38,-120},{56,-120},{56,150},{78,150}},
      color={0,0,127}));
  connect(conInt.y, dedNoLoc.uPumLeaLag)
    annotation (Line(points={{-38,160},{36,160},{36,80},{78,80}}, color={255,127,0}));
  connect(chiWatFlo.y, dedNoLoc.VChiWat_flow)
    annotation (Line(points={{-38,-40},{48,-40},{48,66},{78,66}},
      color={0,0,127}));
  connect(remPreSen1.y, dedNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-60},{52,-60},{52,62},{78,62}},
      color={0,0,127}));
  connect(remPreSen2.y, dedNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-80},{52,-80},{52,62},{78,62}},
      color={0,0,127}));
  connect(difPreSet.y, dedNoLoc.dpChiWatSet)
    annotation (Line(points={{-38,-120},{56,-120},{56,60},{78,60}},
      color={0,0,127}));
  connect(conInt.y, dedLoc.uPumLeaLag)
    annotation (Line(points={{-38,160},{36,160},{36,-60},{78,-60}},
      color={255,127,0}));
  connect(chiWatFlo.y, dedLoc.VChiWat_flow)
    annotation (Line(points={{-38,-40},{48,-40},{48,-74},{78,-74}},
      color={0,0,127}));
  connect(locPreSen.y, dedLoc.dpChiWat_local)
    annotation (Line(points={{-78,-100},{48,-100},{48,-76},{78,-76}}, color={0,0,127}));
  connect(remPreSen1.y, dedLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-60},{52,-60},{52,-78},{78,-78}},
      color={0,0,127}));
  connect(remPreSen2.y, dedLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-80},{52,-80},{52,-78},{78,-78}},
      color={0,0,127}));
  connect(difPreSet.y, dedLoc.dpChiWatSet)
    annotation (Line(points={{-38,-120},{56,-120},{56,-80},{78,-80}}, color={0,0,127}));
  connect(enaStaRet.y, heaNoLoc.uChiWatPum) annotation (Line(points={{-38,120},
          {40,120},{40,166},{78,166}},color={255,0,255}));
  connect(enaStaRet1.y, dedNoLoc.uChiWatPum) annotation (Line(points={{-38,10},
          {40,10},{40,76},{78,76}},color={255,0,255}));
  connect(enaStaRet2.y, dedLoc.uChiWatPum) annotation (Line(points={{-38,-160},
          {40,-160},{40,-64},{78,-64}},color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiEna)
    annotation (Line(points={{-38,50},{44,50},{44,74},{78,74}}, color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiSta)
    annotation (Line(points={{-38,50},{44,50},{44,72},{78,72}}, color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiWatReq)
    annotation (Line(points={{-38,50},{44,50},{44,70},{78,70}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiEna)
    annotation (Line(points={{-38,50},{44,50},{44,-66},{78,-66}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiSta)
    annotation (Line(points={{-38,50},{44,50},{44,-68},{78,-68}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiWatReq)
    annotation (Line(points={{-38,50},{44,50},{44,-70},{78,-70}}, color={255,0,255}));
  connect(con.y, heaNoLoc.uChiIsoVal[1])
    annotation (Line(points={{-38,50},{44,50},{44,158},{78,158}}, color={255,0,255}));
  connect(con.y, heaNoLoc.uChiIsoVal[2])
    annotation (Line(points={{-38,50},{44,50},{44,158},{78,158}}, color={255,0,255}));
  connect(dedNoLoc.yChiWatPum, enaStaRet1.u) annotation (Line(points={{102,78},{
          120,78},{120,30},{-80,30},{-80,10},{-62,10}}, color={255,0,255}));
  connect(enaStaRet1.y, plaEna.u) annotation (Line(points={{-38,10},{-20,10},{-20,
          80},{-2,80}}, color={255,0,255}));
  connect(dedLoc.yChiWatPum, enaStaRet2.u) annotation (Line(points={{102,-62},{120,
          -62},{120,-140},{-80,-140},{-80,-160},{-62,-160}}, color={255,0,255}));
  connect(enaStaRet2.y, plaEna1.u) annotation (Line(points={{-38,-160},{-20,-160},
          {-20,-20},{-2,-20}}, color={255,0,255}));
  connect(plaEna1.y, dedLoc.uPla) annotation (Line(points={{22,-20},{32,-20},{32,
          -62},{78,-62}}, color={255,0,255}));
  connect(plaEna.y, dedNoLoc.uPla) annotation (Line(points={{22,80},{30,80},{30,
          78},{78,78}}, color={255,0,255}));
  connect(heaNoLoc.yChiWatPum, enaStaRet.u) annotation (Line(points={{102,168},{
          120,168},{120,140},{-80,140},{-80,120},{-62,120}}, color={255,0,255}));

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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-180},{140,180}})));
end Controller;
