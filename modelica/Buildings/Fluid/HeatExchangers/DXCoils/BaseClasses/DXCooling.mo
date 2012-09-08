within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model DXCooling "DX cooling coil operation "
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface;
  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  Modelica.Blocks.Interfaces.RealOutput TCoiSur(
    quantity="Temperature",
    unit="K",
    min=240,
    max=400) "Coil surface temperature"
          annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  WetCoil wetCoi(
    redeclare final package Medium = Medium,
    final variableSpeedCoil = variableSpeedCoil,
    final datCoi=datCoi) "Wet coil condition"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  DryCoil dryCoi(
    redeclare final package Medium = Medium,
    final variableSpeedCoil = variableSpeedCoil,
    final datCoi=datCoi) "Dry coil condition"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Modelica.Blocks.Routing.Multiplex5 mux1
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Routing.Multiplex5 mux2
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  // fixme: deltax must be scaled
  Buildings.Utilities.Math.Splice spl[5](
    each deltax=0.0001)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Routing.DeMultiplex5 deMux
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Routing.Replicator rep(
    final nout=5) "Replicator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor dryWetPre
    "Predicts coil condition (1=wet; -1=dry)"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression XADP(
    final y=wetCoi.appDewPt.XADP) "Mass fraction at ADP"
    annotation (Placement(transformation(extent={{-50,-36},{-30,-16}})));
