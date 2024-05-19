within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block ResetHotWaterSupplyTemperature
    "Sequence for hot water supply temperature reset"

  parameter Integer nSta = 5
    "Number of stages in boiler plant";

  parameter Real delPro(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 300
    "Process time-out";

  parameter Real TMinSupNonConBoi(
    final min=0,
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 333.2
    "Minimum supply temperature required for non-condensing boilers";

  parameter Real sigDif(
    final min=0,
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Significant difference based on minimum resolution of temperature sensor"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up command"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
      iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaTyp[nSta]
    "Vector of stage-types"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Stage setpoint being changed to"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final min=0,
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatSupTemRes
    "True: Hot water supply temperature has been reset"
    annotation (Placement(transformation(extent={{160,10},{200,50}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer boiStaInd[nSta]={i for i in 1:nSta}
    "Index vector of boiler plant stages";

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Ensure stage-completion signal is passed only when the stage-up signal is active"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler)
    "Pass True if all preceding stages are condensing boiler type stages"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nSta](
    final k=boiStaInd)
    "Boiler plant stage index generator"
    annotation (Placement(transformation(extent={{-156,-70},{-136,-50}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nSta)
    "Generate row vector with current stage setpoint"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes[nSta]
    "Identify stage indices below current setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[nSta]
    "Pass stage-type values for all stage indices lower than current setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nSta](
    final k=fill(0, nSta))
    "Pass zero for stage indices higher than and equal to current setpoint"
    annotation (Placement(transformation(extent={{-80,-96},{-60,-76}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(
    final nin=nSta)
    "Detect maximum from stage-type vector"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Identify stage-type for current stage setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler)
    "Identify if current stage setpoint is a non-condensing boiler stage"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensure current stage setpoint is the lead non-condensing boiler stage"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Pass process completion signal based on whether stage setpoint is lead non-condensing stage"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delPro,
    final delayOnInit=true)
    "Process time-out delay"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Pass process completion signal upon temperature reset or process time-out"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=TMinSupNonConBoi,
    final uHigh=TMinSupNonConBoi + sigDif)
    "Check if measured hot water supply temperature is greater than minimum
    required temperature for non-condensing boilers"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

equation
  connect(intRep.u, uStaSet)
    annotation (Line(points={{-122,-80},{-180,-80}}, color={255,127,0}));

  connect(uStaTyp, intSwi.u1) annotation (Line(points={{-180,-20},{-150,-20},{
          -150,-40},{-50,-40},{-50,-52},{-42,-52}},
                           color={255,127,0}));

  connect(conInt1.y, intSwi.u3) annotation (Line(points={{-58,-86},{-50,-86},{-50,
          -68},{-42,-68}}, color={255,127,0}));

  connect(intSwi.y, intToRea.u)
    annotation (Line(points={{-18,-60},{-2,-60}}, color={255,127,0}));

  connect(uStaTyp, intToRea1.u)
    annotation (Line(points={{-180,-20},{-142,-20}}, color={255,127,0}));

  connect(intToRea1.y, extIndSig.u)
    annotation (Line(points={{-118,-20},{-102,-20}}, color={0,0,127}));

  connect(extIndSig.index, uStaSet) annotation (Line(points={{-90,-32},{-90,-34},
          {-130,-34},{-130,-80},{-180,-80}}, color={255,127,0}));

  connect(extIndSig.y, greThr1.u)
    annotation (Line(points={{-78,-20},{-62,-20}}, color={0,0,127}));

  connect(greThr1.y, and2.u1) annotation (Line(points={{-38,-20},{110,-20},{110,
          -30},{118,-30}}, color={255,0,255}));

  connect(logSwi.y, yHotWatSupTemRes)
    annotation (Line(points={{142,30},{180,30}}, color={255,0,255}));

  connect(truDel.u, uStaUp) annotation (Line(points={{-142,70},{-180,70},{-180,
          70}}, color={255,0,255}));

  connect(or2.u1, truDel.y) annotation (Line(points={{-102,50},{-110,50},{-110,
          70},{-118,70}}, color={255,0,255}));

  connect(and2.y, logSwi.u2) annotation (Line(points={{142,-30},{150,-30},{150,
          10},{110,10},{110,30},{118,30}}, color={255,0,255}));

  connect(uStaUp, logSwi.u3) annotation (Line(points={{-180,70},{-150,70},{-150,
          10},{100,10},{100,22},{118,22}}, color={255,0,255}));

  connect(hys.u, THotWatSup)
    annotation (Line(points={{-142,30},{-180,30}}, color={0,0,127}));

  connect(hys.y, or2.u2) annotation (Line(points={{-118,30},{-110,30},{-110,42},
          {-102,42}}, color={255,0,255}));

  connect(intRep.y, intLes.u2) annotation (Line(points={{-98,-80},{-90,-80},{-90,
          -68},{-82,-68}}, color={255,127,0}));

  connect(conInt.y, intLes.u1)
    annotation (Line(points={{-134,-60},{-82,-60}}, color={255,127,0}));

  connect(intLes.y, intSwi.u2)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,0,255}));

  connect(intToRea.y, mulMax.u[1:nSta]) annotation (Line(points={{22,-60},{30,-60},
          {30,-60},{38,-60}},     color={0,0,127}));

  connect(mulMax.y, lesThr.u)
    annotation (Line(points={{62,-60},{78,-60}}, color={0,0,127}));

  connect(lesThr.y, and2.u2) annotation (Line(points={{102,-60},{110,-60},{110,-38},
          {118,-38}}, color={255,0,255}));

  connect(or2.y, and1.u1)
    annotation (Line(points={{-78,50},{-42,50}}, color={255,0,255}));

  connect(uStaUp, and1.u2) annotation (Line(points={{-180,70},{-150,70},{-150,
          10},{-50,10},{-50,42},{-42,42}}, color={255,0,255}));

  connect(and1.y, logSwi.u1) annotation (Line(points={{-18,50},{100,50},{100,38},
          {118,38}}, color={255,0,255}));

annotation (
  defaultComponentName="hotWatSupTemRes",
  Icon(graphics={
         Rectangle(
           extent={{-100,-100},{100,100}},
           lineColor={0,0,127},
           fillColor={255,255,255},
           fillPattern=FillPattern.Solid),
         Text(
           extent={{-120,146},{100,108}},
           textColor={0,0,255},
           textString="%name"),
         Text(
           extent={{-100,100},{100,-100}},
           textColor={0,0,0},
           textString="S")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-100},{160,100}})),
  Documentation(info="<html>
<p>
Block that generates hot water supply temperature reset status when there is 
stage-change command.
This development is based on RP-1711, March 2020 draft, section 5.3.3.14, item 3.
</p>
<p>
When a stage-up command is received (<code>uStaUp</code> = true),
the sequence checks if the hot water supply temperature <code>THotWatSup</code>
has exceeded the minimum supply temperature for non-condensing boilers
<code>TMinSupNonConBoi</code> or if the process time-out <code>delPro</code> has
been exceeded since <code>uStaUp</code> became true. It will then set <code>yHotWatSupTemRes</code>
to true.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 07, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResetHotWaterSupplyTemperature;
