within Buildings.DHC.Plants.Cooling.Controls;
model ChillerStage
  "Chiller staging controller for plants with two chillers of the same size"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  parameter Modelica.Units.SI.Time tWai "Waiting time";
  parameter Modelica.Units.SI.Power QChi_nominal(final max=0)
    "Nominal cooling capacity (negative)";
  parameter Modelica.Units.SI.Power staUpThr(final min=0) = -0.8*QChi_nominal
    "Stage up load threshold(from one to two chillers)";
  parameter Modelica.Units.SI.Power staDowThr(final min=0) = -0.6*QChi_nominal
    "Stage down load threshold(from two to one chiller)";
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Enabling signal of the plant. True: chiller should be enabled"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-200,40},{-160,80}})));
  Modelica.Blocks.Interfaces.RealInput TChiWatRet
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-200,-24},{-160,16}}),
      iconTransformation(extent={{-200,-24},{-160,16}})));
  Modelica.Blocks.Interfaces.RealInput TChiWatSup
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-200,-60},{-160,-20}})));
  Modelica.Blocks.Interfaces.RealInput mFloChiWat
    "Chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-200,-96},{-160,-56}}),
      iconTransformation(extent={{-200,-96},{-160,-56}})));
  Modelica.Blocks.Interfaces.BooleanOutput y[2]
    "On/off signal for the chillers - false: off; true: on"
    annotation (Placement(transformation(extent={{160,10},{180,-10}}),
      iconTransformation(extent={{160,-10},{180,10}})));
  Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
    "No cooling is demanded"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=-90,origin={10,90})));
  Modelica.StateGraph.StepWithSignal oneOn(
    nOut=2,
    nIn=2)
    "Status of one chiller on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={10,0})));
  Modelica.StateGraph.StepWithSignal twoOn(nOut=1, nIn=1)
    "Status of two chillers on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={10,-90})));
  Modelica.StateGraph.TransitionWithSignal offToOne(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from off to one chiller on"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=90,origin={10,60})));
  Modelica.StateGraph.TransitionWithSignal oneToTwo(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to two chillers"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=90,origin={10,-40})));
  Modelica.StateGraph.TransitionWithSignal twoToOne(
    enableTimer=true,
    waitTime=tWai) "Condition of transion from two chillers to one chiller"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90,origin={60,-40})));
  Modelica.StateGraph.TransitionWithSignal oneToOff(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90,origin={40,60})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis thrOneToTwo(uLow=-staDowThr/
        QChi_nominal, uHigh=-staUpThr/QChi_nominal)
                    "Threshold of turning two chillers on"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Logical.Not thrTwoToOne
    "Threshold of turning off the second chiller"
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Modelica.Blocks.Math.Add dT(
    final k1=-1,
    final k2=+1)
    "Temperature difference"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Math.Gain plr(final k=cp_default/QChi_nominal)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{-102,-80},{-82,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or Or "On signal for either chiller"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Logical.Not notOn "on switches to false"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Logical.Or TwoToOne
    "Conditions that turn off the second chiller"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(off.outPort[1],offToOne.inPort)
    annotation (Line(points={{10,79.5},{10,64}},color={0,0,0}));
  connect(oneToTwo.outPort,twoOn.inPort[1])
    annotation (Line(points={{10,-41.5},{10,-79}},color={0,0,0}));
  connect(twoToOne.outPort,oneOn.inPort[2])
    annotation (Line(points={{60,-38.5},{60,20},{9.75,20},{9.75,11}},
      color={0,0,0}));
  connect(oneOn.outPort[2],oneToOff.inPort)
    annotation (Line(points={{9.875,-10.5},{9.875,-20},{40,-20},{40,56}},
      color={0,0,0}));
  connect(oneOn.outPort[1],oneToTwo.inPort)
    annotation (Line(points={{10.125,-10.5},{10.125,-36},{10,-36}},
      color={0,0,0}));
  connect(oneToTwo.condition,thrOneToTwo.y)
    annotation (Line(points={{-2,-40},{-20,-40},{-20,-70},{-38,-70}},
      color={255,0,255}));
  connect(dT.y,pro.u1)
    annotation (Line(points={{-119,-10},{-114,-10},{-114,-40},{-150,-40},
      {-150,-64},{-142,-64}},color={0,0,127}));
  connect(plr.u, pro.y)
    annotation (Line(points={{-104,-70},{-119,-70}},
      color={0,0,127}));
  connect(plr.y, thrOneToTwo.u) annotation (Line(points={{-81,-70},{-62,-70}},
    color={0,0,127}));
  connect(dT.u1,TChiWatRet)
    annotation (Line(points={{-142,-4},{-180,-4}},
      color={0,0,127}));
  connect(TChiWatSup,dT.u2)
    annotation (Line(points={{-180,-40},{-160,-40},{-160,-16},{-142,-16}},
      color={0,0,127}));
  connect(pro.u2,mFloChiWat)
    annotation (Line(points={{-142,-76},{-180,-76}},color={0,0,127}));
  connect(oneToTwo.condition, thrTwoToOne.u)
    annotation (Line(points={{-2,-40},{-108,-40},{-108,-8},{-102,-8}},
      color={255,0,255}));
  connect(oneOn.active, Or.u1)
    annotation (Line(points={{21,-8.88178e-16},{80,-8.88178e-16},{80,30},{118,30}},
      color={255,0,255}));
  connect(twoOn.active, Or.u2)
    annotation (Line(points={{21,-90},{100,-90},{100,22},{118,22}},
      color={255,0,255}));
  connect(Or.y, y[1])
    annotation (Line(points={{142,30},{144,30},{144,-2.5},{170,-2.5}},
      color={255,0,255}));
  connect(twoOn.active, y[2])
    annotation (Line(points={{21,-90},{120,-90},{120,2.5},{170,2.5}},
      color={255,0,255}));
  connect(on, notOn.u)
    annotation (Line(points={{-180,60},{-120,60},{-120,30},{-102,30}},
      color={255,0,255}));
  connect(twoOn.outPort[1],twoToOne.inPort)
    annotation (Line(points={{10,-100.5},{10,-120},{60,-120},{60,-44}},
      color={0,0,0}));
  connect(offToOne.outPort,oneOn.inPort[1])
    annotation (Line(points={{10,58.5},{10,11},{10.25,11}},
                                                         color={0,0,0}));
  connect(oneToOff.outPort,off.inPort[1])
    annotation (Line(points={{40,61.5},{40,120},{10,120},{10,101}},
      color={0,0,0}));
  connect(on, offToOne.condition) annotation (Line(points={{-180,60},{-2,60}},
    color={255,0,255}));
  connect(thrTwoToOne.y, TwoToOne.u2) annotation (Line(points={{-79,-8},{-80,-8},
          {-80,-18},{-42,-18}}, color={255,0,255}));
  connect(notOn.y, TwoToOne.u1) annotation (Line(points={{-79,30},{-60,30},{-60,
          -10},{-42,-10}}, color={255,0,255}));
  connect(TwoToOne.y, twoToOne.condition) annotation (Line(points={{-19,-10},{-10,
          -10},{-10,-28},{40,-28},{40,-40},{48,-40}}, color={255,0,255}));
  connect(notOn.y, oneToOff.condition)
    annotation (Line(points={{-79,30},{28,30},{28,60}}, color={255,0,255}));
  annotation (
    defaultComponentName="chiStaCon",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-160},{160,160}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-160},{160,160}}),
        graphics={
        Rectangle(
          extent={{-160,-160},{160,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,206},{146,166}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      revisions="<html>
<ul>
<li>
December 10, 2021, by Michael Wetter:<br/>
Corrected parameter value for <code>twoOn.nOut</code>.
This correction is required to simulate the model in Dymola 2022
if the model has been updated to MSL 4.0.0. With MSL 3.2.3, the simulation
works without this correction.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1563\">Buildings, #1563</a>.
</li>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model implements the staging control logic as follows: </p>
<ul>
<li>When the plant enabling signal <code>on</code> changes from
<code>false</code> to <code>true</code>, one chiller is enabled. </li>
<li>When the total cooling load <code>QLoa</code> exceeds 80 percent (adjustable)
of one chiller&apos;s nominal capacity <code>QChi_nominal</code>, a second
chiller is enabled. </li>
<li>When the total cooling load <code>QLoa</code> drops below 60 percent
(adjustable) of one chiller&apos;s nominal capacity <code>QChi_nominal</code>
(i.e. 30 percent of both chillers combined), or the plant enabling signal
<code>on</code> changes from <code>true</code> to <code>false</code>, the second
chiller is disabled. </li>
<li>When the plant enabling signal <code>on</code> changes from <code>true</code>
to <code>false</code>, the operating chillers will be disabled sequentially.</li>
<li>Parameter <code>tWai</code> assures a transitional time is kept between each
operation. </li>
</ul>
<p><br>It is assumed that both chillers have the same capacity of
<code>QChi_nominal</code>. </p>
<p>Note: This model can be used for plants with two chillers with or without
waterside econimizer (WSE). For plants with WSE, extra control logic on top of
this model needs to be added. </p>
<p><img src=\"modelica://Buildings/Resources/Images/DHC/Plants/Cooling/Controls/ChillerStage.png\" alt=\"State graph\"/>. </p>
</html>"));
end ChillerStage;
