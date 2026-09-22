within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses;
model Fan "Preconfigured server fan"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Real eta_nominal(
    final unit="1",
    final min=Modelica.Constants.small) = 0.7
    "Fan and motor combined efficiency at nominal conditions"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Design air mass flow rate"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Units.SI.Power PFan_nominal(min=0)
    "Fan electricity consumption at design flow rate"
    annotation(Dialog(group="Fan"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Dialog(group="Fan", tab="Dynamics"));
  parameter Boolean use_riseTime=true
    "Set to true to continuously change motor speed"
    annotation(Dialog(group="Fan", tab="Dynamics"));
  parameter Modelica.Units.SI.Time riseTime=2
    "Time needed to change motor speed between zero and full speed"
    annotation(Dialog(group="Fan", tab="Dynamics"));
  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation(Dialog(group="Fan", tab="Dynamics"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    min=1,
    max=1,
    final unit="1")
    "Normalized fan speed control signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

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
      pressure(
        V_flow={0,2*V_flow_nominal},
        dp={2*dp_nominal,0}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={sqrt(eta_nominal)}),
      etaMot_max=sqrt(eta_nominal),
      powerOrEfficiencyIsHydraulic=false))
    "Fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

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
  connect(fan.P, P)
    annotation (Line(points={{11,9},{86,9},{86,60},{110,60}}, color={0,0,127}));

  connect(fan.y, y)
    annotation (Line(points={{0,12},{0,60},{-120,60}}, color={0,0,127}));
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
        Line(points={{-100,60},{0,60},{0,44}},color={0,0,127}),
        Text(
          extent={{78,90},{96,60}},
          textColor={0,0,127},
          textString="P"),
        Line(points={{14,38},{60,38},{60,60},{100,60}},
                                              color={0,0,127}),
        Text(
          extent={{-46,-42},{6,-84}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{-96,92},{-78,62}},
          textColor={0,0,127},
          textString="y")}),
    defaultComponentName="fan",
    Documentation(
      info="<html>
<p>
Preconfigured fan model.
</p>
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
</html>",
      revisions="<html>
<ul>
<li>
September 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Fan;
