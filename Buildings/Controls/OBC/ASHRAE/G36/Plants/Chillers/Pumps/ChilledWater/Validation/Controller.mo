within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller
    heaNoLoc(
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,130},{100,160}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller
    dedNoLoc(
    final have_heaPum=false,
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{80,50},{100,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller
    dedLoc(
    final have_heaPum=false,
    final have_locSen=true,
    final nPum=3,
    final nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and with local DP sensor"
    annotation (Placement(transformation(extent={{80,-90},{100,-60}})));

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
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen1(
    final offset=8.4*6894.75,
    final freqHz=1/3600,
    final amplitude=0.2*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.05*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin locPreSen(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.2*6894.75) "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
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
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Templates.Components.Controls.StatusEmulator sta[3](
    delayTime=fill(2, 3))
    "Chilled water pump proven status emulator"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  CDL.Reals.Sources.Ramp                        locDpSet(
    final height=1000,
    final duration=1500,
    final offset=57000,
    final startTime=500)
                       "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

equation
  connect(conInt.y, heaNoLoc.uPumLeaLag)
    annotation (Line(points={{-38,160},{32,160},{32,158.929},{78,158.929}},
                                                                    color={255,127,0}));
  connect(chiWatFlo.y, heaNoLoc.VChiWat_flow)
    annotation (Line(points={{-38,-40},{42,-40},{42,140.714},{78,140.714}},
      color={0,0,127}));
  connect(remPreSen1.y, heaNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-60},{50,-60},{50,133.214},{78,133.214}},
      color={0,0,127}));
  connect(remPreSen2.y, heaNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-80},{46,-80},{46,133.214},{78,133.214}},
      color={0,0,127}));
  connect(remPreSen1.y, dedNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-78,-60},{50,-60},{50,53.2143},{78,53.2143}},
      color={0,0,127}));
  connect(remPreSen2.y, dedNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-38,-80},{46,-80},{46,53.2143},{78,53.2143}},
      color={0,0,127}));
  connect(locPreSen.y, dedLoc.dpChiWat_local)
    annotation (Line(points={{-78,-100},{50,-100},{50,-82.5},{78,-82.5}},
                                                                      color={0,0,127}));
  connect(enaPla.y, dedNoLoc.uPla) annotation (Line(points={{-38,60},{20,60},{
          20,76.7857},{78,76.7857}},
                           color={255,0,255}));
  connect(enaPla.y, dedLoc.uPla) annotation (Line(points={{-38,60},{20,60},{20,
          -63.2143},{78,-63.2143}},
                          color={255,0,255}));
  connect(leaChiEna.y, dedNoLoc.uLeaChiEna) annotation (Line(points={{-38,10},{
          24,10},{24,72.5},{78,72.5}},
                                   color={255,0,255}));
  connect(leaChiEna.y, dedLoc.uLeaChiEna) annotation (Line(points={{-38,10},{24,
          10},{24,-67.5},{78,-67.5}},
                                  color={255,0,255}));
  connect(leaChiEna.y, leaChiProOn.u) annotation (Line(points={{-38,10},{-30,10},
          {-30,-20},{-22,-20}}, color={255,0,255}));
  connect(leaChiProOn.y, dedNoLoc.uLeaChiSta) annotation (Line(points={{2,-20},
          {28,-20},{28,70.3571},{78,70.3571}},
                                    color={255,0,255}));
  connect(leaChiProOn.y, dedLoc.uLeaChiSta) annotation (Line(points={{2,-20},{
          28,-20},{28,-69.6429},{78,-69.6429}},
                                      color={255,0,255}));
  connect(leaChiProOn.y, dedNoLoc.uLeaChiWatReq) annotation (Line(points={{2,-20},
          {28,-20},{28,68.2143},{78,68.2143}},
                                     color={255,0,255}));
  connect(leaChiProOn.y, dedLoc.uLeaChiWatReq) annotation (Line(points={{2,-20},
          {28,-20},{28,-71.7857},{78,-71.7857}},
                                       color={255,0,255}));
  connect(enaPla.y, booRep.u) annotation (Line(points={{-38,60},{-30,60},{-30,40},
          {-22,40}}, color={255,0,255}));
  connect(booRep.y, dedNoLoc.uChiWatPum) annotation (Line(points={{2,40},{32,40},
          {32,74.6429},{78,74.6429}},
                            color={255,0,255}));
  connect(booRep.y, dedLoc.uChiWatPum) annotation (Line(points={{2,40},{32,40},
          {32,-65.3571},{78,-65.3571}},
                             color={255,0,255}));
  connect(difPreSet.y, reaRep.u)
    annotation (Line(points={{-78,-140},{-2,-140}},  color={0,0,127}));
  connect(reaRep.y, heaNoLoc.dpChiWatSet_remote) annotation (Line(points={{22,-140},
          {56,-140},{56,131.071},{78,131.071}},
                                        color={0,0,127}));
  connect(reaRep.y, dedNoLoc.dpChiWatSet_remote) annotation (Line(points={{22,-140},
          {56,-140},{56,51.0714},{78,51.0714}},
                                      color={0,0,127}));
  connect(isoVal.y, heaNoLoc.uChiWatIsoVal) annotation (Line(points={{-78,140},
          {34,140},{34,142.857},{78,142.857}},
                                      color={0,0,127}));
  connect(heaNoLoc.yChiWatPum, sta.y1) annotation (Line(points={{102,145},{110,
          145},{110,100},{-10,100},{-10,120},{-2,120}},
                                                   color={255,0,255}));
  connect(sta.y1_actual, heaNoLoc.uChiWatPum) annotation (Line(points={{22,120},
          {38,120},{38,154.643},{78,154.643}},
                                       color={255,0,255}));
  connect(locDpSet.y, dedLoc.dpChiWatSet_local) annotation (Line(points={{-38,
          -120},{62,-120},{62,-84.6429},{78,-84.6429}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Pumps/ChilledWater/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.ChilledWater.Controller</a>.
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
