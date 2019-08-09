within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences;
block IntegratedOperation
  "Tower fan speed control when the waterside economizer is enabled and the chillers are running"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Modelica.SIunits.HeatFlowRate minUnLTon[nChi]={1e4, 1e4}
    "Minimum cyclining load below which chiller will begin cycling";
  parameter Real minSpe = 0.1
    "Allowed minimum value of waterside economizer tower maximum speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Load controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Load controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Load controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Load controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    each final unit="W",
    each final quantity="Power") "Current load of each chiller"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCycLoa[nChi](
    final k=minUnLTon)
    "Minimum cycling load of each chiller"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChi](
    each final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID loaCon(
    final controllerType=conTyp,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=1)
    "Controller to maintain chiller load at the sum of minimum cyclining load of operating chillers"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totMinCycLoa(final nin=nChi)
    "Sum of minimum cyclining load for the operating chillers"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totLoa(final nin=nChi) "Total load of operating chillers"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum minCycLoa(final nin=nChi)
    "Sum of minimum cyclining load for all chillers"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div "Output first input divided by second input"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1 "Output first input divided by second input"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=nChi) "Logical or"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Check if WSE is enabled and any chiller is running"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not in the integrated operation"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Output the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "One constant"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTowSpe(final k=minSpe)
    "Minimum speed"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowSpe(final k=1)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is switch from WSE only mode to integrated operation mode"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch fanSpe "Logical switch"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer intOpeTim
    "Count the time after plant switching from WSE-only mode to integrated operation mode"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(final
      threshold=600)           "Check if it is 10 minutes after mode switch"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-180,100},{-62,100}}, color={255,0,255}));
  connect(chiMinCycLoa.y, swi.u1)
    annotation (Line(points={{-98,140},{-80,140},{-80,108},{-62,108}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-98,80},{-80,80},{-80,92},{-62,92}}, color={0,0,127}));
  connect(minCycLoa.y, div.u2)
    annotation (Line(points={{2,140},{20,140},{20,94},{38,94}}, color={0,0,127}));
  connect(minCycLoa.y, div1.u2)
    annotation (Line(points={{2,140},{20,140},{20,54},{38,54}}, color={0,0,127}));
  connect(totLoa.y, div1.u1)
    annotation (Line(points={{2,60},{10,60},{10,66},{38,66}}, color={0,0,127}));
  connect(totMinCycLoa.y, div.u1)
    annotation (Line(points={{2,100},{10,100},{10,106},{38,106}}, color={0,0,127}));
  connect(div.y, loaCon.u_s)
    annotation (Line(points={{62,100},{78,100}}, color={0,0,127}));
  connect(div1.y, loaCon.u_m)
    annotation (Line(points={{62,60},{90,60},{90,88}}, color={0,0,127}));
  connect(mulOr.y, and2.u1)
    annotation (Line(points={{-98,20},{-62,20}},   color={255,0,255}));
  connect(uWSE, and2.u2)
    annotation (Line(points={{-180,0},{-80,0},{-80,12},{-62,12}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-38,20},{-22,20}}, color={255,0,255}));
  connect(not1.y, loaCon.trigger)
    annotation (Line(points={{2,20},{82,20},{82,88}}, color={255,0,255}));
  connect(loaCon.y, lin.u)
    annotation (Line(points={{102,100},{120,100},{120,0},{40,0},{40,-40},{58,
          -40}},
      color={0,0,127}));
  connect(zer1.y, lin.x1)
    annotation (Line(points={{22,-20},{30,-20},{30,-32},{58,-32}}, color={0,0,127}));
  connect(minTowSpe.y, lin.f1)
    annotation (Line(points={{-18,-20},{-10,-20},{-10,-36},{58,-36}}, color={0,0,127}));
  connect(maxTowSpe.y, lin.f2)
    annotation (Line(points={{22,-60},{30,-60},{30,-48},{58,-48}}, color={0,0,127}));
  connect(one.y, lin.x2)
    annotation (Line(points={{-18,-60},{-10,-60},{-10,-44},{58,-44}}, color={0,0,127}));
  connect(mulOr.y, edg.u)
    annotation (Line(points={{-98,20},{-90,20},{-90,-140},{-62,-140}},   color={255,0,255}));
  connect(uWSE, and1.u1)
    annotation (Line(points={{-180,0},{-80,0},{-80,-120},{-2,-120}}, color={255,0,255}));
  connect(edg.y, and1.u2)
    annotation (Line(points={{-38,-140},{-20,-140},{-20,-128},{-2,-128}}, color={255,0,255}));
  connect(and1.y, lat.u)
    annotation (Line(points={{22,-120},{38,-120}}, color={255,0,255}));
  connect(lat.y, intOpeTim.u)
    annotation (Line(points={{62,-120},{78,-120}}, color={255,0,255}));
  connect(intOpeTim.y, greEquThr.u)
    annotation (Line(points={{102,-120},{118,-120}}, color={0,0,127}));
  connect(greEquThr.y, lat.u0)
    annotation (Line(points={{141,-120},{150,-120},{150,-140},{30,-140},
      {30,-126},{39,-126}}, color={255,0,255}));
  connect(lat.y, fanSpe.u2)
    annotation (Line(points={{62,-120},{70,-120},{70,-80},{118,-80}}, color={255,0,255}));
  connect(lin.y, fanSpe.u3)
    annotation (Line(points={{82,-40},{100,-40},{100,-88},{118,-88}}, color={0,0,127}));
  connect(maxTowSpe.y, fanSpe.u1)
    annotation (Line(points={{22,-60},{30,-60},{30,-72},{118,-72}}, color={0,0,127}));
  connect(fanSpe.y, yTowSpe)
    annotation (Line(points={{142,-80},{180,-80}}, color={0,0,127}));
  connect(chiMinCycLoa.y, minCycLoa.u)
    annotation (Line(points={{-98,140},{-22,140}}, color={0,0,127}));
  connect(swi.y, totMinCycLoa.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={0,0,127}));
  connect(chiLoa, totLoa.u)
    annotation (Line(points={{-180,60},{-22,60}},  color={0,0,127}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-180,100},{-140,100},{-140,20},{-122,20}},
      color={255,0,255}));

annotation (
  defaultComponentName="wseTowSpeIntOpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})));
end IntegratedOperation;
