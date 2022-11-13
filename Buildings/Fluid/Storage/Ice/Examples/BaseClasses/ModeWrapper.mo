within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ModeWrapper "wrapper model for control modes"
  extends PartialControlMode;
  Controls.OBC.CDL.Interfaces.RealInput SOC(final unit="1")
                    "State of charge of ice tank"
    annotation (Placement(transformation(extent={{-268,-182},{-228,-142}}),
        iconTransformation(extent={{-280,-200},{-240,-160}})));
  Controls.OBC.CDL.Interfaces.IntegerInput           powMod annotation (
    Placement(visible = true, transformation(origin={-260,-6},     extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,60},     extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  ControlEfficiencyMode controlEfficiencyMode
    annotation (Placement(transformation(extent={{-102,-44},{-54,6}})));
  ControlLowPowerMode controlLowPowerMode
    annotation (Placement(transformation(extent={{-84,134},{-36,184}})));
  ControlHighPowerMode controlHighPowerMode
    annotation (Placement(transformation(extent={{-186,-242},{-138,-192}})));
  Switch swiStoOn
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Switch swiStoByp
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Switch swiWatChi
    annotation (Placement(transformation(extent={{88,10},{108,30}})));
  Switch swiGlyChi
    annotation (Placement(transformation(extent={{112,-24},{132,-4}})));
  Switch swiPumSto
    annotation (Placement(transformation(extent={{144,-90},{164,-70}})));
  Switch swiPumGlyChi
    annotation (Placement(transformation(extent={{168,-130},{188,-110}})));
  Switch swiPumWatChi
    annotation (Placement(transformation(extent={{212,-250},{232,-230}})));
  Switch swiPumWatHex
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
equation
  connect(SOC, controlHighPowerMode.SOC) annotation (Line(points={{-248,-162},{
          -212,-162},{-212,-234},{-188,-234}}, color={0,0,127}));
  connect(controlLowPowerMode.SOC, controlHighPowerMode.SOC) annotation (Line(
        points={{-86,142},{-134,142},{-134,4},{-196,4},{-196,-234},{-188,-234}},
        color={0,0,127}));
  connect(demLev, controlEfficiencyMode.demLev) annotation (Line(points={{-260,
          180},{-194,180},{-194,122},{-192,122},{-192,62},{-190,62},{-190,2},{
          -104,2}}, color={255,127,0}));
  connect(controlLowPowerMode.demLev, controlEfficiencyMode.demLev) annotation
    (Line(points={{-86,180},{-98,180},{-98,8},{-110,8},{-110,2},{-104,2}},
        color={255,127,0}));
  connect(controlHighPowerMode.demLev, controlEfficiencyMode.demLev)
    annotation (Line(points={{-188,-196},{-194,-196},{-194,0},{-190,0},{-190,2},
          {-104,2}}, color={255,127,0}));
  connect(controlLowPowerMode.yStoOn, swiStoOn.u1) annotation (Line(points={{
          -34,172},{10,172},{10,132},{12,132},{12,128},{18,128}}, color={255,0,
          255}));
  connect(controlLowPowerMode.yStoByp, swiStoByp.u1) annotation (Line(points={{
          -34,168},{54,168},{54,88},{58,88}}, color={255,0,255}));
  connect(controlLowPowerMode.yWatChi, swiWatChi.u1) annotation (Line(points={{
          -34,162},{88,162},{88,28},{86,28}}, color={255,0,255}));
  connect(controlLowPowerMode.yGlyChi, swiGlyChi.u1) annotation (Line(points={{
          -34,158},{114,158},{114,142},{116,142},{116,2},{104,2},{104,-6},{110,
          -6}}, color={255,0,255}));
  connect(controlLowPowerMode.yPumSto, swiPumSto.u1) annotation (Line(points={{
          -34,152},{138,152},{138,-72},{142,-72}}, color={255,0,255}));
  connect(controlLowPowerMode.yPumGlyChi, swiPumGlyChi.u1) annotation (Line(
        points={{-34,147.8},{-34,148},{176,148},{176,-100},{164,-100},{164,-104},
          {160,-104},{160,-112},{166,-112}}, color={255,0,255}));
  connect(controlLowPowerMode.yPumWatHex, swiPumWatHex.u1) annotation (Line(
        points={{-34,140},{202,140},{202,-174},{172,-174},{172,-192},{178,-192}},
        color={255,0,255}));
  connect(controlLowPowerMode.yPumWatChi, swiPumWatChi.u1) annotation (Line(
        points={{-34,136},{94,136},{94,134},{222,134},{222,-218},{206,-218},{
          206,-232},{210,-232}}, color={255,0,255}));
  connect(controlEfficiencyMode.yStoOn, swiStoOn.u2) annotation (Line(points={{
          -52,-6},{-32,-6},{-32,124},{18,124}}, color={255,0,255}));
  connect(controlEfficiencyMode.yStoByp, swiStoByp.u2) annotation (Line(points=
          {{-52,-10},{-20,-10},{-20,84},{58,84}}, color={255,0,255}));
  connect(controlEfficiencyMode.yWatChi, swiWatChi.u2) annotation (Line(points=
          {{-52,-16},{-12,-16},{-12,24},{86,24}}, color={255,0,255}));
  connect(controlEfficiencyMode.yGlyChi, swiGlyChi.u2) annotation (Line(points=
          {{-52,-20},{-8,-20},{-8,-10},{110,-10}}, color={255,0,255}));
  connect(controlEfficiencyMode.yPumSto, swiPumSto.u2) annotation (Line(points=
          {{-52,-26},{136,-26},{136,-76},{142,-76}}, color={255,0,255}));
  connect(controlEfficiencyMode.yPumGlyChi, swiPumGlyChi.u2) annotation (Line(
        points={{-52,-30.2},{110,-30.2},{110,-30},{128,-30},{128,-116},{166,
          -116}}, color={255,0,255}));
  connect(controlEfficiencyMode.yPumWatHex, swiPumWatHex.u2) annotation (Line(
        points={{-52,-38},{96,-38},{96,-196},{178,-196}}, color={255,0,255}));
  connect(controlEfficiencyMode.yPumWatChi, swiPumWatChi.u2) annotation (Line(
        points={{-52,-42},{68,-42},{68,-236},{210,-236}}, color={255,0,255}));
  connect(controlHighPowerMode.yPumWatChi, swiPumWatChi.u3)
    annotation (Line(points={{-136,-240},{210,-240}}, color={255,0,255}));
  connect(controlHighPowerMode.yPumWatHex, swiPumWatHex.u3) annotation (Line(
        points={{-136,-236},{-86,-236},{-86,-200},{178,-200}}, color={255,0,255}));
  connect(controlHighPowerMode.yPumGlyChi, swiPumGlyChi.u3) annotation (Line(
        points={{-136,-228.2},{-114,-228.2},{-114,-228},{-92,-228},{-92,-124},{
          158,-124},{158,-120},{166,-120}}, color={255,0,255}));
  connect(controlHighPowerMode.yPumSto, swiPumSto.u3) annotation (Line(points={
          {-136,-224},{-100,-224},{-100,-80},{142,-80}}, color={255,0,255}));
  connect(controlHighPowerMode.yGlyChi, swiGlyChi.u3) annotation (Line(points={
          {-136,-218},{-112,-218},{-112,-60},{-2,-60},{-2,-14},{110,-14}},
        color={255,0,255}));
  connect(controlHighPowerMode.yWatChi, swiWatChi.u3) annotation (Line(points={
          {-136,-214},{-124,-214},{-124,14},{62,14},{62,20},{86,20}}, color={
          255,0,255}));
  connect(controlHighPowerMode.yStoByp, swiStoByp.u3) annotation (Line(points={
          {-136,-208},{-128,-208},{-128,80},{58,80}}, color={255,0,255}));
  connect(controlHighPowerMode.yStoOn, swiStoOn.u3) annotation (Line(points={{
          -136,-204},{-134,-204},{-134,-202},{-132,-202},{-132,120},{18,120}},
        color={255,0,255}));
  connect(swiStoOn.y, yStoOn)
    annotation (Line(points={{40,120},{260,120}}, color={255,0,255}));
  connect(swiStoByp.y, yStoByp)
    annotation (Line(points={{80,80},{260,80}}, color={255,0,255}));
  connect(swiWatChi.y, yWatChi)
    annotation (Line(points={{108,20},{260,20}}, color={255,0,255}));
  connect(swiGlyChi.y, yGlyChi) annotation (Line(points={{132,-14},{234,-14},{
          234,-20},{260,-20}}, color={255,0,255}));
  connect(swiPumSto.y, yPumSto)
    annotation (Line(points={{164,-80},{260,-80}}, color={255,0,255}));
  connect(swiPumGlyChi.y, yPumGlyChi)
    annotation (Line(points={{188,-120},{260,-120}}, color={255,0,255}));
  connect(swiPumWatHex.y, yPumWatHex)
    annotation (Line(points={{200,-200},{260,-200}}, color={255,0,255}));
  connect(swiPumWatChi.y, yPumWatChi)
    annotation (Line(points={{232,-240},{260,-240}}, color={255,0,255}));
  connect(powMod, swiPumWatChi.powLev) annotation (Line(points={{-260,-6},{-220,
          -6},{-220,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiPumWatHex.powLev, swiPumWatChi.powLev) annotation (Line(points={{
          178.2,-206},{166,-206},{166,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiPumGlyChi.powLev, swiPumWatChi.powLev) annotation (Line(points={{
          166.2,-126},{148,-126},{148,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiPumSto.powLev, swiPumWatChi.powLev) annotation (Line(points={{
          142.2,-86},{120,-86},{120,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiGlyChi.powLev, swiPumWatChi.powLev) annotation (Line(points={{
          110.2,-20},{102,-20},{102,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiWatChi.powLev, swiPumWatChi.powLev) annotation (Line(points={{86.2,
          14},{78,14},{78,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiStoByp.powLev, swiPumWatChi.powLev) annotation (Line(points={{58.2,
          74},{56,74},{56,-246},{210.2,-246}}, color={255,127,0}));
  connect(swiStoOn.powLev, swiPumWatChi.powLev) annotation (Line(points={{18.2,
          114},{18,114},{18,-246},{210.2,-246}}, color={255,127,0}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
November 10, 2022, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeWrapper;
