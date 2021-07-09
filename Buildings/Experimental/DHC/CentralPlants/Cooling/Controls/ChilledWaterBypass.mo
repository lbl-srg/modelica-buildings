within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls;
model ChilledWaterBypass
  "Controller for chilled water bypass valve"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numChi(
    min=1)
    "Number of chillers, maximum is 2";
  parameter Modelica.SIunits.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller";
  parameter Real k(min=0) = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=60
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.SimpleController controllerType=
         Modelica.Blocks.Types.SimpleController.PI
    "Type of controller";
  Modelica.Blocks.Interfaces.BooleanInput chiOn[numChi]
    "On signals of the chillers"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput mFloByp(final unit="kg/s")
    "Chilled water bypass loop mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Bypass valve opening ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.Continuous.LimPID bypValCon(
    controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    yMin=0.01,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant mSetOne(
    final k=mMin_flow)
    "Setpoint if one chiller is on"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.BooleanToInteger booToInt[numChi]
    "Boolean signal to integer"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Product mFloSet "Bypass mass flow rate setpoint"
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Greater than zero"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numChiOn(nin=numChi)
    "Number of chillers on"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to real"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(bypValCon.y,y)
    annotation (Line(points={{81,0},{110,0}},                color={0,0,127}));
  connect(chiOn, booToInt.u)
    annotation (Line(points={{-120,30},{-82,30}}, color={255,0,255}));
  connect(mSetOne.y, mFloSet.u2)
    annotation (Line(points={{1,0},{6,0},{6,14},{10,14}}, color={0,0,127}));
  connect(booToInt.y, numChiOn.u)
    annotation (Line(points={{-59,30},{-52,30}}, color={255,127,0}));
  connect(numChiOn.y, intGreThr.u) annotation (Line(points={{-28,30},{-26,30},{-26,
          -40},{-22,-40}}, color={255,127,0}));
  connect(intGreThr.y, bypValCon.trigger)
    annotation (Line(points={{2,-40},{62,-40},{62,-12}}, color={255,0,255}));
  connect(numChiOn.y, intToRea.u)
    annotation (Line(points={{-28,30},{-22,30}}, color={255,127,0}));
  connect(intToRea.y, mFloSet.u1)
    annotation (Line(points={{2,30},{6,30},{6,26},{10,26}}, color={0,0,127}));
  connect(mFloSet.y, bypValCon.u_s)
    annotation (Line(points={{33,20},{40,20},{40,0},{58,0}}, color={0,0,127}));
  connect(mFloByp, bypValCon.u_m) annotation (Line(points={{-120,-40},{-80,-40},
          {-80,-60},{70,-60},{70,-12}}, color={0,0,127}));
  annotation (
    defaultComponentName="chiBypCon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
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
<p>This model implements the chilled water loop bypass valve control logic as follows: </p>
<p>When the plant is on, the PID controller controls the valve opening ratio to reach the scaled mass flow rate setpoint. </p>
<p>The setpoint is <code>mMin_flow</code> multiplied by the number of chillers that are on. <code>mMin_flow</code> is the minimum mass flow rate required by one chiller. </p>
</html>"));
end ChilledWaterBypass;
