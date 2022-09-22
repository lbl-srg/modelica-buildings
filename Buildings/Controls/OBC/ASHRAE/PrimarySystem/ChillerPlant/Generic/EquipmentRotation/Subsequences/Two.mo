within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block Two
  "Updates device roles based on the equipment rotation signal"

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRot
    "Rising edge to rotate the equipment"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRol[nDev]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPreDevRolSig[nDev]
    "Device roles in the previous time instance: true = lead; false = lag or standby"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  Buildings.Controls.OBC.CDL.Logical.Not not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nDev] "Switch"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nDev](
    final pre_u_start=initRoles) "Previous timestep"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nDev) "Signal replicator"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(logSwi.u1,not0. y) annotation (Line(points={{-2,8},{-30,8},{-30,-10},{
          -38,-10}}, color={255,0,255}));
  connect(logSwi.y,pre. u) annotation (Line(points={{22,0},{30,0},{30,-20},{38,-20}},
                      color={255,0,255}));
  connect(pre.y,not0. u) annotation (Line(points={{62,-20},{80,-20},{80,-40},{-70,
          -40},{-70,-10},{-62,-10}},   color={255,0,255}));
  connect(pre.y,logSwi. u3) annotation (Line(points={{62,-20},{72,-20},{72,-34},
          {-14,-34},{-14,-8},{-2,-8}}, color={255,0,255}));
  connect(logSwi.y, yDevRol) annotation (Line(points={{22,0},{66,0},{66,20},{110,
          20}},     color={255,0,255}));
  connect(uRot, booRep.u)
    annotation (Line(points={{-120,0},{-80,0},{-80,30},{-62,30}},color={255,0,255}));
  connect(booRep.y, logSwi.u2) annotation (Line(points={{-38,30},{-20,30},{-20,0},
          {-2,0}},     color={255,0,255}));
  connect(pre.y, yPreDevRolSig) annotation (Line(points={{62,-20},{110,-20}},
           color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      defaultComponentName="rotTwo",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Line(points={{-40,60},{0,60},{0,-60},{40,-60}}, color={128,128,128}),
        Ellipse(
          origin={-26.6667,38.6207},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.333,38.6207},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.3333,-81.3793},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={-26.6667,-81.3793},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Line(points={{-40,-60},{0,-60},{0,60},{40,60}}, color={128,128,128})}),
  Documentation(info="<html>
<p>
This subsequence takes a rotation trigger signal <code>uRot</code> as input to
rotate the device roles for two devices or groups of devices. It outputs the current device roles <code>yDevRol</code>
vector and its previous time instance value <code>yPreDevRolSig</code>, which is used
as an input signal to any upstream subsequences in the 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Two;
