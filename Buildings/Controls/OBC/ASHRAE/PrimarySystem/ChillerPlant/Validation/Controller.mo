within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model Controller "Validation head pressure controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    have_parChi=true,
    dpChiWatPumMin=60,
    dpChiWatPumMax=150,
    TChiWatSupMin=280.15,
    TChiWatSupMax=291.15,
    have_WSE=false,
    chiDesCap={100,200},
    chiMinCap={10,20},
    chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement})
    annotation (Placement(transformation(extent={{-40,-140},{60,160}})));
  CDL.Logical.Sources.Constant                        uChiWatPum[2](final k={
        true,false}) "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,162},{-240,182}})));
  CDL.Continuous.Sources.TimeTable                        timTabLin1(final
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      final table=[0,0; 150,1; 300,2; 450,3; 600,4; 750,5; 900,6; 1050,5; 1200,
        4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-258,120},{-238,140}})));
  CDL.Conversions.RealToInteger                        reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  CDL.Logical.TrueDelay truDel(delayTime=120, delayOnInit=true)
    annotation (Placement(transformation(extent={{220,140},{240,160}})));
  CDL.Logical.TrueDelay truDel1(delayTime=120, delayOnInit=true)
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  CDL.Logical.Sources.Constant uChiAva[2](final k={true,true})
    "Chilled availability"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  CDL.Continuous.Sources.Ramp TChiWatSup1
    "Chilled water supply upstream of WSE"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  CDL.Continuous.Sources.Constant TOutWet1(k=303.15)
    "Outdoor wet bulb temperatur"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  CDL.Continuous.Sources.Constant TOut1(k=313.15)
    "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  CDL.Continuous.Sources.Ramp TChiWatRet1 "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  CDL.Continuous.Sources.Ramp TChiWatSup2
    "Chilled water supply downstream of WSE"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  CDL.Continuous.Sources.Constant TChiWatFlo1(k=273.15) "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  CDL.Continuous.Sources.Constant TConWatRet(k=307.15)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  CDL.Continuous.Sources.Constant TConWatSup(k=305.15)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
  CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
protected
  CDL.Logical.Pre                        chiOneSta(final pre_u_start=false)
    "Chiller one status"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Logical.Pre                        chiTwoSta(final pre_u_start=true)
                            "Chiller two status"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  CDL.Logical.Pre towSta1[4](final pre_u_start=false) "Tower cell status"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  CDL.Continuous.Sources.Ramp                        watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol[4](final
      samplePeriod=fill(5, 4))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
