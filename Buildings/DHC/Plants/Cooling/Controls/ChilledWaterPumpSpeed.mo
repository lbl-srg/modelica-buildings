within Buildings.DHC.Plants.Cooling.Controls;
model ChilledWaterPumpSpeed
  "Controller for two headered variable speed chilled water pumps"

  parameter Real dpSetPoi(
    final unit="Pa",
    final quantity="PressureDifference",
    displayUnit="Pa")
    "Pressure difference setpoint";
  parameter Real tWai(
     final quantity="Time",
     final unit="s")
     "Waiting time";
  parameter Real m_flow_nominal(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Nominal mass flow rate of single chilled water pump";
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1)=0.05
    "Minimum speed ratio required by chilled water pumps";
  parameter Real criPoiFlo(
    final unit="kg/s",
    final quantity="MassFlowRate")=0.7*m_flow_nominal
    "Critcal point of flowrate for switching pump on or off";
  parameter Real deaBanFlo(
    final unit="kg/s",
    final quantity="MassFlowRate")=0.1*m_flow_nominal
    "Deadband for critical point of flowrate";
  parameter Real criPoiSpe=0.5
    "Critical point of speed signal for switching on or off";
  parameter Real deaBanSpe=0.3
    "Deadband for critical point of speed signal";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of pump speed controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Real k(
    final unit="1",
    final min=0)=1
    "Gain of controller"
    annotation (Dialog(group="Speed Controller"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    final min=Buildings.Controls.OBC.CDL.Constants.small) = 60
    "Time constant of Integrator block"
    annotation (Dialog(group= "Speed Controller",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
             controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    final min=0) = 0.1
    "Time constant of Derivative block"
    annotation (Dialog(group= "Speed Controller",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
             controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
   iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput masFloPum(
    final unit="kg/s")
    "Total mass flowrate of chilled water pumps"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMea(
    final unit="Pa")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[numPum](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Pump speed signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pumSpe[numPum]
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
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final controllerType=controllerType,
    final Ti=Ti,
    final k=k,
    final Td=Td)
    "PID controller of pump speed"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSetSca(final k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/dpSetPoi)
    "Gain for mesaured dp value"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold twoPum(
    final t=1.5)
    "Two pumps are on"
    annotation (Placement(transformation(extent={{10,-60},{-10,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPum(
    final nin=numPum)
    "Total number of pumps on"
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or orRes "Or block for controller reset"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

protected
  final parameter Integer numPum=2
    "Number of chilled water pumps";
equation
  connect(pumStaCon.masFloPum,masFloPum)
    annotation (Line(points={{8,4},{0,4},{0,20},{-120,20}},      color={0,0,127}));
  connect(conPID.y,pumStaCon.speSig)
    annotation (Line(points={{-18,0},{0,0},{0,0},{8,0}},      color={0,0,127}));
  connect(pumStaCon.y,pumSpe.u1)
    annotation (Line(points={{31,0},{50,0},{50,6},{58,6}},color={0,0,127}));
  connect(conPID.y,pumSpe[1].u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,-20},{48,-20},{48,-6},{58,-6}},
      color={0,0,127}));
  connect(conPID.y,pumSpe[2].u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,-20},{48,-20},{48,-6},{58,-6}},
      color={0,0,127}));
  connect(dpSetSca.y,conPID.u_s)
    annotation (Line(points={{-58,0},{-42,0}},color={0,0,127}));
  connect(dpMea, gai.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{-58,-40},{-30,-40},{-30,-12}}, color={0,0,127}));
  connect(pumStaCon.y, totPum.u) annotation (Line(points={{31,0},{50,0},{50,-50},
          {42,-50}}, color={0,0,127}));
  connect(totPum.y, twoPum.u)
    annotation (Line(points={{18,-50},{12,-50}},color={0,0,127}));
  connect(pumSpe.y, y)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(on, pumStaCon.on) annotation (Line(points={{-120,80},{4,80},{4,8},{8,
          8}}, color={255,0,255}));
  connect(twoPum.y, orRes.u2) annotation (Line(points={{-12,-50},{-20,-50},{-20,
          -90},{-70,-90},{-70,-78},{-62,-78}}, color={255,0,255}));
  connect(on, orRes.u1) annotation (Line(points={{-120,80},{-90,80},{-90,-70},{
          -62,-70}}, color={255,0,255}));
  connect(orRes.y, conPID.trigger) annotation (Line(points={{-38,-70},{-36,-70},
          {-36,-12}}, color={255,0,255}));
  annotation (
    defaultComponentName="CHWPumCon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,140},{120,100}},
          textString="%name",
          textColor={0,0,255}),
        Ellipse(
          extent={{-54,52},{52,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{78,8},{94,-4}},
          textColor={0,0,127},
          textString="y"),
        Ellipse(
          extent={{-52,50},{50,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,50},{-2,-50},{50,0},{-2,50}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
August 9, 2023, by Hongxiang Fu:<br/>
Restricted this block to a two-pump configuration as intended.
<ul>
<li>
Set <code>final totPum.nin = numPum</code>.
</li>
<li>
Corrected the \"up to two pumps\" language in documentation.
</li>
</ul>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3470\">#3470</a>.
</li>
<li>
December 30, 2022, by Kathryn Hinkelman:<br/>
Added an <code>on</code> input for a plant-level override to turn pumps off.
</li>
<li>
December 14, 2022 by Kathryn Hinkelman:<br/>
Normalized <code>u_s</code> and <code>u_m</code> by <code>dpSetPoi</code>.
Added reset for PI controller based on the number of pumps that are on.<br>
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
through a PI controller.
</p>
<p>The model inputs are the measured chilled water mass flow rate
<code>masFloPum</code> and the pressure difference <code>dpMea</code> at a
reference point from the demand side. The output <code>y</code> is a vector
of pump speeds.
</p>
<p>
The model currently only supports the control of two variable speed pumps.
</p>
</html>"));
end ChilledWaterPumpSpeed;
