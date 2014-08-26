within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
package BaseClasses "Package with base class models"
  extends Modelica.Icons.BasesPackage;
  partial model PartialSource

    Interfaces.Connection3to4_p connection3to4
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    OnePhase.Basics.Ground ground
      annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
    Interfaces.Terminal_p terminal
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  equation
    Connections.branch(connection3to4.terminal4.phase[1].theta, connection3to4.terminal4.phase[4].theta);
    connection3to4.terminal4.phase[1].theta = connection3to4.terminal4.phase[4].theta;
    for i in 1:3 loop
      Connections.branch(connection3to4.terminal3.phase[i].theta, connection3to4.terminal4.phase[i].theta);
      connection3to4.terminal3.phase[i].theta = connection3to4.terminal4.phase[i].theta;
    end for;

    connect(connection3to4.terminal3,terminal)  annotation (Line(
        points={{60,0},{100,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(ground.terminal,connection3to4. terminal4.phase[4]) annotation (Line(
        points={{20,-40},{20,0},{40,0}},
        color={0,120,120},
        smooth=Smooth.None));
  end PartialSource;

  partial model PartialSourceN

    OnePhase.Basics.Ground ground
      annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
    Interfaces.Terminal4_p terminal
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  equation

    connect(ground.terminal, terminal.phase[4]) annotation (Line(
        points={{20,-40},{20,0},{100,0}},
        color={0,120,120},
        smooth=Smooth.None));
  end PartialSourceN;

  model UnbalancedPV
    extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
    extends Buildings.Electrical.Interfaces.PartialPvBase;
    extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;
    replaceable OnePhase.Sources.PVSimple pv_phase2(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A,
      fAct=fAct,
      eta=eta) if PlugPhase2
      annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
    replaceable OnePhase.Sources.PVSimple pv_phase3(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A,
      fAct=fAct,
      eta=eta) if PlugPhase3
      annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
    replaceable OnePhase.Sources.PVSimple pv_phase1(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A,
      fAct=fAct,
      eta=eta) if PlugPhase1
      annotation (Placement(transformation(extent={{-18,40},{-38,60}})));
  protected
    Modelica.Blocks.Interfaces.RealOutput G_int
      "Total solar irradiation per unit area" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-80,20}),
                          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,100})));
  public
    Modelica.Blocks.Math.Add3 sum
      annotation (Placement(transformation(extent={{40,60},{60,80}})));
  equation

    if PlugPhase1 then
      connect(connection3to4.terminal4.phase[1], pv_phase1.terminal) annotation (Line(
          points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(pv_phase1.G, G_int)
                               annotation (Line(
          points={{-28,62},{-28,72},{-46,72},{-46,20},{-80,20}},
          color={0,0,127},
          smooth=Smooth.None));
    end if;

    if PlugPhase2 then
      connect(connection3to4.terminal4.phase[2], pv_phase2.terminal) annotation (Line(
        points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={0,120,120},
        smooth=Smooth.None));
      connect(G_int, pv_phase2.G)
                               annotation (Line(
        points={{-80,20},{-30,20},{-30,12}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;

    if PlugPhase3 then
      connect(connection3to4.terminal4.phase[3], pv_phase3.terminal) annotation (Line(
          points={{40,0},{0,0},{0,-50},{-20,-50}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(G_int, pv_phase3.G)
                               annotation (Line(
          points={{-80,20},{-46,20},{-46,-26},{-30,-26},{-30,-38}},
          color={0,0,127},
          smooth=Smooth.None));
    end if;

    connect(pv_phase1.P, sum.u1) annotation (Line(
        points={{-39,57},{-62,57},{-62,90},{20,90},{20,78},{38,78}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(pv_phase2.P, sum.u2) annotation (Line(
        points={{-41,7},{-56,7},{-56,86},{12,86},{12,70},{38,70}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(pv_phase3.P, sum.u3) annotation (Line(
        points={{-41,-43},{-50,-43},{-50,82},{6,82},{6,62},{38,62}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(sum.y, P) annotation (Line(
        points={{61,70},{110,70}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Line(points={{58,0},{92,0}},   color={0,0,0}),
          Text(
            extent={{-140,-100},{160,-60}},
            textString="%name",
            lineColor={0,0,255}),
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
            pattern=LinePattern.None)}));
  end UnbalancedPV;

  model UnbalancedWindTurbine
    extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
    extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
    extends Buildings.Electrical.Interfaces.PartialWindTurbineBase;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;
    replaceable OnePhase.Sources.WindTurbine
                                          wt_phase2(
      pf=pf,
      eta_DCAC=eta_DCAC,
      scale=scale,
      h=h,
      hRef=hRef,
      nWin=nWin,
      tableOnFile=tableOnFile,
      table=table,
      tableName=tableName,
      fileName=fileName) if
                  PlugPhase2
      annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
    replaceable OnePhase.Sources.WindTurbine
                                          wt_phase3(
      pf=pf,
      eta_DCAC=eta_DCAC,
      scale=scale,
      h=h,
      hRef=hRef,
      nWin=nWin,
      tableOnFile=tableOnFile,
      table=table,
      tableName=tableName,
      fileName=fileName) if
                  PlugPhase3
      annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
    replaceable OnePhase.Sources.WindTurbine
                                          wt_phase1(
      pf=pf,
      eta_DCAC=eta_DCAC,
      scale=scale,
      h=h,
      hRef=hRef,
      nWin=nWin,
      tableOnFile=tableOnFile,
      table=table,
      tableName=tableName,
      fileName=fileName) if
                  PlugPhase1
      annotation (Placement(transformation(extent={{-18,40},{-38,60}})));

  public
    Modelica.Blocks.Math.Add3 sum
      annotation (Placement(transformation(extent={{32,50},{52,70}})));
  equation

    if PlugPhase1 then
      connect(connection3to4.terminal4.phase[1],wt_phase1. terminal) annotation (Line(
          points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={0,120,120},
          smooth=Smooth.None));
    end if;

    if PlugPhase2 then
      connect(connection3to4.terminal4.phase[2],wt_phase2. terminal) annotation (Line(
        points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={0,120,120},
        smooth=Smooth.None));
    end if;

    if PlugPhase3 then
      connect(connection3to4.terminal4.phase[3],wt_phase3. terminal) annotation (Line(
          points={{40,0},{0,0},{0,-50},{-20,-50}},
          color={0,120,120},
          smooth=Smooth.None));
    end if;

    connect(sum.y, P) annotation (Line(
        points={{53,60},{110,60}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase1.P, sum.u1) annotation (Line(
        points={{-39,56},{-60,56},{-60,82},{20,82},{20,68},{30,68}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase2.P, sum.u2) annotation (Line(
        points={{-41,6},{-64,6},{-64,86},{12,86},{12,60},{30,60}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase3.P, sum.u3) annotation (Line(
        points={{-41,-44},{-68,-44},{-68,90},{4,90},{4,52},{30,52}},
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
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
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
            fillPattern=FillPattern.Solid)}));
  end UnbalancedWindTurbine;
  annotation (Documentation(info="<html>
<p>
This package contains base classes used by the models that are part of the package
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end BaseClasses;
