within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.BaseClasses;
model IdealHeaterCooler
  "Model of ideal heater or cooler"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Maximum heat flow rate (positive for heating; negative for cooling)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=120
    "Time constant of integrator block"
    annotation (Dialog(group="Controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet
    "Set point temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMea
    "Measured temperature"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={0,-120}),iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(
    final unit="W")
    "Heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPor
    "Heat port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reverseActing=Q_flow_nominal > 0)
    "Controller for heat input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=Q_flow_nominal) "Gain for heat flow rate"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(conPID.u_s,TSet)
    annotation (Line(points={{-12,0},{-120,0}},color={0,0,127}));
  connect(conPID.u_m,TMea)
    annotation (Line(points={{0,-12},{0,-120}},color={0,0,127}));
  connect(preHeaFlo.Q_flow,gai.y)
    annotation (Line(points={{60,0},{42,0}},color={0,0,127}));
  connect(gai.u,conPID.y)
    annotation (Line(points={{18,0},{12,0}},color={0,0,127}));
  connect(preHeaFlo.port,heaPor)
    annotation (Line(points={{80,0},{100,0}},color={191,0,0}));
  connect(gai.y,Q_flow)
    annotation (Line(points={{42,0},{50,0},{50,60},{120,60}},color={0,0,127}));
  annotation (
    defaultComponentName="heaCoo",
    Documentation(
      info="<html>
<p>
Model of an ideal heater or cooler that tracks a set point using a PI controller.
The heater or cooler has a PID controller that regulates the heat added or removed.
</p>
<p>
To use this model, connect its heat port to the heat port of an air volume, for example,
the heat port <code>heaPorAir</code> of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>.
</p>
<p>
Note that this model can only provide sensible cooling, but no latent cooling.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 4, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2381\">#2381</a>.
</li>
</ul>
</html>"));
end IdealHeaterCooler;
