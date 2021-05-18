within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls;
model ChilledWaterBypass
  "Controller for chilled water bypass valve"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numChi(
    min=1,
    max=2)=2
    "Number of chillers, maximum is 2";
  parameter Modelica.SIunits.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller";
  Modelica.Blocks.Interfaces.BooleanInput chiOn[numChi]
    "On signals of the chillers"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput masFloByp(
    final unit="kg/s")
    "Chilled water bypass loop mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Bypass valve opening ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.Continuous.LimPID bypValCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    yMin=0.01,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Chilled water bypass valve controller"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Math.Division mFloSca
    "Scaled mass flow rate measurement"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Logical.Switch mFloSet
    "Bypass loop mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant mSetOne(
    final k=mMin_flow)
    "Setpoint if one chiller is on"
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Modelica.Blocks.Sources.Constant mSetTwo(
    final k=numChi*mMin_flow)
    "Setpoint if two chillers are on"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  Modelica.Blocks.Math.BooleanToReal valSetSca
    "Scaled valve opening setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(bypValCon.y,y)
    annotation (Line(points={{61,30},{70,30},{70,0},{110,0}},color={0,0,127}));
  connect(masFloByp,mFloSca.u1)
    annotation (Line(points={{-120,-40},{-80,-40},{-80,-4},{18,-4}},color={0,0,127}));
  connect(mFloSca.y,bypValCon.u_m)
    annotation (Line(points={{41,-10},{50,-10},{50,18}},color={0,0,127}));
  connect(mSetTwo.y,mFloSet.u1)
    annotation (Line(points={{-49,-30},{-46,-30},{-46,-42},{-22,-42},{-22,-42}},color={0,0,127}));
  connect(mSetOne.y,mFloSet.u3)
    annotation (Line(points={{-49,-70},{-40,-70},{-40,-58},{-22,-58}},color={0,0,127}));
  connect(mFloSet.y,mFloSca.u2)
    annotation (Line(points={{1,-50},{8,-50},{8,-16},{18,-16}},color={0,0,127}));
  connect(valSetSca.y,bypValCon.u_s)
    annotation (Line(points={{-39,30},{38,30}},color={0,0,127}));
  connect(chiOn[1],valSetSca.u)
    annotation (Line(points={{-120,20},{-92,20},{-92,30},{-62,30}},color={255,0,255}));
  connect(chiOn[1],bypValCon.trigger)
    annotation (Line(points={{-120,20},{-92,20},{-92,10},{42,10},{42,18}},color={255,0,255}));
  connect(chiOn[2],mFloSet.u2)
    annotation (Line(points={{-120,40},{-92,40},{-92,-50},{-22,-50}},color={255,0,255}));
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
<p>When the plant is on, the PID controller controls the valve opening ratio to reach the scaled mass flow rate setpoint. The setpoint is determined based on the number of chillers that are operating. </p>
<p>If one chiller is on, then the setpoint equals <span style=\"font-family: Courier New;\">mMin_flow</span>, which is the minimum mass flow rate required by the chiller. If two chillers are on, the setpoint is twice as much. </p>
</html>"));
end ChilledWaterBypass;
