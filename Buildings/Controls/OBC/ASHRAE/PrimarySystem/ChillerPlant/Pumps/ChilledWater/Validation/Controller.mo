within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    heaNoLoc(nPum=3, nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={2,1,3})
    "Chilled water pump operating priority"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedNoLoc(
    isHeadered=false,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedLoc(
    isHeadered=false,
    haveLocalSensor=true,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and with local DP sensor"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlo(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen1(
    final offset=8.4*6894.75,
    final freqHz=1/3600,
    final amplitude=0.2*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.05*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine locPreSen(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.2*6894.75) "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[3](
    final pre_u_start={true,true,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[3](
    final pre_u_start={true,true,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[3](
    final pre_u_start={true,true,false}) "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

equation
  connect(conInt.y, heaNoLoc.uPumLeaLag)
    annotation (Line(points={{-18,130},{-4,130},{-4,139},{38,139}}, color={255,127,0}));
  connect(chiWatFlo.y, heaNoLoc.VChiWat_flow)
    annotation (Line(points={{-18,-10},{8,-10},{8,127},{38,127}},
      color={0,0,127}));
  connect(remPreSen1.y, heaNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-58,-30},{12,-30},{12,123},{38,123}},
      color={0,0,127}));
  connect(remPreSen2.y, heaNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-18,-50},{12,-50},{12,123},{38,123}},
      color={0,0,127}));
  connect(difPreSet.y, heaNoLoc.dpChiWatSet)
    annotation (Line(points={{-18,-90},{16,-90},{16,121},{38,121}},
      color={0,0,127}));
  connect(conInt.y, dedNoLoc.uPumLeaLag)
    annotation (Line(points={{-18,130},{-4,130},{-4,79},{38,79}}, color={255,127,0}));
  connect(chiWatFlo.y, dedNoLoc.VChiWat_flow)
    annotation (Line(points={{-18,-10},{8,-10},{8,67},{38,67}},
      color={0,0,127}));
  connect(remPreSen1.y, dedNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-58,-30},{12,-30},{12,63},{38,63}},
      color={0,0,127}));
  connect(remPreSen2.y, dedNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-18,-50},{12,-50},{12,63},{38,63}},
      color={0,0,127}));
  connect(difPreSet.y, dedNoLoc.dpChiWatSet)
    annotation (Line(points={{-18,-90},{16,-90},{16,61},{38,61}},
      color={0,0,127}));
  connect(conInt.y, dedLoc.uPumLeaLag)
    annotation (Line(points={{-18,130},{-4,130},{-4,-31},{38,-31}},
      color={255,127,0}));
  connect(chiWatFlo.y, dedLoc.VChiWat_flow)
    annotation (Line(points={{-18,-10},{8,-10},{8,-43},{38,-43}},
      color={0,0,127}));
  connect(locPreSen.y, dedLoc.dpChiWat_local)
    annotation (Line(points={{-58,-70},{8,-70},{8,-45},{38,-45}}, color={0,0,127}));
  connect(remPreSen1.y, dedLoc.dpChiWat_remote[1])
    annotation (Line(points={{-58,-30},{12,-30},{12,-47},{38,-47}},
      color={0,0,127}));
  connect(remPreSen2.y, dedLoc.dpChiWat_remote[2])
    annotation (Line(points={{-18,-50},{12,-50},{12,-47},{38,-47}},
      color={0,0,127}));
  connect(difPreSet.y, dedLoc.dpChiWatSet)
    annotation (Line(points={{-18,-90},{16,-90},{16,-49},{38,-49}}, color={0,0,127}));
  connect(heaNoLoc.yChiWatPum, pre.u)
    annotation (Line(points={{62,138},{80,138},{80,110},{-60,110},{-60,90},
      {-42,90}}, color={255,0,255}));
  connect(pre.y, heaNoLoc.uChiWatPum)
    annotation (Line(points={{-18,90},{0,90},{0,137},{38,137}}, color={255,0,255}));
  connect(dedNoLoc.yChiWatPum, pre1.u)
    annotation (Line(points={{62,78},{80,78},{80,40},{-60,40},{-60,20},{-42,20}},
      color={255,0,255}));
  connect(pre1.y, dedNoLoc.uChiWatPum)
    annotation (Line(points={{-18,20},{0,20},{0,77},{38,77}}, color={255,0,255}));
  connect(dedLoc.yChiWatPum, pre2.u)
    annotation (Line(points={{62,-32},{80,-32},{80,-110},{-60,-110},{-60,-130},
      {-42,-130}}, color={255,0,255}));
  connect(pre2.y, dedLoc.uChiWatPum)
    annotation (Line(points={{-18,-130},{0,-130},{0,-33},{38,-33}}, color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiEna)
    annotation (Line(points={{-18,60},{4,60},{4,75},{38,75}}, color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiSta)
    annotation (Line(points={{-18,60},{4,60},{4,73},{38,73}}, color={255,0,255}));
  connect(con.y, dedNoLoc.uLeaChiWatReq)
    annotation (Line(points={{-18,60},{4,60},{4,71},{38,71}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiEna)
    annotation (Line(points={{-18,60},{4,60},{4,-35},{38,-35}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiSta)
    annotation (Line(points={{-18,60},{4,60},{4,-37},{38,-37}}, color={255,0,255}));
  connect(con.y, dedLoc.uLeaChiWatReq)
    annotation (Line(points={{-18,60},{4,60},{4,-39},{38,-39}}, color={255,0,255}));
  connect(con.y, heaNoLoc.uChiIsoVal[1])
    annotation (Line(points={{-18,60},{4,60},{4,129},{38,129}}, color={255,0,255}));
  connect(con.y, heaNoLoc.uChiIsoVal[2])
    annotation (Line(points={{-18,60},{4,60},{4,129},{38,129}}, color={255,0,255}));

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
