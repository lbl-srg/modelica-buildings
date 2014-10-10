within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
package BaseClasses "Package with base class models"
  extends Modelica.Icons.BasesPackage;
  partial model PartialSource
    "Partial model for a three phases AC unbalanced voltage source without neutral cable"

    Interfaces.Connection3to4_p connection3to4
      "Connection between three to four AC connectors"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    OnePhase.Basics.Ground ground "Ground reference"
      annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
    Interfaces.Terminal_p terminal
      "Connector for three phases unbalanced systems"
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
        color={127,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Documentation(info="<html>
<p>
This model is a partial class extended by three phases unbalanced
voltage sources without neutral cable connection.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
  end PartialSource;

  partial model PartialSource_N "Partial model for a three phases AC unbalanced voltage source 
  with neutral cable"

    OnePhase.Basics.Ground ground "Ground reference"
      annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
    Interfaces.Terminal4_p terminal
      "Connector for three phases unbalanced systems with neutral cable"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  equation

    connect(ground.terminal, terminal.phase[4]) annotation (Line(
        points={{20,-40},{20,0},{100,0}},
        color={127,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}}), graphics), Documentation(info="<html>
<p>
This model is a partial class extended by three phases unbalanced
voltage sources that have neutral cable.
</p>
<p>
The neutral cable is connected to the ground reference.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  end PartialSource_N;

  partial model BaseUnbalancedPV "Partial model for an unbalanced PV source"
    extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
    extends Buildings.Electrical.Interfaces.PartialPvBase;
    extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
    parameter Modelica.SIunits.Voltage V_nominal(min=0, start=480)
      "Nominal voltage (V_nominal >= 0)"
       annotation(Dialog(group="Nominal conditions"));
    parameter Real areaFraction[3](each min=0, each max=1.0) = ones(3)/3
      "Fraction of area occupied by the PVs of each phase";
    replaceable OnePhase.Sources.PVSimple pv_phase2(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A*areaFraction[2],
      fAct=fAct,
      eta=eta,
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase2 "PV phase 2"
      annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
    replaceable OnePhase.Sources.PVSimple pv_phase3(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A*areaFraction[3],
      fAct=fAct,
      eta=eta,
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase3 "PV phase 3"
      annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
    replaceable OnePhase.Sources.PVSimple pv_phase1(
      pf=pf,
      eta_DCAC=eta_DCAC,
      A=A*areaFraction[1],
      fAct=fAct,
      eta=eta,
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase1 "PV phase 1"
      annotation (Placement(transformation(extent={{-18,40},{-38,60}})));
    Modelica.Blocks.Math.Add3 sumBlock
      "Sum of the generated power on each phase"
      annotation (Placement(transformation(extent={{40,84},{60,64}})));
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

    connect(pv_phase1.P, sumBlock.u1) annotation (Line(
        points={{-39,57},{-48,57},{-48,76},{10,76},{10,66},{38,66}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(pv_phase2.P, sumBlock.u2) annotation (Line(
        points={{-41,7},{-50,7},{-50,78},{18,78},{18,74},{38,74}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(pv_phase3.P, sumBlock.u3) annotation (Line(
        points={{-41,-43},{-52,-43},{-52,82},{38,82}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(sumBlock.y, P) annotation (Line(
        points={{61,74},{86,74},{86,70},{110,70}},
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
            pattern=LinePattern.None)}),
      Documentation(info="<html>
<p>
This model is a partial class extended by three phases unbalanced
PV power sources.
</p>
<p>
The model has boolean parameters <code>plugPhase1</code>, <code>plugPhase2</code>,
and <code>plugPhase3</code> that can be used to connect the PV in an 
unbalanced configuration.
</p>
<p>
The model has an array <code>areaFraction[3]</code> that is used to determine how
to partition the power of the PVs on the three phases. By default it is assumed 
a uniform partition <code>areaFraction[3] = {1/3, 1/3, 1/3}</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
  end BaseUnbalancedPV;

  model UnbalancedPV
    "Base model for an unbalanced PV source without neutral cable"
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedPV;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;
  equation

    if plugPhase1 then
      connect(connection3to4.terminal4.phase[1], pv_phase1.terminal) annotation (Line(
          points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

    if plugPhase2 then
      connect(connection3to4.terminal4.phase[2], pv_phase2.terminal) annotation (Line(
        points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={127,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase3 then
      connect(connection3to4.terminal4.phase[3], pv_phase3.terminal) annotation (Line(
          points={{40,0},{0,0},{0,-50},{-20,-50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

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
            pattern=LinePattern.None)}),
      Documentation(info="<html>
<p>
This model is a class extended by three phases unbalanced
PV power sources without neutral cable.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  end UnbalancedPV;

  model UnbalancedPV_N
    "Base model for an unbalanced PV source with neutral cable"
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedPV;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource_N;
  equation

    if plugPhase1 then
      connect(terminal.phase[1], pv_phase1.terminal) annotation (Line(
          points={{100,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

    if plugPhase2 then
      connect(terminal.phase[2], pv_phase2.terminal) annotation (Line(
        points={{100,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={127,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase3 then
      connect(terminal.phase[3], pv_phase3.terminal) annotation (Line(
          points={{100,0},{0,0},{0,-50},{-20,-50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

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
            pattern=LinePattern.None)}),
      Documentation(info="<html>
<p>
This model is a class extended by three phases unbalanced
PV power sources with neutral cable connection.
</p>
<p>
The neutral cable is connected to the ground reference.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  end UnbalancedPV_N;

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
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase2 "Wind turbine phase 2"
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
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase3 "Wind turbine phase 3"
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
      V_nominal=V_nominal/sqrt(3)) if
                  plugPhase1 "Wind turbine phase 1"
      annotation (Placement(transformation(extent={{-18,40},{-38,60}})));
    Modelica.Blocks.Math.Add3 sumBlock
      "Sum of th epower generated on each phase"
      annotation (Placement(transformation(extent={{32,50},{52,70}})));
  equation

    assert(abs(sum(scaleFraction)-1) < Modelica.Constants.eps,
    "Model that extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedWindTurbine,
  has an invalid value for the vector scaleFraction[:]. The sum of the
  elements has to be equal to 1.0.",
    level=AssertionLevel.error);

    if plugPhase1 then
    end if;

    if plugPhase2 then
    end if;

    if plugPhase3 then
    end if;

    connect(sumBlock.y, P) annotation (Line(
        points={{53,60},{110,60}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase1.P, sumBlock.u1) annotation (Line(
        points={{-39,56},{-60,56},{-60,82},{20,82},{20,68},{30,68}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase2.P, sumBlock.u2) annotation (Line(
        points={{-41,6},{-64,6},{-64,86},{12,86},{12,60},{30,60}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wt_phase3.P, sumBlock.u3) annotation (Line(
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
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
This model is a partial class extended by three phases unbalanced
wind turbine power sources.
</p>
<p>
The model has boolean parameters <code>plugPhase1</code>, <code>plugPhase2</code>,
and <code>plugPhase3</code> that can be used to connect the wind turbines in an 
unbalanced configuration.
</p>
<p>
The model has an array <code>scaleFraction[3]</code> that is used to determine how
to partition the power of the wind turbines on the three phases. By default it is assumed 
a uniform partition <code>scaleFraction[3] = {1/3, 1/3, 1/3}</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
  end BaseUnbalancedWindTurbine;

  model UnbalancedWindTurbine
    "Base model for an unbalanced wind power source without neutral cable"
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedWindTurbine;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;

  equation
    if plugPhase1 then
      connect(connection3to4.terminal4.phase[1],wt_phase1.terminal) annotation (Line(
          points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

    if plugPhase2 then
      connect(connection3to4.terminal4.phase[2],wt_phase2.terminal) annotation (Line(
        points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={127,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase3 then
      connect(connection3to4.terminal4.phase[3],wt_phase3.terminal) annotation (Line(
          points={{40,0},{0,0},{0,-50},{-20,-50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

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
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
This model is a class extended by three phases unbalanced
wind turbine power sources without neutral cable.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  end UnbalancedWindTurbine;

  model UnbalancedWindTurbine_N
    "Base model for an unbalanced wind power source with neutral cable"
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedWindTurbine;
    extends
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource_N;

  equation
    if plugPhase1 then
      connect(terminal.phase[1],wt_phase1.terminal) annotation (Line(
          points={{100,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

    if plugPhase2 then
      connect(terminal.phase[2],wt_phase2.terminal) annotation (Line(
        points={{100,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
        color={127,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase3 then
      connect(terminal.phase[3],wt_phase3.terminal) annotation (Line(
          points={{100,0},{0,0},{0,-50},{-20,-50}},
          color={127,0,127},
          smooth=Smooth.None));
    end if;

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
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
This model is a class extended by three phases unbalanced
wind turbine power sources with neutral cable connection.
</p>
<p>
The neutral cable is connected to the ground reference.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  end UnbalancedWindTurbine_N;
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
