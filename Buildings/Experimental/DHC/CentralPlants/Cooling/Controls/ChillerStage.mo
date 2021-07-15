within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls;
model ChillerStage
  "Chiller staging controller for plants with two chillers of the same size"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  parameter Modelica.SIunits.Time tWai
    "Waiting time";
  parameter Modelica.SIunits.Power QChi_nominal(
    final max=0)
    "Nominal cooling capacity (negative)";
  parameter Modelica.SIunits.Power staUpThr(final min=0)=-0.8*QChi_nominal
    "Stage up load threshold(from one to two chillers)";
  parameter Modelica.SIunits.Power staDowThr(final min=0)=-0.6*QChi_nominal
    "Stage down load threshold(from two to one chiller)";
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Enabling signal of the plant. True: chiller should be enabled"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TChiWatRet
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TChiWatSup
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput mFloChiWat
    "Chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput y[2]
    "On/off signal for the chillers - false: off; true: on"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.InitialStep off(
    nIn=1)
    "No cooling is demanded"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=-90,origin={10,70})));
  Modelica.StateGraph.StepWithSignal oneOn(
    nOut=2,
    nIn=2)
    "Status of one chiller on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={10,0})));
  Modelica.StateGraph.StepWithSignal twoOn
    "Status of two chillers on"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={10,-70})));
  Modelica.StateGraph.TransitionWithSignal offToOne(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from off to one chiller on"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=90,origin={10,40})));
  Modelica.StateGraph.TransitionWithSignal oneToTwo(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to two chillers"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=90,origin={10,-40})));
  Modelica.StateGraph.TransitionWithSignal twoToOne(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transion from two chillers to one chiller"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90,origin={60,-40})));
  Modelica.StateGraph.TransitionWithSignal oneToOff(
    enableTimer=true,
    waitTime=tWai)
    "Condition of transition from one chiller to off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={40,40})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis thrOneToTwo(
    uLow=staDowThr,
    uHigh=staUpThr)
    "Threshold of turning two chillers on"
    annotation (Placement(transformation(extent={{-36,-50},{-16,-30}})));
  Modelica.Blocks.Logical.Not thrTwoToOne
    "Threshold of turning off the second chiller"
    annotation (Placement(transformation(extent={{-36,-84},{-16,-64}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOn "Not on"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Math.Add dT(
    final k1=-1,
    final k2=+1)
    "Temperature difference"
    annotation (Placement(transformation(extent={{-150,-4},{-130,16}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Math.Gain cp(
    final k=-cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or Or "On signal for either chiller"
    annotation (Placement(transformation(extent={{106,20},{126,40}})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(
    sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(off.outPort[1],offToOne.inPort)
    annotation (Line(points={{10,59.5},{10,44}},color={0,0,0}));
  connect(oneToOff.outPort,off.inPort[1])
    annotation (Line(points={{40,41.5},{40,88},{10,88},{10,81}},color={0,0,0}));
  connect(oneToTwo.outPort,twoOn.inPort[1])
    annotation (Line(points={{10,-41.5},{10,-59}},color={0,0,0}));
  connect(twoOn.outPort[1],twoToOne.inPort)
    annotation (Line(points={{10,-80.5},{10,-88},{60,-88},{60,-44}},color={0,0,0}));
  connect(twoToOne.outPort,oneOn.inPort[2])
    annotation (Line(points={{60,-38.5},{60,16},{10.5,16},{10.5,11}},color={0,0,0}));
  connect(offToOne.outPort,oneOn.inPort[1])
    annotation (Line(points={{10,38.5},{10,11},{9.5,11}},color={0,0,0}));
  connect(oneOn.outPort[2],oneToOff.inPort)
    annotation (Line(points={{10.25,-10.5},{10.25,-18},{40,-18},{40,36}},color={0,0,0}));
  connect(oneOn.outPort[1],oneToTwo.inPort)
    annotation (Line(points={{9.75,-10.5},{9.75,-18},{10,-18},{10,-36}},color={0,0,0}));
  connect(on,offToOne.condition)
    annotation (Line(points={{-180,60},{-50,60},{-50,40},{-2,40}},color={255,0,255}));
  connect(oneToTwo.condition,thrOneToTwo.y)
    annotation (Line(points={{-2,-40},{-14,-40}},color={255,0,255}));
  connect(thrTwoToOne.y,twoToOne.condition)
    annotation (Line(points={{-15,-74},{-6,-74},{-6,-56},{40,-56},{40,-40},{48,-40}},color={255,0,255}));
  connect(on,notOn.u)
    annotation (Line(points={{-180,60},{-50,60},{-50,20},{-32,20}},color={255,0,255}));
  connect(notOn.y,oneToOff.condition)
    annotation (Line(points={{-8,20},{28,20},{28,40}},color={255,0,255}));
  connect(dT.y,pro.u1)
    annotation (Line(points={{-129,6},{-112,6}},color={0,0,127}));
  connect(cp.u,pro.y)
    annotation (Line(points={{-82,0},{-89,0}},color={0,0,127}));
  connect(cp.y,thrOneToTwo.u)
    annotation (Line(points={{-59,0},{-50,0},{-50,-40},{-38,-40}},color={0,0,127}));
  connect(dT.u1,TChiWatRet)
    annotation (Line(points={{-152,12},{-156,12},{-156,20},{-180,20}},color={0,0,127}));
  connect(TChiWatSup,dT.u2)
    annotation (Line(points={{-180,-20},{-156,-20},{-156,0},{-152,0}},color={0,0,127}));
  connect(pro.u2,mFloChiWat)
    annotation (Line(points={{-112,-6},{-120,-6},{-120,-60},{-180,-60}},color={0,0,127}));
  connect(oneToTwo.condition, thrTwoToOne.u) annotation (Line(points={{-2,-40},
          {-10,-40},{-10,-54},{-50,-54},{-50,-74},{-38,-74}}, color={255,0,255}));
  connect(oneOn.active, Or.u1) annotation (Line(points={{21,0},{80,0},{80,30},{
          104,30}}, color={255,0,255}));
  connect(twoOn.active, Or.u2) annotation (Line(points={{21,-70},{100,-70},{100,
          22},{104,22}}, color={255,0,255}));
  connect(Or.y, y[1]) annotation (Line(points={{128,30},{144,30},{144,-5},{170,
          -5}}, color={255,0,255}));
  connect(twoOn.active, y[2]) annotation (Line(points={{21,-70},{120,-70},{120,
          5},{170,5}}, color={255,0,255}));
  annotation (
    defaultComponentName="chiStaCon",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-100},{160,100}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model implements the staging control logic as follows: </p>
<ul>
<li>When the plant enabling signal <code>on</code> changes from <code>false</code> to <code>true</code>, one chiller is enabled. </li>
<li>When the total cooling load <code>QLoa</code> exceeds 80 percent (adjustable) of one chiller&apos;s nominal capacity <code>QChi_nominal</code>, a second chiller is enabled. </li>
<li>When the total cooling load <code>QLoa</code> drops below 60 percent (adjustable) of one chiller&apos;s nominal capacity <code>QChi_nominal</code>(i.e. 30 percent of both chillers combined), the second chiller is disabled. </li>
<li>When the plant enabling signal <code>on</code> changes from <code>true</code> to <code>false</code>, the operating chiller is disabled.</li>
<li>Parameter <code>tWai</code> assures a transitional time is kept between each operation. </li>
</ul>
<p><br>It is assumed that both chillers have the same capacity of <code>QChi_nominal</code>. </p>
<p>Note: This model can be used for plants with two chillers with or without waterside 
econimizer (WSE). For plants with WSE, extra control logic on top of this model needs to be added. </p>
<p><img alt=\"State graph\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/CentralPlants/Cooling/Controls/ChillerStage.png\"/>. </p>
</html>"));
end ChillerStage;
