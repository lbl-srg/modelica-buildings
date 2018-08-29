within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic;
block FreezeProtectionMixedAir "Freeze protection based on mixed air temperature"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(final unit="1/K")=0.1 "Gain";

  parameter Modelica.SIunits.Time Ti=120 "Time constant of integrator block";

parameter Modelica.SIunits.Time Td=0.1
  "Time constant of derivative block"
  annotation (Dialog(
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));


  parameter Modelica.SIunits.Temperature TFreSet = 279.15
    "Lower limit for mixed air temperature for freeze protection";


  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Mixed air temperature measurement"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFrePro(
    final unit="1",
    final min=0,
    final max=1) "Freeze protection control signal, 0 if no frost, 1 if TMix below TFreSet"
    annotation (Placement(transformation(
    extent={{100,-40},{120,-20}}), iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFreProInv(
    final unit="1",
    final min=0,
    final max=1) "Inverse freeze protection control signal, 1 if no frost, 0 if TMix below TFreSet"
    annotation (Placement(transformation(extent={{100,20},{120,40}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0)
    "Controller for mixed air to track freeze protection set point"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setPoi(final k=TFreSet)
    "Set point for freeze protection"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yOut(final p=1, final k=-1)
    "Freeze protection control signal inverter"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation
  connect(con.u_s, setPoi.y)
    annotation (Line(points={{-22,30},{-39,30}}, color={0,0,127}));
  connect(yOut.y, yFreProInv)
    annotation (Line(points={{81,30},{110,30}}, color={0,0,127}));
  connect(TMix, con.u_m)
    annotation (Line(points={{-120,0},{-10,0},{-10,18}}, color={0,0,127}));
  connect(con.y, yFrePro) annotation (Line(points={{1,30},{30,30},{30,-30},{110,
          -30}}, color={0,0,127}));
  connect(con.y, yOut.u) annotation (Line(points={{1,30},{30,30},{30,30},{58,30}},
        color={0,0,127}));
  annotation (Dialog(
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID),
    defaultComponentName = "freProTMix",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-164,144},{164,106}},
          lineColor={0,0,127},
          textString="%name"),
        Line(
          points={{-20,-46},{-20,40},{36,40},{-20,40},{-20,2},{26,2}},
          color={0,0,127},
          thickness=0.5)}),
Documentation(info="<html>
<p>
Block that tracks the mixed air temperature <code>TMix</code>
using a PI controller and outputs
a freeze protection control signal <code>yFrePro</code> and
its inverse <code>yFreProInv</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtectionMixedAir;
