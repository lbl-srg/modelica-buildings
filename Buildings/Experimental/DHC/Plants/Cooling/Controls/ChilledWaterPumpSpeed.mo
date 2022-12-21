within Buildings.Experimental.DHC.Plants.Cooling.Controls;
model ChilledWaterPumpSpeed
  "Controller for up to two headered variable speed chilled water pumps"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.PressureDifference dpSetPoi(displayUnit="Pa")
    "Pressure difference setpoint";
  parameter Modelica.Units.SI.Time tWai "Waiting time";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of single chilled water pump";
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1)=0.05
    "Minimum speed ratio required by chilled water pumps";
  parameter Modelica.Units.SI.MassFlowRate criPoiFlo=0.7*m_flow_nominal
    "Critcal point of flowrate for switching pump on or off";
  parameter Modelica.Units.SI.MassFlowRate deaBanFlo=0.1*m_flow_nominal
    "Deadband for critical point of flowrate";
  parameter Real criPoiSpe=0.5
    "Critical point of speed signal for switching on or off";
  parameter Real deaBanSpe=0.3
    "Deadband for critical point of speed signal";
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of pump speed controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Real k(
    final unit="1",
    final min=0)=1
    "Gain of controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Modelica.Units.SI.Time Ti(final min=Modelica.Constants.small) = 60
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID, group=
          "Speed Controller"));
  parameter Modelica.Units.SI.Time Td(final min=0) = 0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID, group=
          "Speed Controller"));
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
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage pumStaCon(
    final tWai=tWai,
    final m_flow_nominal=m_flow_nominal,
    final minSpe=minSpe,
    final criPoiFlo=criPoiFlo,
    final deaBanFlo=deaBanFlo,
    final criPoiSpe=criPoiSpe,
    final deaBanSpe=deaBanSpe)
    "Chilled water pump staging control"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    final controllerType=controllerType,
    final Ti=Ti,
    final k=k,
    final Td=Td,
    y_reset=0.5)
    "PID controller of pump speed"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant dpSetSca(final k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain gai(k=1/dpSetPoi) "Gain for mesaured dp value"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Math.RealToBoolean twoPum(threshold=1.5) "Two pumps are on"
    annotation (Placement(transformation(extent={{0,-60},{-20,-40}})));
  Modelica.Blocks.Math.Sum totPum(nin=2) "Total number of pumps on"
    annotation (Placement(transformation(extent={{32,-60},{12,-40}})));
protected
  final parameter Integer numPum=2
    "Number of chilled water pumps";
equation
  connect(pumStaCon.masFloPum,masFloPum)
    annotation (Line(points={{8,8},{0,8},{0,40},{-120,40}},      color={0,0,127}));
  connect(conPID.y,pumStaCon.speSig)
    annotation (Line(points={{-18,0},{0,0},{0,4},{8,4}},      color={0,0,127}));
  connect(pumStaCon.y,pumSpe.u1)
    annotation (Line(points={{31,0},{48,0},{48,6},{58,6}},color={0,0,127}));
  connect(conPID.y,pumSpe[1].u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,-20},{48,-20},{48,-6},{58,-6}},
      color={0,0,127}));
  connect(conPID.y,pumSpe[2].u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,-20},{48,-20},{48,-6},{58,-6}},
      color={0,0,127}));
  connect(pumSpe.y,y)
    annotation (Line(points={{81,0},{110,0}},color={0,0,127}));
  connect(dpSetSca.y,conPID.u_s)
    annotation (Line(points={{-59,0},{-42,0}},color={0,0,127}));
  connect(dpMea, gai.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{-59,-40},{-30,-40},{-30,-12}}, color={0,0,127}));
  connect(pumStaCon.y, totPum.u) annotation (Line(points={{31,0},{40,0},{40,-50},
          {34,-50}}, color={0,0,127}));
  connect(totPum.y, twoPum.u)
    annotation (Line(points={{11,-50},{2,-50}}, color={0,0,127}));
  connect(twoPum.y, conPID.trigger) annotation (Line(points={{-21,-50},{-36,-50},
          {-36,-12}}, color={255,0,255}));
  annotation (
    defaultComponentName="CHWPumCon",
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
        preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
December 14, 2022 by Kathryn Hinkelman:<br/>
Normalized <code>u_s</code> and <code>u_m</code> by <code>dpSetPoi</code>.
Added reset for PID controller based on the number of pumps that are on.<br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>",
      info="<html>
<p>
This model implements the control logic for variable speed pumps. 
The staging of pumps is implemented through an instance of 
<a href=\"modelica://Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage\">
Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage</a>. 
</p>
<p>
The pump speed is controlled to maintain the pressure difference setpoint 
through a PID controller.
</p>
<p>The model inputs are the measured chilled water mass flow rate 
<code>masFloPum</code> and the pressure difference <code>dpMea</code> at a 
reference point from the demand side. The output <code>y</code> is a vector 
of pump speeds.
</p>
<p>
The model currently only supports the control of up to two variable speed pumps.
</p>
</html>"));
end ChilledWaterPumpSpeed;
