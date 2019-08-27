within Buildings.Fluid.CHPs.BaseClasses;
model WaterInternalControl "Internal controller for water flow rate"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod "Operation mode" annotation (
     Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput PEle(unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-140,
            -80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput mWatSet(unit="kg/s")
    "Water flow rate set point" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-10},{120,10}})));
protected
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp
         and not per.warmUpByTimeDelay)
    "Check if special case (warm-up by engine temperature)"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=opeMod ==CHPs.BaseClasses.Types.Mode.Off
         or opeMod ==CHPs.BaseClasses.Types.Mode.StandBy)
    "Check if off mode or stand-by mode"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant PMax(k=per.PEleMax)
    "Maximum electric power "
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Utilities.Math.Biquadratic mWatIntCon(a=per.coeMasWat)
    "Internal control of water flow rate "
    annotation (Placement(transformation(extent={{20,-8},{40,12}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{-30,-2},{-10,18}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  connect(switch.y, mWatIntCon.u1)
    annotation (Line(points={{-9,8},{18,8}}, color={0,0,127}));
  connect(PMax.y, switch.u1) annotation (Line(points={{-58,60},{-40,60},{-40,16},
          {-32,16}}, color={0,0,127}));
  connect(mWatIntCon.u2, TWatIn) annotation (Line(points={{18,-4},{0,-4},{0,-60},
          {-120,-60}}, color={0,0,127}));
  connect(switch.u3, PEle)
    annotation (Line(points={{-32,0},{-120,0}}, color={0,0,127}));
  connect(mWatIntCon.y, switch1.u3)
    annotation (Line(points={{41,2},{50,2},{50,22},{58,22}}, color={0,0,127}));
  connect(switch1.y, mWatSet) annotation (Line(points={{81,30},{90,30},{90,0},{110,
          0}}, color={0,0,127}));
  connect(const.y, switch1.u1) annotation (Line(points={{42,60},{50,60},{50,38},
          {58,38}}, color={0,0,127}));
  connect(booleanExpression.y, switch.u2)
    annotation (Line(points={{-59,8},{-32,8}}, color={255,0,255}));
  connect(booleanExpression1.y, switch1.u2)
    annotation (Line(points={{41,30},{58,30}}, color={255,0,255}));
  annotation (
    defaultComponentName="conWat",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The model calculates the water flow rate that is determined by the internal controller.
In CHPs that use this type of internal control the cooling water flow rate is regulated to optimize engine performance and heat recovery. 
In the main model of the CHP unit (<a href=\"modelica://Buildings.CHP.MainModel\"> Buildings.CHP.MainModel</a>) this optimum water flow rate is specified as the set point signal for the external pump controller. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterInternalControl;
