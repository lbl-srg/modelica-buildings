within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Validation;
model Controller "Validate condenser water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaHavWse
    "Condenser water pumps controller for plant with headered condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    dedHavWse(
    final have_heaPum=false)
    "Condenser water pumps controller for plant with dedicated condenser water pump and have waterside economizer"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    heaNoWse(
    final have_WSE=false,
    final totSta=4,
    final staVec={0,1,2,3},
    final desConWatPumSpe={0,0.5,0.5,0.75},
    final desConWatPumNum={0,1,1,2})
    "Condenser water pumps controller for plant with headered condenser water pump and without waterside economizer"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pumSpe(
    final amplitude=0.2,
    final period=900,
    final offset=0.3) "Measured pump speed"
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    final duration=3600,
    final height=2.4) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiSta
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold chiOn "Chiller status"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final period=1800)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-10,14},{10,34}})));
  Buildings.Controls.OBC.CDL.Reals.Switch meaPumSpe "Measured pump speed"
    annotation (Placement(transformation(extent={{-10,-46},{10,-26}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Zero pump speed"
    annotation (Placement(transformation(extent={{-80,-66},{-60,-46}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pumSpeSet "Pump speed setpoint"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pumSpeSetVal(
    final amplitude=0.2,
    final period=900,
    final offset=0.3,
    final shift=100) "Pump speed setpoint"
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false) "Logical false"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600) "Output boolean pulse"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=2) "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Add two integer inputs"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-10,-74},{10,-54}})));

