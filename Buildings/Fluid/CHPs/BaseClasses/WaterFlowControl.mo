within Buildings.Fluid.CHPs.BaseClasses;
model WaterFlowControl "Internal controller for water flow rate"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod  "Operation mode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mWatSet_flow(final unit=
        "kg/s", final quantity="MassFlowRate") "Water mass flow rate set point"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Modelica.Blocks.Sources.BooleanExpression warUpEngTem(
    final y=opeMod == Buildings.Fluid.CHPs.BaseClasses.Types.Mode.WarmUp and
            not per.warmUpByTimeDelay)
    "Check if it is warm-up by engine temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.BooleanExpression offStaBy(
    final y=opeMod == Buildings.Fluid.CHPs.BaseClasses.Types.Mode.Off or
            opeMod == Buildings.Fluid.CHPs.BaseClasses.Types.Mode.StandBy)
    "Check if off mode or stand-by mode"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxElePow(
    final k=per.PEleMax) "Maximum electric power "
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Utilities.Math.Biquadratic mWatIntCon(
    final a=per.coeMasWat) "Internal control of water flow rate "
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch elePow
    "Electric power switch between maximum value and current value depending on the mode"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch watFloSet "Water flow setpoint"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Zero flow rate"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

equation
  connect(elePow.y, mWatIntCon.u1) annotation (Line(points={{-18,20},{0,20},{0,6},
          {18,6}}, color={0,0,127}));
  connect(maxElePow.y, elePow.u1) annotation (Line(points={{-58,60},{-50,60},{-50,
          28},{-42,28}}, color={0,0,127}));
  connect(mWatIntCon.u2, TWatIn) annotation (Line(points={{18,-6},{0,-6},{0,-60},
          {-120,-60}}, color={0,0,127}));
  connect(elePow.u3, PEle) annotation (Line(points={{-42,12},{-50,12},{-50,0},{
          -120,0}},  color={0,0,127}));
  connect(mWatIntCon.y, watFloSet.u3) annotation (Line(points={{41,0},{50,0},
          {50,22},{58,22}}, color={0,0,127}));
  connect(watFloSet.y, mWatSet_flow) annotation (Line(points={{82,30},{90,30},{
          90,0},{120,0}}, color={0,0,127}));
  connect(const.y, watFloSet.u1) annotation (Line(points={{42,60},{50,60},{50,38},
          {58,38}}, color={0,0,127}));
  connect(warUpEngTem.y, elePow.u2) annotation (Line(points={{-59,20},{-42,20}},
          color={255,0,255}));
  connect(offStaBy.y, watFloSet.u2) annotation (Line(points={{41,30},{58,30}},
          color={255,0,255}));

annotation (
  defaultComponentName="conWat",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>
The model calculates the water mass flow rate that is determined by the internal controller.
In CHPs that use this type of internal control the cooling water mass flow rate is 
controlled to optimize engine performance and heat recovery. 
In the main model of the CHP unit (<a href=\"modelica://Buildings.Fluid.CHPs.ThermalElectricalFollowing\"> 
Buildings.Fluid.CHPs.ThermalElectricalFollowing</a>) 
this optimum water mass flow rate is specified as the set point signal for the external pump controller. 
</p>
<h4>Implementation</h4>
<p>
The mass flow rate is computed as a biquadratic function of the net electrical output of 
the system and the water inlet temperature. Note that 
this implementation is a truncated version of the empirical correlation proposed 
in Beausoleil-Morrison (2007) which includes terms of higher order (up to four). 
</p>
<h4>References</h4>
<p>
Beausoleil-Morrison, Ian and Kelly, Nick, 2007. <i>Specifications for modelling fuel cell
and combustion-based residential cogeneration device within whole-building simulation
programs</i>, Section III. <a href=\"https://strathprints.strath.ac.uk/6704/\">
[Report]</a>
</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterFlowControl;
