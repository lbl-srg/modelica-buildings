within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model UpEnd "Validate sequence of end staging up process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp(
    nChi=2,
    chaChiWatIsoTim=300,
    byPasSetTim=300,
    minFloSet={1,1},
    maxFloSet={1.5,1.5})
    "End staging up process which does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd
    endUp1(
    nChi=2,
    chaChiWatIsoTim=300,
    byPasSetTim=300,
    minFloSet={1,1},
    maxFloSet={1.5,1.5})
    "End staging up process which does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{280,170},{300,190}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-420,100},{-400,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-380,100},{-360,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexDisChi(
    final k=0) "Next disabling chiller"
    annotation (Placement(transformation(extent={{-420,-20},{-400,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-420,20},{-400,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOneHea(final k=true)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlo(final k=2)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-420,-220},{-400,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(final pre_u_start=true)
    "Chiller one status"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  CDL.Logical.Switch                        swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-340,170},{-320,190}})));
  CDL.Continuous.Sources.Constant nexEnaChi(final k=2) "Next enable chiller"
    annotation (Placement(transformation(extent={{-420,190},{-400,210}})));
  CDL.Continuous.Sources.Constant                        zer2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-420,150},{-400,170}})));
  CDL.Conversions.RealToInteger reaToInt "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  CDL.Logical.Sources.Pulse                        booPul1(final width=0.20,
      final period=1200)
                       "Boolean pulse"
    annotation (Placement(transformation(extent={{-420,60},{-400,80}})));
  CDL.Logical.Not upStrDev "Upstream device status"
    annotation (Placement(transformation(extent={{-380,60},{-360,80}})));
  CDL.Logical.Pre chiTwoSta(final pre_u_start=false) "Chiller two status"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Sources.Constant zer3[2](final k=fill(0, 2)) "Constant zero"
    annotation (Placement(transformation(extent={{-420,-100},{-400,-80}})));
  CDL.Continuous.Sources.Constant one[2](final k=fill(1, 2)) "Constant one"
    annotation (Placement(transformation(extent={{-420,-60},{-400,-40}})));
  CDL.Logical.Switch chiWatIsoVal[2] "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-340,-80},{-320,-60}})));
  CDL.Logical.Not chiTwoHea "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));
  CDL.Logical.Sources.Pulse                        booPul2(final width=0.175,
      final period=1200)
                       "Boolean pulse"
    annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));
equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-398,110},{-382,110}}, color={255,0,255}));

  connect(staUp.y, swi2.u2) annotation (Line(points={{-358,110},{-350,110},{-350,
          180},{-342,180}}, color={255,0,255}));
  connect(nexEnaChi.y, swi2.u1) annotation (Line(points={{-398,200},{-380,200},{
          -380,188},{-342,188}}, color={0,0,127}));
  connect(zer2.y, swi2.u3) annotation (Line(points={{-398,160},{-380,160},{-380,
          172},{-342,172}}, color={0,0,127}));
  connect(swi2.y, reaToInt.u)
    annotation (Line(points={{-318,180},{-302,180}}, color={0,0,127}));
  connect(booPul1.y, upStrDev.u)
    annotation (Line(points={{-398,70},{-382,70}}, color={255,0,255}));
  connect(endUp.yChi[1], chiOneSta.u) annotation (Line(points={{-158,188},{-150,
          188},{-150,150},{-142,150}}, color={255,0,255}));
  connect(endUp.yChi[2], chiTwoSta.u) annotation (Line(points={{-158,190},{-150,
          190},{-150,110},{-142,110}}, color={255,0,255}));
  connect(reaToInt.y, endUp.nexEnaChi) annotation (Line(points={{-278,180},{-260,
          180},{-260,190},{-182,190}}, color={255,127,0}));
  connect(staUp.y, endUp.uStaUp) annotation (Line(points={{-358,110},{-256,110},
          {-256,188},{-182,188}}, color={255,0,255}));
  connect(upStrDev.y, endUp.uEnaChiWatIsoVal) annotation (Line(points={{-358,70},
          {-252,70},{-252,186},{-182,186}}, color={255,0,255}));
  connect(chiOneSta.y, endUp.uChi[1]) annotation (Line(points={{-118,150},{-106,
          150},{-106,130},{-248,130},{-248,183},{-182,183}}, color={255,0,255}));
  connect(chiTwoSta.y, endUp.uChi[2]) annotation (Line(points={{-118,110},{-110,
          110},{-110,90},{-244,90},{-244,185},{-182,185}}, color={255,0,255}));
  connect(onOff.y, endUp.uOnOff) annotation (Line(points={{-398,30},{-240,30},{-240,
          182},{-182,182}}, color={255,0,255}));
  connect(nexDisChi.y, endUp.nexDisChi) annotation (Line(points={{-398,-10},{-236,
          -10},{-236,180},{-182,180}}, color={255,127,0}));
  connect(zer3.y, chiWatIsoVal.u3) annotation (Line(points={{-398,-90},{-380,-90},
          {-380,-78},{-342,-78}}, color={0,0,127}));
  connect(one.y, chiWatIsoVal.u1) annotation (Line(points={{-398,-50},{-380,-50},
          {-380,-62},{-342,-62}}, color={0,0,127}));
  connect(chiOneSta.y, endUp.uChiWatReq[1]) annotation (Line(points={{-118,150},
          {-106,150},{-106,130},{-232,130},{-232,177},{-182,177}}, color={255,0,
          255}));
  connect(chiTwoSta.y, endUp.uChiWatReq[2]) annotation (Line(points={{-118,110},
          {-110,110},{-110,90},{-228,90},{-228,179},{-182,179}}, color={255,0,255}));
  connect(chiOneSta.y, chiWatIsoVal[1].u2) annotation (Line(points={{-118,150},{
          -106,150},{-106,-50},{-356,-50},{-356,-70},{-342,-70}}, color={255,0,255}));
  connect(chiTwoSta.y, chiWatIsoVal[2].u2) annotation (Line(points={{-118,110},{
          -110,110},{-110,-46},{-360,-46},{-360,-70},{-342,-70}}, color={255,0,255}));
  connect(chiWatIsoVal.y, endUp.uChiWatIsoVal) annotation (Line(points={{-318,-70},
          {-224,-70},{-224,176},{-182,176}}, color={0,0,127}));
  connect(chiOneSta.y, endUp.uConWatReq[1]) annotation (Line(points={{-118,150},
          {-106,150},{-106,130},{-220,130},{-220,173},{-182,173}}, color={255,0,
          255}));
  connect(chiTwoSta.y, endUp.uConWatReq[2]) annotation (Line(points={{-118,110},
          {-110,110},{-110,90},{-216,90},{-216,175},{-182,175}}, color={255,0,255}));
  connect(booPul2.y, chiTwoHea.u)
    annotation (Line(points={{-398,-170},{-382,-170}}, color={255,0,255}));
  connect(chiOneHea.y, endUp.uChiHeaCon[1]) annotation (Line(points={{-398,-130},
          {-212,-130},{-212,171},{-182,171}}, color={255,0,255}));
  connect(chiTwoHea.y, endUp.uChiHeaCon[2]) annotation (Line(points={{-358,-170},
          {-208,-170},{-208,173},{-182,173}}, color={255,0,255}));
  connect(chiWatFlo.y, endUp.VChiWat_flow) annotation (Line(points={{-398,-210},
          {-204,-210},{-204,170},{-182,170}}, color={0,0,127}));
annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/UpEnd.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.UpEnd</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-440,-320},{440,320}})));
end UpEnd;
