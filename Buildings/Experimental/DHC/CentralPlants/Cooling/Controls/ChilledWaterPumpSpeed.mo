within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls;
model ChilledWaterPumpSpeed
  "Controller for up to two headed variable speed chilled water pumps"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numPum(
    final min=1,
    final max=2)=2
    "Number of chilled water pumps, maximum is 2";
  parameter Modelica.SIunits.PressureDifference dpSetPoi(
    displayUnit="Pa")
    "Pressure difference setpoint";
  parameter Modelica.SIunits.Time tWai
    "Waiting time";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of single chilled water pump";
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1)=0.05
    "Minimum speed ratio required by chilled water pumps";
  parameter Modelica.SIunits.MassFlowRate criPoiFlo=0.7*m_flow_nominal
    "Critcal point of flowrate for switching pump on or off";
  parameter Modelica.SIunits.MassFlowRate deaBanFlo=0.1*m_flow_nominal
    "Deadband for critical point of flowrate";
  parameter Real criPoiSpe=0.5
    "Critical point of speed signal for switching on or off";
  parameter Real deaBanSpe=0.3
    "Deadband for critical point of speed signal";
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of pump speed controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Real k(
    final unit="1",
    final min=0)=1
    "Gain of controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Modelica.SIunits.Time Ti(
    final min=Modelica.Constants.small)=60
    "Time constant of Integrator block"
    annotation (Dialog(enable=controllerType == Modelica.Blocks.Types.SimpleController.PI or controllerType == Modelica.Blocks.Types.SimpleController.PID,group="Speed Controller"));
  parameter Modelica.SIunits.Time Td(
    final min=0)=0.1
    "Time constant of Derivative block"
    annotation (Dialog(enable=controllerType == Modelica.Blocks.Types.SimpleController.PD or controllerType == Modelica.Blocks.Types.SimpleController.PID,group="Speed Controller"));
  Modelica.Blocks.Interfaces.RealInput masFloPum(
    final unit="kg/s")
    "Total mass flowrate of chilled water pumps"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="Pa")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y[numPum](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Pump speed signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Product pumSpe[numPum]
    "Output pump speed"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage pumStaCon(
    final tWai=tWai,
    final m_flow_nominal=m_flow_nominal,
    final minSpe=minSpe,
    final criPoiFlo=criPoiFlo,
    final deaBanFlo=deaBanFlo,
    final criPoiSpe=criPoiSpe,
    final deaBanSpe=deaBanSpe)
    "Chilled water pump staging control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    final controllerType=controllerType,
    final Ti=Ti,
    final k=k,
    final Td=Td)
    "PID controller of pump speed"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Gain gai(
    final k=1/dpSetPoi)
    "Multiplier gain for normalizing dp input"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant dpSetSca(
    final k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In "+getInstanceName()+": This model is a beta version and is not fully validated yet.");
equation
  connect(pumStaCon.masFloPum,masFloPum)
    annotation (Line(points={{-12,8},{-20,8},{-20,40},{-120,40}},color={0,0,127}));
  connect(conPID.y,pumStaCon.speSig)
    annotation (Line(points={{-39,0},{-20,0},{-20,4},{-12,4}},color={0,0,127}));
  connect(pumStaCon.y,pumSpe.u1)
    annotation (Line(points={{11,0},{28,0},{28,6},{38,6}},color={0,0,127}));
  connect(conPID.y,pumSpe[1].u2)
    annotation (Line(points={{-39,0},{-30,0},{-30,-20},{28,-20},{28,-6},{38,-6}},color={0,0,127}));
  connect(conPID.y,pumSpe[2].u2)
    annotation (Line(points={{-39,0},{-30,0},{-30,-20},{28,-20},{28,-6},{38,-6}},color={0,0,127}));
  connect(pumSpe.y,y)
    annotation (Line(points={{61,0},{110,0}},color={0,0,127}));
  connect(dpMea,gai.u)
    annotation (Line(points={{-120,-40},{-82,-40}},color={0,0,127}));
  connect(gai.y,conPID.u_m)
    annotation (Line(points={{-59,-40},{-50,-40},{-50,-12}},color={0,0,127}));
  connect(dpSetSca.y,conPID.u_s)
    annotation (Line(points={{-79,0},{-62,0}},color={0,0,127}));
  annotation (
    defaultComponentName="CHWPumCon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>",
      info="<html>
<p>This model implements the control logic for variable speed pumps. The staging of pumps is implemented through an instance of <a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage\">Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage</a>. </p>
<p>The pump speed is controlled to maintain the pressure difference setpoint through a PID controller.</p>
<p>The model inputs are the measured chilled water mass flow rate <code>masFloPum</code> and the pressure difference <code>dpMea</code> at a reference point from the demand side. The output <code>y</code> is a vector of pump speeds.</p>
<p>The model currently only supports the control of up to two variable speed pumps.</p>
</html>"));
end ChilledWaterPumpSpeed;
