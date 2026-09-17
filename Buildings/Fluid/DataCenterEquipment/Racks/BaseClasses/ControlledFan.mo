within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses;
model ControlledFan "Fan with integrated PI temperature controller"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.Units.SI.Temperature TAirOutSet
    "Set point for the leaving air temperature";

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Design air mass flow rate";

  parameter Modelica.Units.SI.Power PFan_nominal(min=0)
    "Fan electricity consumption at design flow rate";

  parameter Real k(
    final unit="1",
    min=Modelica.Constants.small) = 1
    "Gain of PI controller";

  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 60
    "Integrator time constant of PI controller";

  Modelica.Blocks.Interfaces.RealInput TAirOut(
    final unit="K",
    displayUnit="degC")
    "Leaving air temperature"
    annotation (Placement(
      transformation(
        origin={-120,60},
        extent={{-20,-20},{20,20}}),
      iconTransformation(
        origin={-110,60},
        extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Fan power consumption"
    annotation (Placement(
      transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    per(
      pressure(
        V_flow={0, V_flow_nominal, 2*V_flow_nominal},
        dp={2*dp_nominal, dp_nominal, 0}),
      power(
        V_flow={0.1, 0.3, 0.6, 1} .* V_flow_nominal,
        P={0.1^3, 0.3^3, 0.6^3, 1} .* PFan_nominal),
      powerOrEfficiencyIsHydraulic=false))
    "Fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Reals.PID con(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    r=10,
    reverseActing=false)
    "Fan speed PI controller"
    annotation (Placement(transformation(
      origin={-30,90},
      extent={{-10,-60},{10,-40}})));

protected
  parameter Modelica.Units.SI.Density rho_default = Medium.density(
    Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default air density";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = m_flow_nominal / rho_default
    "Nominal volumetric flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") =
    PFan_nominal * eta_nominal / V_flow_nominal
    "Fan pressure rise at nominal conditions";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutSet(
    final k=TAirOutSet)
    "Temperature set point"
    annotation (Placement(transformation(
      origin={0,110},
      extent={{-80,-80},{-60,-60}})));

equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(TOutSet.y, con.u_s)
    annotation (Line(points={{-58,40},{-42,40}}, color={0,0,127}));
  connect(con.y, fan.y)
    annotation (Line(points={{-18,40},{0,40},{0,12}}, color={0,0,127}));
  connect(fan.P, P)
    annotation (Line(points={{11,9},{80,9},{80,60},{110,60}}, color={0,0,127}));
  connect(TAirOut, con.u_m)
    annotation (Line(points={{-120,60},{-90,60},{-90,20},{-30,20},{-30,28}},
      color={0,0,127}));

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,12},{100,-12}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-44,44},{44,-44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,38},{0,-38},{41,0},{0,38}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{3,12},{27,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Rectangle(
          extent={{-90,80},{-40,40}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,80},{-90,40},{-55,60},{-90,80}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,60},{-90,60}}, color={0,0,127}),
        Line(points={{-40,60},{0,60},{0,44}}, color={0,0,127}),
        Text(
          extent={{-124,122},{-62,60}},
          textColor={0,0,127},
          textString="TAirOut"),
        Text(
          extent={{78,74},{96,44}},
          textColor={0,0,127},
          textString="P")}),
    defaultComponentName="fan",
    Documentation(
      info="<html>
<p>
Model of a fan with an integrated PI controller that regulates the leaving air temperature.
The fan speed is increased when the leaving air temperature <code>TAirOut</code>
rises above the set point <code>TAirOutSet</code>.
</p>
<h4>Fan model</h4>
<p>
The fan is modelled using
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
The fan pressure rise at the nominal volumetric flow rate is
</p>
<p align=\"center\" style=\"font-style:italic;\">
dp<sub>nominal</sub> = P<sub>Fan,nominal</sub> &eta;<sub>nominal</sub> &frasl; V&#775;<sub>nominal</sub>,
</p>
<p>
which follows from the combined fan and motor efficiency
</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta;<sub>nominal</sub> = dp<sub>nominal</sub> V&#775;<sub>nominal</sub> &frasl; P<sub>Fan,nominal</sub>.
</p>
<p>
The fan power curve follows a cubic relationship with relative volume flow rate,
matching
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic\">
Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic</a>.fanRelPow,
with <i>r<sub>P</sub> = r<sub>V</sub><sup>3</sup></i>.
</p>
<h4>Controller</h4>
<p>
The controller is a PI controller configured as direct-acting
(<code>reverseActing=false</code>):
when <code>TAirOut</code> exceeds <code>TAirOutSet</code>,
the fan speed signal <code>y</code> increases to provide additional cooling.
The parameter <code>r = 10</code> sets the typical control error range to 10 K.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 15, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlledFan;
