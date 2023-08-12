within Buildings.Controls.OBC.RooftopUnits.Validation;
model ControllerHeating "Validation of controller model"

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
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,262},{-120,282}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conCooCoi(
    final k=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,142},{-120,162}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramHeaCoi(
    final height=0.5,
    final duration=3600,
    final offset=0.5,
    startTime=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,98},{-120,118}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=273.15 - 15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,262},{40,282}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,220},{40,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conCooCoi1(
    final k=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,142},{40,162}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramHeaCoi1(
    final height=0.5,
    final duration=3600,
    final offset=0.5,
    final startTime=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,98},{40,118}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=273.15 - 15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout1(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,-38},{-120,-18}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=2)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conCooCoi2(
    final k=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,-158},{-120,-138}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramHeaCoi2(
    height=0.5,
    duration=3600,
    offset=0.5,
    startTime=0) "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,-202},{-120,-182}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(
    final k=273.15 - 15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout2(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,-38},{40,-18}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=3)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conCooCoi3(
    final k=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,-158},{40,-138}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramHeaCoi3(
    final height=0.5,
    final duration=3600,
    final offset=0.5,
    final startTime=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,-202},{40,-182}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(
    final k=273.15 - 15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout3(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));

equation

  connect(RTUCon.uDXCoiAva, con1.y) annotation (Line(points={{-82,163.8},{-82,164},
          {-92,164},{-92,272},{-118,272}},color={255,0,255}));
  connect(conInt.y, RTUCon.uCoiSeq) annotation (Line(points={{-118,230},{-100,230},
          {-100,160},{-82,160}},color={255,127,0}));
  connect(conInt1.y, RTUCon.uDemLimLev) annotation (Line(points={{-118,190},{-108,
          190},{-108,156},{-82,156}},           color={255,127,0}));
  connect(TOut.y, RTUCon.TOut) annotation (Line(points={{-118,70},{-100,70},{-100,
          144},{-82,144}}, color={0,0,127}));
  connect(pre2.y, RTUCon1.uDXCoi) annotation (Line(points={{142,150},{148,150},{
          148,180},{74,180},{74,168},{78,168}}, color={255,0,255}));
  connect(RTUCon1.uDXCoiAva, con2.y) annotation (Line(points={{78,163.8},{78,164},
          {68,164},{68,272},{42,272}}, color={255,0,255}));
  connect(conInt2.y, RTUCon1.uCoiSeq) annotation (Line(points={{42,230},{60,230},
          {60,160},{78,160}}, color={255,127,0}));
  connect(conInt3.y, RTUCon1.uDemLimLev) annotation (Line(points={{42,190},{52,190},
          {52,156},{78,156}}, color={255,127,0}));
  connect(conCooCoi1.y, RTUCon1.uCooCoi) annotation (Line(points={{42,152},{78,152}},
          color={0,0,127}));
  connect(ramHeaCoi1.y, RTUCon1.uHeaCoi) annotation (Line(points={{42,108},{52,108},
          {52,148},{78,148}}, color={0,0,127}));
  connect(TOut1.y, RTUCon1.TOut) annotation (Line(points={{42,70},{60,70},{60,144},
          {78,144}}, color={0,0,127}));
  connect(pre3.y, RTUCon2.uDXCoi) annotation (Line(points={{-18,-150},{-12,-150},
          {-12,-120},{-86,-120},{-86,-132},{-82,-132}}, color={255,0,255}));
  connect(RTUCon2.uDXCoiAva, con3.y) annotation (Line(points={{-82,-136.2},{-82,
          -136},{-92,-136},{-92,-28},{-118,-28}}, color={255,0,255}));
  connect(conInt4.y, RTUCon2.uCoiSeq) annotation (Line(points={{-118,-70},{-100,
          -70},{-100,-140},{-82,-140}}, color={255,127,0}));
  connect(conInt5.y, RTUCon2.uDemLimLev) annotation (Line(points={{-118,-110},{-108,
          -110},{-108,-144},{-82,-144}}, color={255,127,0}));
  connect(conCooCoi2.y, RTUCon2.uCooCoi) annotation (Line(points={{-118,-148},{-82,-148}},
          color={0,0,127}));
  connect(ramHeaCoi2.y, RTUCon2.uHeaCoi) annotation (Line(points={{-118,-192},{-108,
          -192},{-108,-152},{-82,-152}}, color={0,0,127}));
  connect(TOut2.y, RTUCon2.TOut) annotation (Line(points={{-118,-230},{-100,-230},
          {-100,-156},{-82,-156}}, color={0,0,127}));
  connect(pre4.y, RTUCon3.uDXCoi) annotation (Line(points={{142,-150},{148,-150},
          {148,-120},{74,-120},{74,-132},{78,-132}}, color={255,0,255}));
  connect(RTUCon3.uDXCoiAva, con4.y) annotation (Line(points={{78,-136.2},{78,-136},
          {68,-136},{68,-28},{42,-28}}, color={255,0,255}));
  connect(conInt6.y, RTUCon3.uCoiSeq) annotation (Line(points={{42,-70},{60,-70},
          {60,-140},{78,-140}}, color={255,127,0}));
  connect(conInt7.y, RTUCon3.uDemLimLev) annotation (Line(points={{42,-110},{52,
          -110},{52,-144},{78,-144}}, color={255,127,0}));
  connect(conCooCoi3.y, RTUCon3.uCooCoi) annotation (Line(points={{42,-148},{78,-148}},
          color={0,0,127}));
  connect(ramHeaCoi3.y, RTUCon3.uHeaCoi) annotation (Line(points={{42,-192},{52,
          -192},{52,-152},{78,-152}}, color={0,0,127}));
  connect(TOut3.y, RTUCon3.TOut) annotation (Line(points={{42,-230},{60,-230},{60,
          -156},{78,-156}}, color={0,0,127}));
  connect(conCooCoi.y, RTUCon.uCooCoi) annotation (Line(points={{-118,152},{-82,152}},
          color={0,0,127}));
  connect(pre1.y, RTUCon.uDXCoi) annotation (Line(points={{-18,150},{-10,150},{-10,
          180},{-86,180},{-86,168},{-82,168}}, color={255,0,255}));
  connect(RTUCon.uHeaCoi, ramHeaCoi.y) annotation (Line(points={{-82,148},{-108,
          148},{-108,108},{-118,108}}, color={0,0,127}));
  connect(RTUCon.yDXHeaCoi, pre1.u) annotation (Line(points={{-58,160},{-50,160},
          {-50,150},{-42,150}}, color={255,0,255}));
  connect(RTUCon1.yDXHeaCoi, pre2.u) annotation (Line(points={{102,160},{110,160},
          {110,150},{118,150}}, color={255,0,255}));
  connect(pre3.u, RTUCon2.yDXHeaCoi) annotation (Line(points={{-42,-150},{-50,-150},
          {-50,-140},{-58,-140}}, color={255,0,255}));
  connect(pre4.u, RTUCon3.yDXHeaCoi) annotation (Line(points={{118,-150},{110,-150},
          {110,-140},{102,-140}}, color={255,0,255}));
  connect(Xout.y, RTUCon.XOut) annotation (Line(points={{-118,30},{-90,30},{-90,
          140},{-82,140}}, color={0,0,127}));
  connect(Xout3.y, RTUCon3.XOut) annotation (Line(points={{42,-270},{70,-270},{70,
          -160},{78,-160}}, color={0,0,127}));
  connect(Xout2.y, RTUCon2.XOut) annotation (Line(points={{-118,-270},{-90,-270},
          {-90,-160},{-82,-160}}, color={0,0,127}));
  connect(Xout1.y, RTUCon1.XOut) annotation (Line(points={{42,30},{70,30},{70,140},
          {78,140}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/Validation/ControllerHeating.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.Controller\">
    Buildings.Controls.OBC.RooftopUnits.Controller</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    August 11, 2022, by Junke Wang and Karthik Devaprasad:<br/>
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
end ControllerHeating;
