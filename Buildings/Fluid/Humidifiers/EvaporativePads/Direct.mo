within Buildings.Fluid.Humidifiers.EvaporativePads;
model Direct
  "Direct evaporative pad"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol,
    final m_flow_nominal=per.v_nominal*padAre*Medium.dStp,
    final dp_nominal=per.dp_nominal,
    final n=per.n);

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic
    "Record with performance data for evaporative pads"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,80}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,40}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput evaCooAct
    "True: the evaporative cooling is active" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-110,-60},{-70,-20}})));
  Buildings.Fluid.Humidifiers.EvaporativePads.BaseClasses.DirectCalculation
    dirEvaPadCal(
    redeclare final package Medium = Medium,
    final padAre=padAre,
    per(final efficiency=per.efficiency,
      final v_nominal=per.v_nominal,
      final dp_nominal=per.dp_nominal,
      final n=per.n))
    "Direct evaporative pad calculation" annotation (Placement(
        transformation(origin={30,50}, extent={{-10,-10},{10,10}})));
protected
  Medium.ThermodynamicState staInl=Medium.setState_phX(
    p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow))
    "State of inlet medium";
  Modelica.Blocks.Sources.RealExpression TDryBul(
    y=Medium.temperature(state=staInl))
    "Inlet air drybulb temperature"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.RealExpression XInl[Medium.nXi](
    y=inStream(port_a.Xi_outflow))
    "Inlet air humidity ratio"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Sources.RealExpression pInl(
    y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.RealExpression V_flow(
    y=port_a.m_flow/Medium.density(staInl))
    "Inlet air volume flowrate"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = Medium)
    "Calculate wet bulb temperature from inlet medium state"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiEvaCoo
    "Switch to turn evaporative cooling on and off"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerWatFlo(k=0)
    "Zero water flow"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(TDryBul.y, dirEvaPadCal.TDryBulIn) annotation (Line(points={{-39,90},{
          -30,90},{-30,52},{18,52}}, color={0,0,127}));
  connect(TDryBul.y, wetBul.TDryBul) annotation (Line(points={{-39,90},{-30,90},
          {-30,88},{-21,88}}, color={0,0,127}));
  connect(wetBul.TWetBul, dirEvaPadCal.TWetBulIn) annotation (Line(points={{1,80},
          {10,80},{10,56},{18,56}}, color={0,0,127}));
  connect(XInl.y, wetBul.Xi)
    annotation (Line(points={{-79,80},{-21,80}}, color={0,0,127}));
  connect(pInl.y, dirEvaPadCal.p) annotation (Line(points={{-79,60},{-60,60},{-60,
          44},{18,44}}, color={0,0,127}));
  connect(V_flow.y, dirEvaPadCal.V_flow) annotation (Line(points={{-79,30},{0,30},
          {0,48},{18,48}}, color={0,0,127}));
  connect(evaCooAct, swiEvaCoo.u2) annotation (Line(points={{-120,-80},{-40,-80},
          {-40,-30},{58,-30}}, color={255,0,255}));
  connect(dirEvaPadCal.dmWat_flow, swiEvaCoo.u1) annotation (Line(points={{42,45},
          {50,45},{50,-22},{58,-22}}, color={0,0,127}));
  connect(swiEvaCoo.y, dmWat_flow) annotation (Line(points={{82,-30},{90,-30},{90,
          80},{120,80}}, color={0,0,127}));
  connect(swiEvaCoo.y, vol.mWat_flow) annotation (Line(points={{82,-30},{90,-30},
          {90,-80},{-20,-80},{-20,-18},{-11,-18}}, color={0,0,127}));
  connect(zerWatFlo.y, swiEvaCoo.u3) annotation (Line(points={{22,-50},{40,-50},
          {40,-38},{58,-38}}, color={0,0,127}));
  connect(pInl.y, wetBul.p) annotation (Line(points={{-79,60},{-60,60},{-60,72},
          {-21,72}}, color={0,0,127}));
annotation (defaultComponentName="dirEvaPad", Icon(graphics={
  Rectangle(lineColor={0,0,255}, fillColor={95,95,95}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-70,60},{70,-60}}),
  Rectangle(lineColor={0,0,255}, fillColor={0,0,255}, pattern = LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-101,5},{100,-4}}),
  Rectangle(lineColor={0,0,255}, fillColor={255,0,0}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{0, -4},{100, 5}}),
  Rectangle(lineColor={0,0,255}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-100, 5}, {101, -5}}),
  Rectangle(lineColor={0,0,255}, fillColor={0,62,0}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-70, 60}, {70, -60}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{-26,-52},{-30,52}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{30,-52},{26,52}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{30,52},{-30,56}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{30,-56},{-30,-52}}),
        Polygon(
          points={{-18,38},{-20,28},{-14,24},{-6,28},{-8,38},{-14,50},{-18,38}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-18,2},{-20,-8},{-14,-12},{-6,-8},{-8,2},{-14,14},{-18,2}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-18,-32},{-20,-42},{-14,-46},{-6,-42},{-8,-32},{-14,-20},{
              -18,-32}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{6,38},{4,28},{10,24},{18,28},{16,38},{10,50},{6,38}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{6,2},{4,-8},{10,-12},{18,-8},{16,2},{10,14},{6,2}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{6,-32},{4,-42},{10,-46},{18,-42},{16,-32},{10,-20},{6,-32}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier)},

  coordinateSystem(grid={2,2})),
Documentation(
info="<html>
<p>
Model for a direct evaporative pad.
</p>
<p>
This direct evaporative pad cools down the airstream by adiabatically increasing the
humidity mass fraction of the air. The mass of water vapor added to the air is
reported by the output signal <code>dmWat_flow</code>.
</p>
<p>
The input variable <code>evaCooAct</code> determines whether the evaporative cooling
is active (such that the evaporative pad is wet). When evaporative cooling is not
active (the evaporative pad is dry), no water vapor is added to the air, and thus
<code>dmWat_flow = 0</code>. The pressure drop through the evaporative
pad is less than <i>10%</i> lower when the evaporative pad is dry compared to when
the evaporative pad is wet (see the Munters CELdek 7090-15 Evaporative Pad
Specification Sheet in the <i>References</i> section below). Thus, this model
assumes that the pressure drop is the same for a dry evaporative pad as for a wet
evaporative pad.
</p>
<p>
This model uses a data record <code>per</code> to provide data on the saturation
efficiency and the pressure drop of an evaporative pad. This data record is an
instance of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic</a>.
</p>
<p>
The elemental block <code>dirEvaPadCal</code> calculates the saturation efficiency
by referencing a cubic hermite spline of discrete data points on the saturation
efficiency <code>eta</code> and the air velocity <code>v</code> from this data
record. The elemental block <code>preDro</code> calculates the pressure drop by
reference the nominal pressure drop <code>dp_nominal</code>, the nominal air
velocity <code>v_nominal</code>, and the flow exponent for pressure drop
<code>n</code> from this data record.
</p>
<p>
Note that this model works correctly only when the air flows from
<code>port_a</code> to <code>port_b</code>.
</p>
<h4>References</h4>
<p>
<a href=\"https://munters.sies.si/images/pdf/celdek7090.pdf\">Munters CELdek 7090-15
Evaporative Pad Specification Sheet</a>, July 26, 2026.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Weiping Huang:<br/>
Added a Modelica data record to calculate saturation efficiency and pressure drop.
</li>
<li>
June 18, 2026, by Weiping Huang:<br/>
Added an evaporative cooling on-and-off boolean flag.
</li>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(grid={2,2}),
          graphics={Line(origin={28, 62}, points={{0, 0}})}));
end Direct;
