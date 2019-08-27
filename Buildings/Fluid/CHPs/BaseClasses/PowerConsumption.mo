within Buildings.Fluid.CHPs.BaseClasses;
model PowerConsumption
  "Power consumption during stand-by and cool-down modes"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod "Operation mode" annotation (
     Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput PCon(unit="W")
    "Power consumption during stand-by and cool-down modes" annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
protected
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=opeMod ==CHPs.BaseClasses.Types.Mode.StandBy)
    "Check if the operation mode is StandBy"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=opeMod ==CHPs.BaseClasses.Types.Mode.StandBy
         or opeMod ==CHPs.BaseClasses.Types.Mode.CoolDown)
    "Check if stand-by mode or cool-down mode"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant PStaBy(k=per.PStaBy)
    "Stand-by mode power consumption "
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant PCooDow(k=per.PCooDow)
    "Cool-down mode power consumption "
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
equation
  connect(PStaBy.y, switch.u1) annotation (Line(points={{-48,60},{-30,60},{-30,
          38},{-22,38}},
                     color={0,0,127}));
  connect(switch1.y, PCon) annotation (Line(points={{81,0},{110,0}},
               color={0,0,127}));
  connect(booleanExpression.y, switch.u2)
    annotation (Line(points={{-49,30},{-22,30}},
                                               color={255,0,255}));
  connect(booleanExpression1.y, switch1.u2)
    annotation (Line(points={{41,0},{58,0}},   color={255,0,255}));
  connect(const.y, switch1.u3)
    annotation (Line(points={{42,-30},{48,-30},{48,-8},{58,-8}},
                                                             color={0,0,127}));
  connect(PCooDow.y, switch.u3) annotation (Line(points={{-48,0},{-36,0},{-36,
          22},{-22,22}}, color={0,0,127}));
  connect(switch.y, switch1.u1)
    annotation (Line(points={{1,30},{48,30},{48,8},{58,8}}, color={0,0,127}));
  annotation (
    defaultComponentName="powCon",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The model calculates power consumption during the stand-by and cool-down modes of operation. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerConsumption;
