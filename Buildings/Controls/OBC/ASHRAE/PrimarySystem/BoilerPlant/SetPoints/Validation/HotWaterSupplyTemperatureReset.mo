within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Validation;
block HotWaterSupplyTemperatureReset
  "Validates hot water supply temperature setpoint reset for boiler plants"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset
    hotWatSupTemRes(
    final nPum=2,
    final nSta=1,
    final nBoi=2,
    final nHotWatResReqIgn=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final TPlaHotWatSetMax=353.15,
    final TConBoiHotWatSetMax=353.15,
    final TConBoiHotWatSetOff=-10,
    final THotWatSetMinNonConBoi=341.48,
    final THotWatSetMinConBoi=305.37,
    final delTimVal=600,
    final samPerVal=300,
    final triAmoVal=-2,
    final resAmoVal=3,
    final maxResVal=7,
    final holTimVal=900)
    "Scenario testing lack of hot-water requests"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset
    hotWatSupTemRes1(
    final nPum=2,
    final nSta=1,
    final nBoi=2,
    final nHotWatResReqIgn=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final TPlaHotWatSetMax=353.15,
    final TConBoiHotWatSetMax=353.15,
    final TConBoiHotWatSetOff=-10,
    final THotWatSetMinNonConBoi=341.48,
    final THotWatSetMinConBoi=305.37,
    final delTimVal=600,
    final samPerVal=300,
    final triAmoVal=-2,
    final resAmoVal=3,
    final maxResVal=7,
    final holTimVal=900)
    "Scenario testing increasing number of requests"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset
    hotWatSupTemRes2(
    final nPum=2,
    final nSta=1,
    final nBoi=2,
    final nHotWatResReqIgn=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final TPlaHotWatSetMax=353.15,
    final TConBoiHotWatSetMax=353.15,
    final TConBoiHotWatSetOff=-10,
    final THotWatSetMinNonConBoi=341.48,
    final THotWatSetMinConBoi=305.37,
    final delTimVal=600,
    final samPerVal=300,
    final triAmoVal=-2,
    final resAmoVal=3,
    final maxResVal=7,
    final holTimVal=900)
    "Scenario testing lack of pumps proven on"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset
    hotWatSupTemRes3(
    final nPum=2,
    final nSta=1,
    final nBoi=2,
    final nHotWatResReqIgn=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final TPlaHotWatSetMax=353.15,
    final TConBoiHotWatSetMax=353.15,
    final TConBoiHotWatSetOff=-10,
    final THotWatSetMinNonConBoi=341.48,
    final THotWatSetMinConBoi=305.37,
    final delTimVal=600,
    final samPerVal=300,
    final triAmoVal=-2,
    final resAmoVal=3,
    final maxResVal=7,
    final holTimVal=900)
    "Scenario testing effect of stage change process"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset
    hotWatSupTemRes4(
    final nPum=2,
    final nSta=3,
    final nBoi=2,
    final nHotWatResReqIgn=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler},
    final TPlaHotWatSetMax=353.15,
    final TConBoiHotWatSetMax=353.15,
    final TConBoiHotWatSetOff=-10,
    final THotWatSetMinNonConBoi=341.48,
    final THotWatSetMinConBoi=305.37,
    final delTimVal=600,
    final samPerVal=300,
    final triAmoVal=-2,
    final resAmoVal=3,
    final maxResVal=7,
    final holTimVal=900)
    "Scenario testing switch between condensing and non-condensing stages"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,150},{-130,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,120},{-130,140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Constant source"
    annotation (Placement(transformation(extent={{-152,90},{-132,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=true)
    "Constant source"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to integer converter"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final height=8,
    final duration=1800,
    final offset=2,
    final startTime=1100)
    "Ramp signal"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9(
    final k=true)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to integer converter"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final height=8,
    final duration=1800,
    final offset=2,
    final startTime=1100)
    "Ramp signal"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=1200,
    final shift=1100)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-150,-120},{-130,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[1](
    final k={1})
    "Constant source"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[1](
    final k={1})
    "Constant source"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[1](
    final k={1})
    "Constant source"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8[1](
    final k={1})
    "Constant source"
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt9(
    final k=1)
    "Constant source"
    annotation (Placement(transformation(extent={{-150,-180},{-130,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11(
    final k=true)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con12(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to integer converter"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final height=8,
    final duration=1800,
    final offset=2,
    final startTime=1100)
    "Ramp signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con13(
    final k=false)
    "Constant source"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt10[3](
    final k={2,1,2})
    "Constant source"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Real to integer converter"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=1.25,
    final freqHz=1/7200,
    final offset=2)
    "Sine signal"
    annotation (Placement(transformation(extent={{-90,-180},{-70,-160}})));

equation
  connect(ram.y, reaToInt.u)
    annotation (Line(points={{52,100},{58,100}},     color={0,0,127}));
  connect(ram1.y, reaToInt1.u)
    annotation (Line(points={{-158,-80},{-152,-80}},
                                                 color={0,0,127}));
  connect(con.y, hotWatSupTemRes.uHotWatPumSta[1]) annotation (Line(points={{-128,
          160},{-126,160},{-126,107},{-122,107}}, color={255,0,255}));
  connect(con1.y, hotWatSupTemRes.uHotWatPumSta[2]) annotation (Line(points={{-128,
          130},{-124,130},{-124,109},{-122,109}}, color={255,0,255}));
  connect(conInt.y, hotWatSupTemRes.nHotWatSupResReq) annotation (Line(points={{-130,
          100},{-130,104},{-122,104}},                 color={255,127,0}));
  connect(con2.y, hotWatSupTemRes.uStaCha) annotation (Line(points={{-128,70},{-128,
          100},{-122,100}},           color={255,0,255}));
  connect(conInt1.y, hotWatSupTemRes.uTyp) annotation (Line(points={{-128,40},{-126,
          40},{-126,96},{-122,96}}, color={255,127,0}));
  connect(con6.y, hotWatSupTemRes2.uHotWatPumSta[1]) annotation (Line(points={{-38,
          160},{-30,160},{-30,107},{-22,107}}, color={255,0,255}));
  connect(con7.y, hotWatSupTemRes2.uHotWatPumSta[2]) annotation (Line(points={{-38,
          130},{-30,130},{-30,109},{-22,109}}, color={255,0,255}));
  connect(conInt2.y, hotWatSupTemRes2.nHotWatSupResReq) annotation (Line(points=
         {{-38,100},{-30,100},{-30,104},{-22,104}}, color={255,127,0}));
  connect(con8.y, hotWatSupTemRes2.uStaCha) annotation (Line(points={{-38,70},{-28,
          70},{-28,100},{-22,100}}, color={255,0,255}));
  connect(conInt3.y, hotWatSupTemRes2.uTyp) annotation (Line(points={{-38,40},{-26,
          40},{-26,96},{-22,96}}, color={255,127,0}));
  connect(conInt4.y, hotWatSupTemRes.uCurStaSet) annotation (Line(points={{-128,
          10},{-124,10},{-124,92},{-122,92}}, color={255,127,0}));
  connect(conInt5.y, hotWatSupTemRes2.uCurStaSet) annotation (Line(points={{-38,
          10},{-24,10},{-24,92},{-22,92}}, color={255,127,0}));
  connect(con3.y, hotWatSupTemRes1.uHotWatPumSta[1]) annotation (Line(points={{82,
          160},{92,160},{92,107},{98,107}}, color={255,0,255}));
  connect(con4.y, hotWatSupTemRes1.uHotWatPumSta[2]) annotation (Line(points={{82,
          130},{92,130},{92,109},{98,109}}, color={255,0,255}));
  connect(reaToInt.y, hotWatSupTemRes1.nHotWatSupResReq) annotation (Line(
        points={{82,100},{88,100},{88,104},{98,104}}, color={255,127,0}));
  connect(con5.y, hotWatSupTemRes1.uStaCha) annotation (Line(points={{82,70},{90,
          70},{90,100},{98,100}}, color={255,0,255}));
  connect(conInt6.y, hotWatSupTemRes1.uTyp) annotation (Line(points={{82,40},{92,
          40},{92,96},{98,96}}, color={255,127,0}));
  connect(conInt7.y, hotWatSupTemRes1.uCurStaSet) annotation (Line(points={{82,
          10},{96,10},{96,92},{98,92}}, color={255,127,0}));
  connect(con9.y, hotWatSupTemRes3.uHotWatPumSta[1]) annotation (Line(points={{-128,
          -20},{-124,-20},{-124,-73},{-122,-73}}, color={255,0,255}));
  connect(con10.y, hotWatSupTemRes3.uHotWatPumSta[2]) annotation (Line(points={{
          -128,-50},{-126,-50},{-126,-71},{-122,-71}}, color={255,0,255}));
  connect(reaToInt1.y, hotWatSupTemRes3.nHotWatSupResReq) annotation (Line(
        points={{-128,-80},{-128,-76},{-122,-76}}, color={255,127,0}));
  connect(booPul.y, hotWatSupTemRes3.uStaCha) annotation (Line(points={{-128,-110},
          {-126,-110},{-126,-80},{-122,-80}}, color={255,0,255}));
  connect(conInt8.y, hotWatSupTemRes3.uTyp) annotation (Line(points={{-128,-140},
          {-124,-140},{-124,-84},{-122,-84}}, color={255,127,0}));
  connect(conInt9.y, hotWatSupTemRes3.uCurStaSet) annotation (Line(points={{-128,
          -170},{-122,-170},{-122,-88}}, color={255,127,0}));
  connect(con11.y, hotWatSupTemRes4.uHotWatPumSta[1]) annotation (Line(points={{
          -38,-20},{-30,-20},{-30,-73},{-22,-73}}, color={255,0,255}));
  connect(con12.y, hotWatSupTemRes4.uHotWatPumSta[2]) annotation (Line(points={{
          -38,-50},{-30,-50},{-30,-71},{-22,-71}}, color={255,0,255}));
  connect(ram2.y,reaToInt2. u)
    annotation (Line(points={{-68,-80},{-62,-80}},
                                                 color={0,0,127}));
  connect(reaToInt2.y, hotWatSupTemRes4.nHotWatSupResReq) annotation (Line(
        points={{-38,-80},{-30,-80},{-30,-76},{-22,-76}}, color={255,127,0}));
  connect(con13.y, hotWatSupTemRes4.uStaCha) annotation (Line(points={{-38,-110},
          {-28,-110},{-28,-80},{-22,-80}}, color={255,0,255}));
  connect(conInt10.y, hotWatSupTemRes4.uTyp) annotation (Line(points={{-38,-140},
          {-26,-140},{-26,-84},{-22,-84}}, color={255,127,0}));
  connect(sin.y, reaToInt3.u)
    annotation (Line(points={{-68,-170},{-62,-170}}, color={0,0,127}));
  connect(reaToInt3.y, hotWatSupTemRes4.uCurStaSet) annotation (Line(points={{
          -38,-170},{-22,-170},{-22,-88}}, color={255,127,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
    graphics={
      Ellipse(
        lineColor = {75,138,73},
        fillColor={255,255,255},
        fillPattern = FillPattern.Solid,
        extent={{-100,-100},{100,100}}),
      Polygon(
        lineColor = {0,0,255},
        fillColor = {75,138,73},
        pattern = LinePattern.None,
        fillPattern = FillPattern.Solid,
        points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{180,180}})),
    experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Validation/HotWaterSupplyTemperatureReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.HotWaterSupplyTemperatureReset</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      May 19, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end HotWaterSupplyTemperatureReset;
