within Buildings.Controls.OBC.RooftopUnits.Validation;
model ControllerCooling "Validation of controller model"

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon(
    nCoi=3,
    conCoiLow=0.2,
    conCoiHig=0.8,
    uThrCoi=0.8,
    uThrCoi1=0.2,
    uThrCoi2=0.8,
    uThrCoi3=0.1,
    timPer=480,
    timPer1=180,
    timPer2=300,
    timPer3=300,
    minComSpe=0.1,
    maxComSpe=1,
    k1=0.9,
    k2=0.85,
    k3=0.8,
    k4=1,
    k5=10,
    TLocOut=273.15 - 12.2,
    uThrHeaCoi=0.9,
    have_TFroSen=false,
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    TDefLim=273.15,
    dUHys=0.01,
    dTHys=273.2,
    dTHys1=273.65)
    "RTU congtroller"
    annotation (Placement(transformation(extent={{-80,138},{-60,166}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon1(
    nCoi=3,
    conCoiLow=0.2,
    conCoiHig=0.8,
    uThrCoi=0.8,
    uThrCoi1=0.2,
    uThrCoi2=0.8,
    uThrCoi3=0.1,
    timPer=480,
    timPer1=180,
    timPer2=300,
    timPer3=300,
    minComSpe=0.1,
    maxComSpe=1,
    k1=0.9,
    k2=0.85,
    k3=0.8,
    k4=1,
    k5=10,
    TLocOut=273.15 - 12.2,
    uThrHeaCoi=0.9,
    have_TFroSen=false,
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    TDefLim=273.15,
    dUHys=0.01,
    dTHys=273.2,
    dTHys1=273.65)
    "RTU congtroller"
    annotation (Placement(transformation(extent={{80,138},{100,166}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon2(
    nCoi=3,
    conCoiLow=0.2,
    conCoiHig=0.8,
    uThrCoi=0.8,
    uThrCoi1=0.2,
    uThrCoi2=0.8,
    uThrCoi3=0.1,
    timPer=480,
    timPer1=180,
    timPer2=300,
    timPer3=300,
    minComSpe=0.1,
    maxComSpe=1,
    k1=0.9,
    k2=0.85,
    k3=0.8,
    k4=1,
    k5=10,
    TLocOut=273.15 - 12.2,
    uThrHeaCoi=0.9,
    have_TFroSen=false,
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    TDefLim=273.15,
    dUHys=0.01,
    dTHys=273.2,
    dTHys1=273.65)
    "RTU congtroller"
    annotation (Placement(transformation(extent={{-80,-162},{-60,-134}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon3(
    nCoi=3,
    conCoiLow=0.2,
    conCoiHig=0.8,
    uThrCoi=0.8,
    uThrCoi1=0.2,
    uThrCoi2=0.8,
    uThrCoi3=0.1,
    timPer=480,
    timPer1=180,
    timPer2=300,
    timPer3=300,
    minComSpe=0.1,
    maxComSpe=1,
    k1=0.9,
    k2=0.85,
    k3=0.8,
    k4=1,
    k5=10,
    TLocOut=273.15 - 12.2,
    uThrHeaCoi=0.9,
    have_TFroSen=false,
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    TDefLim=273.15,
    dUHys=0.01,
    dTHys=273.2,
    dTHys1=273.65)
    "RTU congtroller"
    annotation (Placement(transformation(extent={{80,-162},{100,-134}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,156},{-20,176}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true}) "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,260},{-120,280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi(
    final height=0.35,
    final duration=3600,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,260},{40,280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,220},{40,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi1(
    final height=0.35,
    final duration=2800,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi1(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout1(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,156},{140,176}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi2(
    final height=0.5,
    final duration=1200,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi2(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout2(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi3(
    final height=0.5,
    final duration=1200,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi3(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout3(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,-144},{-20,-124}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,-144},{140,-124}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));

equation
  connect(conInt1.y, RTUCon.uDemLimLev) annotation (Line(points={{-118,190},{-104,
          190},{-104,150},{-82,150}}, color={255,127,0}));
  connect(TOut.y, RTUCon.TOut) annotation (Line(points={{-118,70},{-100,70},{-100,
          141},{-82,141}}, color={0,0,127}));
  connect(conInt3.y, RTUCon1.uDemLimLev) annotation (Line(points={{42,190},{56,190},
          {56,150},{78,150}}, color={255,127,0}));
  connect(ramCooCoi1.y, RTUCon1.uCooCoi) annotation (Line(points={{42,150},{52,150},
          {52,147},{78,147}}, color={0,0,127}));
  connect(conHeaCoi1.y, RTUCon1.uHeaCoi) annotation (Line(points={{42,110},{52,110},
          {52,144},{78,144}}, color={0,0,127}));
  connect(TOut1.y, RTUCon1.TOut) annotation (Line(points={{42,70},{60,70},{60,141},
          {78,141}}, color={0,0,127}));
  connect(conInt5.y, RTUCon2.uDemLimLev) annotation (Line(points={{-118,-110},{-104,
          -110},{-104,-150},{-82,-150}}, color={255,127,0}));
  connect(ramCooCoi2.y, RTUCon2.uCooCoi) annotation (Line(points={{-118,-150},{-108,
          -150},{-108,-153},{-82,-153}}, color={0,0,127}));
  connect(conHeaCoi2.y, RTUCon2.uHeaCoi) annotation (Line(points={{-118,-190},{-108,
          -190},{-108,-156},{-82,-156}}, color={0,0,127}));
  connect(TOut2.y, RTUCon2.TOut) annotation (Line(points={{-118,-230},{-100,-230},
          {-100,-159},{-82,-159}}, color={0,0,127}));
  connect(conInt7.y, RTUCon3.uDemLimLev) annotation (Line(points={{42,-110},{56,
          -110},{56,-150},{78,-150}}, color={255,127,0}));
  connect(ramCooCoi3.y, RTUCon3.uCooCoi) annotation (Line(points={{42,-150},{52,
          -150},{52,-153},{78,-153}}, color={0,0,127}));
  connect(conHeaCoi3.y, RTUCon3.uHeaCoi) annotation (Line(points={{42,-190},{52,
          -190},{52,-156},{78,-156}}, color={0,0,127}));
  connect(TOut3.y, RTUCon3.TOut) annotation (Line(points={{42,-230},{60,-230},{60,
          -159},{78,-159}}, color={0,0,127}));
  connect(ramCooCoi.y, RTUCon.uCooCoi) annotation (Line(points={{-118,150},{-108,
          150},{-108,147},{-82,147}}, color={0,0,127}));
  connect(RTUCon.uHeaCoi, conHeaCoi.y) annotation (Line(points={{-82,144},{-108,
          144},{-108,110},{-118,110}}, color={0,0,127}));
  connect(Xout.y, RTUCon.XOut) annotation (Line(points={{-118,30},{-90,30},{-90,
          138},{-82,138}}, color={0,0,127}));
  connect(Xout1.y, RTUCon1.XOut) annotation (Line(points={{42,30},{70,30},{70,138},
          {78,138}}, color={0,0,127}));
  connect(Xout2.y, RTUCon2.XOut) annotation (Line(points={{-118,-270},{-90,-270},
          {-90,-162},{-82,-162}}, color={0,0,127}));
  connect(Xout3.y, RTUCon3.XOut) annotation (Line(points={{42,-270},{70,-270},{70,
          -162},{78,-162}}, color={0,0,127}));
  connect(RTUCon.yDXCooCoi, pre1.u) annotation (Line(points={{-58,166},{-42,166}},
          color={255,0,255}));
  connect(RTUCon.yDXHeaCoi, pre2.u) annotation (Line(points={{-58,160},{-50,160},
          {-50,130},{-42,130}}, color={255,0,255}));
  connect(pre2.y, RTUCon.uDXHeaCoi) annotation (Line(points={{-18,130},{-6,130},
          {-6,200},{-92,200},{-92,166},{-82,166}}, color={255,0,255}));
  connect(RTUCon.uCooCoiAva, con1.y) annotation (Line(points={{-82,163},{-82,164},
          {-96,164},{-96,270},{-118,270}}, color={255,0,255}));
  connect(RTUCon.uHeaCoiAva, con1.y) annotation (Line(points={{-82,160},{-96,160},
          {-96,270},{-118,270}}, color={255,0,255}));
  connect(RTUCon.uHeaCoiSeq, conInt.y) annotation (Line(points={{-82,153.8},{-82,
          154},{-100,154},{-100,230},{-118,230}}, color={255,127,0}));
  connect(RTUCon.uCooCoiSeq, conInt.y) annotation (Line(points={{-82,157},{-82,156},
          {-100,156},{-100,230},{-118,230}}, color={255,127,0}));
  connect(RTUCon.uDXCooCoi, pre1.y) annotation (Line(points={{-82,169},{-82,170},
          {-88,170},{-88,190},{-12,190},{-12,166},{-18,166}}, color={255,0,255}));
  connect(RTUCon1.yDXCooCoi, pre3.u) annotation (Line(points={{102,166},{118,166}},
          color={255,0,255}));
  connect(pre3.y, RTUCon1.uDXCooCoi) annotation (Line(points={{142,166},{148,166},
          {148,190},{72,190},{72,170},{78,170},{78,169}}, color={255,0,255}));
  connect(RTUCon1.yDXHeaCoi, pre4.u) annotation (Line(points={{102,160},{110,160},
          {110,130},{118,130}}, color={255,0,255}));
  connect(pre4.y, RTUCon1.uDXHeaCoi) annotation (Line(points={{142,130},{154,130},
          {154,200},{68,200},{68,166},{78,166}}, color={255,0,255}));
  connect(RTUCon1.uCooCoiAva, con2.y) annotation (Line(points={{78,163},{78,162},
          {64,162},{64,270},{42,270}}, color={255,0,255}));
  connect(RTUCon1.uHeaCoiAva, con2.y) annotation (Line(points={{78,160},{64,160},
          {64,270},{42,270}}, color={255,0,255}));
  connect(RTUCon1.uCooCoiSeq, conInt2.y) annotation (Line(points={{78,157},{60,157},
          {60,230},{42,230}}, color={255,127,0}));
  connect(RTUCon1.uHeaCoiSeq, conInt2.y) annotation (Line(points={{78,153.8},{78,
          152},{60,152},{60,230},{42,230}}, color={255,127,0}));
  connect(RTUCon2.yDXCooCoi, pre5.u) annotation (Line(points={{-58,-134},{-42,-134}},
          color={255,0,255}));
  connect(pre5.y, RTUCon2.uDXCooCoi) annotation (Line(points={{-18,-134},{-12,-134},
          {-12,-110},{-88,-110},{-88,-130},{-82,-130},{-82,-131}}, color={255,0,255}));
  connect(RTUCon2.yDXHeaCoi, pre6.u) annotation (Line(points={{-58,-140},{-50,-140},
          {-50,-170},{-42,-170}}, color={255,0,255}));
  connect(pre6.y, RTUCon2.uDXHeaCoi) annotation (Line(points={{-18,-170},{-6,-170},
          {-6,-100},{-92,-100},{-92,-134},{-82,-134}}, color={255,0,255}));
  connect(RTUCon2.uCooCoiAva, con3.y) annotation (Line(points={{-82,-137},{-96,-137},
          {-96,-30},{-118,-30}}, color={255,0,255}));
  connect(RTUCon2.uHeaCoiAva, con3.y) annotation (Line(points={{-82,-140},{-96,-140},
          {-96,-30},{-118,-30}}, color={255,0,255}));
  connect(RTUCon2.uCooCoiSeq, conInt4.y) annotation (Line(points={{-82,-143},{-100,
          -143},{-100,-70},{-118,-70}}, color={255,127,0}));
  connect(RTUCon2.uHeaCoiSeq, conInt4.y) annotation (Line(points={{-82,-146.2},{
          -100,-146.2},{-100,-70},{-118,-70}}, color={255,127,0}));
  connect(RTUCon3.yDXCooCoi, pre7.u) annotation (Line(points={{102,-134},{118,-134},
          {118,-134}}, color={255,0,255}));
  connect(pre7.y, RTUCon3.uDXCooCoi) annotation (Line(points={{142,-134},{148,-134},
          {148,-110},{72,-110},{72,-130},{78,-130},{78,-131}}, color={255,0,255}));
  connect(RTUCon3.yDXHeaCoi, pre8.u) annotation (Line(points={{102,-140},{110,-140},
          {110,-170},{118,-170}}, color={255,0,255}));
  connect(pre8.y, RTUCon3.uDXHeaCoi) annotation (Line(points={{142,-170},{154,-170},
          {154,-100},{68,-100},{68,-134},{78,-134}}, color={255,0,255}));
  connect(RTUCon3.uCooCoiAva, con4.y) annotation (Line(points={{78,-137},{64,-137},
          {64,-30},{42,-30}}, color={255,0,255}));
  connect(RTUCon3.uHeaCoiAva, con4.y) annotation (Line(points={{78,-140},{64,-140},
          {64,-30},{42,-30}}, color={255,0,255}));
  connect(RTUCon3.uCooCoiSeq, conInt6.y) annotation (Line(points={{78,-143},{60,
          -143},{60,-70},{42,-70}}, color={255,127,0}));
  connect(RTUCon3.uHeaCoiSeq, conInt6.y) annotation (Line(points={{78,-146.2},{70,
          -146.2},{70,-146},{60,-146},{60,-70},{42,-70}}, color={255,127,0}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/Validation/ControllerCooling.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.Controller\">
    Buildings.Controls.OBC.RooftopUnits.Controller</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    In Plot[1], when the coil valve position <code>RTUCon.uCooCoi</code> exceeds the threshold 
    <code>RTUCon.uThrCoi</code> set at 0.8 for a duration of <code>RTUCon.timPer</code> 
    amounting to 480 seconds, the controller initiates staging up of the first available DX coil 
    <code>RTUCon.yDXCooCoi[1]=true</code>. 
    </li>
    <li>
    Compared to Plot[1], Plot[2] shows that when <code>RTUCon1.uCooCoi</code> surpasses
    <code>RTUCon1.uThrCoi</code> for an additional duration of <code>RTUCon1.timPer</code>, 
    the controller initiates staging up the next DX coil <code>RTUCon1.yDXCooCoi[2]=true</code>. 
    </li>
    <li>
    Compared to Plot[2], Plot[3] illustrates that when <code>RTUCon2.uCooCoi</code> continually exceeds
    <code>RTUCon2.uThrCoi</code> for another extended period <code>RTUCon2.timPer</code>, 
    the controller initiates staging up the next DX coil <code>RTUCon2.yDXCooCoi[3]=true</code>. 
    </li>
    <li>
    Compared to Plot[3], Plot[4] represents that upon the activation of the demand limit signal to Level 1 
    <code>RTUCon3.uDemLimLev=1</code>, the controller modifies the compressor speed 
    <code>RTUCon3.yComSpeCoo</code> to operate at 90% of its initial speed. 
    </li>
    </ul>
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    August 14, 2022, by Junke Wang and Karthik Devaprasad:<br/>
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
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-300},{160,300}})));
end ControllerCooling;