equation
  connect(ramp1.y,round1. u)
    annotation (Line(points={{-68,90},{-52,90}}, color={0,0,127}));
  connect(round1.y, chiSta.u)
    annotation (Line(points={{-28,90},{-12,90}}, color={0,0,127}));
  connect(chiSta.y, chiOn.u)
    annotation (Line(points={{12,90},{20,90},{20,76},{-20,76},{-20,60},{-12,60}},
      color={255,127,0}));
  connect(chiSta.y, heaHavWse.uChiSta)
    annotation (Line(points={{12,90},{20,90},{20,99},{58,99}},   color={255,127,0}));
  connect(chiSta.y, dedHavWse.uChiSta)
    annotation (Line(points={{12,90},{20,90},{20,69},{58,69}}, color={255,127,0}));
  connect(wseSta.y, heaHavWse.uWSE)
    annotation (Line(points={{12,24},{32,24},{32,97},{58,97}}, color={255,0,255}));
  connect(wseSta.y, dedHavWse.uWSE)
    annotation (Line(points={{12,24},{32,24},{32,67},{58,67}}, color={255,0,255}));
  connect(heaHavWse.yLeaPum, meaPumSpe.u2)
    annotation (Line(points={{82,109},{90,109},{90,36},{-40,36},{-40,-36},{-12,-36}},
      color={255,0,255}));
  connect(pumSpe.y, meaPumSpe.u1)
    annotation (Line(points={{-58,-26},{-20,-26},{-20,-28},{-12,-28}},
      color={0,0,127}));
  connect(zer.y, meaPumSpe.u3)
    annotation (Line(points={{-58,-56},{-30,-56},{-30,-44},{-12,-44}},
      color={0,0,127}));
  connect(meaPumSpe.y, heaHavWse.uConWatPumSpe)
    annotation (Line(points={{12,-36},{46,-36},{46,93},{58,93}}, color={0,0,127}));
  connect(meaPumSpe.y, dedHavWse.uConWatPumSpe)
    annotation (Line(points={{12,-36},{46,-36},{46,63},{58,63}}, color={0,0,127}));
  connect(meaPumSpe.y, heaNoWse.uConWatPumSpe)
    annotation (Line(points={{12,-36},{46,-36},{46,-67},{58,-67}}, color={0,0,127}));
  connect(pumSpeSet.u2, heaHavWse.yLeaPum)
    annotation (Line(points={{-12,-6},{-40,-6},{-40,36},{90,36},{90,109},{82,109}},
                 color={255,0,255}));
  connect(pumSpeSetVal.y, pumSpeSet.u1)
    annotation (Line(points={{-58,14},{-20,14},{-20,2},{-12,2}},   color={0,0,127}));
  connect(zer.y, pumSpeSet.u3)
    annotation (Line(points={{-58,-56},{-30,-56},{-30,-14},{-12,-14}},
      color={0,0,127}));
  connect(pumSpeSet.y, heaHavWse.uConWatPumSpeSet)
    annotation (Line(points={{12,-6},{40,-6},{40,95},{58,95}},   color={0,0,127}));
  connect(pumSpeSet.y, dedHavWse.uConWatPumSpeSet)
    annotation (Line(points={{12,-6},{40,-6},{40,65},{58,65}},   color={0,0,127}));
  connect(pumSpeSet.y, heaNoWse.uConWatPumSpeSet)
    annotation (Line(points={{12,-6},{40,-6},{40,-65},{58,-65}},   color={0,0,127}));
  connect(chiOn.y, heaHavWse.uLeaChiSta)
    annotation (Line(points={{12,60},{26,60},{26,106},{58,106}}, color={255,0,255}));
  connect(chiOn.y, heaHavWse.uLeaConWatReq)
    annotation (Line(points={{12,60},{26,60},{26,104},{58,104}}, color={255,0,255}));
  connect(chiOn.y, dedHavWse.uLeaChiSta)
    annotation (Line(points={{12,60},{26,60},{26,76},{58,76}}, color={255,0,255}));
  connect(chiOn.y, dedHavWse.uLeaConWatReq)
    annotation (Line(points={{12,60},{26,60},{26,74},{58,74}}, color={255,0,255}));
  connect(chiOn.y, heaNoWse.uLeaChiSta)
    annotation (Line(points={{12,60},{26,60},{26,-54},{58,-54}}, color={255,0,255}));
  connect(chiOn.y, heaNoWse.uLeaConWatReq)
    annotation (Line(points={{12,60},{26,60},{26,-56},{58,-56}}, color={255,0,255}));
  connect(booPul.y, booToInt.u)
    annotation (Line(points={{-58,-100},{-52,-100}}, color={255,0,255}));
  connect(booToInt.y, addInt.u2)
    annotation (Line(points={{-28,-100},{-20,-100},{-20,-106},{-12,-106}},
      color={255,127,0}));
  connect(chiSta.y, addInt.u1)
    annotation (Line(points={{12,90},{20,90},{20,-80},{-20,-80},{-20,-94},
      {-12,-94}}, color={255,127,0}));
  connect(addInt.y, heaNoWse.uChiSta)
    annotation (Line(points={{12,-100},{26,-100},{26,-61},{58,-61}}, color={255,127,0}));
  connect(chiOn.y, heaHavWse.uLeaChiEna)
    annotation (Line(points={{12,60},{28,60},{28,108},{58,108}}, color={255,0,255}));
  connect(chiOn.y, dedHavWse.uLeaChiEna)
    annotation (Line(points={{12,60},{28,60},{28,78},{58,78}}, color={255,0,255}));
  connect(chiOn.y, heaNoWse.uLeaChiEna)
    annotation (Line(points={{12,60},{28,60},{28,-52},{58,-52}}, color={255,0,255}));
  connect(chiOn.y, heaHavWse.uChiConIsoVal[1])
    annotation (Line(points={{12,60},{28,60},{28,110},{58,110}}, color={255,0,255}));
  connect(chiOn.y, dedHavWse.uChiConIsoVal[1])
    annotation (Line(points={{12,60},{28,60},{28,80},{58,80}}, color={255,0,255}));
  connect(chiOn.y, heaNoWse.uChiConIsoVal[1])
    annotation (Line(points={{12,60},{28,60},{28,-50},{58,-50}}, color={255,0,255}));
  connect(fal.y, heaHavWse.uChiConIsoVal[2])
    annotation (Line(points={{-58,44},{30,44},{30,110},{58,110}}, color={255,0,255}));
  connect(fal.y, dedHavWse.uChiConIsoVal[2])
    annotation (Line(points={{-58,44},{30,44},{30,80},{58,80}}, color={255,0,255}));
  connect(fal.y, heaNoWse.uChiConIsoVal[2])
    annotation (Line(points={{-58,44},{30,44},{30,-50},{58,-50}}, color={255,0,255}));
  connect(con1.y, heaHavWse.uEnaPla) annotation (Line(points={{12,-64},{36,-64},
          {36,102},{58,102}}, color={255,0,255}));
  connect(con1.y, dedHavWse.uEnaPla) annotation (Line(points={{12,-64},{36,-64},
          {36,72},{58,72}}, color={255,0,255}));
  connect(con1.y, heaNoWse.uEnaPla) annotation (Line(points={{12,-64},{36,-64},{
          36,-58},{58,-58}}, color={255,0,255}));
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
August 4, 2019, by Jianjun Hu:<br/>
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
