within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    heaNoLoc(nPum=3, nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={2,1,3})
    "Chilled water pump operating priority"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedNoLoc(
    isHeadered=false,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    dedLoc(
    isHeadered=false,
    haveLocalSensor=true,
    nPum=3,
    nPum_nominal=3)
    "Pump speed control for plant with dedicated primary chilled water pump and with local DP sensor"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2)) "Constant true"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlo(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen1(
    final offset=8.4*6894.75,
    final freqHz=1/3600,
    final amplitude=0.2*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.05*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine locPreSen(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=0.2*6894.75) "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

equation
  connect(conInt.y, heaNoLoc.uPumPri)
    annotation (Line(points={{-19,140},{-4,140},{-4,139},{39,139}},
      color={255,127,0}));
  connect(con[1].y, heaNoLoc.uChiWatPum[1])
    annotation (Line(points={{-19,100},{4,100},{4,136.333},{39,136.333}},
      color={255,0,255}));
  connect(con[2].y, heaNoLoc.uChiWatPum[2])
    annotation (Line(points={{-19,100},{4,100},{4,137},{39,137}},
      color={255,0,255}));
  connect(chiWatFlo.y, heaNoLoc.VChiWat_flow)
    annotation (Line(points={{-19,20},{8,20},{8,127},{39,127}},
      color={0,0,127}));
  connect(con[1].y, heaNoLoc.uChiIsoVal[1])
    annotation (Line(points={{-19,100},{4,100},{4,129},{39,129}},
      color={255,0,255}));
  connect(remPreSen1.y, heaNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-19,-20},{12,-20},{12,123},{39,123}},
      color={0,0,127}));
  connect(remPreSen2.y, heaNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-19,-60},{12,-60},{12,123},{39,123}},
      color={0,0,127}));
  connect(difPreSet.y, heaNoLoc.dpChiWatSet)
    annotation (Line(points={{-19,-140},{16,-140},{16,121},{39,121}},
      color={0,0,127}));
  connect(con1.y, heaNoLoc.uChiWatPum[3])
    annotation (Line(points={{-19,60},{0,60},{0,137.667},{39,137.667}},
      color={255,0,255}));
  connect(con1.y, heaNoLoc.uChiIsoVal[2])
    annotation (Line(points={{-19,60},{0,60},{0,129},{39,129}},
      color={255,0,255}));
  connect(conInt.y, dedNoLoc.uPumPri)
    annotation (Line(points={{-19,140},{-4,140},{-4,89},{39,89}},
      color={255,127,0}));
  connect(con[1].y, dedNoLoc.uChiWatPum[1])
    annotation (Line(points={{-19,100},{4,100},{4,86.3333},{39,86.3333}},
      color={255,0,255}));
  connect(con[2].y, dedNoLoc.uChiWatPum[2])
    annotation (Line(points={{-19,100},{4,100},{4,87},{39,87}},
      color={255,0,255}));
  connect(con1.y, dedNoLoc.uChiWatPum[3])
    annotation (Line(points={{-19,60},{0,60},{0,87.6667},{39,87.6667}},
      color={255,0,255}));
  connect(con[1].y, dedNoLoc.uLeaChiEna)
    annotation (Line(points={{-19,100},{4,100},{4,85},{39,85}},
      color={255,0,255}));
  connect(con[1].y, dedNoLoc.uLeaChiOn)
    annotation (Line(points={{-19,100},{4,100},{4,83},{39,83}},
      color={255,0,255}));
  connect(con[1].y, dedNoLoc.uLeaChiWatReq)
    annotation (Line(points={{-19,100},{4,100},{4,81},{39,81}},
      color={255,0,255}));
  connect(chiWatFlo.y, dedNoLoc.VChiWat_flow)
    annotation (Line(points={{-19,20},{8,20},{8,77},{39,77}},
      color={0,0,127}));
  connect(remPreSen1.y, dedNoLoc.dpChiWat_remote[1])
    annotation (Line(points={{-19,-20},{12,-20},{12,73},{39,73}},
      color={0,0,127}));
  connect(remPreSen2.y, dedNoLoc.dpChiWat_remote[2])
    annotation (Line(points={{-19,-60},{12,-60},{12,73},{39,73}},
      color={0,0,127}));
  connect(difPreSet.y, dedNoLoc.dpChiWatSet)
    annotation (Line(points={{-19,-140},{16,-140},{16,71},{39,71}},
      color={0,0,127}));
  connect(conInt.y, dedLoc.uPumPri)
    annotation (Line(points={{-19,140},{-4,140},{-4,9},{39,9}},
      color={255,127,0}));
  connect(con[1].y, dedLoc.uChiWatPum[1])
    annotation (Line(points={{-19,100},{4,100},{4,6.33333},{39,6.33333}},
      color={255,0,255}));
  connect(con[2].y, dedLoc.uChiWatPum[2])
    annotation (Line(points={{-19,100},{4,100},{4,7},{39,7}}, color={255,0,255}));
  connect(con1.y, dedLoc.uChiWatPum[3])
    annotation (Line(points={{-19,60},{0,60},{0,7.66667},{39,7.66667}},
      color={255,0,255}));
  connect(con[1].y, dedLoc.uLeaChiEna)
    annotation (Line(points={{-19,100},{4,100},{4,5},{39,5}}, color={255,0,255}));
  connect(con[1].y, dedLoc.uLeaChiOn)
    annotation (Line(points={{-19,100},{4,100},{4,3},{39,3}}, color={255,0,255}));
  connect(con[1].y, dedLoc.uLeaChiWatReq)
    annotation (Line(points={{-19,100},{4,100},{4,1},{39,1}},  color={255,0,255}));
  connect(chiWatFlo.y, dedLoc.VChiWat_flow)
    annotation (Line(points={{-19,20},{8,20},{8,-3},{39,-3}}, color={0,0,127}));
  connect(locPreSen.y, dedLoc.dpChiWat_local)
    annotation (Line(points={{-19,-100},{8,-100},{8,-5},{39,-5}}, color={0,0,127}));
  connect(remPreSen1.y, dedLoc.dpChiWat_remote[1])
    annotation (Line(points={{-19,-20},{12,-20},{12,-7},{39,-7}}, color={0,0,127}));
  connect(remPreSen2.y, dedLoc.dpChiWat_remote[2])
    annotation (Line(points={{-19,-60},{12,-60},{12,-7},{39,-7}}, color={0,0,127}));
  connect(difPreSet.y, dedLoc.dpChiWatSet)
    annotation (Line(points={{-19,-140},{16,-140},{16,-9},{39,-9}},  color={0,0,127}));

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