equation

  connect(chiPlaCon.uChiWatPum, uChiWatPum.y) annotation (Line(points={{-50,100},
          {-100,100},{-100,172},{-238,172}}, color={255,0,255}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-236,130},{-222,130}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.chiWatSupResReq) annotation (Line(points={{
          -198,130},{-160,130},{-160,75},{-50,75}}, color={255,127,0}));
  connect(chiPlaCon.yChi[1], chiOneSta.u) annotation (Line(points={{70,135},{
          100,135},{100,150},{138,150}}, color={255,0,255}));
  connect(chiPlaCon.yChi[2], chiTwoSta.u) annotation (Line(points={{70,135},{
          100,135},{100,110},{138,110}}, color={255,0,255}));
  connect(chiOneSta.y, truDel.u)
    annotation (Line(points={{162,150},{218,150}}, color={255,0,255}));
  connect(chiTwoSta.y, truDel1.u)
    annotation (Line(points={{162,110},{218,110}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uConWatReq[2]) annotation (Line(points={{242,150},
          {260,150},{260,220},{-70,220},{-70,150},{-50,150}}, color={255,0,255}));
  connect(truDel1.y, chiPlaCon.uConWatReq[2]) annotation (Line(points={{242,110},
          {260,110},{260,220},{-70,220},{-70,150},{-50,150}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uChiWatReq[1]) annotation (Line(points={{242,150},
          {260,150},{260,220},{-70,220},{-70,140},{-50,140}}, color={255,0,255}));
  connect(truDel1.y, chiPlaCon.uChiWatReq[2]) annotation (Line(points={{242,110},
          {260,110},{260,220},{-70,220},{-70,140},{-50,140}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uChi[1]) annotation (Line(points={{242,150},{260,
          150},{260,220},{-70,220},{-70,130},{-50,130}}, color={255,0,255}));
  connect(truDel1.y, chiPlaCon.uChi[2]) annotation (Line(points={{242,110},{260,
          110},{260,220},{-70,220},{-70,130},{-50,130}}, color={255,0,255}));
  connect(chiOneSta.y, chiPlaCon.uChiConIsoVal[1]) annotation (Line(points={{
          162,150},{180,150},{180,200},{-80,200},{-80,120},{-50,120}}, color={
          255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiConIsoVal[2]) annotation (Line(points={{
          162,110},{180,110},{180,200},{-80,200},{-80,120},{-50,120}}, color={
          255,0,255}));
  connect(chiOneSta.y, chiPlaCon.uChiIsoVal[1]) annotation (Line(points={{162,
          150},{180,150},{180,210},{-88,210},{-88,110},{-50,110}}, color={255,0,
          255}));
  connect(chiTwoSta.y, chiPlaCon.uChiIsoVal[2]) annotation (Line(points={{162,
          110},{180,110},{180,210},{-88,210},{-88,110},{-50,110}}, color={255,0,
          255}));
  connect(uChiAva.y, chiPlaCon.uChiAva) annotation (Line(points={{-238,90},{
          -140,90},{-140,90},{-50,90}}, color={255,0,255}));
  connect(chiPlaCon.yTowSta, towSta1.u) annotation (Line(points={{70,105},{80,
          105},{80,170},{98,170}}, color={255,0,255}));
  connect(towSta1.y, chiPlaCon.uTowSta) annotation (Line(points={{122,170},{140,
          170},{140,190},{-60,190},{-60,160},{-50,160}}, color={255,0,255}));
  connect(TOutWet1.y, chiPlaCon.TOutWet) annotation (Line(points={{-198,30},{
          -190,30},{-190,35},{-50,35}}, color={0,0,127}));
  connect(TOut1.y, chiPlaCon.TOut) annotation (Line(points={{-158,10},{-140,10},
          {-140,25},{-50,25}}, color={0,0,127}));
  connect(TChiWatRet1.y, chiPlaCon.TChiWatRet) annotation (Line(points={{-198,
          -20},{-100,-20},{-100,10},{-50,10}}, color={0,0,127}));
  connect(TChiWatSup1.y, chiPlaCon.TChiWatSup) annotation (Line(points={{-158,
          -40},{-90,-40},{-90,0},{-50,0}}, color={0,0,127}));
  connect(TChiWatSup2.y, chiPlaCon.TChiWatRetDow) annotation (Line(points={{
          -198,-60},{-80,-60},{-80,-10},{-50,-10}}, color={0,0,127}));
  connect(TChiWatFlo1.y, chiPlaCon.VChiWat_flow) annotation (Line(points={{-238,
          -80},{-70,-80},{-70,-20},{-50,-20}}, color={0,0,127}));
  connect(TConWatRet.y, chiPlaCon.TConWatRet) annotation (Line(points={{-158,
          -130},{-100,-130},{-100,-89},{-50,-89}}, color={0,0,127}));
  connect(TConWatSup.y, chiPlaCon.TConWatSup) annotation (Line(points={{-198,
          -110},{-120,-110},{-120,-99},{-50,-99}}, color={0,0,127}));
  connect(chiPlaCon.yFanSpe[1], max1.u1) annotation (Line(points={{70,-20},{100,
          -20},{100,-14},{118,-14}}, color={0,0,127}));
  connect(chiPlaCon.yFanSpe[2], max1.u2) annotation (Line(points={{70,-20},{100,
          -20},{100,-26},{118,-26}}, color={0,0,127}));
  connect(max1.y, chiPlaCon.uFanSpe) annotation (Line(points={{142,-20},{160,
          -20},{160,-180},{-80,-180},{-80,-115},{-50,-115}}, color={0,0,127}));
  connect(watLev.y, chiPlaCon.watLev) annotation (Line(points={{-198,-170},{-60,
          -170},{-60,-140},{-50,-140}}, color={0,0,127}));
  connect(chiPlaCon.yIsoVal, zerOrdHol.u) annotation (Line(points={{70,-65},{80,
          -65},{80,-70},{98,-70}}, color={0,0,127}));
  connect(zerOrdHol.y, chiPlaCon.uChiLoa) annotation (Line(points={{122,-70},{
          132,-70},{132,-200},{-278,-200},{-278,50},{-50,50}}, color={0,0,127}));
annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
fixme
</p>
</html>", revisions="<html>
<ul>
<li>
August 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-680,-800},{680,800}})));
end Controller;
