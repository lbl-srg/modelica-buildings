within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block WSEControl "Control unit for WSE"

  Modelica.Blocks.Interfaces.RealInput wseCHWST(
    final quantity="Temperature",
    final unit="K",
    displayUnit="deg")
    "WSE's chilled water supply temperature (water entering WSE)" annotation (
      Placement(transformation(extent={{-140,180},{-100,220}}),
        iconTransformation(extent={{-140,180},{-100,220}})));
  Modelica.Blocks.Interfaces.RealOutput y2
    "Control signal for valve in CHW loop of WSE" annotation (Placement(
        transformation(extent={{400,-16},{420,4}}), iconTransformation(extent={
            {400,-16},{420,4}})));
  Modelica.Blocks.Sources.Constant TWSEApp(k=1) "Approach for WSE" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,150})));
  Modelica.Blocks.Math.Sum sum(nin=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={12,98})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Logical.And andOpe
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.Continuous.OffTimer offTim
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Modelica.Blocks.Sources.Constant minDisTim(k=1200)
    "minium Disabled time for WSE"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Logical.Less less
    annotation (Placement(transformation(extent={{42,-50},{62,-30}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="Temperature",
    final unit="K",
    displayUnit="deg") "Wet bulb temperature" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput towTApp(
    final quantity="Temperature",
    final unit="K",
    displayUnit="deg") "cooling tower approach"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.Product pro
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  Modelica.Blocks.Sources.Constant cons(k=0.9) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,110})));
  Modelica.Blocks.Interfaces.RealInput wseCWST(
    final quantity="Temperature",
    final unit="K",
    displayUnit="deg")
    "WSE's condenser water supply temperature (water entering WSE)" annotation (
     Placement(transformation(extent={{-140,320},{-100,360}}),
        iconTransformation(extent={{-140,320},{-100,360}})));
  Modelica.Blocks.Logical.Greater less1
    annotation (Placement(transformation(extent={{0,290},{20,310}})));
  Modelica.Blocks.Sources.Constant cons1(k=1) "cons" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-82,370})));
  Modelica.Blocks.Sources.Constant minEnaTim(k=1200)
    "minium enabled time for heat exchanger"
    annotation (Placement(transformation(extent={{0,318},{20,338}})));
  Buildings.Controls.Continuous.OffTimer onTim
    annotation (Placement(transformation(extent={{20,348},{40,368}})));
  Modelica.Blocks.Logical.Greater less2
    annotation (Placement(transformation(extent={{60,334},{80,354}})));
  Modelica.Blocks.Logical.And dis "true for disable"
    annotation (Placement(transformation(extent={{100,308},{120,328}})));
  Modelica.Blocks.Math.Add add1(k1=+1)
    annotation (Placement(transformation(extent={{-52,324},{-32,344}})));
  Modelica.Blocks.Logical.Not not3
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{158,90},{178,110}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{242,90},{262,110}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{118,50},{138,70}})));
  Modelica.Blocks.Interfaces.RealOutput y1
    "Control signal for valve in the CW loop of WSE" annotation (Placement(
        transformation(extent={{400,270},{420,290}}), iconTransformation(extent=
           {{400,250},{420,270}})));
  KMinusU kMinU(k=1)
    annotation (Placement(transformation(extent={{362,270},{382,290}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{192,90},{212,110}})));
