within Buildings.Fluid.CHPs.BaseClasses;
model FilterPower "Constraints for electric power"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Modelica.Blocks.Interfaces.RealInput PEleDem(unit="W")
    "Electric power demand" annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle(unit="W")
    "Electric power demand after applied constraints" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-10},{120,10}})));
  CHPs.BaseClasses.AssertPower assPow(per=per)
    "Assert if electric power is outside boundaries"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
protected
  Modelica.Blocks.Nonlinear.VariableLimiter PLim "Power limiter"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant PMax(k=per.PEleMax)
    "Maximum power"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant PMin(k=per.PEleMin)
    "Minimum power"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter dPLim(raisingSlewRate=
        per.dPEleMax, Td=1) "Power rate limiter"
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  Modelica.Blocks.Sources.BooleanExpression booExp(y=per.dPEleLim)
    "Check if dP is limited"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(PMax.y, PLim.limit1) annotation (Line(points={{-59,20},{-50,20},{-50,8},
          {-42,8}}, color={0,0,127}));
  connect(PMin.y, PLim.limit2) annotation (Line(points={{-59,-20},{-50,-20},{-50,
          -8},{-42,-8}}, color={0,0,127}));
  connect(PLim.u, PEleDem)
    annotation (Line(points={{-42,0},{-120,0}}, color={0,0,127}));
  connect(booExp.y, switch.u2)
    annotation (Line(points={{33,0},{58,0}}, color={255,0,255}));
  connect(switch.y, PEle)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(dPLim.y, switch.u1)
    annotation (Line(points={{33,20},{40,20},{40,8},{58,8}}, color={0,0,127}));
  connect(PLim.y, dPLim.u)
    annotation (Line(points={{-19,0},{0,0},{0,20},{10,20}}, color={0,0,127}));
  connect(PLim.y, switch.u3)
    annotation (Line(points={{-19,0},{0,0},{0,-8},{58,-8}}, color={0,0,127}));
  connect(assPow.PEleDem, PEleDem) annotation (Line(points={{-42,-50},{-90,-50},
          {-90,0},{-120,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="filPow",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The model checks if the electric power and power rate are within the boundaries specified by the manufacturer. 
The constraints are applied and a warning message is sent if the electric power is outside the boundaries. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end FilterPower;
