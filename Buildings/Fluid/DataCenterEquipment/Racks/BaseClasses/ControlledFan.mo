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

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Boolean use_riseTime=false
    "Set to true to continuously change motor speed";
  parameter Modelica.Units.SI.Time riseTime=30
    "Time needed to change motor speed between zero and full speed";
  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic";
  parameter Movers.BaseClasses.Characteristics.powerParameters power(
      V_flow={0.1,0.3,0.6,1} .* m_flow_nominal / rho_default,
      P={0.1^3,0.3^3,0.6^3,1} .* PFan_nominal)
    "Fan power vs. volumetric flow rate";

  parameter Real k(
    final unit="1",
    min=Modelica.Constants.small) = 1
    "Gain of PI controller";

  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 60
    "Integrator time constant of PI controller";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMea(
    final unit="K",
    displayUnit="degC")
    "Measured air temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Set point for air temperature"
    annotation (Placement(
      transformation(
        origin={-120,80},
        extent={{-20,-20},{20,20}}),
      iconTransformation(
        origin={-120,80},
        extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Fan power consumption"
    annotation (Placement(
      transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    final use_riseTime=use_riseTime,
    final riseTime=riseTime,
    per(
      pressure(V_flow={0,2*V_flow_nominal}, dp={2*dp_nominal,0}),
      final power=power,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
      powerOrEfficiencyIsHydraulic=false))
    "Fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Reals.PID con(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    r(final unit="K")=1,
    final reverseActing=false,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Fan speed PI controller"
    annotation (Placement(transformation(
      origin={-30,130},
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

equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(con.y, fan.y)
    annotation (Line(points={{-18,80},{0,80},{0,12}}, color={0,0,127}));
  connect(fan.P, P)
    annotation (Line(points={{11,9},{80,9},{80,60},{110,60}}, color={0,0,127}));
  connect(TMea, con.u_m)
    annotation (Line(points={{-120,40},{-30,40},{-30,68}},
                                                      color={0,0,127}));

  connect(TSet, con.u_s)
    annotation (Line(points={{-120,80},{-42,80}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          extent={{3,12},{27,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Rectangle(
          extent={{-80,92},{-40,66}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,92},{-80,66},{-62,80},{-80,92}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,80},{-80,80}}, color={0,0,127}),
        Line(points={{-40,80},{0,80},{0,44}}, color={0,0,127}),
        Text(
          extent={{78,96},{96,66}},
          textColor={0,0,127},
          textString="P"),
        Line(points={{14,40},{60,40},{60,60},{100,60}},
                                              color={0,0,127}),
        Line(points={{-100,40},{-90,40},{-90,80}},
                                              color={0,0,127})}),
    defaultComponentName="fan",
    Documentation(
      info="<html>
<p>
Model of a fan with an integrated PI controller that regulates the leaving air temperature.
The fan speed is modulated to track a leaving air temperature <code>TAirOut</code>
to a set point <code>TAirOutSet</code>.
</p>
<h4>Fan model</h4>
<p>
The fan is modelled using
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
The fan pressure rise at the nominal volumetric flow rate is
</p>
<p align=\"center\" style=\"font-style:italic;\">
dp<sub>0</sub> = P<sub>fan,0</sub> &eta;<sub>0</sub> &frasl; V&#775;<sub>0</sub>.
</p>
<p>
The fan uses a constant total efficiency, which is set by the parameters <code>eta_nominal</code>.
</p>
<h4>Controller</h4>
<p>
The controller is a PI controller that modulates the fan speed so that
the measured temperatures <code>TMea</code> tracks the set point <code>TAirSet</code>.
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
