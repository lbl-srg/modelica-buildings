within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block Setpoint "Calculate condener return water temperature setpoint"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Real LIFT_min[nChi] = {12, 12} "Minimum LIFT of each chiller";
  parameter Real LIFT_max[nChi] = {25, 25} "Maximum LIFT of each chiller";
  parameter Modelica.SIunits.Temperature TConWatRet_nominal[nChi] = {303.15, 303.15}
    "Condenser water return temperature (condenser leaving) of each chiller";
  parameter Modelica.SIunits.Temperature TChiWatSupMin[nChi] = {278.15, 278.15}
    "Lowest chilled water supply temperature of each chiller";
  parameter Modelica.SIunits.Time iniPlaTim = 600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(group="Plant startup"));
  parameter Modelica.SIunits.Time ramTim = 180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(group="Plant startup"));
  parameter Modelica.SIunits.Temperature TPlaConWatRet_nominal = 303.15
    "Plant design condenser water return temperature"
    annotation (Dialog(group="Plant startup"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plaParLoaRat(
    final unit="1",
    final min=0,
    final max=1) "Current plant partial load ratio"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatRetSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.MultiMax lifMax(
    final nin=nChi) "Maximum chiller LIFT"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLifMin[nChi](
    final k=LIFT_min)
    "Minimum LIFT of chillers"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zeoCon[nChi](
    each final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax lifMin(
    final nin=nChi) "Minimum chiller LIFT"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add coeA(
    final k1=1.1, final k2=-1.1) "Coefficien A"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback coeB "Coefficient B"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min "Minimum value of two inputs"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Max tarLif "Target chiller LIFT"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add conWatRet
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zeoTim(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant iniTemSet(
    final k=TPlaConWatRet_nominal - 10*5/9)
    "Initial condenser water return temperature which equals to 10 degF less than design condenser water return temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxRamTim(
    final k=ramTim)
    "Time to change the return water temperature from initial value to setpoint"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Output true at moment when input becomes true"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer plaEnaTim
    "Count the time after plant being enabled"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=iniPlaTim)
    "Check if it is 10 minutes after plant being enabled"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPlaEna(
    final delayTime=iniPlaTim)
    "Delay plant enabling status"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer chaTim
    "Count the time after starting to ramp condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desConWatRet[nChi](
    final k=TConWatRet_nominal)
    "Design condenser water return (condenser leaving) temperature of each chiller"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minChiWatSup[nChi](
    final k=TChiWatSupMin)
    "Lowest chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback maxLif[nChi]
    "Maximum LIFT of each chiller"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-200,100},{-82,100}},color={255,0,255}));
  connect(zeoCon.y, swi.u3)
    annotation (Line(points={{-98,80},{-90,80},{-90,92},{-82,92}},
      color={0,0,127}));
  connect(chiLifMin.y, swi.u1)
    annotation (Line(points={{-98,120},{-90,120},{-90,108},{-82,108}},
      color={0,0,127}));
  connect(lifMax.y, coeA.u1)
    annotation (Line(points={{-58,160},{10,160},{10,126},{18,126}}, color={0,0,127}));
  connect(lifMin.y, coeA.u2)
    annotation (Line(points={{2,100},{10,100},{10,114},{18,114}}, color={0,0,127}));
  connect(coeA.y, coeB.u2)
    annotation (Line(points={{42,120},{90,120},{90,148}}, color={0,0,127}));
  connect(lifMax.y, coeB.u1)
    annotation (Line(points={{-58,160},{78,160}}, color={0,0,127}));
  connect(coeA.y, pro.u1)
    annotation (Line(points={{42,120},{60,120},{60,76},{78,76}}, color={0,0,127}));
  connect(coeB.y, add2.u1)
    annotation (Line(points={{102,160},{110,160},{110,76},{118,76}}, color={0,0,127}));
  connect(pro.y, add2.u2)
    annotation (Line(points={{102,70},{110,70},{110,64},{118,64}}, color={0,0,127}));
  connect(lifMax.y, min.u2)
    annotation (Line(points={{-58,160},{-50,160},{-50,4},{-22,4}},
      color={0,0,127}));
  connect(add2.y, min.u1)
    annotation (Line(points={{142,70},{160,70},{160,40},{-40,40},{-40,16},{-22,
          16}},
      color={0,0,127}));
  connect(min.y, tarLif.u2)
    annotation (Line(points={{2,10},{10,10},{10,4},{18,4}},
      color={0,0,127}));
  connect(lifMin.y, tarLif.u1)
    annotation (Line(points={{2,100},{10,100},{10,16},{18,16}}, color={0,0,127}));
  connect(tarLif.y, conWatRet.u1)
    annotation (Line(points={{42,10},{60,10},{60,6},{78,6}},
      color={0,0,127}));
  connect(TChiWatSupSet, conWatRet.u2)
    annotation (Line(points={{-200,-20},{60,-20},{60,-6},{78,-6}},
      color={0,0,127}));
  connect(swi.y, lifMin.u)
    annotation (Line(points={{-58,100},{-22,100}}, color={0,0,127}));
  connect(uPla, edg.u)
    annotation (Line(points={{-200,-140},{-142,-140}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{-118,-140},{-100,-140},{-100,-140},{-82,-140}},
      color={255,0,255}));
  connect(lat.y, plaEnaTim.u)
    annotation (Line(points={{-58,-140},{-40,-140},{-40,-140},{-22,-140}},
      color={255,0,255}));
  connect(plaEnaTim.y, greEquThr.u)
    annotation (Line(points={{2,-140},{18,-140}}, color={0,0,127}));
  connect(greEquThr.y, lat.u0)
    annotation (Line(points={{41,-140},{60,-140},{60,-160},{-100,-160},
      {-100,-146},{-81,-146}}, color={255,0,255}));
  connect(uPla, delPlaEna.u)
    annotation (Line(points={{-200,-140},{-160,-140},{-160,-80},{-142,-80}},
      color={255,0,255}));
  connect(delPlaEna.y, chaTim.u)
    annotation (Line(points={{-118,-80},{-82,-80}}, color={255,0,255}));
  connect(zeoTim.y, lin.x1)
    annotation (Line(points={{62,-50},{80,-50},{80,-72},{138,-72}}, color={0,0,127}));
  connect(iniTemSet.y, lin.f1)
    annotation (Line(points={{2,-50},{20,-50},{20,-76},{138,-76}}, color={0,0,127}));
  connect(chaTim.y, lin.u)
    annotation (Line(points={{-58,-80},{138,-80}}, color={0,0,127}));
  connect(maxRamTim.y, lin.x2)
    annotation (Line(points={{2,-110},{20,-110},{20,-84},{138,-84}}, color={0,0,127}));
  connect(conWatRet.y, lin.f2)
    annotation (Line(points={{102,0},{120,0},{120,-88},{138,-88}}, color={0,0,127}));
  connect(lin.y, TConWatRetSet)
    annotation (Line(points={{162,-80},{200,-80}}, color={0,0,127}));
  connect(plaParLoaRat, pro.u2)
    annotation (Line(points={{-200,40},{-60,40},{-60,64},{78,64}},   color={0,0,127}));
  connect(desConWatRet.y, maxLif.u1)
    annotation (Line(points={{-138,160},{-122,160}}, color={0,0,127}));
  connect(minChiWatSup.y, maxLif.u2)
    annotation (Line(points={{-138,120},{-130,120},{-130,140},{-110,140},{-110,
          148}},
      color={0,0,127}));
  connect(maxLif.y,lifMax.u)
    annotation (Line(points={{-98,160},{-82,160}}, color={0,0,127}));

annotation (
  defaultComponentName="conWatRetSet",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-180},{180,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end Setpoint;
