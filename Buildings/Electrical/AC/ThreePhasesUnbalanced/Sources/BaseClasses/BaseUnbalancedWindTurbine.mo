within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
partial model BaseUnbalancedWindTurbine
  "Partial model for an unbalanced wind power source"
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
  extends Buildings.Electrical.Interfaces.PartialWindTurbineBase(V_nominal(start = 480));
  parameter Real scaleFraction[3](each min=0, each max=1.0) = ones(3)/3
    "Fraction of power allocated to the wind turbines of each phase";
  replaceable OnePhase.Sources.WindTurbine
                                        wt_phase2(
    pf=pf,
    eta_DCAC=eta_DCAC,
    scale=scale*scaleFraction[2],
    h=h,
    hRef=hRef,
    nWin=nWin,
    tableOnFile=tableOnFile,
    table=table,
    tableName=tableName,
    fileName=fileName,
    V_nominal=V_nominal/sqrt(3))
             if plugPhase2 "Wind turbine phase 2"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  replaceable OnePhase.Sources.WindTurbine
                                        wt_phase3(
    pf=pf,
    eta_DCAC=eta_DCAC,
    scale=scale*scaleFraction[3],
    h=h,
    hRef=hRef,
    nWin=nWin,
    tableOnFile=tableOnFile,
    table=table,
    tableName=tableName,
    fileName=fileName,
    V_nominal=V_nominal/sqrt(3))
             if plugPhase3 "Wind turbine phase 3"
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  replaceable OnePhase.Sources.WindTurbine
                                        wt_phase1(
    pf=pf,
    eta_DCAC=eta_DCAC,
    scale=scale*scaleFraction[1],
    h=h,
    hRef=hRef,
    nWin=nWin,
    tableOnFile=tableOnFile,
    table=table,
    tableName=tableName,
    fileName=fileName,
    V_nominal=V_nominal/sqrt(3))
             if plugPhase1 "Wind turbine phase 1"
    annotation (Placement(transformation(extent={{-18,40},{-38,60}})));
  Modelica.Blocks.Math.Add3 sumBlock "Sum of th epower generated on each phase"
    annotation (Placement(transformation(extent={{32,50},{52,70}})));
equation

  assert(abs(sum(scaleFraction)-1) < Modelica.Constants.eps,
  "Model that extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedWindTurbine,
  has an invalid value for the vector scaleFraction[:]. The sum of the
  elements has to be equal to 1.0.",
  level=AssertionLevel.error);

  if plugPhase1 then
    connect(wt_phase1.P, sumBlock.u1) annotation (Line(
      points={{-39,56},{-60,56},{-60,82},{20,82},{20,68},{30,68}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u1 = 0;
  end if;

  if plugPhase2 then
    connect(wt_phase2.P, sumBlock.u2) annotation (Line(
      points={{-41,6},{-64,6},{-64,86},{12,86},{12,60},{30,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u2 = 0;
  end if;

  if plugPhase3 then
    connect(wt_phase3.P, sumBlock.u3) annotation (Line(
      points={{-41,-44},{-68,-44},{-68,90},{4,90},{4,52},{30,52}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  else
    sumBlock.u3 = 0;
  end if;

  connect(sumBlock.y, P) annotation (Line(
      points={{53,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(vWin, wt_phase1.vWin) annotation (Line(
      points={{0,120},{0,72},{-28,72},{-28,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin, wt_phase2.vWin) annotation (Line(
      points={{0,120},{0,72},{-52,72},{-52,20},{-30,20},{-30,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin, wt_phase3.vWin) annotation (Line(
      points={{0,120},{0,72},{-52,72},{-52,-26},{-30,-26},{-30,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          fillColor={202,230,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{42,44},{46,-54}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-42,12},{-38,-86}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,10},{-26,-42},{-38,14},{-44,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-38,10},{8,44},{-42,16},{-38,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-42,10},{-90,38},{-38,16},{-42,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,42},{100,38},{42,48},{40,42}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-21,-17},{27,17},{-25,-11},{-21,-17}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={29,67},
          rotation=90,
          lineColor={0,0,0}),
        Polygon(
          points={{24,-14},{-20,22},{26,-8},{24,-14}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={32,18},
          rotation=90,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-46,18},{-34,6}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,50},{50,38}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is a partial class extended by three-phase unbalanced
wind turbine power sources.
</p>
<p>
The model has boolean parameters <code>plugPhase1</code>, <code>plugPhase2</code>,
and <code>plugPhase3</code> that can be used to connect the wind turbines in an
unbalanced configuration.
</p>
<p>
The model has an array <code>scaleFraction[3]</code> that is used to determine how
to partition the power of the wind turbines on the three-phase. By default it is assumed
a uniform partition <code>scaleFraction[3] = {1/3, 1/3, 1/3}</code>.
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
end BaseUnbalancedWindTurbine;
