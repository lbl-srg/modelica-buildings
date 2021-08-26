within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model Controller "Validation head pressure controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    closeCoupledPlant=false,
    nChi=2,
    have_parChi=true,
    have_ponyChiller=false,
    desCap=400,
    TChiWatSupMin={278.15,278.15},
    minChiLif=10,
    have_heaPreConSig=false,
    anyVsdCen=false,
    heaExcAppDes=2,
    nChiWatPum=2,
    have_heaChiWatPum=true,
    have_locSenChiWatPum=false,
    nSenChiWatPum=1,
    nConWatPum=2,
    have_heaConWatPum=true,
    nSta=2,
    totSta=6,
    staMat=[1,0; 1,1],
    staVec={0,0.5,1,1.5,2,2.5},
    desConWatPumSpe={0,0.5,0.75,0.6,0.75,0.9},
    desConWatPumNum={0,1,1,2,2,2},
    towCelOnSet={0,1,1,2,2,2},
    nTowCel=2,
    cooTowAppDes=2,
    dpChiWatPumMax={10*6894.76},
    TChiWatSupMax=291.15,
    have_WSE=true,
    chiDesCap={200,200},
    chiMinCap={20,20},
    chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement})
    annotation (Placement(transformation(extent={{-20,-140},{80,160}})));
  CDL.Logical.Sources.Constant                        uChiWatPum[2](final k={
        true,false}) "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,162},{-240,182}})));
  CDL.Continuous.Sources.TimeTable                        timTabLin1(final
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      final table=[0,0; 150,1; 300,2; 450,3; 600,4; 750,5; 900,6; 1050,5; 1200,
        4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-320,-40},{-300,-20}})));
  CDL.Conversions.RealToInteger                        reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  CDL.Logical.TrueDelay truDel(delayTime=120, delayOnInit=true)
    annotation (Placement(transformation(extent={{240,90},{260,110}})));
  CDL.Logical.TrueDelay truDel1(delayTime=120, delayOnInit=true)
    annotation (Placement(transformation(extent={{240,50},{260,70}})));
  CDL.Logical.Sources.Constant uChiAva[2](final k={true,true})
    "Chilled availability"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  CDL.Continuous.Sources.Ramp TChiWatSup1(
    height=3,
    duration=3600,
    offset=273.15 + 5)
    "Chilled water supply upstream of WSE"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
  CDL.Continuous.Sources.Constant TOutWet1(k=303.15)
    "Outdoor wet bulb temperatur"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  CDL.Continuous.Sources.Constant TOut1(k=313.15)
    "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  CDL.Continuous.Sources.Ramp TChiWatRet1(
    height=5,
    duration=3600,
    offset=273.15 + 10) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  CDL.Continuous.Sources.Ramp TChiWatSup2(
    height=3,
    duration=3600,
    offset=273.15 + 4.5)
    "Chilled water supply downstream of WSE"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  CDL.Continuous.Sources.Constant TChiWatFlo1(k=273.15) "Chilled water flow"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  CDL.Continuous.Sources.Constant TConWatRet(k=307.15)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  CDL.Continuous.Sources.Constant TConWatSup(k=305.15)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  CDL.Routing.RealReplicator reaRep(nout=2)
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  CDL.Conversions.BooleanToReal booToRea[2]
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  CDL.Continuous.Product pro[2]
    annotation (Placement(transformation(extent={{260,10},{280,30}})));
  CDL.Continuous.Sources.Ramp dpChiWat(
    height=2*6895,
    duration=3600,
    offset=3*6895,
    startTime=0) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  CDL.Conversions.BooleanToReal booToRea1[2]
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));
  CDL.Continuous.Product pro1[2]
    annotation (Placement(transformation(extent={{-200,-98},{-180,-78}})));
  CDL.Continuous.Product pro2[2]
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
protected
  CDL.Logical.Pre                        chiOneSta(final pre_u_start=false)
    "Chiller one status"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  CDL.Logical.Pre                        chiTwoSta(final pre_u_start=true)
                            "Chiller two status"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  CDL.Logical.Pre towSta1[2](final pre_u_start=fill(false, 2))
    "Tower cell status"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  CDL.Continuous.Sources.Ramp                        watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{-260,-230},{-240,-210}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol[2](final
      samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol1[2](final
      samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{220,20},{240,40}})));
  CDL.Logical.Pre conWatPum[2](final pre_u_start=fill(false, 2))
    "Condenser water pump status setpoint"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol2[2](final
      samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  CDL.Continuous.Sources.Ramp chiCooLoa[2](
    final height={80,70},
    final duration=fill(3600, 2),
    final offset={20,25}) "Current chiller cooling load"
    annotation (Placement(transformation(extent={{-300,-100},{-280,-80}})));
  CDL.Continuous.Sources.Ramp chiLoa[2](
    final height={8,7},
    final duration=fill(3600, 2),
    final offset={2,2.5}) "Current chiller load in ampers"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
equation

  connect(chiPlaCon.uChiWatPum, uChiWatPum.y) annotation (Line(points={{-30,120},
          {-128,120},{-128,172},{-238,172}}, color={255,0,255}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-298,-30},{-282,-30}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.chiWatSupResReq) annotation (Line(points={{-258,
          -30},{-100,-30},{-100,-40},{-30,-40}},    color={255,127,0}));
  connect(chiPlaCon.yChi[1], chiOneSta.u) annotation (Line(points={{90,75},{120,
          75},{120,100},{158,100}},      color={255,0,255}));
  connect(chiPlaCon.yChi[2], chiTwoSta.u) annotation (Line(points={{90,85},{114,
          85},{114,60},{158,60}},        color={255,0,255}));
  connect(chiOneSta.y, truDel.u)
    annotation (Line(points={{182,100},{238,100}}, color={255,0,255}));
  connect(chiTwoSta.y, truDel1.u)
    annotation (Line(points={{182,60},{238,60}},   color={255,0,255}));
  connect(uChiAva.y, chiPlaCon.uChiAva) annotation (Line(points={{-218,-10},{
          -30,-10}},                    color={255,0,255}));
  connect(TOutWet1.y, chiPlaCon.TOutWet) annotation (Line(points={{-258,60},{
          -30,60}},                     color={0,0,127}));
  connect(TOut1.y, chiPlaCon.TOut) annotation (Line(points={{-238,-140},{-150,
          -140},{-150,-70},{-30,-70}},
                               color={0,0,127}));
  connect(TChiWatRet1.y, chiPlaCon.TChiWatRet) annotation (Line(points={{-218,40},
          {-30,40}},                           color={0,0,127}));
  connect(TChiWatSup1.y, chiPlaCon.TChiWatSup) annotation (Line(points={{-258,20},
          {-30,20}},                       color={0,0,127}));
  connect(TChiWatSup2.y, chiPlaCon.TChiWatRetDow) annotation (Line(points={{-278,
          -120},{-170,-120},{-170,50},{-30,50}},    color={0,0,127}));
  connect(TChiWatFlo1.y, chiPlaCon.VChiWat_flow) annotation (Line(points={{-278,
          -160},{-160,-160},{-160,80},{-30,80}},
                                               color={0,0,127}));
  connect(TConWatRet.y, chiPlaCon.TConWatRet) annotation (Line(points={{-198,
          -200},{-120,-200},{-120,30},{-30,30}},   color={0,0,127}));
  connect(TConWatSup.y, chiPlaCon.TConWatSup) annotation (Line(points={{-238,
          -180},{-130,-180},{-130,-100},{-30,-100}},
                                                   color={0,0,127}));
  connect(max1.y, chiPlaCon.uFanSpe) annotation (Line(points={{142,-100},{170,
          -100},{170,-160},{-60,-160},{-60,-90},{-30,-90}},  color={0,0,127}));
  connect(watLev.y, chiPlaCon.watLev) annotation (Line(points={{-238,-220},{-90,
          -220},{-90,-120},{-30,-120}}, color={0,0,127}));
  connect(chiOneSta.y, chiPlaCon.uChiIsoVal[1]) annotation (Line(points={{182,
          100},{200,100},{200,240},{-120,240},{-120,105},{-30,105}}, color={255,
          0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiIsoVal[2]) annotation (Line(points={{182,
          60},{190,60},{190,230},{-110,230},{-110,115},{-30,115}}, color={255,0,
          255}));
  connect(chiOneSta.y, chiPlaCon.uChiConIsoVal[1]) annotation (Line(points={{
          182,100},{200,100},{200,240},{-120,240},{-120,145},{-30,145}}, color=
          {255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiConIsoVal[2]) annotation (Line(points={{
          182,60},{190,60},{190,230},{-110,230},{-110,155},{-30,155}}, color={
          255,0,255}));
  connect(truDel1.y, chiPlaCon.uChi[2]) annotation (Line(points={{262,60},{290,
          60},{290,260},{-100,260},{-100,75},{-30,75}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uChi[1]) annotation (Line(points={{262,100},{280,
          100},{280,250},{-90,250},{-90,65},{-30,65}}, color={255,0,255}));
  connect(truDel1.y, chiPlaCon.uConWatReq[2]) annotation (Line(points={{262,60},
          {290,60},{290,260},{-100,260},{-100,135},{-30,135}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uConWatReq[1]) annotation (Line(points={{262,100},
          {280,100},{280,250},{-90,250},{-90,125},{-30,125}}, color={255,0,255}));
  connect(truDel1.y, chiPlaCon.uChiWatReq[2]) annotation (Line(points={{262,60},
          {290,60},{290,260},{-100,260},{-100,145},{-30,145}}, color={255,0,255}));
  connect(truDel.y, chiPlaCon.uChiWatReq[1]) annotation (Line(points={{262,100},
          {280,100},{280,250},{-90,250},{-90,135},{-30,135}}, color={255,0,255}));
  connect(chiPlaCon.yTowFanSpe[2], max1.u2) annotation (Line(points={{90,-100},
          {106,-100},{106,-106},{118,-106}}, color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe[1], max1.u1) annotation (Line(points={{90,-110},
          {112,-110},{112,-94},{118,-94}}, color={0,0,127}));
  connect(chiPlaCon.yTowCel, towSta1.u) annotation (Line(points={{90,-90},{100,
          -90},{100,-130},{118,-130}}, color={255,0,255}));
  connect(towSta1.y, chiPlaCon.uTowSta) annotation (Line(points={{142,-130},{
          160,-130},{160,-150},{-40,-150},{-40,-130},{-30,-130}}, color={255,0,
          255}));
  connect(chiPlaCon.yTowCelIsoVal, zerOrdHol.u) annotation (Line(points={{90,
          -75},{100,-75},{100,-70},{118,-70}}, color={0,0,127}));
  connect(zerOrdHol.y, chiPlaCon.uIsoVal) annotation (Line(points={{142,-70},{
          180,-70},{180,-170},{-70,-170},{-70,-110},{-30,-110}}, color={0,0,127}));
  connect(chiPlaCon.yConWatPumSpe, reaRep.u) annotation (Line(points={{90,50},{
          120,50},{120,30},{158,30}}, color={0,0,127}));
  connect(reaRep.y, zerOrdHol1.u)
    annotation (Line(points={{182,30},{218,30}}, color={0,0,127}));
  connect(chiPlaCon.yConWatPum, conWatPum.u) annotation (Line(points={{90,20},{
          100,20},{100,0},{118,0}}, color={255,0,255}));
  connect(conWatPum.y, chiPlaCon.uConWatPum) annotation (Line(points={{142,0},{
          210,0},{210,-190},{-100,-190},{-100,-60},{-30,-60}}, color={255,0,255}));
  connect(conWatPum.y, booToRea.u)
    annotation (Line(points={{142,0},{218,0}}, color={255,0,255}));
  connect(zerOrdHol1.y, pro.u1) annotation (Line(points={{242,30},{250,30},{250,
          26},{258,26}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{242,0},{250,0},{250,14},
          {258,14}}, color={0,0,127}));
  connect(pro.y, chiPlaCon.uConWatPumSpe) annotation (Line(points={{282,20},{
          300,20},{300,-210},{-110,-210},{-110,-50},{-30,-50}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal, zerOrdHol2.u) annotation (Line(points={{90,
          -15},{100,-15},{100,-30},{118,-30}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{142,
          -30},{190,-30},{190,-180},{-80,-180},{-80,-30},{-30,-30}}, color={0,0,
          127}));
  connect(dpChiWat.y, chiPlaCon.dpChiWat_remote[1]) annotation (Line(points={{
          -238,110},{-128,110},{-128,90},{-30,90}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-218,210},{-210,210},
          {-210,-82},{-202,-82}}, color={0,0,127}));
  connect(chiCooLoa.y, pro1.u2) annotation (Line(points={{-278,-90},{-220,-90},
          {-220,-94},{-202,-94}}, color={0,0,127}));
  connect(pro1.y, chiPlaCon.uChiCooLoa) annotation (Line(points={{-178,-88},{
          -70,-88},{-70,-80},{-30,-80}}, color={0,0,127}));
  connect(chiLoa.y, pro2.u2) annotation (Line(points={{-238,-60},{-230,-60},{
          -230,-56},{-202,-56}}, color={0,0,127}));
  connect(booToRea1.y, pro2.u1) annotation (Line(points={{-218,210},{-210,210},
          {-210,-44},{-202,-44}}, color={0,0,127}));
  connect(pro2.y, chiPlaCon.uChiLoa) annotation (Line(points={{-178,-50},{-140,
          -50},{-140,0},{-30,0}}, color={0,0,127}));
  connect(truDel.y, booToRea1[1].u) annotation (Line(points={{262,100},{280,100},
          {280,250},{-250,250},{-250,210},{-242,210}}, color={255,0,255}));
  connect(truDel1.y, booToRea1[2].u) annotation (Line(points={{262,60},{290,60},
          {290,260},{-260,260},{-260,210},{-242,210}}, color={255,0,255}));
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
  Icon(coordinateSystem(extent={{-340,-300},{340,300}}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-300},{340,
            300}})));
end Controller;
