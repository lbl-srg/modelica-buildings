within Buildings.Airflow.Multizone.BaseClasses;
partial model DoorDiscretized
  "Door model using discretization along height coordinate"
  extends Buildings.Airflow.Multizone.BaseClasses.TwoWayFlowElementBuoyancy;

  parameter Integer nCom=10 "Number of compartments for the discretization";

  parameter Modelica.Units.SI.PressureDifference dp_turbulent(
    min=0,
    displayUnit="Pa") = 0.01
    "Pressure difference where laminar and turbulent flow relation coincide. Recommended: 0.01";

  Modelica.Units.SI.PressureDifference dpAB[nCom](each nominal=1)
    "Pressure difference between compartments";
  Modelica.Units.SI.Velocity v[nCom](each nominal=0.01)
    "Velocity in compartment from A to B";
  Modelica.Units.SI.Velocity vTop "Velocity at top of opening from A to B";
  Modelica.Units.SI.Velocity vBot "Velocity at bottom of opening from A to B";


  input Modelica.Units.SI.Length dh=hOpe/nCom "Height of each compartment";
protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);

  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

  input Real hAg[nCom](each unit="m2/s2")=
    {Modelica.Constants.g_n*(hA - (i - 0.5)*dh) for i in 1:nCom}
    "Product g*h_i for each compartment";

  input Real hBg[nCom](each unit="m2/s2")=
    {Modelica.Constants.g_n*(hB - (i - 0.5)*dh) for i in 1:nCom}
    "Product g*h_i for each compartment";
  Modelica.Units.SI.AbsolutePressure pA[nCom](each nominal=101325)
    "Pressure in compartments of room A";
  Modelica.Units.SI.AbsolutePressure pB[nCom](each nominal=101325)
    "Pressure in compartments of room B";

  Modelica.Units.SI.VolumeFlowRate dV_flow[nCom]
    "Volume flow rate through compartment from A to B";
  Modelica.Units.SI.VolumeFlowRate dVAB_flow[nCom]
    "Volume flow rate through compartment from A to B if positive";
  Modelica.Units.SI.VolumeFlowRate dVBA_flow[nCom]
    "Volume flow rate through compartment from B to A if positive";
  Modelica.Units.SI.VolumeFlowRate VZerCom_flow=VZer_flow/nCom
    "Small flow rate for regularization";

  Real m(min=0.5, max=1) "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  Real CVal "Flow coefficient for each compartment, C = V_flow/ dp^m";
  Modelica.Units.SI.Area dA "Compartment area";
  Real gaiFlo[nCom] "Gain to sum up the positive flows and set the negative to zero in a differentiable way";
equation
  dA = A/nCom;

  for i in 1:nCom loop
    // pressure drop in each compartment
    pA[i] = port_a1.p + rho_a1_inflow*hAg[i];
    pB[i] = port_a2.p + rho_a2_inflow*hBg[i];
    dpAB[i] = pA[i] - pB[i];
    v[i] = dV_flow[i]/dA;
    // assignment of net volume flows
    gaiFlo[i] = Buildings.Utilities.Math.Functions.smoothHeaviside(x=dV_flow[i], delta=VZerCom_flow);
    dVAB_flow[i] =  dV_flow[i] * gaiFlo[i];
    dVBA_flow[i] = -dV_flow[i] * (1-gaiFlo[i]);
  end for;
  // add positive and negative flows
  VAB_flow = sum(dVAB_flow);
  VBA_flow = sum(dVBA_flow);
  vTop = v[nCom];
  vBot = v[1];
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-60,80},{60,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,75,55},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,72},{56,-84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,72},{-36,66},{-36,-90},{56,-84},{56,72}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-30,-10},{-16,-8},{-16,-14},{-30,-16},{-30,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-54,48},{-36,48}}, color={0,0,0}),
        Line(points={{-54,20},{-36,20}}, color={0,0,0}),
        Line(points={{-54,-6},{-36,-6}}, color={0,0,0}),
        Line(points={{-54,-58},{-36,-58}}, color={0,0,0}),
        Line(points={{-54,-32},{-36,-32}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
This is a partial model for the bi-directional air flow through a door.
</p>
<p>
To compute the bi-directional flow,
the door is discretize along the height coordinate, and uses
an orifice equation to compute the flow for each compartment.
</p>
<p>
The compartment area <code>dA</code> is a variable, which allows
using the model for a door that can be open or closed.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 8, 2019, by Michael Wetter:<br/>
Moved parameter <code>CD</code> from
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized\">
Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized</a>
to
<a href=\"modelica://Buildings.Airflow.Multizone.DoorDiscretizedOpen\">
Buildings.Airflow.Multizone.DoorDiscretizedOpen</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/971\">#971</a>.
</li>
<li>
June 27, 2018, by Michael Wetter:<br/>
Corrected old parameter annotation.
</li>
<li>
June 6, 2018, by Michael Wetter:<br/>
Removed term that assures non-zero flow rate in each path, and
reformulated flow balance to ensure that model is symmetric.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/937\">#937</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 26, 2013 by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li><i>December 6, 2011</i> by Michael Wetter:<br/>
       Removed protected variable <code>rhoAve</code>.
</li>
<li><i>August 12, 2011</i> by Michael Wetter:<br/>
       Changed model to use the new function
       <a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
       Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 8, 2005</i> by Michael Wetter:<br/>
       Released first version.
</li>
</ul>
</html>"));
end DoorDiscretized;
