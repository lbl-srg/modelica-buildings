within Buildings.Templates.Plants.HeatPumps_PNNL.Components.Controls;
block RequiredFlowrate
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetRef annotation (Placement(
        transformation(extent={{-140,0},{-100,40}}), iconTransformation(extent=
            {{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupRef annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent
          ={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mRef_flow annotation (
      Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupMea annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mReq_flow annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=273.15)
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(p=1e-6)
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
equation
  connect(TSupRef, sub.u1) annotation (Line(points={{-120,60},{-88,60},{-88,46},
          {-82,46}}, color={0,0,127}));
  connect(TRetRef, sub.u2) annotation (Line(points={{-120,20},{-88,20},{-88,34},
          {-82,34}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-58,40},{-52,40}}, color={0,0,127}));
  connect(abs1.y, mul.u1) annotation (Line(points={{-28,40},{-18,40},{-18,6},{
          -12,6}}, color={0,0,127}));
  connect(mRef_flow, mul.u2) annotation (Line(points={{-120,-20},{-18,-20},{-18,
          -6},{-12,-6}}, color={0,0,127}));
  connect(TSupMea, sub1.u2) annotation (Line(points={{-120,-60},{-50,-60},{-50,
          -56},{-52,-56}}, color={0,0,127}));
  connect(sub1.y, abs2.u)
    annotation (Line(points={{-28,-50},{-22,-50}}, color={0,0,127}));
  connect(mul.y, div1.u1)
    annotation (Line(points={{12,0},{30,0},{30,6},{38,6}}, color={0,0,127}));
  connect(TRetRef, addPar.u) annotation (Line(points={{-120,20},{-88,20},{-88,
          -44},{-82,-44}}, color={0,0,127}));
  connect(addPar.y, sub1.u1)
    annotation (Line(points={{-58,-44},{-52,-44}}, color={0,0,127}));
  connect(abs2.y, addPar1.u)
    annotation (Line(points={{2,-50},{8,-50}}, color={0,0,127}));
  connect(addPar1.y, div1.u2) annotation (Line(points={{32,-50},{38,-50},{38,
          -14},{32,-14},{32,-6},{38,-6}}, color={0,0,127}));
  connect(max1.y, mReq_flow) annotation (Line(points={{94,0},{100,0},{100,0},{
          120,0}}, color={0,0,127}));
  connect(div1.y, max1.u1)
    annotation (Line(points={{62,0},{70,0},{70,6}}, color={0,0,127}));
  connect(mRef_flow, max1.u2) annotation (Line(points={{-120,-20},{64,-20},{64,
          -6},{70,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,140},{150,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=
            false)));
end RequiredFlowrate;