equation

  connect(TConIn, wetCoi.TConIn)  annotation (Line(
      points={{-110,50},{-76,50},{-76,55},{-51,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn, dryCoi.TConIn)  annotation (Line(
      points={{-110,50},{-76,50},{-76,-45},{-51,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, wetCoi.m_flow)  annotation (Line(
      points={{-110,24},{-72,24},{-72,52.4},{-51,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dryCoi.m_flow)  annotation (Line(
      points={{-110,24},{-72,24},{-72,-47.6},{-51,-47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, wetCoi.TIn)  annotation (Line(
      points={{-110,5.55112e-16},{-68,5.55112e-16},{-68,50},{-51,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, dryCoi.TIn)  annotation (Line(
      points={{-110,5.55112e-16},{-68,5.55112e-16},{-68,-50},{-51,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, wetCoi.p)  annotation (Line(
      points={{-110,-24},{-64,-24},{-64,47.6},{-51,47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, wetCoi.XIn)  annotation (Line(
      points={{-110,-50},{-60,-50},{-60,45},{-51,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, wetCoi.hIn)  annotation (Line(
      points={{-110,-77},{-56,-77},{-56,42.3},{-51,42.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, dryCoi.hIn)  annotation (Line(
      points={{-110,-77},{-56,-77},{-56,-57.7},{-51,-57.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, dryCoi.p)  annotation (Line(
      points={{-110,-24},{-64,-24},{-64,-52.4},{-51,-52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, dryCoi.XIn)  annotation (Line(
      points={{-110,-50},{-60,-50},{-60,-55},{-51,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, wetCoi.speRat)  annotation (Line(
      points={{-110,76},{-80,76},{-80,57.6},{-51,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, dryCoi.speRat)  annotation (Line(
      points={{-110,76},{-80,76},{-80,-42.4},{-51,-42.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.EIR, mux2.u1[1])          annotation (Line(
      points={{-29,-42},{-18,-42},{-18,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.Q_flow, mux2.u2[1])          annotation (Line(
      points={{-29,-46},{-16.5,-46},{-16.5,-45},{-12,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.SHR, mux2.u3[1])          annotation (Line(
      points={{-29,-50},{-12,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.TDry, mux2.u4[1])          annotation (Line(
      points={{-29,-54},{-18,-54},{-18,-55},{-12,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.mWat_flow, mux2.u5[1])          annotation (Line(
      points={{-29,-58},{-18,-58},{-18,-60},{-12,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mux1.y, spl.u1)         annotation (Line(
      points={{11,50},{20,50},{20,6},{28,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mux2.y, spl.u2)         annotation (Line(
      points={{11,-50},{20,-50},{20,-6},{28,-6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(spl.y, deMux.u)          annotation (Line(
      points={{51,6.10623e-16},{60.5,6.10623e-16},{60.5,6.66134e-16},{58,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(deMux.y1[1], EIR)          annotation (Line(
      points={{81,8},{88,8},{88,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMux.y2[1], Q_flow)          annotation (Line(
      points={{81,4},{94,4},{94,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(deMux.y4[1], TCoiSur)            annotation (Line(
      points={{81,-4},{94,-4},{94,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(deMux.y3[1], SHR) annotation (Line(
      points={{81,5.55112e-16},{88.25,5.55112e-16},{88.25,5.55112e-16},{95.5,
          5.55112e-16},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMux.y5[1], mWat_flow) annotation (Line(
      points={{81,-8},{88,-8},{88,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.EIR, mux1.u1[1]) annotation (Line(
      points={{-29,58},{-22,58},{-22,60},{-12,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.Q_flow, mux1.u2[1]) annotation (Line(
      points={{-29,54},{-20.5,54},{-20.5,55},{-12,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.SHR, mux1.u3[1]) annotation (Line(
      points={{-29,50},{-12,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.TADP, mux1.u4[1]) annotation (Line(
      points={{-29,46},{-20.5,46},{-20.5,45},{-12,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.mWat_flow, mux1.u5[1]) annotation (Line(
      points={{-29,42},{-22,42},{-22,40},{-12,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep.y, spl.x) annotation (Line(
      points={{11,6.10623e-16},{15.5,6.10623e-16},{15.5,6.66134e-16},{28,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(XIn, dryWetPre.XIn) annotation (Line(
      points={{-110,-50},{-60,-50},{-60,5},{-41,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWetPre.dryWetCoi, rep.u) annotation (Line(
      points={{-19,6.10623e-16},{-15.5,6.10623e-16},{-15.5,6.66134e-16},{-12,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XADP.y, dryWetPre.XADP) annotation (Line(
      points={{-29,-26},{-20,-26},{-20,-14},{-50,-14},{-50,-5},{-41,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stage, dryCoi.stage) annotation (Line(
      points={{-110,100},{-54,100},{-54,-40},{-51,-40}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(stage, wetCoi.stage) annotation (Line(
      points={{-110,100},{-54,100},{-54,60},{-51,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="dxCoo", Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                     graphics), Documentation(info="<html>
<p>
This block preovides results of cooling operation. It encompasses 
both cases i.e. dry and wet coil condition. The coil condition is decided by 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor</a>.
Smooth transition is attained between results of these two conditions using 
<a href=\"modelica://Buildings.Utilities.Math.Splice\"> 
Buildings.Utilities.Math.Splice</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 4, 2012 by Michael Wetter:<br>
Renamed connector to follow naming convention.
</li><li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-64,-56},{78,-92}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="DXCool"),
        Line(
          points={{-78,26},{-46,26}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,26},{-48,28},{-48,24},{-44,26}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,4},{-46,4}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,4},{-48,6},{-48,2},{-44,4}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,32},{26,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{24,32},{-12,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{22,20},{-16,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{20,8},{-18,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{18,-4},{-20,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{16,8},{22,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{14,-32},{-24,-14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{16,-20},{-22,-2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{12,-20},{18,-32}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{-78,-18},{-46,-18}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,-18},{-46,-16},{-46,-20},{-42,-18}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,46},{-44,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,46},{-46,48},{-46,44},{-42,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{74,32},{38,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{72,20},{34,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{70,32},{76,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{70,8},{32,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{68,-4},{30,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{66,8},{72,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{68,-22},{30,-4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{66,-34},{28,-16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{64,-22},{70,-34}},
          lineColor={0,0,255},
          lineThickness=0.5)}));
end DXCooling;
