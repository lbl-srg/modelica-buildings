within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    heaNoLoc(
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedNoLoc(
    final have_heaPum=false,
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedLoc(
    final have_heaPum=false,
    final have_locSen=true,
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and with local DP sensor"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp isoVal[2](
    duration=fill(1200, 2),
    startTime={0,300})
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={2,1,3})
    "Chilled water pump operating priority"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlo(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen1(
    final offset=8.4*6894.75,
    final freqHz=1/3600,
    final amplitude=0.2*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.05*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin locPreSen(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.2*6894.75) "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold leaChiProOn(
    final trueHoldDuration=2000, falseHoldDuration=0)
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=3) "Replicate plant enabling status"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPla(
    final period=7200,
    final shift=200)
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leaChiEna(
    final period=3600,
    final shift=300) "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=2)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol[3](
    trueHoldDuration=fill(5, 3)) "Chilled water pump status"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[3] "Break loop"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

equation
  connect(conInt.y, heaNoLoc.uPumLeaLag)
    annotation (Line(points={{-38,160},{32,160},{32,171},{78,171}}, color={255,127,0}));
  connect(chiWatFlo.y, heaNoLoc.VChiWat_flow)
    annotation (Line(points={{-38,-50},{48,-50},{48,155},{78,155}},
      color={0,0,127}));
  connect(remPreSen1.y, heaNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-70},{52,-70},{52,151},{78,151}},
      color={0,0,127}));
  connect(remPreSen2.y, heaNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-90},{52,-90},{52,151},{78,151}},
      color={0,0,127}));
  connect(remPreSen1.y, dedNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-70},{52,-70},{52,61},{78,61}},
      color={0,0,127}));
  connect(remPreSen2.y, dedNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-90},{52,-90},{52,61},{78,61}},
      color={0,0,127}));
  connect(locPreSen.y, dedLoc.dpChiWat_local)
    annotation (Line(points={{-78,-110},{48,-110},{48,-87},{78,-87}}, color={0,0,127}));
  connect(remPreSen1.y, dedLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-70},{52,-70},{52,-89},{78,-89}},
      color={0,0,127}));
  connect(remPreSen2.y, dedLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-90},{52,-90},{52,-89},{78,-89}},
      color={0,0,127}));
  connect(enaPla.y, dedNoLoc.uPla) annotation (Line(points={{-38,60},{20,60},{
          20,79},{78,79}}, color={255,0,255}));
  connect(enaPla.y, dedLoc.uPla) annotation (Line(points={{-38,60},{20,60},{20,
          -71},{78,-71}}, color={255,0,255}));
  connect(leaChiEna.y, dedNoLoc.uLeaChiEna) annotation (Line(points={{-38,10},{
          24,10},{24,75},{78,75}}, color={255,0,255}));
  connect(leaChiEna.y, dedLoc.uLeaChiEna) annotation (Line(points={{-38,10},{24,
          10},{24,-75},{78,-75}}, color={255,0,255}));
  connect(leaChiEna.y, leaChiProOn.u) annotation (Line(points={{-38,10},{-30,10},
          {-30,-20},{-22,-20}}, color={255,0,255}));
  connect(leaChiProOn.y, dedNoLoc.uLeaChiSta) annotation (Line(points={{2,-20},
          {28,-20},{28,73},{78,73}},color={255,0,255}));
  connect(leaChiProOn.y, dedLoc.uLeaChiSta) annotation (Line(points={{2,-20},{
          28,-20},{28,-77},{78,-77}}, color={255,0,255}));
  connect(leaChiProOn.y, dedNoLoc.uLeaChiWatReq) annotation (Line(points={{2,-20},
          {28,-20},{28,71},{78,71}}, color={255,0,255}));
  connect(leaChiProOn.y, dedLoc.uLeaChiWatReq) annotation (Line(points={{2,-20},
          {28,-20},{28,-79},{78,-79}}, color={255,0,255}));
  connect(enaPla.y, booRep.u) annotation (Line(points={{-38,60},{-30,60},{-30,40},
          {-22,40}}, color={255,0,255}));
  connect(booRep.y, dedNoLoc.uChiWatPum) annotation (Line(points={{2,40},{32,40},
          {32,77},{78,77}}, color={255,0,255}));
  connect(booRep.y, dedLoc.uChiWatPum) annotation (Line(points={{2,40},{32,40},
          {32,-73},{78,-73}},color={255,0,255}));
  connect(difPreSet.y, reaRep.u)
    annotation (Line(points={{-38,-130},{-22,-130}}, color={0,0,127}));
  connect(reaRep.y, heaNoLoc.dpChiWatSet_remote) annotation (Line(points={{2,-130},
          {56,-130},{56,149},{78,149}}, color={0,0,127}));
  connect(reaRep.y, dedNoLoc.dpChiWatSet_remote) annotation (Line(points={{2,-130},
          {56,-130},{56,59},{78,59}}, color={0,0,127}));
  connect(reaRep.y, dedLoc.dpChiWatSet_remote) annotation (Line(points={{2,-130},
          {56,-130},{56,-91},{78,-91}}, color={0,0,127}));
  connect(isoVal.y, heaNoLoc.uChiWatIsoVal) annotation (Line(points={{-78,140},
          {40,140},{40,157},{78,157}},color={0,0,127}));
  connect(truFalHol.y, heaNoLoc.uChiWatPum) annotation (Line(points={{22,120},{
          44,120},{44,167},{78,167}}, color={255,0,255}));
  connect(heaNoLoc.yChiWatPum, pre.u) annotation (Line(points={{102,160},{120,160},
          {120,140},{70,140},{70,120},{78,120}}, color={255,0,255}));
  connect(pre.y, truFalHol.u) annotation (Line(points={{102,120},{110,120},{110,
          100},{-10,100},{-10,120},{-2,120}}, color={255,0,255}));
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
