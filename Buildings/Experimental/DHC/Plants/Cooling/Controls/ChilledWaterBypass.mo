within Buildings.Experimental.DHC.Plants.Cooling.Controls;
model ChilledWaterBypass
  "Controller for chilled water bypass valve"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numChi(
    min=1)
    "Number of chillers";
  parameter Modelica.Units.SI.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller";
  parameter Real k(min=0) = 0.06 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 60
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.SimpleController controllerType=
         Modelica.Blocks.Types.SimpleController.PI
    "Type of controller";
  Modelica.Blocks.Interfaces.BooleanInput chiOn[numChi]
    "On signals of the chillers"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput mFloByp(final unit="kg/s")
    "Chilled water bypass loop mass flow rate"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Bypass valve opening ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset
                                       bypValCon(
    controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    yMin=0.01,
    y_reset=0)
    "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.BooleanToInteger booToInt[numChi]
    "Boolean signal to integer"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Greater than zero"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numChiOn(nin=numChi)
    "Number of chillers on"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to real"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Math.Gain mFloSetSca(k=1/numChi)
    "Normalize mass flowrate setpoint"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Gain mFloBypSca(k=1/(numChi*mMin_flow))
    "Normalize the measured mass flowrate"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(chiOn, booToInt.u)
    annotation (Line(points={{-120,50},{-92,50}}, color={255,0,255}));
  connect(booToInt.y, numChiOn.u)
    annotation (Line(points={{-69,50},{-62,50}}, color={255,127,0}));
  connect(numChiOn.y, intGreThr.u)
    annotation (Line(points={{-38,50},{-30,50},{-30,-30},{-2,-30}},
                           color={255,127,0}));
  connect(intGreThr.y, bypValCon.trigger)
    annotation (Line(points={{22,-30},{64,-30},{64,-12}},color={255,0,255}));
  connect(numChiOn.y, intToRea.u)
    annotation (Line(points={{-38,50},{-22,50}}, color={255,127,0}));
  connect(bypValCon.y, y)
    annotation (Line(points={{82,0},{110,0}},  color={0,0,127}));
  connect(intToRea.y, mFloSetSca.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(mFloSetSca.y, bypValCon.u_s)
    annotation (Line(points={{41,50},{50,50},{50,0},{58,0}}, color={0,0,127}));
  connect(mFloByp, mFloBypSca.u)
    annotation (Line(points={{-120,-50},{-62,-50}}, color={0,0,127}));
  connect(mFloBypSca.y, bypValCon.u_m)
    annotation (Line(points={{-39,-50},{70,-50},{70,-12}}, color={0,0,127}));
  connect(y, y) annotation (Line(points={{110,0},{110,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="chiBypCon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(
      revisions="<html>
<ul>
<li>
May 3, 2021 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>",
      info="<html>
<p>This model implements the chilled water loop bypass valve control logic as 
follows: </p>
<p>When the plant is on, the PID controller controls the valve opening ratio to 
reach the scaled mass flow rate setpoint. </p>
<p>The setpoint is <code>mMin_flow</code> multiplied by the number of chillers 
that are on. <code>mMin_flow</code> is the minimum mass flow rate required by 
one chiller. </p>
<p>This control sequence assumes that all the chillers are identical and the 
cooling load is evenly split between all of the chillers that are on.</p>
</html>"));
end ChilledWaterBypass;
