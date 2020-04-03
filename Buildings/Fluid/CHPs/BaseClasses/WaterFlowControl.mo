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
  Modelica.Blocks.Sources.BooleanExpression offStaBy(
    final y=opeMod == Buildings.Fluid.CHPs.BaseClasses.Types.Mode.Off or
            opeMod == Buildings.Fluid.CHPs.BaseClasses.Types.Mode.StandBy)
    "Check if off mode or stand-by mode"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Utilities.Math.Biquadratic mWatIntCon(
    final a=per.coeMasWat) "Internal control of water flow rate "
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch watFloSet "Water flow setpoint"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Zero flow rate"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

equation
  connect(mWatIntCon.u2, TWatIn) annotation (Line(points={{-22,-46},{-40,-46},{
          -40,-60},{-120,-60}},
                       color={0,0,127}));
  connect(mWatIntCon.y, watFloSet.u3) annotation (Line(points={{1,-40},{20,-40},
          {20,-8},{38,-8}}, color={0,0,127}));
  connect(watFloSet.y, mWatSet_flow) annotation (Line(points={{62,0},{120,0}},
                          color={0,0,127}));
  connect(const.y, watFloSet.u1) annotation (Line(points={{2,40},{20,40},{20,8},
          {38,8}},  color={0,0,127}));
  connect(offStaBy.y, watFloSet.u2) annotation (Line(points={{1,0},{38,0}},
          color={255,0,255}));

  connect(PEle, mWatIntCon.u1) annotation (Line(points={{-120,0},{-40,0},{-40,
          -34},{-22,-34}}, color={0,0,127}));
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
The mass flow rate is computed as a biquadratic function of the net power output of 
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
