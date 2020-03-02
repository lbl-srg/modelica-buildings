within Buildings.Applications.DHC.EnergyTransferStations.Controls;
model PrimaryPumpsConstantSpeed
  "Controller of constant speed condenser and evaporator pumps"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
    "True if cooling is required"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "True if heating is required"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumCon
    "Condenser pump control signal"       annotation (Placement(transformation(
          extent={{100,40},{140,80}}),   iconTransformation(extent={{100,40},{
            140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumEva
    "Evaporator pump control signal"      annotation (Placement(transformation(
          extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},{
            140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical OR"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real conversion"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation

  connect(reqCoo, or2.u2) annotation (Line(points={{-120,-60},{-80,-60},{-80,-8},
          {-72,-8}}, color={255,0,255}));
  connect(reqHea, or2.u1) annotation (Line(points={{-120,60},{-80,60},{-80,0},{
          -72,0}}, color={255,0,255}));
  connect(or2.y, booToRea.u)
    annotation (Line(points={{-48,0},{-12,0}}, color={255,0,255}));
  connect(booToRea.y, yPumCon) annotation (Line(points={{12,0},{60,0},{60,60},{
          120,60}}, color={0,0,127}));
  connect(booToRea.y, yPumEva) annotation (Line(points={{12,0},{60,0},{60,-60},
          {120,-60}}, color={0,0,127}));
annotation (defaultComponentName="conPumPri",
Documentation(info="<html>
<p>
The block computes the control signals for
</p>
<h4>Chiller condenser pump</h4>
<p>
The heating generating source i.e.EIR chiller condenser pump is constant speed and switched
on and off based on a supervisory control signal
generated from the <a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a>
</p>
<h4>Chiller evaporator pump</h4>
<p>
The cooling generating source i.e.EIR chiller evaporator pump is constant speed and switched
on and off based on a supervisory control signal
generated from the <a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>
</p>
</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrimaryPumpsConstantSpeed;
