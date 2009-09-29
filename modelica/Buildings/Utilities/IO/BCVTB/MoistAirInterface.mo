within Buildings.Utilities.IO.BCVTB;
model MoistAirInterface
  "Fluid interface that can be coupled to BCVTB for medium that model the air humidity"
  extends Buildings.Utilities.IO.BCVTB.BaseClasses.FluidInterface(bou(
        final use_X_in=true));
  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{32,104},{102,78}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="HSen"), Text(
          extent={{30,72},{100,46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="HLat")}),
    Documentation(info="<html>
This model allows interfacing to the 
<a href=\"https://gaia.lbl.gov/bcvtb\">Building Controls Virtual Test Bed</a>
an air-conditioning system
that uses a medium model with water vapor concentration.
</p>
<p>
The model takes as input signals the temperature and water vapor
concentration and, optionally, a bulk mass flow rate into or
out of the system boundary. The state of the fluid 
that flows out of this model will be at this temperature and
water vapor concentration. The output of this model are the sensible and
latent heat exchanged across the system boundary.
</p>
<p>
When used with the BCVTB, a building
simulation program such as EnergyPlus
may compute the room air temperatures and
room air humidity rate, which is then used as an input
to this model. The sensible and latent heat flow rates may be
sent to EnergyPlus to couple the air-conditioning system to 
the energy balance of the building model.
</p>
<p>
<b>Note:</b> The EnergyPlus building simulation program outputs the
absolute humidity ratio in units of [kg/kg dry air]. Since
<code>Modelica.Media</code> uses [kg/kg total mass of air], this quantity
needs to be converted. The conversion can be done with the model
<a href=\"Modelica:Buildings.Utilities.Psychrometrics.ToTotalAir\">
Buildings.Utilities.Psychrometrics.ToTotalAir</a>.
</html>", revisions="<html>
<ul>
<li>
September 10, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  Modelica.Blocks.Interfaces.RealOutput HLat_flow(unit="W")
    "Latent enthalpy flow rate, positive if flow into the component" 
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate senEntFloRat[nPorts](
      redeclare package Medium = Medium) "Sensible enthalpy flow rates" 
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
public
  Modelica.Blocks.Math.Sum sumHSen_flow(nin=nPorts)
    "Sum of sensible enthalpy flow rates" 
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Math.Feedback diff
    "Difference between total and sensible enthalpy flow rate" 
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.Blocks.Interfaces.RealInput XWat_totAir
    "Prescribed water vapor concentration in [kg/kg_totalAirMass]" 
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant uni(k=1) "Outputs 1" 
                                         annotation (Placement(transformation(
          extent={{-100,-100},{-80,-80}},
                                       rotation=0)));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
          extent={{-58,-36},{-38,-16}},
                                      rotation=0)));
equation
  for i in 1:nPorts loop
  connect(senEntFloRat[i].port_a, ports[i]) annotation (Line(
      points={{40,0},{98,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senEntFloRat[i].H_flow, sumHSen_flow.u[i]) annotation (Line(
      points={{30,11},{30,20},{6,20},{6,40},{18,40}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;
  connect(senEntFloRat.port_b, totEntFloRat.port_a) annotation (Line(
      points={{20,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sumHSen_flow.y, HSen_flow) annotation (Line(
      points={{41,40},{60,40},{60,90},{110,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumHTot_flow.y, diff.u1) annotation (Line(
      points={{21,80},{36,80},{36,60},{72,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(diff.y, HLat_flow) annotation (Line(
      points={{89,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(diff.u2, sumHSen_flow.y) annotation (Line(
      points={{80,52},{80,40},{41,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, bou.X_in[2]) annotation (Line(
      points={{-39,-26},{-30,-26},{-30,-12},{-68,-12},{-68,-4},{-62,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XWat_totAir, feedback.u2) annotation (Line(
      points={{-120,-60},{-48,-60},{-48,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uni.y, feedback.u1) annotation (Line(
      points={{-79,-90},{-70,-90},{-70,-26},{-56,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.X_in[1], XWat_totAir) annotation (Line(
      points={{-62,-4},{-80,-4},{-80,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
end MoistAirInterface;