equation
  connect(sum.y, greater.u2) annotation (Line(
      points={{23,98},{28,98},{28,122},{38,122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greater.y, andOpe.u1) annotation (Line(
      points={{61,130},{72,130},{72,60},{78,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(minDisTim.y, less.u1) annotation (Line(
      points={{21,-20},{30,-20},{30,-40},{40,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(offTim.y, less.u2) annotation (Line(
      points={{21,-60},{30,-60},{30,-48},{40,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(less.y, andOpe.u2) annotation (Line(
      points={{63,-40},{70,-40},{70,52},{78,52}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TWSEApp.y, sum.u[1]) annotation (Line(
      points={{-19,150},{-10,150},{-10,96.6667},{-6.66134e-16,96.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.y, sum.u[2]) annotation (Line(
      points={{-19,84},{-10,84},{-10,98},{-6.66134e-16,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cons.y, pro.u1) annotation (Line(
      points={{-59,110},{-54,110},{-54,90},{-42,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cons1.y, add1.u1) annotation (Line(
      points={{-71,370},{-60,370},{-60,340},{-54,340}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(less1.y, dis.u2) annotation (Line(
      points={{21,300},{46,300},{46,310},{98,310}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(less2.y, dis.u1) annotation (Line(
      points={{81,344},{90,344},{90,318},{98,318}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(minEnaTim.y, less2.u2) annotation (Line(
      points={{21,328},{39.5,328},{39.5,336},{58,336}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onTim.y, less2.u1) annotation (Line(
      points={{41,358},{44,358},{44,344},{58,344}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(not3.y, offTim.u) annotation (Line(
      points={{-19,-60},{-2,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(dis.y, and2.u1) annotation (Line(
      points={{121,318},{132,318},{132,100},{156,100}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(andOpe.y, not1.u) annotation (Line(
      points={{101,60},{116,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, and2.u2) annotation (Line(
      points={{139,60},{146,60},{146,92},{156,92}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(kMinU.y, y1) annotation (Line(
      points={{383,280},{410,280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(and2.y, pre1.u) annotation (Line(
      points={{179,100},{190,100}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pre1.y, booToRea.u) annotation (Line(
      points={{213,100},{240,100}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pre1.y, onTim.u) annotation (Line(
      points={{213,100},{224,100},{224,384},{-20,384},{-20,358},{18,358}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pre1.y, not3.u) annotation (Line(
      points={{213,100},{224,100},{224,-78},{-54,-78},{-54,-60},{-42,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToRea.y, kMinU.u) annotation (Line(
      points={{263,100},{320,100},{320,280},{360.2,280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToRea.y, y2) annotation (Line(
      points={{263,100},{320,100},{320,-6},{410,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWetBul, pro.u2) annotation (Line(
      points={{-120,60},{-74,60},{-74,78},{-42,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCHWST, greater.u1) annotation (Line(
      points={{-120,200},{20,200},{20,130},{38,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCWST, add1.u2) annotation (Line(
      points={{-120,340},{-78,340},{-78,328},{-54,328}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, less1.u1) annotation (Line(
      points={{-31,334},{-18,334},{-18,300},{-2,300}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCHWST, less1.u2) annotation (Line(
      points={{-120,200},{-20,200},{-20,292},{-2,292}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(towTApp, sum.u[3]) annotation (Line(
      points={{-120,-40},{-48,-40},{-48,56},{-10,56},{-10,99.3333},{
          -6.66134e-16,99.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="wseCon",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{400,400}},
        initialScale=0.01), graphics={
        Rectangle(
          extent={{-100,-106},{400,400}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-74,416},{380,532}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{326,76},{6,168}},
          lineColor={0,0,255},
          textString="C_WSE")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{400,400}},
        initialScale=0.01,
        grid={2,2}), graphics),
    Documentation(info="<HTML>
<p>
This component decides if the WSE is set to on or off.
The WSE is enabled when
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWST</sub> &gt; 0.9 T<sub>WetBul</sub> + T<sub>TowApp</sub> + T<sub>WSEApp</sub> </li>
</ol>
<br/>
The WSE is disabled when
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWRT</sub> &lt; 1 + T<sub>WSE_CWST</sub></li>
</li>
</ol>
<br/>
where <i>T<sub>WSE_CHWST</sub></i> is the chilled water supply temperature for the WSE, 
<i>T<sub>WetBul</sub></i> is the wet bulb temperature, <i>T<sub>TowApp</sub></i> is the cooling tower approach, <i>T<sub>WSEApp</sub></i> is the approach for the WSE, <i>T<sub>WSE_CHWRT</sub></i> is the chilled water return temperature for the WSE, and <i>T<sub>WSE_CWST</sub></i> is the condenser water return temperature for the WSE.
</p> 
</HTML>
", revisions="<html>
<ul>
<li>
September 12, 2011, by Wangda Zuo:<br>
Delete the first order continuous block and reformat the model for SI units. 
</li>
<li>
July 20, 2011, by Wangda Zuo:<br>
Add comments, redefine variables names, and merge to library. 
</li>
<li>
January 18, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul></HTML>"));
end WSEControl;
