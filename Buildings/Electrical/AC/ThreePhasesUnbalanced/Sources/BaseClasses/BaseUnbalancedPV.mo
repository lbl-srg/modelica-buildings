within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
partial model BaseUnbalancedPV "Partial model for an unbalanced PV source"
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  extends Buildings.Electrical.Interfaces.PartialPvBase;
  extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=480)
    "Nominal voltage (V_nominal >= 0)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real areaFraction[3](each min=0, each max=1.0) = ones(3)/3
    "Fraction of area occupied by the PVs of each phase";
  replaceable OnePhase.Sources.PVSimple pv_phase2(
    pf=pf,
    eta_DCAC=eta_DCAC,
    A=A*areaFraction[2],
    fAct=fAct,
    eta=eta,
    V_nominal=V_nominal/sqrt(3))
    if plugPhase2 "PV phase 2"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  replaceable OnePhase.Sources.PVSimple pv_phase3(
    pf=pf,
    eta_DCAC=eta_DCAC,
    A=A*areaFraction[3],
    fAct=fAct,
    eta=eta,
    V_nominal=V_nominal/sqrt(3))
    if plugPhase3 "PV phase 3"
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  replaceable OnePhase.Sources.PVSimple pv_phase1(
    pf=pf,
    eta_DCAC=eta_DCAC,
    A=A*areaFraction[1],
    fAct=fAct,
    eta=eta,
    V_nominal=V_nominal/sqrt(3))
    if plugPhase1 "PV phase 1"
    annotation (Placement(transformation(extent={{-18,40},{-38,60}})));
  Modelica.Blocks.Math.Add3 sumBlock "Sum of the generated power on each phase"
    annotation (Placement(transformation(extent={{40,84},{60,64}})));
protected
  Modelica.Blocks.Interfaces.RealOutput G_int
    "Total solar irradiation per unit area" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-80,20}),
                        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
equation
  assert(abs(sum(areaFraction)-1) < Modelica.Constants.eps,
  "Model that extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedPV,
  has an invalid value for the vector areaFraction[:]. The sum of the
  elements has to be equal to 1.0.",
  level=AssertionLevel.error);

  if plugPhase1 then
    connect(pv_phase1.G, G_int)
                             annotation (Line(
        points={{-28,62},{-28,72},{-46,72},{-46,20},{-80,20}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase2 then
    connect(G_int, pv_phase2.G)
                             annotation (Line(
      points={{-80,20},{-30,20},{-30,12}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if plugPhase3 then
    connect(G_int, pv_phase3.G)
                             annotation (Line(
        points={{-80,20},{-46,20},{-46,-26},{-30,-26},{-30,-38}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase1 then
    connect(pv_phase1.P, sumBlock.u1) annotation (Line(
      points={{-39,57},{-48,57},{-48,76},{10,76},{10,66},{38,66}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u1 = 0;
  end if;

  if plugPhase2 then
    connect(pv_phase2.P, sumBlock.u2) annotation (Line(
      points={{-41,7},{-50,7},{-50,78},{18,78},{18,74},{38,74}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u2 = 0;
  end if;

  if plugPhase3 then
    connect(pv_phase3.P, sumBlock.u3) annotation (Line(
      points={{-41,-43},{-52,-43},{-52,82},{38,82}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u3 = 0;
  end if;

  connect(sumBlock.y, P) annotation (Line(
      points={{61,74},{86,74},{86,70},{110,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{58,0},{92,0}},   color={0,0,0}),
        Text(
          extent={{-140,-100},{160,-60}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{80,-52},{32,63},{-78,63},{-29,-52},{80,-52}},
          smooth=Smooth.None,
          fillColor={205,203,203},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-32,27},{-44,53},{-67,53},{-56,27},{-32,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-16,-9},{-28,17},{-51,17},{-40,-9},{-16,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-1,-45},{-13,-19},{-36,-19},{-25,-45},{-1,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{1,27},{-11,53},{-34,53},{-23,27},{1,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{17,-9},{5,17},{-18,17},{-7,-9},{17,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{32,-45},{20,-19},{-3,-19},{8,-45},{32,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{34,27},{22,53},{-1,53},{10,27},{34,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{50,-9},{38,17},{15,17},{26,-9},{50,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{65,-45},{53,-19},{30,-19},{41,-45},{65,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
This model is a partial class extended by three-phase unbalanced
PV power sources.
</p>
<p>
The model has boolean parameters <code>plugPhase1</code>, <code>plugPhase2</code>,
and <code>plugPhase3</code> that can be used to connect the PV in an
unbalanced configuration.
</p>
<p>
The model has an array <code>areaFraction[3]</code> that is used to determine how
to partition the power of the PVs on the three-phase. By default it is assumed
a uniform partition <code>areaFraction[3] = {1/3, 1/3, 1/3}</code>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end BaseUnbalancedPV;
